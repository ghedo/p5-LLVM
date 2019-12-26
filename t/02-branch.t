#!perl -T

use Test::More;
use File::Slurp;
use Capture::Tiny 'capture_stderr';

use LLVM;

my $mod = LLVM::Module -> new("test2");
my $bld = LLVM::Builder -> new;

my $intt = LLVM::Type -> int(32);
my $funt = LLVM::Type -> func($intt, $intt, $intt);

my $fun = $mod -> add_func("test2", $funt);

my $params = $fun -> func_params;

$params -> [0] -> name("x");
$params -> [1] -> name("y");

my $blk = $fun -> func_append("entry");
$bld -> position_at_end($blk);

my $cmp = $bld -> icmp("ugt", $params -> [0], $params -> [1], "cmp");

my $true_blk = $fun -> func_append("true");
$bld -> position_at_end($true_blk);
$bld -> ret($params -> [0]);

my $false_blk = $fun -> func_append("false");
$bld -> position_at_end($false_blk);
$bld -> ret($params -> [1]);

$bld -> position_at_end($blk);
$bld -> cond($cmp, $true_blk, $false_blk);

my $stderr = capture_stderr { $mod -> dump };

# LLVM 7 (and maybe earlier) adds some extra
$stderr =~ s/^source_filename = "test2"\n//m;

my $expected = <<'EOS';
; ModuleID = 'test2'

define i32 @test2(i32 %x, i32 %y) {
entry:
  %cmp = icmp ugt i32 %x, %y
  br i1 %cmp, label %true, label %false

true:                                             ; preds = %entry
  ret i32 %x

false:                                            ; preds = %entry
  ret i32 %y
}
EOS

is $stderr, $expected;

my $arg1 = LLVM::GenericValue -> int($intt, 10);
my $arg2 = LLVM::GenericValue -> int($intt, 15);

my $eng = LLVM::ExecutionEngine -> new($mod);

my $res1 = $eng -> run_func($fun, $arg1, $arg2);
is $res1 -> to_int, 15;

my $res2 = $eng -> run_func($fun, $arg2, $arg1);
is $res2 -> to_int, 15;

my $targets = LLVM::Target -> targets;

my ($x86_64) = grep $_->name eq 'x86-64', @$targets;
my $tm = LLVM::TargetMachine -> create(
	$x86_64, 'x86_64-linux-gnu',
	'penryn', ['64bit', '64bit-mode', 'avx']
);

$tm -> emit($mod, 't/cond.out', 0);

$expected = <<'EOS';
	.file	"test2"
	.text
	.globl	test2
	.align	16, 0x90
	.type	test2,@function
test2:
	.cfi_startproc
	cmpl	%esi, %edi
	jbe	.LBB0_2
	movl	%edi, %eax
	ret
.LBB0_2:
	movl	%esi, %eax
	ret
.Ltmp0:
	.size	test2, .Ltmp0-test2
	.cfi_endproc


	.section	".note.GNU-stack","",@progbits
EOS

my $code = read_file('t/cond.out');
# .text and .file lines swapped
$code =~ s/^(\s+\.text\n)(\s+\.file\s+"test2"\n)/$2$1/;
$code =~ s/\.p2align\t4/.align\t16/;
$code =~ s/\.Lfunc_end0\b/.Ltmp0/g;
$code =~ s/\bretq\b/ret/g;
is $code, $expected;

done_testing;

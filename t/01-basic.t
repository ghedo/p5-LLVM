#!perl -T

use Test::More;
use File::Slurp;
use Capture::Tiny 'capture_stderr';

use LLVM;

my $mod = LLVM::Module -> new("test1");
my $bld = LLVM::Builder -> new;

my $intt = LLVM::Type -> int(32);
my $funt = LLVM::Type -> func($intt, $intt, $intt, $intt);

my $fun = $mod -> add_func("test1", $funt);

my $params = $fun -> func_params;

$params -> [0] -> name("x");
is $params -> [0] -> name, "x";

$params -> [1] -> name("y");
is $params -> [1] -> name, "y";

$params -> [2] -> name("z");
is $params -> [2] -> name, "z";

my $blk = $fun -> func_append("entry");

$bld -> position_at_end($blk);

my $tmp1 = $bld -> add($params -> [0], $params -> [1], "tmp1");
my $tmp2 = $bld -> mul($tmp1, $params -> [2], "tmp2");

$bld -> ret($tmp2);

my $stderr = capture_stderr { $mod -> dump };

is $fun->name, "test1", "check name";

$stderr =~ s/^source_filename = "test1"\n//m;

my $expected = <<'EOS';
; ModuleID = 'test1'

define i32 @test1(i32 %x, i32 %y, i32 %z) {
entry:
  %tmp1 = add i32 %x, %y
  %tmp2 = mul i32 %tmp1, %z
  ret i32 %tmp2
}
EOS

is $stderr, $expected, "expected llvm code";

my $pass = LLVM::PassManager -> new;

$pass -> add("GlobalDCE");
$pass -> add("ArgumentPromotion");
$pass -> add("ConstantMerge");
$pass -> add("DeadArgElimination");
$pass -> add("FunctionAttrs");
$pass -> add("FunctionInlining");
$pass -> add("AlwaysInliner");
$pass -> add("GlobalDCE");
$pass -> add("GlobalOptimizer");
$pass -> add("IPConstantPropagation");
$pass -> add("PruneEH");
$pass -> add("IPSCCP");
$pass -> add("Internalize");
$pass -> add("StripDeadPrototypes");
$pass -> add("StripSymbols");
$pass -> add("AggressiveDCE");
$pass -> add("CFGSimplification");
$pass -> add("DeadStoreElimination");
$pass -> add("GVN");
$pass -> add("IndVarSimplify");
$pass -> add("InstructionCombining");
$pass -> add("JumpThreading");
$pass -> add("LICMP");
$pass -> add("LoopDeletion");
$pass -> add("LoopIdiom");
$pass -> add("LoopRotate");
$pass -> add("LoopUnroll");
$pass -> add("LoopUnswitch");
$pass -> add("MemCpyOpt");
$pass -> add("PromoteMemoryToRegister");
$pass -> add("Reassociate");
$pass -> add("SCCP");
$pass -> add("ScalarReplAggregates");
$pass -> add("SimplifyLibCall");
$pass -> add("TailCallElimination");
$pass -> add("ConstantPropagation");
$pass -> add("DemoteMemoryToRegoster");
$pass -> add("Verifier");
$pass -> add("CorrelatedValuePropagation");
$pass -> add("EarlyCSE");
$pass -> add("LowerExpectIntrinsic");
$pass -> add("TypeBasedAliasAnalysis");
$pass -> add("BasicAliasAnalysis");
$pass -> add("BBVectorize");

$pass -> run($mod);

$stderr = capture_stderr { $mod -> dump };

# LLVM 7 and maybe earlier adds this
$stderr =~ s/^source_filename = "test1"\n//m;
$stderr =~ s/^; Function Attrs: (?:norecurse )?nounwind readnone\n//m;

# later LLVM loses the function name?
# Possibly since we're doing module global optimization
$stderr =~ s/internal i32 \@0/i32 \@test1/;

#$stderr =~ s/local_unnamed_addr #0//;
if ($stderr =~ s/\nattributes #0 = \{ (?:norecurse )?nounwind readnone \}\n//m) {
    $stderr =~ s/\) (?:local_unnamed_addr )?#0 \{/) nounwind readnone {/;
}

$expected = <<'EOS';
; ModuleID = 'test1'

define i32 @test1(i32, i32, i32) nounwind readnone {
  %4 = add i32 %1, %0
  %5 = mul i32 %4, %2
  ret i32 %5
}
EOS

is $stderr, $expected;

my $arg1 = LLVM::GenericValue -> int($intt, 10);
my $arg2 = LLVM::GenericValue -> int($intt, 15);
my $arg3 = LLVM::GenericValue -> int($intt, 20);

my $eng = LLVM::ExecutionEngine -> new($mod);

my $res = $eng -> run_func($fun, $arg1, $arg2, $arg3);

is $res -> to_int, 500;

my $targets = LLVM::Target -> targets;
note '"', $_->name, '" - ', $_->description for @$targets;
my ($x86_64) = grep $_->name eq 'x86-64', @$targets;
note "using ", $x86_64->name, ": ", $x86_64->description;

my $tm = LLVM::TargetMachine -> create(
	$x86_64, 'x86_64-linux-gnu',
	'penryn', ['64bit', '64bit-mode', 'avx']
);

$tm -> emit($mod, 't/basic.out', 0);

$expected = <<'EOS';
	.file	"test1"
	.text
	.globl	test1
	.align	16, 0x90
	.type	test1,@function
test1:
	addl	%esi, %edi
	imull	%edx, %edi
	movl	%edi, %eax
	ret
.Ltmp0:
	.size	test1, .Ltmp0-test1


	.section	".note.GNU-stack","",@progbits
EOS

my $basic = read_file('t/basic.out');

# later LLVM swaps the .text and .file
# and loses the function name
$basic =~ s/(\t\.text\n)(\t\.file\t"test1"\n)/$2$1\t.globl\ttest1\n/;
# different alignment directive
$basic =~ s/\.p2align\t4\b/\.align\t16/;
# loss of function name
$basic =~ s/__unnamed_1/test1/g;
# different end of function symbol
$basic =~ s/\.Lfunc_end0\b/\.Ltmp0/g;
# better code gen in later LLVM
# addl is replaced with lea and the result ends up in
# %eax without the need for the movl
$basic =~ s/\tleal\t\(%rdi,%rsi\), %eax
\timull\t%edx, %eax/\taddl\t%esi, %edi
\timull\t%edx, %edi
\tmovl\t%edi, %eax/;
$basic =~ s/\bretq\b/ret/;

is($basic, $expected,);

done_testing;

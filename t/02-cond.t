#!perl -T

use Test::More;
use IO::CaptureOutput qw(capture);

use LLVM;

my $mod = LLVM::Module -> new("test2");

my $intt = LLVM::Type -> int(32);
my $funt = LLVM::Type -> func($intt, $intt, $intt);

my $fun = $mod -> add_func("test2", $funt);

my $params = $fun -> func_params;

$params -> [0] -> set_name("x");
$params -> [1] -> set_name("y");

my $blk = $fun -> func_append("entry");
my $bld = LLVM::Builder -> new($blk);

my $cmp = $bld -> icmp("ugt", $params -> [0], $params -> [1], "cmp");

my $true_blk = $fun -> func_append("true");
my $true_bld = LLVM::Builder -> new($true_blk);
$true_bld -> ret($params -> [0]);

my $false_blk = $fun -> func_append("false");
my $false_bld = LLVM::Builder -> new($false_blk);
$false_bld -> ret($params -> [1]);

$bld -> cond($cmp, $true_blk, $false_blk);

my ($stdout, $stderr);
capture { $mod -> dump } \$stdout, \$stderr;

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

is($stderr, $expected);

my $arg1 = LLVM::GenericValue -> int($intt, 10);
my $arg2 = LLVM::GenericValue -> int($intt, 15);

my $eng = LLVM::ExecutionEngine -> new($mod);

my $res1 = $eng -> run_func($fun, $arg1, $arg2);
is($res1 -> to_int, 15);

my $res2 = $eng -> run_func($fun, $arg2, $arg1);
is($res2 -> to_int, 15);

done_testing;

#!perl -T

use Test::More;
use IO::CaptureOutput qw(capture);

use LLVM;

my $ctx = LLVM::Context -> new;
my $mod = LLVM::Module -> new($ctx, "test");

my $intt = LLVM::Type -> int($ctx, 32);
my $funt = LLVM::Type -> func($intt, $intt, $intt, $intt);

my $fun = $mod -> add_func("add", $funt);

my $params = $fun -> func_params;

$params -> [0] -> set_name("x");
$params -> [1] -> set_name("y");
$params -> [2] -> set_name("z");

my $blk = $fun -> func_append($ctx, "entry");
my $bld = LLVM::Builder -> new($ctx, $blk);

my $tmp1 = $bld -> add($params -> [0], $params -> [1], "tmp1");
my $tmp2 = $bld -> mul($tmp1, $params -> [2], "tmp2");

$bld -> ret($tmp2);

my ($stdout, $stderr);
capture { $mod -> dump } \$stdout, \$stderr;

my $expected = <<'EOS';
; ModuleID = 'test'

define i32 @add(i32 %x, i32 %y, i32 %z) {
entry:
  %tmp1 = add i32 %x, %y
  %tmp2 = mul i32 %tmp1, %z
  ret i32 %tmp2
}
EOS

is($stderr, $expected);

done_testing;

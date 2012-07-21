#!perl -T

use Test::More;

use LLVM;

my $ctx = LLVM::Context -> new;
isa_ok($ctx, 'LLVM::Context');

my $mod = LLVM::Module -> new($ctx, "test");
isa_ok($mod, 'LLVM::Module');

my $intt = LLVM::Type -> int($ctx, 32);
my $funt = LLVM::Type -> func($intt, $intt, $intt);
isa_ok($funt, 'LLVM::Type');

my $fun = $mod -> add_func("add", $funt);
isa_ok($fun, 'LLVM::Value');

my $params = $fun -> func_params;

$params -> [0] -> set_name("x");
$params -> [1] -> set_name("y");

my $blk = $fun -> func_append($ctx, "entry");
isa_ok($blk, 'LLVM::BasicBlock');

my $bld = LLVM::Builder -> new($ctx, $blk);
isa_ok($bld, 'LLVM::Builder');

my $tmp = $bld -> add($params -> [0], $params -> [1], "tmp");
isa_ok($tmp, 'LLVM::Value');

$bld -> ret($tmp);

$mod -> dump;

done_testing;

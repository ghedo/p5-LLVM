package inc::MakeMaker;

use Moose;
use File::Which;
use Devel::CheckLib;

extends 'Dist::Zilla::Plugin::MakeMaker::Awesome';

my $llvmc = $ENV{LLVM_CONFIG} || 'llvm-config';
unless (which($llvmc)) { print "Can't find \"$llvmc\"\n"; exit }

override _build_MakeFile_PL_template => sub {
	my ($self) = @_;

	my $template = <<'TEMPLATE';
use Devel::CheckLib;

check_lib_or_exit(lib => 'LLVM-3.1');

TEMPLATE

	return $template.super();
};

override _build_WriteMakefile_args => sub {
	my $ccflags = `$llvmc --cflags`; chomp $ccflags;

	return +{
		%{ super() },
		LIBS		=> '-lLLVM-3.1',
		CCFLAGS		=> $ccflags,
		INC		=> '-I.',
		OBJECT		=> '$(O_FILES)',
	}
};

__PACKAGE__ -> meta -> make_immutable;

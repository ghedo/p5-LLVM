package inc::MakeMaker;

use Moose;
use Devel::CheckLib;

extends 'Dist::Zilla::Plugin::MakeMaker::Awesome';

my $ccflags = `llvm-config --cflags`;

override _build_MakeFile_PL_template => sub {
	my ($self) = @_;
	my $template  = "use Devel::CheckLib;\n";
	$template .= "check_lib_or_exit(lib => 'LLVM-3.1');\n";

	return $template.super();
};

override _build_WriteMakefile_args => sub {
	return +{
		%{ super() },
		LIBS		=> ['-lLLVM-3.1'],
		CCFLAGS		=> $ccflags,
		INC		=> '-I.',
		OBJECT		=> '$(O_FILES)',
	}
};

__PACKAGE__ -> meta -> make_immutable;

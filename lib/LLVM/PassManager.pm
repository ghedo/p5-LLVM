package LLVM::PassManager;

use strict;
use warnings;

=head1 NAME

LLVM::PassManager - LLVM pass manager class

=head1 DESCRIPTION

A C<LLVM::PassManager> holds and optimizes the  execution of passes. A pass
performs the transformations and optimizations that make up the compiler.

=head1 METHODS

=head2 new( )

Create a new whole-module C<LLVM::PassManager>.

=head2 run( $mod )

Run all the passes scheduled on the given L<LLVM::Module>. Returns true if any
of the passes modified the module, false otherwise.

=head1 AUTHOR

Alessandro Ghedini <alexbio@cpan.org>

=head1 LICENSE AND COPYRIGHT

Copyright 2012 Alessandro Ghedini.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut

1; # End of LLVM::PassManager

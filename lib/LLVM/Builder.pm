package LLVM::Builder;

use strict;
use warnings;

=head1 NAME

LLVM::Builder - LLVM builder class

=head1 DESCRIPTION

A C<LLVM::Builder> is the means of building instructions and represents a point
within a basic block.

=head1 METHODS

=head2 new( $ctx, $blk )

Create a new C<LLVM::Builder> object given a L<LLVM::Context> and a
L<LLVM::BasicBlock>.

=head2 add( $lhs, $rhs, $name )

Append an add instruction to the block. This function takes two L<LLVM::Value>s
representing the arguments and a string used to name the resulting variable. It
also returns a L<LLVM::Value> representing the result of the operation.

=head2 ret( $v )

Append a ret instruction to the block. This function takes a L<LLVM::Value>
representing the value to be returned and returns a L<LLVM::Value>.

=head1 AUTHOR

Alessandro Ghedini <alexbio@cpan.org>

=head1 LICENSE AND COPYRIGHT

Copyright 2012 Alessandro Ghedini.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut

1; # End of LLVM::Builder

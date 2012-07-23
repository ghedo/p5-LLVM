package LLVM::Type;

use strict;
use warnings;

=head1 NAME

LLVM::Type - LLVM type class

=head1 DESCRIPTION

A C<LLVM::Type> represents the type of an individual L<LLVM::Value>.

=head1 METHODS

=head2 void( $ctx )

Create a new C<LLVM::Type> representing a void given a L<LLVM::Context>.

=head2 int( $ctx, $bits )

Create a new C<LLVM::Type> representing an integer with C<$bits> bits (e.g. 16,
32, 64, ...) given a L<LLVM::Context>.

=head2 float( $ctx )

Create a new C<LLVM::Type> representing a float given a L<LLVM::Context>.

=head2 double( $ctx )

Create a new C<LLVM::Type> representing a double given a L<LLVM::Context>.

=head2 func( $ret_type [, $arg_type ...] )

Create a new C<LLVM::Type> representing a function with return type
C<$ret_type>. This functions also takes a variable number of arguments
representing the arguments of the function. The return type and arguments types
must be C<LLVM::Type> objects.

=head1 AUTHOR

Alessandro Ghedini <alexbio@cpan.org>

=head1 LICENSE AND COPYRIGHT

Copyright 2012 Alessandro Ghedini.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut

1; # End of LLVM::Type

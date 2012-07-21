package LLVM::Module;

use strict;
use warnings;

=head1 NAME

LLVM::Module - LLVM module class

=head1 DESCRIPTION

Some description here...

=head1 METHODS

=head2 new( $ctx, $id )

Create a new C<LLVM::Module> given its L<LLVM::Context> and a string
representing its id (name).

=head2 add_func( $func_name, $func_type )

Add a function named C<$func_name> with L<LLVM::Type> C<$func_type> to the
module.

=head2 dump( )

Dump the compiled module to C<STDERR> (useful for debug).

=head1 AUTHOR

Alessandro Ghedini <alexbio@cpan.org>

=head1 LICENSE AND COPYRIGHT

Copyright 2012 Alessandro Ghedini.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut

1; # End of LLVM::Module

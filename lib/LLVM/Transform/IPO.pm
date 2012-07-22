package LLVM::Transform::IPO;

use strict;
use warnings;

=head1 NAME

LLVM::Transform::IPO - LLVM interprocedural transformations class

=head1 DESCRIPTION

Various interprocedural transformations of the LLVM IR.

=head1 METHODS

=head2 argument_promotion( )

Schedule a ArgumentPromotion pass.

=head2 constant_merge( )

Schedule a ConstantMerge pass.

=head2 dead_arg_elimination( )

Schedule a DeadArgElimination pass.

=head2 function_attrs( )

Schedule a FunctionAttrs pass.

=head2 function_inlining( )

Schedule a FunctionInlining pass.

=head2 always_inliner( )

Schedule a AlwaysInliner pass.

=head2 global_dce( )

Schedule a GlobalDCE pass.

=head2 global_optimizer( )

Schedule a GlobalOptimizer pass.

=head2 ip_constant_propagation( )

Schedule a IPConstantPropagation pass.

=head2 prune_eh( )

Schedule a PruneEH pass.

=head2 ipsccp( )

Schedule a IPSCCP pass.

=head2 internalize( $all_but_main )

Schedule a Internalize pass.

=head2 strip_dead_prototypes( )

Schedule a StripDeadPrototypes pass.

=head2 strip_symbols( )

Schedule a StripSymbols pass.

=head1 AUTHOR

Alessandro Ghedini <alexbio@cpan.org>

=head1 LICENSE AND COPYRIGHT

Copyright 2012 Alessandro Ghedini.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut

1; # End of LLVM::Transform::IPO

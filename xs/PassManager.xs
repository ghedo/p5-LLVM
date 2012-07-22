MODULE = LLVM				PACKAGE = LLVM::PassManager

PassManager
new()
	CODE:
		RETVAL = LLVMCreatePassManager();

	OUTPUT: RETVAL

bool
run(self, mod)
	PassManager self
	Module mod

	CODE:
		RETVAL = LLVMRunPassManager(self, mod);

	OUTPUT: RETVAL

# IPO transformations

void argument_promotion(self)
	PassManager self

	CODE:
		LLVMAddArgumentPromotionPass(self);

void constant_merge(self)
	PassManager self

	CODE:
		LLVMAddConstantMergePass(self);

void dead_arg_elimination(self)
	PassManager self

	CODE:
		LLVMAddDeadArgEliminationPass(self);

void function_attrs(self)
	PassManager self

	CODE:
		LLVMAddFunctionAttrsPass(self);

void function_inlining(self)
	PassManager self

	CODE:
		LLVMAddFunctionInliningPass(self);

void always_inliner(self)
	PassManager self

	CODE:
		LLVMAddAlwaysInlinerPass(self);

void global_dce(self)
	PassManager self

	CODE:
		LLVMAddGlobalDCEPass(self);

void global_optimizer(self)
	PassManager self

	CODE:
		LLVMAddGlobalOptimizerPass(self);

void ip_constant_propagation(self)
	PassManager self

	CODE:
		LLVMAddIPConstantPropagationPass(self);

void prune_eh(self)
	PassManager self

	CODE:
		LLVMAddPruneEHPass(self);

void ipsccp(self)
	PassManager self

	CODE:
		LLVMAddIPSCCPPass(self);

void internalize(self, all_but_main)
	PassManager self
	unsigned int all_but_main

	CODE:
		LLVMAddInternalizePass(self, all_but_main);

void strip_dead_prototypes(self)
	PassManager self

	CODE:
		LLVMAddStripDeadPrototypesPass(self);

void strip_symbols(self)
	PassManager self

	CODE:
		LLVMAddStripSymbolsPass(self);

void
DESTROY(self)
	PassManager self

	CODE:
		LLVMDisposePassManager(self);

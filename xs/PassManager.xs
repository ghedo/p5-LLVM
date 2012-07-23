MODULE = LLVM				PACKAGE = LLVM::PassManager

PassManager
new(class)
	SV *class

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

void add(self, pass, ...)
	PassManager self
	SV *pass

	CODE:
		STRLEN len;
		char *spass = SvPVbyte(pass, len);

		# IPO transformations
		if (strcmp(spass, "ArgumentPromotion") == 0)
			LLVMAddArgumentPromotionPass(self);
		else if (strcmp(spass, "ConstantMerge") == 0)
			LLVMAddConstantMergePass(self);
		else if (strcmp(spass, "DeadArgElimination") == 0)
			LLVMAddDeadArgEliminationPass(self);
		else if (strcmp(spass, "FunctionAttrs") == 0)
			LLVMAddFunctionAttrsPass(self);
		else if (strcmp(spass, "FunctionInlining") == 0)
			LLVMAddFunctionInliningPass(self);
		else if (strcmp(spass, "AlwaysInliner") == 0)
			LLVMAddAlwaysInlinerPass(self);
		else if (strcmp(spass, "GlobalDCE") == 0)
			LLVMAddGlobalDCEPass(self);
		else if (strcmp(spass, "GlobalOptimizer") == 0)
			LLVMAddGlobalOptimizerPass(self);
		else if (strcmp(spass, "IPConstantPropagation") == 0)
			LLVMAddIPConstantPropagationPass(self);
		else if (strcmp(spass, "PruneEH") == 0)
			LLVMAddPruneEHPass(self);
		else if (strcmp(spass, "IPSCCP") == 0)
			LLVMAddIPSCCPPass(self);
		else if (strcmp(spass, "Internalize") == 0)
			LLVMAddInternalizePass(self, 1);
		else if (strcmp(spass, "StripDeadPrototypes") == 0)
			LLVMAddStripDeadPrototypesPass(self);
		else if (strcmp(spass, "StripSymbols") == 0)
			LLVMAddStripSymbolsPass(self);
		else
			Perl_croak(aTHX_ "invalid pass '%s'", spass);

void
DESTROY(self)
	PassManager self

	CODE:
		LLVMDisposePassManager(self);

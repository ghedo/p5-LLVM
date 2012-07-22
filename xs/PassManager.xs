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

void
DESTROY(self)
	PassManager self

	CODE:
		LLVMDisposePassManager(self);

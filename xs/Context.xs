MODULE = LLVM				PACKAGE = LLVM::Context

Context
new(class)
	SV *class

	CODE:
		RETVAL = LLVMContextCreate();

	OUTPUT:
		RETVAL

void
DESTROY(self)
	Context self

	CODE:
		LLVMContextDispose(self);

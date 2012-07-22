MODULE = LLVM				PACKAGE = LLVM::Module

Module
new(class, ctx, id)
	SV *class
	Context ctx
	SV *id

	CODE:
		STRLEN len;
		const char *name = SvPVbyte(id, len);

		RETVAL = LLVMModuleCreateWithNameInContext(name, ctx);

	OUTPUT: RETVAL

Value
add_func(self, func_name, func_type)
	Module self
	SV *func_name
	Type func_type

	CODE:
		STRLEN len;
		const char *name = SvPVbyte(func_name, len);

		Value val = LLVMAddFunction(self, name, func_type);

		RETVAL = val;

	OUTPUT: RETVAL

void
dump(self)
	Module self

	CODE:
		LLVMDumpModule(self);

void
DESTROY(self)
	Module self

	CODE:
		LLVMDisposeModule(self);

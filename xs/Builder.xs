MODULE = LLVM				PACKAGE = LLVM::Builder

Builder
new(class, ctx, blk)
	SV *class
	Context ctx
	BasicBlock blk

	CODE:
		Builder bld = LLVMCreateBuilderInContext(ctx);
		LLVMPositionBuilderAtEnd(bld, blk);

		RETVAL = bld;

	OUTPUT:
		RETVAL

Value
add(self, lhs, rhs, inst_name)
	Builder self
	Value lhs
	Value rhs
	SV *inst_name

	CODE:
		STRLEN len;
		const char *name = SvPVbyte(inst_name, len);

		RETVAL = LLVMBuildAdd(self, lhs, rhs, name);

	OUTPUT:
		RETVAL

Value
ret(self, v)
	Builder self
	Value v

	CODE:
		RETVAL = LLVMBuildRet(self, v);

	OUTPUT:
		RETVAL

void
DESTROY(self)
	Builder self

	CODE:
		LLVMDisposeBuilder(self);

MODULE = LLVM				PACKAGE = LLVM::Builder

#define BIN_OP(FN) FN(self, lhs, rhs, SvPVbyte(inst_name, len))

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

# Terminators

Value
ret(self, v)
	Builder self
	Value v

	CODE:
		RETVAL = LLVMBuildRet(self, v);

	OUTPUT:
		RETVAL

# Binary operations

Value
add(self, lhs, rhs, inst_name)
	Builder self
	Value lhs
	Value rhs
	SV *inst_name

	CODE:
		STRLEN len; RETVAL = BIN_OP(LLVMBuildAdd);
	OUTPUT:
		RETVAL

Value
fadd(self, lhs, rhs, inst_name)
	Builder self
	Value lhs
	Value rhs
	SV *inst_name

	CODE:
		STRLEN len; RETVAL = BIN_OP(LLVMBuildFAdd);

	OUTPUT:
		RETVAL

Value
mul(self, lhs, rhs, inst_name)
	Builder self
	Value lhs
	Value rhs
	SV *inst_name

	CODE:
		STRLEN len; RETVAL = BIN_OP(LLVMBuildMul);

	OUTPUT:
		RETVAL

Value
fmul(self, lhs, rhs, inst_name)
	Builder self
	Value lhs
	Value rhs
	SV *inst_name

	CODE:
		STRLEN len; RETVAL = BIN_OP(LLVMBuildFMul);

	OUTPUT:
		RETVAL

Value
sub(self, lhs, rhs, inst_name)
	Builder self
	Value lhs
	Value rhs
	SV *inst_name

	CODE:
		STRLEN len; RETVAL = BIN_OP(LLVMBuildSub);

	OUTPUT:
		RETVAL

Value
fsub(self, lhs, rhs, inst_name)
	Builder self
	Value lhs
	Value rhs
	SV *inst_name

	CODE:
		STRLEN len; RETVAL = BIN_OP(LLVMBuildFSub);

	OUTPUT:
		RETVAL

Value
udiv(self, lhs, rhs, inst_name)
	Builder self
	Value lhs
	Value rhs
	SV *inst_name

	CODE:
		STRLEN len; RETVAL = BIN_OP(LLVMBuildUDiv);

	OUTPUT:
		RETVAL

Value
sdiv(self, lhs, rhs, inst_name)
	Builder self
	Value lhs
	Value rhs
	SV *inst_name

	CODE:
		STRLEN len; RETVAL = BIN_OP(LLVMBuildSDiv);

	OUTPUT:
		RETVAL

Value
fdiv(self, lhs, rhs, inst_name)
	Builder self
	Value lhs
	Value rhs
	SV *inst_name

	CODE:
		STRLEN len; RETVAL = BIN_OP(LLVMBuildFDiv);

	OUTPUT:
		RETVAL

# Binary bitwise operations

Value
shl(self, lhs, rhs, inst_name)
	Builder self
	Value lhs
	Value rhs
	SV *inst_name

	CODE:
		STRLEN len; RETVAL = BIN_OP(LLVMBuildShl);

	OUTPUT:
		RETVAL

Value
lshr(self, lhs, rhs, inst_name)
	Builder self
	Value lhs
	Value rhs
	SV *inst_name

	CODE:
		STRLEN len; RETVAL = BIN_OP(LLVMBuildLShr);

	OUTPUT:
		RETVAL

Value
ashr(self, lhs, rhs, inst_name)
	Builder self
	Value lhs
	Value rhs
	SV *inst_name

	CODE:
		STRLEN len; RETVAL = BIN_OP(LLVMBuildAShr);

	OUTPUT:
		RETVAL

Value
and(self, lhs, rhs, inst_name)
	Builder self
	Value lhs
	Value rhs
	SV *inst_name

	CODE:
		STRLEN len; RETVAL = BIN_OP(LLVMBuildAnd);

	OUTPUT:
		RETVAL

Value
or(self, lhs, rhs, inst_name)
	Builder self
	Value lhs
	Value rhs
	SV *inst_name

	CODE:
		STRLEN len; RETVAL = BIN_OP(LLVMBuildOr);

	OUTPUT:
		RETVAL

Value
xor(self, lhs, rhs, inst_name)
	Builder self
	Value lhs
	Value rhs
	SV *inst_name

	CODE:
		STRLEN len; RETVAL = BIN_OP(LLVMBuildXor);

	OUTPUT:
		RETVAL

void
DESTROY(self)
	Builder self

	CODE:
		LLVMDisposeBuilder(self);

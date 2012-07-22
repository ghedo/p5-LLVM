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

	OUTPUT: RETVAL

# Terminators

Value
ret(self, v)
	Builder self
	Value v

	CODE:
		RETVAL = LLVMBuildRet(self, v);

	OUTPUT: RETVAL

Value
ret_void(self)
	Builder self

	CODE:
		RETVAL = LLVMBuildRetVoid(self);

	OUTPUT: RETVAL

Value
cond(self, cond, th, el)
	Builder self
	Value cond
	BasicBlock th
	BasicBlock el

	CODE:
		RETVAL = LLVMBuildCondBr(self, cond, th, el);

	OUTPUT: RETVAL

# Binary operations

Value
add(self, lhs, rhs, inst_name)
	Builder self
	Value lhs
	Value rhs
	SV *inst_name

	CODE:
		STRLEN len; RETVAL = BIN_OP(LLVMBuildAdd);

	OUTPUT: RETVAL

Value
fadd(self, lhs, rhs, inst_name)
	Builder self
	Value lhs
	Value rhs
	SV *inst_name

	CODE:
		STRLEN len; RETVAL = BIN_OP(LLVMBuildFAdd);

	OUTPUT: RETVAL

Value
mul(self, lhs, rhs, inst_name)
	Builder self
	Value lhs
	Value rhs
	SV *inst_name

	CODE:
		STRLEN len; RETVAL = BIN_OP(LLVMBuildMul);

	OUTPUT: RETVAL

Value
fmul(self, lhs, rhs, inst_name)
	Builder self
	Value lhs
	Value rhs
	SV *inst_name

	CODE:
		STRLEN len; RETVAL = BIN_OP(LLVMBuildFMul);

	OUTPUT: RETVAL

Value
sub(self, lhs, rhs, inst_name)
	Builder self
	Value lhs
	Value rhs
	SV *inst_name

	CODE:
		STRLEN len; RETVAL = BIN_OP(LLVMBuildSub);

	OUTPUT: RETVAL

Value
fsub(self, lhs, rhs, inst_name)
	Builder self
	Value lhs
	Value rhs
	SV *inst_name

	CODE:
		STRLEN len; RETVAL = BIN_OP(LLVMBuildFSub);

	OUTPUT: RETVAL

Value
udiv(self, lhs, rhs, inst_name)
	Builder self
	Value lhs
	Value rhs
	SV *inst_name

	CODE:
		STRLEN len; RETVAL = BIN_OP(LLVMBuildUDiv);

	OUTPUT: RETVAL

Value
sdiv(self, lhs, rhs, inst_name)
	Builder self
	Value lhs
	Value rhs
	SV *inst_name

	CODE:
		STRLEN len; RETVAL = BIN_OP(LLVMBuildSDiv);

	OUTPUT: RETVAL

Value
fdiv(self, lhs, rhs, inst_name)
	Builder self
	Value lhs
	Value rhs
	SV *inst_name

	CODE:
		STRLEN len; RETVAL = BIN_OP(LLVMBuildFDiv);

	OUTPUT: RETVAL

# Binary bitwise operations

Value
shl(self, lhs, rhs, inst_name)
	Builder self
	Value lhs
	Value rhs
	SV *inst_name

	CODE:
		STRLEN len; RETVAL = BIN_OP(LLVMBuildShl);

	OUTPUT: RETVAL

Value
lshr(self, lhs, rhs, inst_name)
	Builder self
	Value lhs
	Value rhs
	SV *inst_name

	CODE:
		STRLEN len; RETVAL = BIN_OP(LLVMBuildLShr);

	OUTPUT: RETVAL

Value
ashr(self, lhs, rhs, inst_name)
	Builder self
	Value lhs
	Value rhs
	SV *inst_name

	CODE:
		STRLEN len; RETVAL = BIN_OP(LLVMBuildAShr);

	OUTPUT: RETVAL

Value
and(self, lhs, rhs, inst_name)
	Builder self
	Value lhs
	Value rhs
	SV *inst_name

	CODE:
		STRLEN len; RETVAL = BIN_OP(LLVMBuildAnd);

	OUTPUT: RETVAL

Value
or(self, lhs, rhs, inst_name)
	Builder self
	Value lhs
	Value rhs
	SV *inst_name

	CODE:
		STRLEN len; RETVAL = BIN_OP(LLVMBuildOr);

	OUTPUT: RETVAL

Value
xor(self, lhs, rhs, inst_name)
	Builder self
	Value lhs
	Value rhs
	SV *inst_name

	CODE:
		STRLEN len; RETVAL = BIN_OP(LLVMBuildXor);

	OUTPUT: RETVAL

# Misc

Value
icmp(self, pred, lhs, rhs, inst_name)
	Builder self
	SV *pred
	Value lhs
	Value rhs
	SV *inst_name

	CODE:
		STRLEN len;
		LLVMIntPredicate ipred;
		char *spred = SvPVbyte(pred, len);

		if (strncmp(spred, "eq", 2) == 0)
			ipred = LLVMIntEQ;
		else if (strncmp(spred, "ne", 2) == 0)
			ipred = LLVMIntNE;
		else if (strncmp(spred, "ugt", 3) == 0)
			ipred = LLVMIntUGT;
		else if (strncmp(spred, "uge", 3) == 0)
			ipred = LLVMIntUGE;
		else if (strncmp(spred, "ult", 3) == 0)
			ipred = LLVMIntULT;
		else if (strncmp(spred, "ule", 3) == 0)
			ipred = LLVMIntULE;
		else if (strncmp(spred, "sgt", 3) == 0)
			ipred = LLVMIntSGT;
		else if (strncmp(spred, "sge", 3) == 0)
			ipred = LLVMIntSGE;
		else if (strncmp(spred, "slt", 3) == 0)
			ipred = LLVMIntSLT;
		else if (strncmp(spred, "sge", 3) == 0)
			ipred = LLVMIntSGE;
		else
			Perl_croak(aTHX_ "invalid predicate '%s'\n", spred);

		RETVAL = LLVMBuildICmp(
			self, ipred, lhs, rhs, SvPVbyte(inst_name, len)
		);

	OUTPUT: RETVAL

Value
fcmp(self, pred, lhs, rhs, inst_name)
	Builder self
	SV *pred
	Value lhs
	Value rhs
	SV *inst_name

	CODE:
		STRLEN len;
		LLVMRealPredicate rpred;
		char *spred = SvPVbyte(pred, len);

		if (strncmp(spred, "false", 5) == 0)
			rpred = LLVMRealPredicateFalse;
		else if (strncmp(spred, "oeq", 3) == 0)
			rpred = LLVMRealOEQ;
		else if (strncmp(spred, "ogt", 3) == 0)
			rpred = LLVMRealOGT;
		else if (strncmp(spred, "oge", 3) == 0)
			rpred = LLVMRealOGE;
		else if (strncmp(spred, "olt", 3) == 0)
			rpred = LLVMRealOLT;
		else if (strncmp(spred, "ole", 3) == 0)
			rpred = LLVMRealOLE;
		else if (strncmp(spred, "one", 3) == 0)
			rpred = LLVMRealONE;
		else if (strncmp(spred, "ord", 3) == 0)
			rpred = LLVMRealORD;
		else if (strncmp(spred, "uno", 3) == 0)
			rpred = LLVMRealUNO;
		else if (strncmp(spred, "ueq", 3) == 0)
			rpred = LLVMRealUEQ;
		else if (strncmp(spred, "ugt", 3) == 0)
			rpred = LLVMRealUGT;
		else if (strncmp(spred, "uge", 3) == 0)
			rpred = LLVMRealUGE;
		else if (strncmp(spred, "ult", 3) == 0)
			rpred = LLVMRealULT;
		else if (strncmp(spred, "ule", 3) == 0)
			rpred = LLVMRealULE;
		else if (strncmp(spred, "une", 3) == 0)
			rpred = LLVMRealUNE;
		if (strncmp(spred, "true", 4) == 0)
			rpred = LLVMRealPredicateTrue;
		else
			Perl_croak(aTHX_ "invalid predicate '%s'\n", spred);

		RETVAL = LLVMBuildFCmp(
			self, rpred, lhs, rhs, SvPVbyte(inst_name, len)
		);

	OUTPUT: RETVAL

void
DESTROY(self)
	Builder self

	CODE:
		LLVMDisposeBuilder(self);

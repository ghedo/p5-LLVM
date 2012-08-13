MODULE = LLVM				PACKAGE = LLVM::Value

Type
type(self)
	Value self

	CODE:
		RETVAL = LLVMTypeOf(self);

	OUTPUT: RETVAL

void
set_name(self, val_name)
	Value self
	SV *val_name

	CODE:
		const char *name = SvPVbyte_nolen(val_name);

		LLVMSetValueName(self, name);

AV *
func_params(self)
	Value self

	CODE:
		AV *params = newAV();
		unsigned int i, count = LLVMCountParams(self);

		Value *values = malloc(sizeof(Value) * count);

		LLVMGetParams(self, values);

		for (i = 0; i < count; i++) {
			SV *param = sv_setref_pv(
				newSV(0), "LLVM::Value",
				(void *) values[i]
			);

			av_push(params, param);
		}

		RETVAL = params;

	OUTPUT: RETVAL

BasicBlock
func_append(self, block_name)
	Value self
	SV *block_name

	CODE:
		const char *name = SvPVbyte_nolen(block_name);

		RETVAL = LLVMAppendBasicBlock(self, name);

	OUTPUT: RETVAL

bool
global_is_constant(self, ...)
	Value self

	CODE:
		if (items == 2) LLVMSetGlobalConstant(self, SvIV(ST(1)));

		RETVAL = LLVMIsGlobalConstant(self);

	OUTPUT: RETVAL

bool
global_is_threadlocal(self, ...)
	Value self

	CODE:
		if (items == 2) LLVMSetThreadLocal(self, SvIV(ST(1)));

		RETVAL = LLVMIsThreadLocal(self);

	OUTPUT: RETVAL

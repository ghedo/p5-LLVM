MODULE = LLVM				PACKAGE = LLVM::Value

Type
type(self)
	Value self

	CODE:
		RETVAL = LLVMTypeOf(self);

	OUTPUT:
		RETVAL

void
set_name(self, val_name)
	Value self
	SV *val_name

	CODE:
		STRLEN len;
		const char *name = SvPVbyte(val_name, len);

		LLVMSetValueName(self, name);

AV *
func_params(self)
	Value self

	CODE:
		int i;
		AV *params = newAV();
		unsigned int count = LLVMCountParams(self);

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

	OUTPUT:
		RETVAL

BasicBlock
func_append(self, ctx, block_name)
	Value self
	Context ctx
	SV *block_name

	CODE:
		STRLEN len;
		const char *name = SvPVbyte(block_name, len);

		RETVAL = LLVMAppendBasicBlockInContext(ctx, self, name);

	OUTPUT:
		RETVAL

MODULE = LLVM				PACKAGE = LLVM::Type

Type
int(class, ctx, bits)
	SV *class
	Context ctx
	unsigned int bits

	CODE:
		RETVAL = LLVMIntTypeInContext(ctx, bits);

	OUTPUT:
		RETVAL

Type
float(class, ctx)
	SV *class
	Context ctx

	CODE:
		RETVAL = LLVMFloatTypeInContext(ctx);

	OUTPUT:
		RETVAL

Type
double(class, ctx)
	SV *class
	Context ctx

	CODE:
		RETVAL = LLVMDoubleTypeInContext(ctx);

	OUTPUT:
		RETVAL

Type
func(class, ret_type, ...)
	SV *class
	Type ret_type

	CODE:
		int i;

		Type *params = malloc(sizeof(Type) * (items - 2));

		for (i = 2; i < items; i++) {
			Type param;
			SV *arg = ST(i);

			if (sv_isobject(arg) && sv_derived_from(arg, "LLVM::Type"))
				param = INT2PTR(Type, SvIV((SV *) SvRV(arg)));
			else
				Perl_croak(aTHX_ "arg is not of type LLVM::Type");

			params[i - 2] = param;
		}

		RETVAL = LLVMFunctionType(ret_type, params, items - 2, 0);

	OUTPUT:
		RETVAL

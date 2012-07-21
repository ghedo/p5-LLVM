#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include <llvm-c/Core.h>

typedef LLVMContextRef		Context;
typedef LLVMModuleRef		Module;
typedef LLVMTypeRef		Type;
typedef LLVMValueRef		Value;
typedef LLVMBasicBlockRef	BasicBlock;
typedef LLVMBuilderRef		Builder;

MODULE = LLVM				PACKAGE = LLVM

INCLUDE: xs/Context.xs
INCLUDE: xs/Module.xs
INCLUDE: xs/Type.xs
INCLUDE: xs/Value.xs
INCLUDE: xs/Builder.xs

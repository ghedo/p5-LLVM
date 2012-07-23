#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include <llvm-c/Core.h>

#include <llvm-c/Transforms/IPO.h>
#include <llvm-c/Transforms/Scalar.h>
#include <llvm-c/Transforms/Vectorize.h>

#include <llvm-c/ExecutionEngine.h>

typedef LLVMContextRef		Context;
typedef LLVMModuleRef		Module;
typedef LLVMTypeRef		Type;
typedef LLVMValueRef		Value;
typedef LLVMBasicBlockRef	BasicBlock;
typedef LLVMBuilderRef		Builder;
typedef LLVMPassManagerRef	PassManager;

typedef LLVMGenericValueRef	GenericValue;
typedef LLVMExecutionEngineRef	ExecutionEngine;

MODULE = LLVM				PACKAGE = LLVM

# Core
INCLUDE: xs/Context.xs
INCLUDE: xs/Module.xs
INCLUDE: xs/Type.xs
INCLUDE: xs/Value.xs
INCLUDE: xs/Builder.xs
INCLUDE: xs/PassManager.xs

# ExecutionEngine
INCLUDE: xs/GenericValue.xs
INCLUDE: xs/ExecutionEngine.xs

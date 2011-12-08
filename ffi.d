module ffi;

private
{
    enum ffi_status
    {
        FFI_OK,
        FFI_BAD_TYPEDEF,
        FFI_BAD_ABI,
    }

    version (X86)
    {
        enum ffi_abi
        {
            FFI_DEFAULT_ABI = 1, // FFI_SYSV
        }
    }
    else version (X86_64)
    {
        version (Windows)
        {
            enum ffi_abi
            {
                FFI_DEFAULT_ABI = 1, // FFI_WIN64
            }
        }
        else
        {
            enum ffi_abi
            {
                FFI_DEFAULT_ABI = 2, // FFI_UNIX64
            }
        }
    }
    else version (ARM)
    {
        enum ffi_abi
        {
            // TODO: Check for VFP (FFI_VFP).
            FFI_DEFAULT_ABI = 1, // FFI_SYSV
        }
    }
    else version (PPC)
    {
        version (AIX)
        {
            enum ffi_abi
            {
                FFI_DEFAULT_ABI = 1, // FFI_AIX
            }
        }
        else version (OSX)
        {
            enum ffi_abi
            {
                FFI_DEFAULT_ABI = 1, // FFI_DARWIN
            }
        }
        else version (FreeBSD)
        {
            enum ffi_abi
            {
                FFI_DEFAULT_ABI = 1, // FFI_SYSV
            }
        }
        else
        {
            enum ffi_abi
            {
                // TODO: Detect soft float (FFI_LINUX_SOFT_FLOAT) and FFI_LINUX.
                FFI_DEFAULT_ABI = 2, // FFI_GCC_SYSV
            }
        }
    }
    else version (PPC64)
    {
        enum ffi_abi
        {
            FFI_DEFAULT_ABI = 3, // FFI_LINUX64
        }
    }
    else version (IA64)
    {
        enum ffi_abi
        {
            FFI_DEFAULT_ABI = 1, // FFI_UNIX
        }
    }
    else version (MIPS)
    {
        enum ffi_abi
        {
            // TODO: Detect soft float (FFI_*_SOFT_FLOAT).
            // TODO: Detect O32 vs N32.
            FFI_DEFAULT_ABI = 1, // FFI_O32
        }
    }
    else version (MIPS64)
    {
        enum ffi_abi
        {
            FFI_DEFAULT_ABI = 3, // FFI_N64
        }
    }
    else version (SPARC)
    {
        enum ffi_abi
        {
            FFI_DEFAULT_ABI = 1, // FFI_V8
        }
    }
    else version (SPARC64)
    {
        enum ffi_abi
        {
            FFI_DEFAULT_ABI = 3, // FFI_V9
        }
    }
    else version (S390)
    {
        enum ffi_abi
        {
            FFI_DEFAULT_ABI = 1, // FFI_SYSV
        }
    }
    else version (S390X)
    {
        enum ffi_abi
        {
            FFI_DEFAULT_ABI = 1, // FFI_SYSV
        }
    }
    else version (HPPA)
    {
        enum ffi_abi
        {
            FFI_DEFAULT_ABI = 1, // FFI_PA32
        }
    }
    else version (HPPA64)
    {
        enum ffi_abi
        {
            FFI_DEFAULT_ABI = 1, // FFI_PA64
        }
    }
    else version (SH)
    {
        enum ffi_abi
        {
            FFI_DEFAULT_ABI = 1, // FFI_SYSV
        }
    }
    else version (SH64)
    {
        enum ffi_abi
        {
            FFI_DEFAULT_ABI = 1, // FFI_SYSV
        }
    }
    else version (Alpha)
    {
        enum ffi_abi
        {
            FFI_DEFAULT_ABI = 1, // FFI_OSF
        }
    }
    else
        static assert(false, "Unsupported architecture/platform.");

    struct ffi_type
    {
        size_t size;
        ushort alignment;
        ushort type;
        ffi_type** elements;
    }

    struct ffi_cif
    {
        int abi;
        uint nargs;
        ffi_type** arg_types;
        ffi_type* rtype;
        uint bytes;
        uint flags;
    }

    extern (C)
    {
        extern __gshared
        {
            ffi_type ffi_type_void;
            ffi_type ffi_type_uint8;
            ffi_type ffi_type_sint8;
            ffi_type ffi_type_uint16;
            ffi_type ffi_type_sint16;
            ffi_type ffi_type_uint32;
            ffi_type ffi_type_sint32;
            ffi_type ffi_type_uint64;
            ffi_type ffi_type_sint64;
            ffi_type ffi_type_float;
            ffi_type ffi_type_double;
            ffi_type ffi_type_pointer;
        }

        ffi_status ffi_prep_cif(ffi_cif* cif,
                                ffi_abi abi,
                                uint nargs,
                                ffi_type* rtype,
                                ffi_type** atypes);

        ffi_status ffi_prep_cif_var(ffi_cif* cif,
                                    ffi_abi abi,
                                    uint nfixedargs,
                                    uint ntotalargs,
                                    ffi_type* rtype,
                                    ffi_type** atypes);

        void ffi_call(ffi_cif* cif,
                      void* fn,
                      void* rvalue,
                      void** avalue);
    }

    ffi_status initializeCIF(ffi_cif* cif,
                             ffi_type*[] argTypes,
                             ffi_type* returnType,
                             int abi)
    {
        return ffi_prep_cif(cif,
                            cast(ffi_abi)abi,
                            cast(uint)argTypes.length,
                            returnType,
                            argTypes.ptr);
    }

    ffi_status initializeVarCIF(ffi_cif* cif,
                                ffi_type*[] argTypes,
                                uint variadicArgs,
                                ffi_type* returnType,
                                int abi)
    {
        return ffi_prep_cif_var(cif,
                                cast(ffi_abi)abi,
                                cast(uint)argTypes.length,
                                cast(uint)argTypes.length + variadicArgs,
                                returnType,
                                argTypes.ptr);
    }

    ffi_type* publicTypeToPointer(FFIType type)
    {
        final switch (type)
        {
            case FFIType.ffiVoid:
                return &ffi_type_void;
            case FFIType.ffiUByte:
                return &ffi_type_uint8;
            case FFIType.ffiByte:
                return &ffi_type_sint8;
            case FFIType.ffiUShort:
                return &ffi_type_uint16;
            case FFIType.ffiShort:
                return &ffi_type_sint16;
            case FFIType.ffiUInt:
                return &ffi_type_uint32;
            case FFIType.ffiInt:
                return &ffi_type_sint32;
            case FFIType.ffiULong:
                return &ffi_type_uint64;
            case FFIType.ffiLong:
                return &ffi_type_sint64;
            case FFIType.ffiFloat:
                return &ffi_type_float;
            case FFIType.ffiDouble:
                return &ffi_type_double;
            case FFIType.ffiPointer:
                return &ffi_type_pointer;
        }
    }
}

enum FFIType
{
    ffiVoid,
    ffiUByte,
    ffiByte,
    ffiUShort,
    ffiShort,
    ffiUInt,
    ffiInt,
    ffiULong,
    ffiLong,
    ffiFloat,
    ffiDouble,
    ffiPointer,
}

enum FFIStatus
{
    success,
    badType,
    badABI,
}

version (X86)
{
    enum FFIInterface
    {
        platform,
        stdCall,
    }
}
else
{
    enum FFIInterface
    {
        platform,
    }
}

alias extern (C) void function() FFIFunction;

FFIStatus ffiCall(FFIFunction func,
                  FFIType returnType,
                  FFIType[] parameterTypes,
                  uint variadicArgs,
                  void* returnValue,
                  void*[] argumentValues,
                  FFIInterface abi = FFIInterface.platform)
in
{
    assert(func);

    if (returnType != FFIType.ffiVoid)
        assert(returnValue);

    assert(parameterTypes.length + variadicArgs == argumentValues.length);
}
body
{
    ffi_type*[] argTypes;

    foreach (param; parameterTypes)
        argTypes ~= publicTypeToPointer(param);

    ffi_cif cif;
    ffi_status status;
    int selectedABI = ffi_abi.FFI_DEFAULT_ABI;

    version (Win32)
    {
        if (abi == FFIInterface.stdCall)
            selectedABI = 2; // FFI_STDCALL
    }

    auto retType = publicTypeToPointer(returnType);

    if (variadicArgs)
        status = initializeVarCIF(&cif, argTypes, variadicArgs, retType, selectedABI);
    else
        status = initializeCIF(&cif, argTypes, retType, selectedABI);

    if (status != ffi_status.FFI_OK)
        return cast(FFIStatus)status;

    ffi_call(&cif, cast(void*)func, returnValue, argumentValues.ptr);

    return FFIStatus.success;
}

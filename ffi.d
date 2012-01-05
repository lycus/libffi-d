module ffi;

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

    version (Windows)
    {
        enum FFI_TRAMPOLINE_SIZE = 13;
    }
    else
    {
        enum FFI_TRAMPOLINE_SIZE = 24;
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

        enum FFI_TRAMPOLINE_SIZE = 29;
    }
    else
    {
        enum ffi_abi
        {
            FFI_DEFAULT_ABI = 2, // FFI_UNIX64
        }

        enum FFI_TRAMPOLINE_SIZE = 10;
    }
}
else version (ARM)
{
    enum ffi_abi
    {
        // TODO: Check for VFP (FFI_VFP).
        FFI_DEFAULT_ABI = 1, // FFI_SYSV
    }

    enum FFI_TRAMPOLINE_SIZE = 20;
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

    enum FFI_TRAMPOLINE_SIZE = 40;
}
else version (PPC64)
{
    enum ffi_abi
    {
        FFI_DEFAULT_ABI = 3, // FFI_LINUX64
    }

    version (OSX)
    {
        enum FFI_TRAMPOLINE_SIZE = 48;
    }
    else
    {
        enum FFI_TRAMPOLINE_SIZE = 24;
    }
}
else version (IA64)
{
    enum ffi_abi
    {
        FFI_DEFAULT_ABI = 1, // FFI_UNIX
    }

    enum FFI_TRAMPOLINE_SIZE = 24;
}
else version (MIPS)
{
    enum ffi_abi
    {
        // TODO: Detect soft float (FFI_*_SOFT_FLOAT).
        // TODO: Detect O32 vs N32.
        FFI_DEFAULT_ABI = 1, // FFI_O32
    }

    enum FFI_TRAMPOLINE_SIZE = 20;
}
else version (MIPS64)
{
    enum ffi_abi
    {
        FFI_DEFAULT_ABI = 3, // FFI_N64
    }

    enum FFI_TRAMPOLINE_SIZE = 20;
}
else version (SPARC)
{
    enum ffi_abi
    {
        FFI_DEFAULT_ABI = 1, // FFI_V8
    }

    enum FFI_TRAMPOLINE_SIZE = 16;
}
else version (SPARC64)
{
    enum ffi_abi
    {
        FFI_DEFAULT_ABI = 3, // FFI_V9
    }

    enum FFI_TRAMPOLINE_SIZE = 24;
}
else version (S390)
{
    enum ffi_abi
    {
        FFI_DEFAULT_ABI = 1, // FFI_SYSV
    }

    enum FFI_TRAMPOLINE_SIZE = 16;
}
else version (S390X)
{
    enum ffi_abi
    {
        FFI_DEFAULT_ABI = 1, // FFI_SYSV
    }

    enum FFI_TRAMPOLINE_SIZE = 32;
}
else version (HPPA)
{
    enum ffi_abi
    {
        FFI_DEFAULT_ABI = 1, // FFI_PA32
    }

    enum FFI_TRAMPOLINE_SIZE = 32;
}
else version (HPPA64)
{
    enum ffi_abi
    {
        FFI_DEFAULT_ABI = 1, // FFI_PA64
    }

    // TODO: Verify validity of this.
    enum FFI_TRAMPOLINE_SIZE = 40;
}
else version (SH)
{
    enum ffi_abi
    {
        FFI_DEFAULT_ABI = 1, // FFI_SYSV
    }

    enum FFI_TRAMPOLINE_SIZE = 16;
}
else version (SH64)
{
    enum ffi_abi
    {
        FFI_DEFAULT_ABI = 1, // FFI_SYSV
    }

    enum FFI_TRAMPOLINE_SIZE = 32;
}
else version (Alpha)
{
    enum ffi_abi
    {
        FFI_DEFAULT_ABI = 1, // FFI_OSF
    }

    enum FFI_TRAMPOLINE_SIZE = 24;
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

struct ffi_closure
{
    char[FFI_TRAMPOLINE_SIZE] tramp;
    ffi_cif* cif;
    ffi_closure_fun fun;
    void* user_data;
}

extern (C)
{
    alias void function(ffi_cif*, void*, void**, void*) ffi_closure_fun;

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

    void ffi_call(ffi_cif* cif,
                  void* fn,
                  void* rvalue,
                  void** avalue);

    void* ffi_closure_alloc(size_t size,
                            void** code);

    void ffi_closure_free(void* writable);

    ffi_status ffi_prep_closure_loc(ffi_closure* closure,
                                    ffi_cif* cif,
                                    ffi_closure_fun fun,
                                    void* user_data,
                                    void* codeloc);
}

struct FFIType
{
    private ffi_type* _type;

    private this(ffi_type* type)
    {
        _type = type;
    }

    this(FFIType*[] fields)
    in
    {
        foreach (field; fields)
            assert(field);
    }
    body
    {
        _type = new ffi_type();
        _type.type = 13; // FFI_TYPE_STRUCT

        ffi_type*[] f;

        foreach (fld; fields)
            f ~= fld._type;

        _type.elements = f.ptr;
    }

    shared static this()
    {
        _ffiVoid = FFIType(&ffi_type_void);
        _ffiByte = FFIType(&ffi_type_sint8);
        _ffiUByte = FFIType(&ffi_type_uint8);
        _ffiShort = FFIType(&ffi_type_sint16);
        _ffiUShort = FFIType(&ffi_type_uint16);
        _ffiInt = FFIType(&ffi_type_sint32);
        _ffiUInt = FFIType(&ffi_type_uint32);
        _ffiLong = FFIType(&ffi_type_sint64);
        _ffiULong = FFIType(&ffi_type_uint64);
        _ffiFloat = FFIType(&ffi_type_float);
        _ffiDouble = FFIType(&ffi_type_double);
        _ffiPointer = FFIType(&ffi_type_pointer);
    }

    private __gshared FFIType _ffiVoid;
    private __gshared FFIType _ffiByte;
    private __gshared FFIType _ffiUByte;
    private __gshared FFIType _ffiShort;
    private __gshared FFIType _ffiUShort;
    private __gshared FFIType _ffiInt;
    private __gshared FFIType _ffiUInt;
    private __gshared FFIType _ffiLong;
    private __gshared FFIType _ffiULong;
    private __gshared FFIType _ffiFloat;
    private __gshared FFIType _ffiDouble;
    private __gshared FFIType _ffiPointer;

    @property static FFIType* ffiVoid()
    out (result)
    {
        assert(result);
    }
    body
    {
        return &_ffiVoid;
    }

    @property static FFIType* ffiByte()
    out (result)
    {
        assert(result);
    }
    body
    {
        return &_ffiByte;
    }

    @property static FFIType* ffiUByte()
    out (result)
    {
        assert(result);
    }
    body
    {
        return &_ffiUByte;
    }

    @property static FFIType* ffiShort()
    out (result)
    {
        assert(result);
    }
    body
    {
        return &_ffiShort;
    }

    @property static FFIType* ffiUShort()
    out (result)
    {
        assert(result);
    }
    body
    {
        return &_ffiUShort;
    }

    @property static FFIType* ffiInt()
    out (result)
    {
        assert(result);
    }
    body
    {
        return &_ffiInt;
    }

    @property static FFIType* ffiUInt()
    out (result)
    {
        assert(result);
    }
    body
    {
        return &_ffiUInt;
    }

    @property static FFIType* ffiLong()
    out (result)
    {
        assert(result);
    }
    body
    {
        return &_ffiLong;
    }

    @property static FFIType* ffiULong()
    out (result)
    {
        assert(result);
    }
    body
    {
        return &_ffiULong;
    }

    @property static FFIType* ffiFloat()
    out (result)
    {
        assert(result);
    }
    body
    {
        return &_ffiFloat;
    }

    @property static FFIType* ffiDouble()
    out (result)
    {
        assert(result);
    }
    body
    {
        return &_ffiDouble;
    }

    @property static FFIType* ffiPointer()
    out (result)
    {
        assert(result);
    }
    body
    {
        return &_ffiPointer;
    }
}

enum FFIStatus
{
    success,
    badType,
    badABI,
}

version (Win32)
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

alias void function() FFIFunction;

FFIStatus ffiCall(FFIFunction func,
                  FFIType* returnType,
                  FFIType*[] parameterTypes,
                  void* returnValue,
                  void*[] argumentValues,
                  FFIInterface abi = FFIInterface.platform)
in
{
    assert(func);
    assert(returnType);

    foreach (param; parameterTypes)
        assert(param);

    if (returnType != FFIType.ffiVoid)
        assert(returnValue);

    foreach (arg; argumentValues)
        assert(arg);

    assert(argumentValues.length == parameterTypes.length);
}
body
{
    ffi_type*[] argTypes;

    foreach (param; parameterTypes)
        argTypes ~= param._type;

    int selectedABI = ffi_abi.FFI_DEFAULT_ABI;

    version (Win32)
    {
        if (abi == FFIInterface.stdCall)
            selectedABI = 2; // FFI_STDCALL
    }

    ffi_cif cif;

    auto status = ffi_prep_cif(&cif, cast(ffi_abi)selectedABI, cast(uint)argTypes.length, returnType._type, argTypes.ptr);

    if (status != ffi_status.FFI_OK)
        return cast(FFIStatus)status;

    ffi_call(&cif, cast(void*)func, returnValue, argumentValues.ptr);

    return FFIStatus.success;
}

final class FFIClosure
{
    private ffi_cif* _cif;
    private FFIFunction _function;
    private FFIClosureFunction _closure;

    private this(ffi_cif* cif, FFIFunction function_, FFIClosureFunction closure)
    {
        _cif = cif;
        _function = function_;
    }

    ~this()
    {
        ffi_closure_free(_function);
    }

    @property FFIFunction function_()
    out (result)
    {
        assert(result);
    }
    body
    {
        return _function;
    }

    @property FFIClosureFunction closure()
    out (result)
    {
        assert(result);
    }
    body
    {
        return _closure;
    }
}

alias void delegate(void*, void**) FFIClosureFunction;

private extern (C) void closureHandler(ffi_cif* cif, void* ret, void** args, FFIClosure closure)
{
    auto cb = closure.closure;
    cb(ret, args);
}

FFIClosure ffiClosure(FFIClosureFunction func,
                      FFIType* returnType,
                      FFIType*[] parameterTypes,
                      FFIInterface abi = FFIInterface.platform)
in
{
    assert(func);
}
body
{
    ffi_type*[] argTypes;

    foreach (param; parameterTypes)
        argTypes ~= param._type;

    int selectedABI = ffi_abi.FFI_DEFAULT_ABI;

    version (Win32)
    {
        if (abi == FFIInterface.stdCall)
            selectedABI = 2; // FFI_STDCALL
    }

    auto cif = new ffi_cif();

    if (ffi_prep_cif(cif, cast(ffi_abi)selectedABI, cast(uint)argTypes.length, returnType._type, argTypes.ptr) != ffi_status.FFI_OK)
        return null;

    void* code;
    auto mem = cast(ffi_closure*)ffi_closure_alloc(ffi_closure.sizeof, &code);

    auto closure = new FFIClosure(cif, cast(FFIFunction)code, func);

    if (ffi_prep_closure_loc(mem, cif, cast(ffi_closure_fun)&closureHandler, cast(void*)closure, code) != ffi_status.FFI_OK)
        return null;

    return closure;
}

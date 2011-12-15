import ffi;

extern (C) void test00()
{
}

void main()
{
    assert(ffiCall(cast(FFIFunction)&test00, FFIType.ffiVoid, null, null, null) == FFIStatus.success);
}

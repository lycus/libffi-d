import ffi;

extern (C) void test00()
{
}

void main()
{
    auto ret = FFIType.ffiVoid;
    assert(ffiCall(cast(FFIFunction)&test00, &ret, null, null, null) == FFIStatus.success);
}

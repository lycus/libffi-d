import ffi;

extern (C) void test02(int i)
{
    assert(i == 24);
}

void main()
{
    auto value = 24;
    auto ret = FFIType.ffiVoid;
    auto param = FFIType.ffiInt;

    assert(ffiCall(cast(FFIFunction)&test02, &ret, [&param], null, [cast(void*)&value]) == FFIStatus.success);
}

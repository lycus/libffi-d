import ffi;

extern (C) void test02(int i)
{
    assert(i == 24);
}

void main()
{
    int value = 24;
    assert(ffiCall(cast(FFIFunction)&test02, FFIType.ffiVoid, [FFIType.ffiInt], null, [cast(void*)&value]) == FFIStatus.success);
}

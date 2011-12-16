import ffi;

extern (C) int test01()
{
    return 42;
}

void main()
{
    int value;
    auto ret = FFIType.ffiInt;

    assert(ffiCall(cast(FFIFunction)&test01, &ret, null, &value, null) == FFIStatus.success);
    assert(value == 42);
}

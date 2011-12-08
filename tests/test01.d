import ffi;

extern (C) int test01()
{
    return 42;
}

void main()
{
    int value;

    assert(ffiCall(cast(FFIFunction)&test01, FFIType.ffiInt, null, 0, &value, null) == FFIStatus.success);
    assert(value == 42);
}

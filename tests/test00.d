import ffi;

extern (C) void test00()
{
}

void main()
{
    assert(ffiCall(&test00, FFIType.ffiVoid, null, 0, null, null) == FFIStatus.success);
}

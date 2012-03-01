libffi binding for D
====================

libffi-d is a binding to the libffi foreign function
interface library. It allows you to invoke functions
that use various calling conventions dynamically.
Often, particularly in interpreters, it is necessary
to dynamically invoke a native function. This is
made possible with libffi(-d) as long as you know
the return type, parameter types, and the ABI.

Building
--------

On Windows, load up libffi-d.sln in Visual D and build
in either Debug or Release mode.

On all other systems, you build libffi-d by using Waf:

    $ waf configure --lp64=true --mode=release
    $ waf build
    $ waf install

You can of course adjust the parameters to configure
as needed.

Limitations
-----------

* This binding assumes the presence of the closure API.
* The raw API is not bound.
* This binding only supports the native C calling
  convention (i.e. cdecl) on all platforms, and
  'stdcall' on Windows.
* There is no support for functions with variadic
  argument lists.

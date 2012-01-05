#!/usr/bin/env python

VERSION = '1.0'
APPNAME = 'libffi-d'

top = '.'
out = 'build'

def options(opt):
    opt.load('dmd')

    opt.add_option('--lp64', action='store', default='true', help='Compile for 64-bit CPUs (true/false)')

def configure(conf):
    def add_option(option):
        conf.env.append_value('DFLAGS', [option])

    def common_options():
        conf.load('dmd')

        add_option('-w')
        add_option('-wi')
        add_option('-ignore')
        add_option('-property')
        add_option('-gc')

        if conf.options.lp64 == 'true':
            add_option('-m64')
        else:
            add_option('-m32')

    conf.setenv('debug')
    common_options()

    add_option('-debug')

    conf.setenv('release')
    common_options()

    add_option('-release')
    add_option('-O')
    add_option('-inline')

def build(bld):
    if not bld.variant and bld.cmd != 'list':
        bld.fatal('You have to use the _debug or _release variants of Waf commands.')

    bld.stlib(source = 'ffi.d',
              target = 'ffi-d',
              install_path = '${PREFIX}/lib')

from waflib.Build import BuildContext, CleanContext, InstallContext, UninstallContext

for x in ('debug', 'release'):
    for y in (BuildContext, CleanContext, InstallContext, UninstallContext):
        class tmp(y):
            cmd = y.__name__.replace('Context', '').lower() + '_' + x
            variant = x

#!/usr/bin/env python

VERSION = '1.0'
APPNAME = 'libffi-d'

TOP = '.'
OUT = 'build'

def options(opt):
    opt.load('dmd')

    opt.add_option('--lp64', action='store', default='true', help='Compile for 64-bit CPUs (true/false)')
    opt.add_option('--mode', action='store', default='debug', help='The mode to compile in (debug/release)')

def configure(conf):
    def add_option(option):
        conf.env.append_value('DFLAGS', option)

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

    if conf.options.mode == 'debug':
        add_option('-debug')
    else:
        add_option('-release')
        add_option('-O')
        add_option('-inline')

def build(bld):
    bld.stlib(source = 'ffi.d',
              target = 'ffi-d',
              install_path = '${PREFIX}/lib')

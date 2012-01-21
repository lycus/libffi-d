#!/usr/bin/env python

import os, shutil
from waflib import Build, Context, Scripting

APPNAME = 'libffi-d'
VERSION = '1.0'

TOP = '.'
OUT = 'build'

def options(opt):
    opt.load('dmd')

    opt.add_option('--lp64', action = 'store', default = 'true', help = 'Compile for 64-bit CPUs (true/false)')
    opt.add_option('--mode', action = 'store', default = 'debug', help = 'The mode to compile in (debug/release)')

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
    elif conf.options.lp64 == 'false':
        add_option('-m32')
    else:
        conf.fatal('--lp64 must be either true or false.')

    if conf.options.mode == 'debug':
        add_option('-debug')
    elif conf.options.mode == 'release':
        add_option('-release')
        add_option('-O')
        add_option('-inline')
    else:
        conf.fatal('--mode must be either debug or release.')

    conf.check_dlibrary()

def build(bld):
    bld.stlib(source = 'ffi.d',
              target = 'ffi-d',
              install_path = '${PREFIX}/lib')

def dist(dst):
    with open('.gitignore', 'r') as f:
        dst.excl = ' '.join(l.strip() for l in f if l.strip())

class PackageContext(Build.InstallContext):
    cmd = 'package'
    fun = 'build'

    def init_dirs(self, *k, **kw):
        super(PackageContext, self).init_dirs(*k, **kw)

        self.tmp = self.bldnode.make_node('package_tmp_dir')

        try:
            shutil.rmtree(self.tmp.abspath())
        except:
            pass
        if os.path.exists(self.tmp.abspath()):
            self.fatal('Could not remove the temporary directory %r' % self.tmp)

        self.tmp.mkdir()
        self.options.destdir = self.tmp.abspath()

    def execute(self, *k, **kw):
        back = self.options.destdir

        try:
            super(PackageContext, self).execute(*k, **kw)
        finally:
            self.options.destdir = back

        files = self.tmp.ant_glob('**')

        appname = getattr(Context.g_module, Context.APPNAME, 'noname')
        version = getattr(Context.g_module, Context.VERSION, '1.0')

        ctx = Scripting.Dist()
        ctx.arch_name = '%s-%s-bin.tar.bz2' % (appname, version)
        ctx.files = files
        ctx.tar_prefix = ''
        ctx.base_path = self.tmp
        ctx.archive()

        shutil.rmtree(self.tmp.abspath())

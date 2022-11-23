from distutils.core import setup, Extension

module1 = Extension('DemoTrace',
                    define_macros = [('MAJOR_VERSION', '1'), ('MINOR_VERSION', '0')],
                    #extra_link_args=[]
                    #extra_compile_args=[]
                    include_dirs = ['C/include'],
                    #libraries = ['DemoTrace'],
                    #library_dirs = ['/usr/lib'],
                    sources = ['CPython/Demo.c', 'C/source/Passwd.c'])

setup (name = 'PyDemo',
       version = '1.0',
       description = 'package for python tracing',
       author = 'Wen xx',
       author_email = 'xx.wen@xxx.edu',
       ext_modules = [module1])


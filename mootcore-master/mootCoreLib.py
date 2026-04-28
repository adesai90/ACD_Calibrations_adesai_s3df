# $Header: /nfs/slac/g/glast/ground/cvs/GlastRelease-scons/mootCore/mootCoreLib.py,v 1.3 2009/01/23 19:57:10 jrb Exp $
def generate(env, **kw):
    if not kw.get('depsOnly', 0):
        env.Tool('addLibrary', library = ['mootCore'])
        if env['PLATFORM']=='win32' and env.get('CONTAINERNAME','')=='GlastRelease':
	    env.Tool('findPkgPath', package = 'mootCore') 
    env.Tool('rdbModelLib')
    env.Tool('xmlBaseLib')
    env.Tool('facilitiesLib')
def exists(env):
    return 1;

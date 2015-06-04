#!/usr/bin/python
# -*- coding: iso-8859-1 -*-
#
#
# Copyright (C) 2011 Domingos Rodrigues <ddcr@lcc.ufmg.br>
#
# Created: Thu Mar 31 14:34:44 2011 (BRT)
#
# $Id$
#

__id__ = "$Id:$"
__revision__ = "$Revision:$"

import subprocess, os.path

def getGitVersion():
    if not os.path.exists( ".git" ):
        return "nogitversion"
    
    version = open( ".git/HEAD" ,'r' ).read().strip()
    if not version.startswith( "ref: " ):
        return version
    version = version[5:]
    f = ".git/" + version
    if not os.path.exists( f ):
        return version
    git_sha = open( f , 'r' ).read().strip()[:10]

    #
    #-- now check if there are modified files awaiting to
    #   be added to the repository
    subdirs = 'libAtoms QUIP_Core QUIP_Utils QUIP_Programs nttm3f'
    p1 = subprocess.Popen(["git", "status", subdirs], stdout=subprocess.PIPE )
    p2 = subprocess.Popen(["grep", "Changed but not updated\\|Changes to be committed"],
                          stdin=p1.stdout,
                          stdout=subprocess.PIPE)
    result = p2.communicate()[0].strip()

    if result!="":
        git_sha += "[MOD]"
    return git_sha

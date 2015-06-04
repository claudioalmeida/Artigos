#!/usr/bin/env python
# A git integration for latex diff
# Using git diff will be faster but more work.

import os
from os.path import join, split
import sys
import shutil
import logging
import tempfile
from optparse import OptionParser

if __name__ == '__main__':
    parser = OptionParser()
    parser.add_option("-o", "--output", dest="output", default='diff', help="name of the output file")
    parser.add_option("-t", "--temp", dest="tmp_path", default=None, help="name of the temporary folder")
    #parser.add_option("-1", "--one", dest="", default=None, help="Uses pdflatex in the oldest commit")

    (options, args) = parser.parse_args()

    if not options.tmp_path:
        options.tmp_path = tempfile.mkdtemp()

    pdf = '%s.pdf' % options.output
    texout = '%s.tex' % options.output
    basedir = os.getcwd()
    dir1 = join(options.tmp_path, '1')
    dir2 = join(options.tmp_path, '2')

    if len(args) == 2:
        commit1 = args[0]
        commit2 = 'HEAD'
        texin = args[1]
    else:
        commit1 = args[0]
        commit2 = args[1]
        texin = args[2]

    texin = '%s.tex' % texin
    file1 = join(dir1, texin)
    file2 = join(dir2, texin)

    shutil.rmtree(options.tmp_path, ignore_errors = True)

    (hdl, header) = tempfile.mkstemp()

    print('Temporary path: %s' % options.tmp_path)
    print('Temporary file: %s' % header)

    os.system(r'echo \\begin{verbatim} >> %s' % header)
    os.system('echo %s >> %s' % (texin, header))
    os.system(r'echo \\end{verbatim} >> %s' % header)
    os.system(r'echo \\hrule >> %s' % header)
    os.system(r'echo \\begin{verbatim} >> %s' % header)
    os.system('echo From: %s >> %s' % (commit1, header))
    shutil.copytree(basedir, dir1)
    os.chdir(dir1)
    os.system('git checkout %s' % commit1)
    os.system('git log -1 >> %s' % header)
    os.system(r'echo \\end{verbatim} >> %s' % header)

    os.system(r'echo \\hrule >> %s' % header)

    os.system(r'echo \\begin{verbatim} >> %s' % header)
    os.system('echo To: %s >> %s' % (commit2, header))
    shutil.copytree(basedir, dir2)
    os.chdir(dir2)
    os.system('git checkout %s' % commit2)
    os.system('git log -1 >> %s' % header)
    os.system(r'echo \\end{verbatim} >> %s' % header)

    (hdl, header_name) = split(header)
    os.system('latexdiff --flatten %s %s > %s' % (join(dir1, texin), join(dir2, texin), texout))
    #os.system(r"sed -i 's/$/\/\/\//g' %s " % header)
    shutil.copy(header, join(dir2, '%s.tex' % header_name))
    os.system(r"sed -i 's/begin{document}/begin{document}\\include{%s}/g' %s " % (header_name, texout))
    os.system('pdflatex %s' % texout)
    shutil.copy(texout, basedir)
    shutil.copy(pdf, basedir)
    os.chdir(basedir)
    shutil.rmtree(options.tmp_path, ignore_errors = True)
    os.remove(header)
    if os.name == 'nt':
        os.filestart(pdf)
    elif os.name == 'posix':
        os.system('/usr/bin/xdg-open %s' % pdf)
    else:
        os.system('open %s' % pdf)

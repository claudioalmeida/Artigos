#!/usr/bin/python
# Copyright (C) M. Alford, April 1998
import string, regex, sys, os

# This is  order_citations.py

# Usage: 
#   order_citations texfile.tex
# overwrites texfile.tex, original backed up in texfile.tex.bak

# If your citations are already in the right order, the file will be unchanged:
# > diff texfile.tex texfile.tex.bak

# This script orders citations in a latex file.
# Remembers in what order things were cited (using \cite)
# and puts refs (between \begin{thebibliography} and \end{thebibliography}
# or between \begin{references} and \end{references})
# in the same order.
# Ignores comments, but \\% or \\\\% etc will confuse it!)

# BUGS:
# does not understand \cite{X,Y,Z} if a newline occurs in the 
#     list of citations
# should stop looking for citations after \end{document}
# doesn't realize that \\cite is different from \cite,
#     \\bibitem is different from \bibitem, etc
# doesn't get [opt\]ion], {arg\{ument} etc right

True = 1
False = 0

verbose = True
debug = True
flag_uncited = False
flag_missing = False

if True:
  if len(sys.argv)<2:
    print('\nUsage: order_citations.py  filename\n')
    sys.exit()
  texfilename = sys.argv[1]
else:
  texfilename = 'testfile.tex'

backupfilename = texfilename + '.bak'

# first, read in the file, and encode (disrupt) all comments by
# interleaving them with a flag character, so they don't match
# the regular expressions for \cite{...} , \begin{bib...} etc

comment_ch = '\000'  # null char, to disrupt comments
newline_ch = '\001'  # encoded newline char, for bibliography

encode_newl_table = string.maketrans('\n',newline_ch)
decode_newl_table = string.maketrans(newline_ch,'\n')

def encode_newl(str):
  return string.translate(str,encode_newl_table)

def decode_newl(str):
  return string.translate(str,decode_newl_table)

def encode_comment(line,icomment):
# interleaves with comment_ch, starting at position icomment
  nch = len(line)
  resl = line[0:icomment+1]
  for ich in range(icomment+1,nch):
    resl=resl+comment_ch+line[ich]
  return resl

def decode(line):  
# delete all occurences of comment_ch from this line,
# and convert newline_ch back to newline
  return string.translate(line,decode_newl_table,comment_ch)

if(verbose): print "reading "+texfilename
file = open(texfilename,'r').readlines()
nlines = len(file)
for iline in range(nlines):
  line = file[iline]
  if line[0]=='%':
    file[iline] = encode_comment(line,0)
  else:
    i=0
    done=False
    while not done and i<len(line)-1:
      i=i+1
      if line[i]=='%' and line[i-1] != '\\': #comments begin with "%", not "\%"
        done=True
        file[iline] = encode_comment(line,i)

# OK, we've encoded all the comments. 
# Now let's search for \cite{...}, and remember the citations in order.

if(verbose): print "searching for citations..."
cit_list=[]

Patt_citation1 = regex.compile('^[\]cite{\([^}]+\)}')
Patt_citation2 = regex.compile('^[\]cite\[.*\]{\([^}]+\)}')
for line in file:
  icite = string.find(line,'\\cite')
  rest_of_line = line
  while icite>=0:
    rest_of_line = rest_of_line[icite:]  # starting at the next citation...
    if Patt_citation1.match(rest_of_line) > -1:   # \cite{..}
      cit_names = map(string.strip,
             string.splitfields(Patt_citation1.group(1),',') )
      for cit_name in cit_names:
        if cit_list.count(cit_name)==0: 
          cit_list.append(cit_name)
	  if(debug): print "found "+cit_name
    elif Patt_citation2.match(rest_of_line) > -1: # \cite[...]{...}
      cit_names = string.splitfields(Patt_citation2.group(1),',')
      for cit_name in cit_names:
        if cit_list.count(cit_name)==0: 
	  cit_list.append(cit_name)
	  if(debug): print "found "+cit_name
    else:
      print "**** found '\\cite' but could not parse it!"
    offset=1   # find the next citation on this line
    icite = string.find(rest_of_line[offset:],'\\cite')
    if icite>=0: icite=icite+offset
    

# This is the reordering procedure we'll be using on the bibliography:

Patt_refname1 = regex.compile('^{\([^}]+\)}\(.*\)')
#                                '{refname}reftext'
Patt_refname2 = regex.compile('^\(\[[^]]*\]\){\([^}]+\)}\(.*\)')
#                                '[optarg]{refname}reftext'
def reorder(bibtext,file):
  ref_list = string.splitfields(bibtext,'\\bibitem')
  ref_dict = {}
  opt_dict = {}
  for ref in ref_list:
    if Patt_refname1.match(ref) > -1:    # \bibitem{...}
      optarg  = ''
      refname = Patt_refname1.group(1)
      reftext = Patt_refname1.group(2)
      ref_dict[refname] = reftext
      opt_dict[refname] = ''
      if(debug): print "bibitem "+refname
    elif  Patt_refname2.match(ref) > -1: # \bibitem[...]{...}
      optarg  = Patt_refname2.group(1)
      refname = Patt_refname2.group(2)
      reftext = Patt_refname2.group(3)
      ref_dict[refname] = reftext
      opt_dict[refname] = optarg
      if(debug): print "bibitem[] "+refname
    else:
      # this is probably harmless stuff before the first \bibitem
      file.write(decode(ref))
      if(debug): print "passed on:\n<"+ref+">"
      continue
  for cit in cit_list:
    if ref_dict.has_key(cit):
      file.write('\\bibitem'+opt_dict[cit]+'{'+cit+'}'+decode(ref_dict[cit]))
      del(ref_dict[cit])
    else:
      print "++++ Reference "+cit+" not supplied"
      if flag_missing: 
        file.write('%%%OC: \\bibitem{'+cit+'} should go here\n\n')
  for ref in ref_dict.keys():
    print "**** bibitem "+ref+" not cited"
    if flag_uncited:
      file.write('%%%OC: Uncited reference:\n')
    file.write('\\bibitem'+opt_dict[ref]+'{'+ref+'}'+ \
               decode(ref_dict[ref]))


# write the text out to file again (decoding encoded comments and newlines)
# reordering the refs when we get to them:

# os.system('mv -f '+texfilename+' '+backupfilename)
if os.path.exists(backupfilename):
  os.unlink(backupfilename)
os.rename(texfilename,backupfilename)
print "original backed up to "+backupfilename
outfile = open(texfilename,'w')

doingbib=False
donebib=False
bibtext = "";
for line in file:
  if( not doingbib): 
    doingbib =  ( string.count(line,'\\begin{thebibliography}')>0
               or string.count(line,'\\begin{references}')>0 )
    if doingbib and verbose: print "reordering bibliography..."

  if( not doingbib):      # if we haven't got to the bib yet, so just copy
    outfile.write(decode(line))

  if(donebib): continue   # only 1 bibliography allowed

  if(doingbib):
    iend = string.find(line,'\\end{thebibliography}') 
    if iend<0: iend = string.find(line,'\\end{references}')
    donebib = iend>=0
    if donebib: 
      doingbib=False
#     include the bit before '\end{bib..} in the bib text
      bibtext = bibtext + encode_newl(line[0:iend])
      reorder(bibtext,outfile)
      outfile.write(decode(line[iend:]))
    else:
      bibtext = bibtext + encode_newl(line)

print "writing "+texfilename
outfile.close()

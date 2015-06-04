#!/usr/bin/env python
#
#

import sys, os, re, shutil, string, fileinput
from UserDict import UserDict



class PrepareBibTeX(object):
    """
    class for bibtex parsing
    """

    def process_bbl(self, bbl_infn, bbl_outfn):
        """
        """

        procbib = False
        bibinfo = {}
        bibkeys = []
        
        fin = fileinput.FileInput(files=[bbl_infn]) #redundant?
        while 1:
            line = fin.readline()
            if not line:
                break

            if re.match(r"\\bibitem", line):
                item = line
                procbib = True
                continue

            # append line to current item strint
            if procbib:
                item += line

            # end of item -- process
            if re.match(r"\n", line) and procbib:
                procbib = False

                # strip newlines
                item = re.sub(r"\n", '', item)

                # strip '\natexlab's
                item = re.sub(r"\{\\natexlab\{(.*?)\}\}", r"\1", item)

                # strip \noopsort{}'s
                item = re.sub(r"\{\\noopsort\{(.*?)\}\}", '', item)

                # parse entry
                m = re.match(
                    r"\\bibitem\[\{(.*?)\((\d{4}[a-z]*)\)(.*?)\}\]\{(.*?)\}(.*)", item)
                if m:
                    shortlist, year, longlist, key, ref = m.groups()

                    shortlist_clean = re.sub(
                        r"\\citenamefont\{(.*?)\}", r"\1",
                        shortlist)
                    longlist_clean = re.sub(
                        r"\\citenamefont\{(.*?)\}", r"\1",
                        longlist)

                    #------------------------------------------------------------
                    #
                    #get clean list of AUTHORS from "ref"
                    m = re.match(r"(.*?)(\,)?\s*\\bibinfo\{journal\}",ref)
                    if not m:
                        print "Can't find journal in reference:\n%s" % ref
                    else:
                        line_with_authors = m.group(1)
                        tmp = re.sub(
                            r"\\bibinfo\{author\}\{(.*?)\}",r"\1",
                            line_with_authors
                            )
                        tmp = re.sub(
                            r"\\bibfnamefont\{(.*?)\}",r"\1",
                            tmp
                            )
                        authlist_clean = re.sub(
                            r"\\bibnamefont\{(.*?)\}",r"\1",
                            tmp
                            )
                    #
                    #get clean JOURNAL from "ref"
                    m = re.match(r"(.*)\\bibinfo\{journal\}\{(.*?)\}(.*)",ref)
                    if not m:
                        print "Can't find JOURNAL in reference:\n%s" % ref
                    else:
                        journal_clean = m.group(2)
                    #
                    #get clean YEAR from "ref"
                    m = re.match(r"(.*)\(\\bibinfo\{year\}\{(.*?)\}\)(.*)",ref)
                    if not m:
                        print "Can't find YEAR in reference:\n%s" % ref
                    else:
                        year_clean = '('+ m.group(2)+')'
                    #
                    #get clean VOLUME from "ref"
                    m = re.match(r"(.*)\\bibinfo\{volume\}\{(.*?)\}(.*)",ref)
                    if not m:
                        print "Can't find VOLUME in reference:\n%s" % ref
                    else:
                        volume_clean = '\\textbf{'+ m.group(2)+'}'
                    #
                    #get clean PAGES from "ref"
                    m = re.match(r"(.*)\\bibinfo\{pages\}\{(.*?)\}(.*)",ref)
                    if not m:
                        print "Can't find VOLUME in reference:\n%s" % ref
                    else:
                        pages_clean = m.group(2)

                    # output entry
                    bibkeys.append(key)
                    bibinfo[key] = shortlist_clean, year_clean,   \
                                   authlist_clean, journal_clean, \
                                   volume_clean, pages_clean, year_clean
                else: # didn't match
                    print "weird bibitem: %s" % item

        fin.close()

        # output info to file
        bbl_outf = open(bbl_outfn, 'w')
        bbl_outf.write("\\begin{thebibliography}{%d}\n\n" % len(bibkeys))
        for key in bibkeys:
            shortlist, y, authlist, journal, volume, pages, year = bibinfo[key]
            bbl_outf.write("\\bibitem[{%s(%s)}]{%s}\n%s, %s, %s, %s %s\n\n" %
                           (shortlist, y, key, authlist,
                            journal, volume, pages, year))
        bbl_outf.write("\\end{thebibliography}\n")
        bbl_outf.close()
            
#------------------------------------------------------------------------------
if __name__ == '__main__':
    usage=""" process_bib.py

# Copyright (C) 2007 by Domingos Rodrigues

Usage:  process_bib.py [-o <output.bbl>] (file.bbl)

Required arguments:
    file.bbl:  file previously processed by BibTeX

Options:
    -o <output.bbl> output file with \\bibitem entries
    
Description
-----------
     This script processes the bbl file that results from bibtex. It
     simply produces a final output file with the following format:
     \begin{thebibliography}{# of references}
       \bibitem[]{}
       ...
       \bibitem[]{}
       ...
     \end{thebibliography}

     to be included manually in the manuscript.
"""
    import getopt
    try:
        opts, args = getopt.getopt(sys.argv[1:], 'o:')
    except getopt.GetoptError:
        print usage
        sys.exit(2)

    for o, a in opts:
        if o == '-o':
            output_bbl=a

    if not args:
        print usage
        sys.exit(1)
    fileroot = args.pop(0)

    #
    #------- instantiate
    preparer = PrepareBibTeX()
    preparer.process_bbl(fileroot, output_bbl)

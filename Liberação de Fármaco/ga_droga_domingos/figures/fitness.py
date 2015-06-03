#!/usr/bin/env python
#
#
from pylab import *
from time import strftime

t = arange(0.0, 0.9999, 0.0001)
s = log(abs(t-1.0))
plot(t, s, linewidth=1.0)

ylabel(r'FIT$=\log(\alpha/\alpha_\mathrm{ref}-1)$')
xlabel(r'$\alpha/\alpha_\mathrm{ref}$')
grid(True)

time=strftime("%Y-%m-%d %H:%M:%S")
title(time)
#savefig('ola.png')
show()


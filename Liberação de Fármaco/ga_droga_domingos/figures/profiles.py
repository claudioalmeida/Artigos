#!/usr/bin/env python
#
# $Id$
#
import unittest
import asciidata
from asciidata import *
import numpy

from numpy.testing import *

import scipy
import pylab as P

from pylab import *
import matplotlib.numerix as N
import matplotlib.numerix.ma as ma
from scipy.special import *
from scipy.optimize.zeros import bisect, brentq, brenth, ridder
from scipy.integrate import quad, quadrature, romberg

#
#=============================PUBLICATION QUALITY==========================================
#

# set_printoptions(precision=6, suppress=True)

def figure_size(fig_width_pt=2*246.0):
    """
    calculates figure dimensions for publication quality
    """
    inches_per_pt = 1.0/72.27               # Convert pt to inch
    golden_mean = (sqrt(5)-1.0)/2.0         # Aesthetic ratio
    fig_width = fig_width_pt*inches_per_pt  # width in inches
    fig_height = fig_width*golden_mean      # height in inches
    fig_size =  [fig_width,fig_height]
    return(fig_size)

params = {
    'backend': 'GTKAgg',
    'font.weight': 'bold',
    'axes.labelsize': 8,
    'text.fontsize': 8,
    'xtick.labelsize': 8,
    'ytick.labelsize': 8,
    'text.usetex': True,
    'text.tex.engine': 'latex',
    'font.latex.package': 'type1cm',
    'figure.figsize': figure_size(),
    'figure.subplot.left': 0.09,
    'figure.subplot.right': 0.90,
    'figure.subplot.top': 0.95,
    'figure.subplot.bottom': 0.08,
    'figure.facecolor': 'white',
    'xtick.major.size': 6,
    'xtick.minor.size': 4,
    'ytick.major.size': 6,
    'ytick.minor.size': 4,
    'contour.negative_linestyle': 'solid'
    }

rcParams.update(params)
#
#=============================PUBLICATION QUALITY==========================================
#


class SlabModel:
    """
    Thick Slab model of suspended drug in polymeric carrier material
    """
    def __init__(self, D = 1.35e-5, L = 0.167, C0 = 70.0, Cs = 16.2, R=None):
        # physical parameters
        self.D   = D    # cm2/day
        self.C0  = C0   # mg/cm3
        self.Cs  = Cs   # mg/cm3
        self.L   = L    # cm
        
        self.L2    = self.L * self.L
        self.D_L2  = self.D / self.L2

        if R is None:
            self.R  = self.Cs / self.C0
        else:
            self.R  = R
        #
        #--- calculate beta for Paul & McSpadden model (assumes 'ridder' root finding method)
        if hasattr(R,'shape'):
            print '\n\t SlabModel Class: R must be a scalar' 
            sys.exit(1)
        self.beta  = self.PaulMcSpaddenRoot(self.R)[0]
        return

    def HiguchiCumMass(self, t, R=None):
        """
        Higuchi pseudo-steady state approximation (R<<1):
        Mass released to chamber while there is still some undissolved drug
        """
        if R is None:
            R = self.R
        fR = R * ( 1.0 - 0.5 * R )
        return ( sqrt( 2.0 * fR * self.D_L2 * t ) )  
    
    def HiguchiCumMassNorm(self, SqrtDtL2, R=None):
        """
        HiguchiCumMass mormalized: M_R/M_O = f(sqrt(D*t/L**2))
        """
        if R is None:
            R = self.R
        fR        = R * ( 1.0 - 0.5 * R )
        SqrtDtfL2 = self.HiguchiDissoTimeNorm(R=R)
        SqrtDtL2_ = SqrtDtL2[where( SqrtDtL2 < SqrtDtfL2 )]
        return ( SqrtDtL2_, sqrt( 2.0 * fR ) * SqrtDtL2_ )  
    
    def HiguchiDissoTime(self, R=None):
        """
        time required for all of the drug to dissolve
        """
        if R is None:
            R = self.R
        return( 0.5 * ( 1.0 - 0.5 * R ) / ( R * self.D_L2 ) )

    def HiguchiDissoTimeNorm(self, R=None):
        """
        HiguchiDissoTime in dimensionless units
        """
        if R is None:
            R = self.R
        return( sqrt( 0.5 * ( 1.0 - 0.5 * R ) / R ) )

    def HiguchiDissoMass(self, R=None):
        """
        Mass released (by diffusion) when all suspended
        mass has dissolved
        """
        if R is None:
            R = self.R
        return( 1.0 - 0.5 * R )
    
    def HiguchiCumMassAfterDissoNorm(self, SqrtDtL2, ti=None, mi=None, R=None, m=0):
        """
        Mass time release after all suspended mass has been dissolved
        in normalized coordinates
        """
        if R is None:
            R = self.R

        if ti is None:
            ti  = self.HiguchiDissoTimeNorm(R=R) # sqrt(D*tf/L**2)
            ti2 = ti * ti

        if mi is None:
            mi = self.HiguchiDissoMass(R=R)

        cm1        = ones(m)
        cm1[1:m:2] = -1
        
        l_m   = ( 2.0 * arange(m) + 1.0 ) * pi / 2.0  # lambda_m = (2*m+1)*PI/2
        l_m2  = l_m * l_m
        l_m3  = l_m2 * l_m
        
        SqrtDtL2_  = SqrtDtL2[where( SqrtDtL2 >= ti )]
        SqrtDtL2_2 = SqrtDtL2_ * SqrtDtL2_
        #
        #---- 2nd part:  classical Crank solution: diffusion of completely dissolved drug
        sum_terms  = cm1 * exp( -outer( SqrtDtL2_2 - ti2, l_m2 ) ) / l_m3
        sump       = sum(sum_terms, axis=1)
        mr         = mi + 0.5 * R - 2.0 * R * sump
        return(SqrtDtL2_, mr)

    def PaulMcSpaddenCumMass(self, t, R=None, beta=None):
        """
        PaulMcSpaddenCumMass: M_R/M_0 = 2*(1-R)*beta*exp(beta^2)*sqrt(D*t/L^2)
        """
        if R is None:
            R    = self.R
            beta = self.beta
        else:
            beta = self.PaulMcSpaddenRoot(R)[0] 
        beta2 = beta * beta
        return( 2.0 * ( 1.0 - R ) * beta * exp( beta2 ) * sqrt( self.D_L2 * t ) )

    def PaulMcSpaddenCumMassNorm(self, SqrtDtL2, R=None):
        """
        PaulMcSpaddenCumMass normalized: M_R/M_0 = f(sqrt(D&t/L**2x))
        """
        if R is None:
            R    = self.R
            beta = self.beta
        else:
            beta = self.PaulMcSpaddenRoot(R)[0] 
        beta2 = beta * beta
        SqrtDtfL2 = self.PaulMcSpaddenDissoTimeNorm(beta=beta)
        SqrtDtL2_ = SqrtDtL2[where( SqrtDtL2 < SqrtDtfL2 )]

        return( SqrtDtL2_, 2.0 * ( 1.0 - R ) * beta * exp( beta2 ) * SqrtDtL2_ )

    def PaulMcSpaddenDissoTime(self, beta=None):
        """
        Time required for all of the drug to dissolve
        """
        if beta is None:
            beta = self.beta
        beta2 = beta * beta
        return( 0.25 / ( beta2 * self.D_L2 ) )

    def PaulMcSpaddenDissoTimeNorm(self, beta=None):
        """
        PaulMcSpaddenDissoTime() in dimensionless units
        """
        if beta is None:
            beta = self.beta
        return( 0.5 / beta )

    def PaulMcSpaddenDissoMass(self, R=None):
        """
        Mass released (by diffusion) when all suspended
        mass has dissolved
        """
        if R is None:
            R    = self.R
            beta = self.beta
        else:
            beta = self.PaulMcSpaddenRoot(R)[0]
        beta2 = beta * beta
        return( ( 1.0 - R ) * exp( beta2 ) )

    def PaulMcSpaddenCumMassAfterDissoNorm(self, SqrtDtL2, ti=None, R=None, m=0):
        """
        Mass time release after all suspended mass has been dissolved
        in normalized coordinates
        """
        if R is None:
            R    = self.R
            beta = self.beta
        else:
            beta = self.PaulMcSpaddenRoot(R)[0]

        if ti is None:
            ti = self.PaulMcSpaddenDissoTimeNorm(beta)
        ti2 = ti * ti

        l_m   = ( 2.0 * arange(m) + 1.0 ) * pi / 2.0  # lambda_m = (2*m+1)*PI/2
        l_m2  = l_m * l_m
        #
        #--- Integral: \int_0^1 erf(\beta\eta)\sin(\lambda_m\eta)
        IntegralVect = vectorize(self.PaulMcSpaddenInt)
        Int_m        = IntegralVect(beta, range(m))

        SqrtDtL2_  = SqrtDtL2[where( SqrtDtL2 >= ti )]
        SqrtDtL2_2 = SqrtDtL2_ * SqrtDtL2_
        #
        #---- 2nd part:  classical Crank solution: diffusion of completely dissolved drug
        sum_terms = Int_m * exp( -outer( SqrtDtL2_2 - ti2, l_m2 ) ) / l_m
        sump      = 2.0 * R * sum(sum_terms, axis=1) / erf( beta )
        return(SqrtDtL2_, 1.0-sump)

    def PaulMcSpaddenRootFunc(self, x, R=None):
        """
        f = sqrt(pi) * beta * exp(beta**2) * erf(beta) - R/(1-R)
        """
        if R is None:
            R = self.R
        x2 = x * x
        y = sqrt(pi) * x * exp(x2) * erf(x) - R / ( 1.0 - R )
        return( y )

    def PaulMcSpaddenRoot(self, R=None, method=ridder):
        """
        get value of beta such that:
             f = sqrt(pi) * beta * exp(beta**2) * erf(beta) - R/(1-R) = 0.0
        (0,3) is a good initial bracketing interval
        """
        a, b = (0.0, 3.0) # This is a good guess ...
        if R is None:
            R = self.R
        beta, r = method(self.PaulMcSpaddenRootFunc, a, b, args=R,
                         xtol=0.1e-12, full_output=True)
        assert r.converged
        return(beta, r)
        
    def PaulMcSpaddenIntegrand(self, eta, beta=None, m=0):
        """
        f = erf(beta*eta)*sin(lambda_m*eta)
        """
        if beta is None:
            beta = self.beta
        l_m = ( 2.0 * m + 1.0 ) * pi / 2.0
        ym = erf(beta*eta) * sin(l_m * eta)
        return( ym )

    def PaulMcSpaddenInt(self, beta=None, m=1, method=quad):
        """
        Integral of above function (vectorized routine):
        
        To vectorize this function:
             PaulMcSpaddenIntVec=vectorize(PaulMcSpaddenInt)
        """
        if beta is None:
            beta = self.beta

        if method is romberg:
            return( method(self.PaulMcSpaddenIntegrand, 0.0, 1.0, args=(beta, m), divmax = 10) )
        if method is quadrature:
            return( method(self.PaulMcSpaddenIntegrand, 0.0, 1.0, args=(beta, m), maxiter = 200)[0] )
        if method is quad:
            return( method(self.PaulMcSpaddenIntegrand, 0.0, 1.0, args=(beta, m), limit = 100)[0] )


class test_myfuncs(NumpyTestCase):
    """
    test auxiliary procedures needed for Paul & McSpadden model
    """

    def bench_integration_method(self):
        """
        Check integration methods for vectorized form of Integral
        """
        from matplotlib.collections import LineCollection
        from matplotlib.font_manager import FontProperties

        slab = SlabModel()
        PaulMcSpaddenIntVec = vectorize(slab.PaulMcSpaddenInt)
        betas = linspace(0.1, 1.0, num = 10)
        
        methods     = [quad, quadrature, romberg]
        names       = ['quad', 'quadrature', 'romberg']
        col_styles  = {'quad':'r', 'quadrature':'g', 'romberg':'b'}
        sizes       = {'quad':200, 'quadrature':100, 'romberg':20}
        
        results = {}
        for n, i in zip(names,range(len(names))):
            results[n] = [ PaulMcSpaddenIntVec(b, range(10), methods[i]) for b in betas ]

        #
        #--- PLOTS
        pfont=FontProperties(size=8)
        fig = P.figure(1)
        P.clf()

        ax1 = fig.add_subplot(1,1,1)
        #for name in names:
            #loglog(betas, results[name][0], col_styles[name], label=name)
        for name in names:
            c = ax1.scatter(betas, results[name][0], s=sizes[name], c=col_styles[name])
            c.set_alpha(0.5)
        ax1.set_xlabel(r'$\beta$')
        ax1.set_ylabel(r'$Int$')
        leg = legend(('quad','quadrature','romberg'),loc='best',prop=pfont)
        leg.draw_frame(False)
        P.show()
        return

    def bench_root_methods(self):
        """
        compare relative performance of root finding methods
        """
        from matplotlib.collections import LineCollection
        from matplotlib.font_manager import FontProperties

        a, b = (0.0, 3.0)  # initial interval
        r = linspace(0.01, 0.9, num=100)
        
        methods = [bisect, ridder, brentq, brenth]
        names   = ['bisect', 'ridder', 'brentq', 'brenth']
        colors  = {'bisect':'r', 'ridder':'g', 'brentq':'b', 'brenth':'k'}

        slab = SlabModel()
        PaulMcSpaddenRootVec = vectorize(slab.PaulMcSpaddenRoot)

        zeros = {}
        stats = {}
        for n, i in zip(names,range(len(names))):
            zeros[n], stats[n] = PaulMcSpaddenRootVec(r,methods[i])
        #
        #--- PLOTS
        pfont=FontProperties(size=8)
        fig = P.figure(1)
        P.clf()

        #subplot1
        ax1 = fig.add_subplot(2,2,1)
        for name in names:
            semilogy(r, zeros[name], color=colors[name], label=name) 
        ax1.set_xlabel(r'R')
        ax1.set_ylabel(r'$\beta$')
        leg = legend(loc='best',prop=pfont)
        leg.draw_frame(False)

        #subplot2
        ax2 = fig.add_subplot(2,2,2)
        for name in names:
            plot(r, [ x.iterations for x in stats[name]],
                 color=colors[name], label=name) 
        ax2.set_xlabel(r'R')
        ax2.set_ylabel(r'N$_\mathrm{iter}$')
        leg = legend(loc='best',prop=pfont)
        leg.draw_frame(False)
    
        #subplot3
        ax3 = fig.add_subplot(2,2,3)
        for name in names:
            plot(r, [ x.function_calls for x in stats[name]],
                 color=colors[name], label=name) 
        ax3.set_xlabel(r'R')
        ax3.set_ylabel(r'N$_\mathrm{iter}$')
        leg = legend(loc='best',prop=pfont)
        leg.draw_frame(False)
        P.show()
        return


class MyTests(unittest.TestCase):
    """Do some tests of the above classes"""
    
    def setUp(self):
        """Initializes test suite"""

    def plot1(self):
        """
        check visually the best starting interval for bracketing the root
        """
        from matplotlib.collections import LineCollection


        a = 0.0
        b = 3.0
        
        P.figure(1)
        P.clf()
        ax = P.axes([0.125,0.2,0.95-0.125,0.95-0.2])
        ax.set_xlim((0.0, 1.0))
        
        slab = SlabModel(R=0.01)
        x    = linspace(a, b, num=100)
        rr   = linspace(0.99, 0.9999, num=20)
        ym   = [ slab.PaulMcSpaddenRootFunc(x, t) for t in rr ]
        
        line_segments =  LineCollection( [ zip(x,y) for y in ym ] )
        ax.add_collection( line_segments, autolim=True )
        ax.autoscale_view() 
        P.axhline()
        P.show()
        return()

    def plot2(self):
        """
        plot curves of function integrand for different beta values
        """
        from matplotlib.collections import LineCollection
        from matplotlib.colors import ColorConverter
        colorConverter = ColorConverter()
        
        slab = SlabModel() # R is unimportant
        eta  = linspace(0.0, 1.0, num=100)
        
        fig = P.figure(1)
        P.clf()

        #
        #--- subplot 1: Fixed lambda, varying beta
        ax1 = fig.add_subplot(2,1,1)
        ax1.set_xlim((0.0, 1.0))

        beta = linspace(0.0, 1.0, num=10)
        ym = [ slab.PaulMcSpaddenIntegrand(eta, beta=b, m=3) for b in beta ]
        line_segments =  LineCollection( [ zip(eta,y) for y in ym ],
                                         colors = [colorConverter.to_rgba(i) \
                                                   for i in ('b','g','r','c','m','y','k')]
                                         )
        ax1.add_collection( line_segments, autolim=True )
        ax1.autoscale_view() 
        axhline()
        ax1.set_xlabel(r'$\eta\quad\quad(m=3)$')
        ax1.set_ylabel(r'$\mbox{erf}(\beta\eta)\sin(\lambda_m\eta)$')

        #
        #--- subplot 2: Fixed beta, varying lambda
        ax2 = fig.add_subplot(2,1,2)
        ax2.set_xlim((0.0, 1.0))

        ym = [ slab.PaulMcSpaddenIntegrand(eta, beta=0.27, m=m) for m in range(10) ]
        line_segments =  LineCollection( [ zip(eta,y) for y in ym ],
                                         colors = [colorConverter.to_rgba(i) \
                                                   for i in ('b','g','r','c','m','y','k')]
                                         )
        ax2.add_collection( line_segments, autolim=True )
        ax2.autoscale_view() 
        axhline()
        ax2.set_xlabel(r'$\eta\quad\quad(\beta=0.27)$')
        ax2.set_ylabel(r'$\mbox{erf}(\beta\eta)\sin(\lambda_m\eta)$')

        P.show()
        return

    def plot3(self):
        """
        Higuchi profiles from Fig. 2 of A.L.Bunte, J. Controlled Release, 52, 141-148 (1998)
        """
        tnorm = linspace(0.0, 2.5, num=100)
        slab = SlabModel()
        rr = array([0.01, 0.1, 0.5, 0.9])
        
        # lists of tuples
        #
        #--- (I) before complete dissolution
        #--- (II) after complete dissolution
        y1_bc = [slab.HiguchiCumMassNorm(tnorm, R=x) for x in rr]
        y1_ac = [slab.HiguchiCumMassAfterDissoNorm(tnorm, R=x, m=200) for x in rr] 

        y2_bc = [slab.PaulMcSpaddenCumMassNorm(tnorm, R=x) for x in rr]
        y2_ac = [slab.PaulMcSpaddenCumMassAfterDissoNorm(tnorm, R=x, m=200) for x in rr] 

        P.figure(1)
        P.clf()
        ax = P.axes([0.125,0.2,0.95-0.125,0.95-0.2])

        for i in range(len(rr)):
            P.plot(y1_bc[i][0], y1_bc[i][1], '-k')
            P.plot(y2_bc[i][0], y2_bc[i][1], '-r')

        for i in range(len(rr)):
            P.plot(y1_ac[i][0], y1_ac[i][1], '--k')
            P.plot(y2_ac[i][0], y2_ac[i][1], '--r')

        ax.set_ylim(0.0,1.1)
        P.ylabel(r'$\frac{M_R(t)}{M_0}$')
        P.xlabel(r'$\sqrt{\frac{Dt}{L^2}}$')
        P.show()
        return()

    def plot4(self):
        """
        Figure 4 of A.L.Bunte, J. Controlled Release, 52, 141-148 (1998)
        """
        from matplotlib.font_manager import FontProperties

        rr = linspace(0.01, 0.9999, num=100)
        slab = SlabModel()

        PaulMcSpaddenRootVec = vectorize(slab.PaulMcSpaddenRoot)
        beta = PaulMcSpaddenRootVec(rr)[0]
        beta2 = beta * beta
        
        HiguchiRatio = sqrt( 1.0 - 0.5 * rr )
        PaulMcSpaddenRatio = sqrt( 2.0 / rr )*( 1.0 - rr ) * beta * exp( beta2 )

        pfont=FontProperties(size=8)
        P.figure(1)
        P.clf()
        ax = P.axes([0.125,0.2,0.95-0.125,0.95-0.2])
        P.plot(rr, HiguchiRatio, '-k', label='Higuchi')
        P.plot(rr, PaulMcSpaddenRatio, '--k', label='Exact')
        ax.set_ylim(0.0,1.1)
        P.legend(loc='best').draw_frame(False)
        P.ylabel(r'$\frac{M_R(t)/M_0}{\sqrt{\frac{2RDt}{L^2}}}$')
        P.xlabel(r'R')
        P.show()
        return

    def plot5(self):
        """
        Figure 5 of A.L.Bunte, J. Controlled Release, 52, 141-148 (1998)
        """
        from matplotlib.font_manager import FontProperties

        rc('figure', figsize=figure_size(246.0))
        
        rr  = linspace(0.01, 0.9999, num=100)
        rr2 = rr * rr
        slab = SlabModel()

        PaulMcSpaddenRootVec = vectorize(slab.PaulMcSpaddenRoot)
        beta = PaulMcSpaddenRootVec(rr)[0]
        beta2 = beta * beta

        fr1  = 1.0 - rr
        fr2  = 1.0 - 0.5 * rr
        fr3  = rr * fr2
        fr   = fr1 * fr1 / fr3

        #
        #---
        
        yD  = 2.0 * fr * beta2 * exp( 2.0 * beta2 ) - 1.0
        ym  = sqrt( 2.0 * rr * fr2 ) / ( 2.0 * fr1 * beta * exp( beta2 ) ) - 1.0
        ytf = 2.0 * beta2 * fr2 / rr - 1.0 
        
        pfont=FontProperties(size=8)
        P.figure(1)
        P.clf()
        ax = P.axes([0.125,0.2,0.95-0.125,0.95-0.2])
        P.plot(rr, ytf, '-k')
        ax.autoscale_view()
        P.ylabel(r'Error in D')
        P.xlabel(r'R')
        P.show()
        return
        

class WorkTests(unittest.TestCase):
    """
    Real work !!!
    """
    def setUp(self):
        """
        Initializes test suite by loading file

        In this archive the second row corresponds to the reference
        profile taken in our work.
        """
        self.table = AsciiData(filename='release_solutions.dat', ncols=5, comment_char='#')
        self.D  = array(self.table[0]) * 1.0e-5
        self.Cs = array(self.table[1])
        self.C0 = array(self.table[2])
        self.L  = array(self.table[3]) / 2.0  # L is actually the half-height of the device
        self.Dev= array(self.table[4])

        self.R  = self.Cs/self.C0

    def work1(self):
        """                              
        Plots of M(t)/M0 as function of sqrt(D t/ L^2)
        """
        from matplotlib.font_manager import FontProperties

        iR = range(len(self.R))

        time = linspace(0.0, 1400.0, num=100) # days
        #tnorm = [ sqrt( (self.D[i]/self.L[i]**2)*time ) for i in iR ]
        tnorm = [ linspace( 0.0, 3.5, num=100 ) for i in iR ]

        slab = SlabModel() # just to instantiate the class ...
        y_bc = [ slab.HiguchiCumMassNorm(tnorm[i], R=self.R[i]) for i in iR ]
        y_ac = [ slab.HiguchiCumMassAfterDissoNorm(tnorm[i], R=self.R[i], m=200) for i in iR ]

        t_disso = [ slab.HiguchiDissoTimeNorm(R=r) for r in self.R ]
        m_disso = [ slab.HiguchiDissoMass(R=r) for r in self.R ]

        pfont=FontProperties(size=8)
        P.figure(1)
        P.clf()
        ax = P.axes([0.125,0.2,0.95-0.125,0.95-0.2])

        for i in iR:
            P.plot(y_bc[i][0], y_bc[i][1], '-k')
            P.plot(y_ac[i][0], y_ac[i][1], '--k')

        P.scatter(t_disso, m_disso)

        ax.autoscale_view()
        ax.set_ylim(0.0, 1.2)
        
        P.ylabel(r'$\frac{M_R(t)}{M_0}$')
        P.xlabel(r'$\sqrt{\frac{Dt}{L^2}}$')
        P.show()
        return

    def work2(self):
        """                              
        Plots of M(t)/M0 as function of t
        """
        from matplotlib.font_manager import FontProperties
        from matplotlib.collections import LineCollection

        iR = range(len(self.R))
        time = linspace(0.0, 100.0, num=100) # days

        y = []
        for i in iR:
            slab = SlabModel(D=self.D[i], Cs=self.Cs[i], C0=self.C0[i], L=self.L[i])
            y.append( slab.HiguchiCumMass(time) )

        P.figure(1)
        P.clf()
        ax = P.axes([0.125,0.2,0.95-0.125,0.95-0.2])
        ax.set_xlim((0.0, 1.0))
        line_segments = LineCollection( [ zip(time, ym) for ym in y ] )
        ax.add_collection( line_segments, autolim=True )
        ax.autoscale_view() 
        P.show()
        return

    def work3(self):
        """
        various plots ...
        """
        from matplotlib.font_manager import FontProperties
        from matplotlib.collections import LineCollection
        #rcParams.update({'figure.subplot.right': 0.8})

        P.figure(1)
        P.clf()
        ax = P.axes([0.125,0.2,0.95-0.125,0.95-0.2])

        P.plot( self.R , sqrt( 2.0 * self.D / self.L**2 ), 'bo')
        P.xlabel(r'$R$')
        P.ylabel(r'$\sqrt{\frac{2D}{L^2}}$')

        ax2 = twinx()
        #P.plot( self.R, sqrt(self.R*(1.0-0.5*self.R)), 'ro')
        #P.ylabel(r'$\sqrt{R\left(1-\frac{R}{2}\right)}$')

        #P.plot( self.R, sqrt( 2.0 * self.D / self.L**2 ) * sqrt( self.R * ( 1.0 - 0.5*self.R ) ), 'ro' )
        P.plot( self.R, ( 1.0 - 0.5*self.R ) / sqrt( 2.0 * self.R * self.D / self.L**2 ), 'ro' )
        
        ax.autoscale_view() 
        P.savefig('ola.eps')
        P.show()

    def work4(self):
        """
        Arguments:
        - `self`:
        """
        import asciidata
        
        newtable = asciidata.create(self.table.ncols, self.table.nrows)
        newtable[0] = self.table[2]
        newtable[1] = self.table[1]
        newtable[2] = self.table[0]
        newtable[3] = self.table[3]
        newtable[4] = self.table[4]

        newtable.sort(4)
        LaTeXTable = newtable.writetolatex('release_solutions.tex')

    def work5(self):
        """
        Plot histograms ...
        """
        from matplotlib.font_manager import FontProperties

        pfont=FontProperties(size=8)
        P.figure(1)
        P.clf()
        ax = P.axes([0.125,0.2,0.95-0.125,0.95-0.2])

        P.scatter(self.Cs, self.D)

        ax.autoscale_view()
        P.xlabel(r'X')
        P.ylabel(r'Y')
        P.show()
        return

#-----------------------------------------------------------------------------------
if __name__ == '__main__':
    """
    Main work
    """
    suite = unittest.TestSuite()

    it = 3
    if it == 1:
        suite.addTest(MyTests("plot5"))
        unittest.TextTestRunner(verbosity=2).run(suite)
    if it == 2:    
        NumpyTest().test()
    if it == 3:
        suite.addTest(WorkTests("work5"))
        unittest.TextTestRunner(verbosity=2).run(suite)
    

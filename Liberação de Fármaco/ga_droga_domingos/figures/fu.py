#!/usr/bin/env python
#
#
#from __future__ import nested_scopes

import gobject
import gtk
import sys,os

from pylab import *
from matplotlib.font_manager import FontProperties
from matplotlib import cm, colors
import numpy, scipy
from numpy import *
from scipy.special import *


###########################################################
#          Bessel 0-order roots
#
#                     Takes some time !!!
#
# J0_zeros = jn_zeros(0,300)

table = __import__('bessel_zeros')
J0_zeros_mathematica = table.Jnu_zeros_mathematica
###########################################################


numpy.set_printoptions(precision=6, suppress=True)


def test_bessel1(nt):
    #t = logspace(-2, log10(120.0), num=50)
    t = linspace(0.001, 25.0, num=200)
    bessel = jn(0,t)
    alpham = jn_zeros(0,nt)
    plot(t, bessel)
    scatter(alpham,zeros(nt))
    show()

def test_bessel2(nt=len(J0_zeros_mathematica)):
    my_zeros = J0_zeros[:nt]
    diff = 1.0-my_zeros/J0_zeros_mathematica[:nt]
    plot(arange(len(diff)), diff,'.')
    show()

class FuModel:
    """
    """
    def __init__(self, D=4.82e-5, a=1.5/2.0, l=0.17, nt=7):
        self.D  = D   #cm^2/day
        self.a  = a   #cm
        self.l  = l
        self.nt = nt
        self.D1 = self.D / (self.a *self.a)
        self.D2 = self.D / (self.l *self.l)
        #
        # t_alpham is actually \tilde{\alpha_m} = a * \alpha_m
        #  such that J0[t_alpham] == 0
        #
        self.t_alpham = J0_zeros_mathematica[:self.nt]
        self.j1 = jn(1, self.t_alpham)
        #
        # t_betan is actually \tilde{\beta_n} = l*\beta_n
        #
        n = arange(self.nt)
        self.pow_minus_one = ones(self.nt)
        self.pow_minus_one[1:self.nt:2] = -1     # (-1)**n;  n=0,1,2,...
        self.t_betan  = (n+0.5)*scipy.pi
        return


    def FuConR(self,R,time):
        """
        radial concentration
        """
        #
        # R is r/a --> 0<=R<=1
        #
        am = self.D1 * self.t_alpham * self.t_alpham
        #
        # matrix:   alpha -->
        #       time
        #        |
        #        |
        #        v
        #
        p1 = scipy.exp( -outer( time, am ) ) / self.t_alpham
        p2 = jn(0,outer(R,self.t_alpham)) / self.j1
        #
        # recall that here we are summing over alpha
        # p3:    t ---->
        #      R
        #      |
        #      |
        #      V
        p3 = dot(p2,transpose(p1)) 

        return(2.0*p3)

    def FuConZ(self,Z,time):
        """
        concentration along Z
        """
        #
        # Z is z/a --> -1<=Z<=1
        #
        bn = self.D2 * self.t_betan * self.t_betan
    
        p1 = scipy.exp( -outer( time, bn ) ) / self.t_betan
        p2 = cos(outer(Z, self.t_betan)) * self.pow_minus_one
        #
        # recall that here we are summing over alpha
        # p3:    t ---->
        #      Z
        #      |
        #      |
        #      V
        p3 = dot(p2,transpose(p1))

        return(2.0*p3)

    def FuCon(self, R, Z, t):
        """
        concentration profile: C(r,z)/C_0
        """
        nz, nr = shape(R)
        nt =  len(t)

        yr = self.FuConR(R,t)
        yz = self.FuConZ(Z,t)

        y = yr*yz
        
        y2 = y[:,0].reshape(nz,nr)
        for id in range(1, nt):
            y2 = dstack((y2,y[:,id].reshape(nz,nr)))

        return(y2)

    def FuMass(self,t):
        """
        time = array of values where to calculate the Fu etal model
        """
        am = self.t_alpham * self.t_alpham
        bn = self.t_betan  * self.t_betan
        
        # P1:
        # matrix:   alpha -->
        #       time
        #        |
        #        |
        #        v
        #
        p1 = scipy.exp( -self.D1 * outer( t, am ) ) / am
        # P2:
        # matrix:   beta -->
        #       time
        #        |
        #        |
        #        v
        #
        p2 = scipy.exp( -self.D2 * outer( t, bn ) ) / bn
        
        s1 = sum(p1,axis=1)
        s2 = sum(p2,axis=1)
        
        return( 1.0-8.0*s1*s2 )


def dynamic_figure(r=None,z=None,t=None):
    """
    Evolution of mass concentration with time. Horizontal and vertical
    cross-section images.
    """
    global yt, t0, nt, zcut, theta, cnt, main_title

    if r is None:
        RunTimeError("r is None")
    if z is None:
        RunTimeError("z is None")
    if t is None:
        RunTimeError("t is None")
            
    theta = linspace( 0.0, 2.0*scipy.pi, num=100)
    
    R, Z     = meshgrid(r,z)
    
    fu = FuModel(nt=100)
    
    ycube = fu.FuCon(R, Z, t)    # ycube[:,:,:] DATA CUBE!!!

    #-----------------------------FIGURES------------------------------
    fig = figure(figsize=(6,8.5))
    
    t0 = 0
    yt = ycube[:,:,t0]
    
    titulo = 'Fu drug diffusion model: t = %07.2f' % t[t0]
    main_title=fig.text(0.25, 0.95, titulo,
                        horizontalalignment='left',
                        fontproperties=FontProperties(size=16))
    
    cmap = cm.cool
    subplots_adjust(hspace=0.0)
    
    subplot(211)
    ax = gca()
    im1 = imshow(yt,
                 interpolation='bilinear',
                 cmap=cmap,
                 origin='lower',
                 extent=(0,1.0,z[0],z[-1]),
                 aspect = 0.23
                 )
    
    xlabel(r'R = r/a', fontsize=14)
    ylabel(r'Z = z/l', fontsize=14)

    subplot(212,aspect='equal')
    ax = gca()

    #
    #--- cylindrical cross-section
    
    RAD, THETA = meshgrid(r,theta)
    Xpos       = RAD*cos(THETA)
    Ypos       = RAD*sin(THETA)
    
    #
    # top cap of cylinder
    #
    #zcut = len(z)-1
    zcut = 0
    if z[0] != 0.0:
        zcut = int(len(z)/2+0.5)
    title('Z = %f'%z[zcut],fontsize=16)
    #
    # Take a cross-section of the cylinder at some point Z ==> radius array of length len(r) 
    #  -----
    #  Trick
    #  -----
    #  Now create a matrix[len(theta),len(r)] by replicating the above array len(theta) times
    #  along dimension 0
    #
    
    zx = outer( ones(len(theta)), yt[zcut,:] )
    
    im2 = pcolormesh(Xpos, Ypos,
                     zx,
                     shading='flat',
                     cmap=cmap)
    
    xlabel(r'X/a', fontsize=14)
    ylabel(r'Y/a', fontsize=14)
    
    #
    #--- new axis for colorbar
    #
    norm = colors.Normalize(vmin=0.0, vmax=1.0)
    im1.set_norm(norm)
    im2.set_norm(norm)
    im1.add_observer(im2)
    
    pos = ax.get_position()
    l, b, w, h = getattr(pos, 'bounds', pos)
    cax = axes([l+w+0.015, b, 0.025, h]) # setup colorbar axes
    colorbar(im1, cax, orientation='vertical') 
    
    manager = get_current_fig_manager()
    
    cnt = 0
    files = []
    nt = len(t)
    #
    #------------------------------------------------------------------
    def updatefig(*args):
        global yt, t0, nt, zcut, theta, cnt, main_title
        
        t0 += 1
        if t0 > nt-1:
            return False
    
        yt = ycube[:,:,t0]
        zx = outer( ones(len(theta)), yt[zcut,:] )
        Nx, Ny = yt.shape
        im1.set_array(yt)
        im2.set_array(ravel(zx[0:Nx-1,0:Ny-1]))
        titulo = 'Fu drug diffusion model: t = %07.2f' % t[t0]
        main_title.set_text(titulo)
        manager.canvas.draw()
    
        #fname = '_tmp%03d.jpg' % t0
        fname = '_tmp%03d.png' % t0
        savefig(fname)
        files.append(fname)
    
        cnt += 1
        return True
    #
    #------------------------------------------------------------------

    cnt = 0
    gobject.idle_add(updatefig)

    ioff()
    show()

    command = "ffmpeg -r 10 -sameq -i _tmp%03d.png test.mp4"
    #command = "mencoder -ovc xvid -xvidencopts " + \
    #          "pass=2:bitrate=15999:max_bframes=0 " + \
    #          "-oac copy -mf  fps=10:type=jpeg 'mf://_tmp*.jpg' -vf harddup -ofps 10 " + \
    #          "-noskip -of avi -o outputfile.avi"
    os.system(command)
    for fname in files: os.remove(fname)    #clean up

    return True

def mass_fraction(t):
    """
    Mass fraction
    """
    fu = FuModel(nt=100)
    qt = fu.FuMass(t)

    fig = figure(1)
    subplot(111)
    ax = gca
    p1 = plot(t, qt, '-k')

    xlabel(r't')
    ylabel(r'Q(t)')
    
    show()
    
    return True




#-------------------------------------------------------------------------------

if __name__ == '__main__':
    t     = logspace(-1.0, log10(120.0), num=200)
    r     = logspace(-4.0,   log10(1.0), num=200)
    z     = linspace(-1.0,          1.0, num=200)


    #dynamic_figure(r=r,t=t,z=z)
    mass_fraction(t)
    
    sys.exit()

#!/usr/bin/python
# -*- coding: iso-8859-1 -*-
#
#
# Copyright (C) 2012 Domingos Rodrigues <ddcr@lcc.ufmg.br>
#
# Created: Mon Jan 16 15:44:40 2012 (BRST)
#
# $Id$
#

__id__ = "$Id:$"
__revision__ = "$Revision:$"

import matplotlib
import matplotlib.pyplot as plt
import matplotlib.gridspec as gridspec
import matplotlib.cm as cm
from matplotlib.patches import Rectangle
from matplotlib.ticker import  ScalarFormatter
from matplotlib import mpl, colors

from asciidata import *
import numpy as np


inches_per_pt = 1.0/72.27                # Convert pt to inch
golden_mean = (5**0.5-1.0)/2.0         # Aesthetic ratio
packages = ['amsmath', 'amssymb', 'amsfonts', 'amsbsy', 'bm']
usepackages = [r'\usepackage{{{0}}}'.format(pkg) for pkg in packages]

def make_ticklabels_invisible(fig):
    for i, ax in enumerate(fig.axes):
        if i in [1, 2, 4]:
            for tl in ax.get_yticklabels():
                tl.set_visible(False)


def get_rcParams(fig_width_pt = 2*232.0, scale = 1.0, dpi = 600):
    """
    publication quality settings
    """
    fig_width = fig_width_pt*inches_per_pt  # width in inches
    fig_height = fig_width*golden_mean      # height in inches
    fig_size =  [fig_width*scale, fig_height*scale]

    params = {
        'text.latex.preamble': usepackages,
        'legend.fontsize': 8,
        'savefig.dpi': dpi,
        'axes.labelsize': 10,
        'text.fontsize': 8,
        'xtick.labelsize': 8,
        'ytick.labelsize': 8,
        'font.family': 'serif',
        'font.serif': 'Times',
        'text.usetex': True,
        'figure.figsize': fig_size,
        'figure.facecolor': 'white',
        'contour.negative_linestyle': 'solid'
        }
    return params




#-----------------------------DATA-----------------------------
table = AsciiData(filename='release_solutions.dat', ncols=5, comment_char='#')
D_sol  = np.array(table[0])
Cs_sol = np.array(table[1])
A_sol  = np.array(table[2])
L_sol  = np.array(table[3]) / 2.0  # L is actually the half-height of the device

R_sol  = Cs_sol/A_sol

D_p  = np.array([0.042,  1.35,  4.82])
Cs_p = np.array([  2.7,  16.2,  40.0])
A_p  = np.array([ 33.3,  70.0, 133.1])
h_p  = np.array([0.164, 0.167, 0.170])

N = 500
D  = np.linspace(D_p[0],   D_p[2], num=N)
Cs = np.linspace(Cs_p[0], Cs_p[2], num=N)
A  = np.linspace(A_p[0],   A_p[2], num=N)
h  = np.linspace(h_p[0],   h_p[2], num=N)

#
#-- Higuchi equation: M(t)/M(oo) = K * sqrt(t)
K_ref = np.sqrt( 8.0*D_p[1]*Cs_p[1]*( A_p[1] - 0.5*Cs_p[1] ))/( A_p[1]*h_p[1] )






#-----------------------------PLOTS-----------------------------
matplotlib.rcParams.update(get_rcParams())
f = plt.figure()
nlevels  = 20
gs0 = gridspec.GridSpec(2, 3)
arrowprops_base={'arrowstyle'      : "fancy",
                 'fc'              : "0.6",
                 'ec'              : "k",
                 'connectionstyle' : "angle3,angleA=0,angleB=-90"}


#--------------------------------------------------------------------------------
gs00 = gridspec.GridSpecFromSubplotSpec(1, 3, subplot_spec=gs0[0,:], wspace=0.0)
#--------------------------------------------------------------------------------

#------------------------------------- PLOT 11-------------------------------------
ax1 = plt.Subplot(f, gs00[0])
X, Y = np.meshgrid(Cs, D)
K    = np.sqrt( 8.0*Y*X*( A_p[1] - 0.5*X ))/( A_p[1]*h_p[1] )
Z    = np.log( np.abs( K/K_ref - 1.0 ) )
Zmin = np.min(Z)
Zmax = np.max(Z)
levels = -np.logspace(np.log10(abs(Zmin)),np.log10(abs(Zmax)),num=nlevels)

# -- contours of (a) 
LineContour1 = ax1.contour(X, Y, Z, levels, colors='k', hold='on')
#                           extent=[8.13, 10.17, 2.175, 2.455])
ax1.set_xlim(8.13,10.17)
ax1.set_ylim(2.175,2.455)

f.add_subplot(ax1)
#------------------------------------- PLOT 11-------------------------------------




#------------------------------------- PLOT 21-------------------------------------
ax2 = plt.Subplot(f, gs00[1])
X, Y = np.meshgrid(A, D)
K    = np.sqrt( 8.0*Y*Cs_p[1]*( X - 0.5*Cs_p[1] ))/( X*h_p[1] )
Z    = np.log( np.abs( K/K_ref - 1.0 ) )
Zmin = np.amin(Z)
Zmax = np.amax(Z)
levels = -np.logspace(np.log10(abs(Zmin)),np.log10(abs(Zmax)),num=nlevels)

# -- contours of (b) 
LineContour2 = ax2.contour(X, Y, Z, nlevels, colors='k', hold='on')
ax2.set_xlim(75.42,80.55)
ax2.set_ylim(1.406,1.523)

f.add_subplot(ax2)
#------------------------------------- PLOT 21-------------------------------------



#------------------------------------- PLOT 31-------------------------------------
ax3 = plt.Subplot(f, gs00[2])
X, Y = np.meshgrid(h, D)
K    = np.sqrt( 8.0*Y*Cs_p[1]*( A_p[1] - 0.5*Cs_p[1] ))/( A_p[1]*X )
Z    = np.log( np.abs( K/K_ref - 1.0 ) )
Zmin = np.amin(Z)
Zmax = np.amax(Z)
levels = -np.logspace(np.log10(abs(Zmin)),np.log10(abs(Zmax)),num=nlevels)

# -- contours of (c) 
LineContour3 = ax3.contour(X, Y, Z, nlevels, colors='k', hold='on')
ax3.set_xlim(0.1663,0.1675)
ax3.set_ylim(1.315,1.379)
f.add_subplot(ax3)
#------------------------------------- PLOT 31-------------------------------------


#--------------------------------------------------------------------------------
gs01 = gridspec.GridSpecFromSubplotSpec(1, 3, subplot_spec=gs0[1,:], wspace=0.0)
#--------------------------------------------------------------------------------


#------------------------------------- PLOT 12-------------------------------------
ax4 = plt.Subplot(f, gs01[0])
X, Y = np.meshgrid(A, Cs)
K    = np.sqrt( 8.0*D_p[1]*Y*( X - 0.5*Y ))/( X*h_p[1] )
Z    = np.log( np.abs( K/K_ref - 1.0 ) )
Zmin = np.amin(Z)
Zmax = np.amax(Z)
levels = -np.logspace(np.log10(abs(Zmin)),np.log10(abs(Zmax)),num=nlevels)

# -- contours of (d) 
LineContour4 = ax4.contour(X, Y, Z, nlevels, colors='k', hold='on')
ax4.set_xlim(41.11,49.97)
ax4.set_ylim(9.78,11.14)
f.add_subplot(ax4)
#------------------------------------- PLOT 12-------------------------------------

#------------------------------------- PLOT 22-------------------------------------
ax5 = plt.Subplot(f, gs01[1])
X, Y = np.meshgrid(h, Cs)
K    = np.sqrt( 8.0*D_p[1]*Y*( A_p[1] - 0.5*Y ))/( A_p[1]*X )
Z    = np.log( np.abs( K/K_ref - 1.0 ) )
Zmin = np.amin(Z)
Zmax = np.amax(Z)
levels = -np.logspace(np.log10(abs(Zmin)),np.log10(abs(Zmax)),num=nlevels)

# -- contours of (e) 
LineContour5 = ax5.contour(X, Y, Z, nlevels, colors='k', hold='on')
ax5.set_xlim(0.1657,0.1668)
ax5.set_ylim(15.82,16.172)
f.add_subplot(ax5)
#------------------------------------- PLOT 22-------------------------------------


#--------------------------------------------------------------------------------
gs02 = gridspec.GridSpecFromSubplotSpec(1, 1, subplot_spec=gs0[1,-1], wspace=0.0)
#--------------------------------------------------------------------------------


#------------------------------------- PLOT 32-------------------------------------
ax6 = plt.Subplot(f, gs02[0])
X, Y = np.meshgrid(h, A)
K    = np.sqrt( 8.0*D_p[1]*Cs_p[1]*( Y - 0.5*Cs_p[1] ))/( Y*X )
Z    = np.log( np.abs( K/K_ref - 1.0 ) )
Zmin = np.amin(Z)
Zmax = np.amax(Z)
levels = -np.logspace(np.log10(abs(Zmin)),np.log10(abs(Zmax)),num=nlevels)

LineContour6 = ax6.contour(X, Y, Z, nlevels, colors='k', hold='on')
ax6.set_xlim(0.1653,0.1661)
ax6.set_ylim(70.44,72.46)
f.add_subplot(ax6)
#------------------------------------- PLOT 32-------------------------------------

ax1.set_ylabel(r'D$/10^{-5}$ (cm$^2/$day)')
ax1.set_xlabel(r'C$_\mathrm{s}$ (mg/cm$^3$)')
ax2.set_xlabel(r'C (mg/cm$^3$)')
ax3.set_xlabel(r'L (cm)')

ax4.set_ylabel(r'C$_\mathrm{s}$ (mg/cm$^3)$')
ax4.set_xlabel(r'C (mg/cm$^3)$')
ax5.set_xlabel(r'L (cm)')

ax6.set_ylabel('C (mg/cm$^3$)')
ax6.set_xlabel('L (cm)')

#plt.suptitle("GridSpec")
make_ticklabels_invisible(plt.gcf())

ax3.locator_params(tight=True, nbins=4)
ax5.locator_params(tight=True, nbins=4)
ax6.locator_params(tight=True, nbins=5)

#myformatter = ScalarFormatter(useMathText=True)
#myformatter = ScalarFormatter()
#myformatter.set_powerlimits((-1,1))
#ax3.xaxis.set_major_formatter(myformatter)
#ax5.xaxis.set_major_formatter(myformatter)
#ax6.yaxis.set_major_formatter(myformatter)
#ax6.xaxis.set_major_formatter(myformatter)

plt.tight_layout()

plt.savefig('higuchi_proj_zoom.eps')
plt.savefig('higuchi_proj_zoom.pdf')

plt.show()

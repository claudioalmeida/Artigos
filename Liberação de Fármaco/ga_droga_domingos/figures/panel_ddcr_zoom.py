#!/usr/bin/env python
#
# $Id$
#
import asciidata
from asciidata import *

from pylab import *
#import matplotlib.numerix as N
#import matplotlib.numerix.ma as ma
import numpy as nx

#
#=============================PUBLICATION QUALITY==========================================
#

fig_width_pt = 2*246.0  # Get this from LaTeX using \showthe\columnwidth

inches_per_pt = 1.0/72.0                # Convert pt to inch
golden_mean = (sqrt(5)-1.0)/2.0         # Aesthetic ratio
fig_width = fig_width_pt*inches_per_pt  # width in inches
fig_height = fig_width*golden_mean      # height in inches
fig_size =  [fig_width,fig_height]

params = {
    'backend': 'GTKAgg',
    'axes.labelsize': 10,
    'text.fontsize': 10,
    'xtick.labelsize': 8,
    'ytick.labelsize': 8,
    'text.usetex': True,
    'text.tex.engine': 'latex',
    'font.latex.package': 'type1cm',
    'figure.figsize': fig_size,
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

#------------------------------------------------------------------------------
if __name__ == '__main__':
    from matplotlib.ticker import ScalarFormatter, OldScalarFormatter, AutoLocator, MultipleLocator 
    

#     table = AsciiData(filename='release_solutions.dat', ncols=5, comment_char='#')
#     D_sol  = array(table[0])
#     Cs_sol = array(table[1])
#     C0_sol = array(table[2])
#     L_sol  = array(table[3]) / 2.0  # L is actually the half-height of the device
    
#     R_sol  = Cs_sol/C0_sol


    D_p  = nx.array([0.042,  1.35,  4.82])
    Cs_p = nx.array([  2.7,  16.2,  40.0])
    A_p  = nx.array([ 33.3,  70.0, 133.1])
    h_p  = nx.array([0.164, 0.167, 0.170])

    N = 500
    
    D  = linspace(D_p[0],   D_p[2], num=N)
    Cs = linspace(Cs_p[0], Cs_p[2], num=N)
    A  = linspace(A_p[0],   A_p[2], num=N)
    h  = linspace(h_p[0],   h_p[2], num=N)

    #
    # Higuchi equation: M(t)/M(oo) = K * sqrt(t)
    #

    K_ref = sqrt( 8.0*D_p[1]*Cs_p[1]*( A_p[1] - 0.5*Cs_p[1] ))/( A_p[1]*h_p[1] )

    fig = Figure()

    colormap = cm.gray
    origin = 'lower'
    nlevels = 20
    extend = 'neither'

    subplots_adjust(wspace=0.28, hspace=0.29)

    vmin = 1e40
    vmax = -1e40
    #---------------------------------------------------------------------------------------------
    #
    #       PLOT 1
    #

    plot1 = subplot(231)

    X, Y = meshgrid(Cs, D)
    K    = sqrt( 8.0*Y*X*( A_p[1] - 0.5*X ))/( A_p[1]*h_p[1] )
    Z    = log( abs( K/K_ref - 1.0 ) )
    zmin = nx.min(Z); zmax = nx.max(Z)
    levels = -nx.logspace(log10(abs(zmin)),log10(abs(zmax)),num=nlevels)
    
    plot1.text(0.1, 0.1,'(a)', horizontalalignment='center',
               verticalalignment='center', transform = plot1.transAxes)    
    LineContour1 = plot1.contour(X, Y, Z, levels,
                                 colors = 'k',
                                 origin=origin,
                                 extend = extend,
                                 hold='on',
                                 extent = [8.13,10.17,2.175,2.455]
                                 )

    #plot1.scatter(Cs_sol, D_sol)
    
    plot1.xaxis.set_major_locator(AutoLocator())
    plot1.xaxis.set_major_formatter(OldScalarFormatter())
    plot1.xaxis.set_minor_locator(MultipleLocator(0.1))

    plot1.yaxis.set_major_locator(AutoLocator())
    plot1.yaxis.set_minor_locator(MultipleLocator(0.01))
    plot1.yaxis.set_major_formatter(OldScalarFormatter())

    plot1.set_xlim(8.13,10.17)
    plot1.set_ylim(2.175,2.455)

    plot1.set_xlabel(r'C$_\mathrm{s}$ (mg/cm$^3$)')
    plot1.set_ylabel(r'D$/10^{-5}$ (cm$^2/$day)')

    vmin = min(vmin, zmin)
    vmax = max(vmax, zmax)

    #---------------------------------------------------------------------------------------------
    #
    # PLOT 2
    #
    
    plot2 = subplot(232)

    X, Y = meshgrid(A, D)
    K    = sqrt( 8.0*Y*Cs_p[1]*( X - 0.5*Cs_p[1] ))/( X*h_p[1] )
    Z    = log( abs( K/K_ref - 1.0 ) )
    zmin = amin(Z); zmax = amax(Z)
    levels = -nx.logspace(log10(abs(zmin)),log10(abs(zmax)),num=nlevels)

    plot2.text(0.1, 0.1,'(b)', horizontalalignment='center',
               verticalalignment='center', transform = plot2.transAxes)    
    LineContour2 = plot2.contour(X, Y, Z, levels,
                                 colors = 'k',
                                 origin=origin,
                                 hold='on'
                                 )

    plot2.xaxis.set_minor_locator(MultipleLocator(0.2))
    plot2.yaxis.set_minor_locator(MultipleLocator(0.005))
    plot2.set_xlim(75.42,80.55)
    plot2.set_ylim(1.406,1.523)

    plot2.set_xlabel(r'C (mg/cm$^3$)')

    vmin = min(vmin, zmin)
    vmax = max(vmax, zmax)

    #---------------------------------------------------------------------------------------------
    #
    # PLOT 3
    #
    
    plot3 = subplot(233)

    X, Y = meshgrid(h, D)
    K    = sqrt( 8.0*Y*Cs_p[1]*( A_p[1] - 0.5*Cs_p[1] ))/( A_p[1]*X )
    Z    = log( abs( K/K_ref - 1.0 ) )
    zmin = amin(Z); zmax = amax(Z)
    levels = -nx.logspace(log10(abs(zmin)),log10(abs(zmax)),num=nlevels)

    plot3.text(0.1, 0.1,'(c)', horizontalalignment='center',
               verticalalignment='center', transform = plot3.transAxes)    
    LineContour3 = plot3.contour(X, Y, Z, levels,
                                 colors = 'k',
                                 origin=origin,
                                 hold='on'
                                 )
    
    plot3.xaxis.set_minor_locator(MultipleLocator(0.00005))
    plot3.yaxis.set_minor_locator(MultipleLocator(0.002))
    plot3.set_xlim(0.1663,0.1675)
    plot3.set_ylim(1.315,1.379)

    plot3.set_xticks(plot3.get_xticks()[1::2])
    plot3.xaxis.set_major_formatter(ScalarFormatter(useOffset=False,useMathText=True))
    plot3.set_xlabel(r'L (cm)')
    
    vmin = min(vmin, zmin)
    vmax = max(vmax, zmax)

    #---------------------------------------------------------------------------------------------
    #
    # PLOT 4
    #
    
    plot4 = subplot(234)
    
    X, Y = meshgrid(A, Cs)
    K    = sqrt( 8.0*D_p[1]*Y*( X - 0.5*Y ))/( X*h_p[1] )
    Z    = log( abs( K/K_ref - 1.0 ) )
    zmin = amin(Z); zmax = amax(Z)
    levels = -nx.logspace(log10(abs(zmin)),log10(abs(zmax)),num=nlevels)

    plot4.text(0.1, 0.1,'(d)', horizontalalignment='center',
               verticalalignment='center', transform = plot4.transAxes)    
    LineContour4 = plot4.contour(X, Y, Z, levels,
                                 colors = 'k',
                                 origin=origin,
                                 hold='on'
                                 )
    
    plot4.xaxis.set_minor_locator(MultipleLocator(0.2))
    plot4.yaxis.set_minor_locator(MultipleLocator(0.05))
    plot4.set_xlim(41.11,49.97)
    plot4.set_ylim(9.78,11.14)

    plot4.set_xlabel(r'C (mg/cm$^3$)')
    plot4.set_ylabel(r'C$_\mathrm{s}$ (mg/cm$^3$)')
    
    vmin = min(vmin, zmin)
    vmax = max(vmax, zmax)

    #---------------------------------------------------------------------------------------------
    #
    # PLOT 5
    #
    
    plot5 = subplot(235)
    
    X, Y = meshgrid(h, Cs)
    K    = sqrt( 8.0*D_p[1]*Y*( A_p[1] - 0.5*Y ))/( A_p[1]*X )
    Z    = log( abs( K/K_ref - 1.0 ) )
    zmin = amin(Z); zmax = amax(Z)
    levels = -nx.logspace(log10(abs(zmin)),log10(abs(zmax)),num=nlevels)

    plot5.text(0.1, 0.1,'(e)', horizontalalignment='center',
               verticalalignment='center', transform = plot5.transAxes)    
    LineContour5 = plot5.contour(X, Y, Z, levels,   #LINE CONTOUR
                                 colors = 'k',
                                 origin=origin,
                                 hold='on'
                                 )
    
    plot5.xaxis.set_minor_locator(MultipleLocator(0.00005))
    plot5.yaxis.set_minor_locator(MultipleLocator(0.01))
    plot5.set_xlim(0.1657,0.1668)
    plot5.set_ylim(15.82,16.172)

    plot5.set_xticks(plot5.get_xticks()[1::2])
    plot5.xaxis.set_major_formatter(ScalarFormatter(useOffset=False,useMathText=True))
    plot5.set_xlabel(r'L (cm)')

    vmin = min(vmin, zmin)
    vmax = max(vmax, zmax)

    #---------------------------------------------------------------------------------------------
    #
    # PLOT 6
    #

    plot6 = subplot(236)
    
    X, Y = meshgrid(h, A)
    K    = sqrt( 8.0*D_p[1]*Cs_p[1]*( Y - 0.5*Cs_p[1] ))/( Y*X )
    Z    = log( abs( K/K_ref - 1.0 ) )
    zmin = amin(Z); zmax = amax(Z)
    levels = -nx.logspace(log10(abs(zmin)),log10(abs(zmax)),num=nlevels)

    plot6.text(0.1, 0.1,'(f)', horizontalalignment='center',
               verticalalignment='center', transform = plot6.transAxes)    
    LineContour6 = plot6.contour(X, Y, Z, levels,   #LINE CONTOUR
                                 colors = 'k',
                                 origin=origin,
                                 hold='on'
                                 )
    
    setp(plot6.get_yticklabels(), visible=False)

    plot6.xaxis.set_minor_locator(MultipleLocator(0.00002))
    plot6.yaxis.set_minor_locator(MultipleLocator(0.1))
    plot6.yaxis.tick_right()

    plot6.set_xlim(0.1653,0.1661)
    plot6.set_ylim(70.44,72.46)

    plot6.set_xlabel(r'L (cm)')
    plot6.set_ylabel(r'C (mg/cm$^3$)')

    plot6.set_xticks(plot6.get_xticks()[2:-1:2])
    plot6.xaxis.set_major_formatter(ScalarFormatter(useOffset=False,useMathText=True))
    plot6.yaxis.set_label_position('right')
    
    vmin = min(vmin, zmin)
    vmax = max(vmax, zmax)

    show()
    #savefig('higuchi_zoom.eps')
    

    #show()

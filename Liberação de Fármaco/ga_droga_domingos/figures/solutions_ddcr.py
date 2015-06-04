#!/usr/bin/env python
#
# $Id:$
#
import asciidata
from asciidata import *

from pylab import *
import matplotlib.numerix as N
import matplotlib.numerix.ma as ma
from matplotlib import colors
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
    'lines.linewidth':0.8,
    'axes.labelsize': 10,
    'text.fontsize': 10,
    'xtick.labelsize': 8,
    'ytick.labelsize': 8,
    'text.usetex': True,
    'text.tex.engine': 'latex',
    'font.latex.package': 'type1cm',
    'figure.figsize': fig_size,
    'figure.subplot.left': 0.125,
    'figure.subplot.right': 0.90,
    'figure.subplot.top': 0.95,
    'figure.subplot.bottom': 0.2,
#     'figure.subplot.top': 0.85,
#     'figure.subplot.bottom': 0.1,
    'figure.facecolor': 'white',
    'xtick.major.size': 4,
    'xtick.minor.size': 2,
    'ytick.major.size': 4,
    'ytick.minor.size': 2 ###,
    #'contour.negative_linestyle': 'solid'
    }

rcParams.update(params)

#
#=============================PUBLICATION QUALITY==========================================
#



#------------------------------------------------------------------------------
if __name__ == '__main__':
    from matplotlib.ticker import ScalarFormatter, OldScalarFormatter

    table = AsciiData(filename='release_solutions.dat', ncols=5, comment_char='#')
    D_sol  = array(table[0])
    Cs_sol = array(table[1])
    C0_sol = array(table[2])
    L_sol  = array(table[3])  # L is actually the half-height of the device
    
    res  = array(table[4])

    R_sol = Cs_sol/C0_sol
    M_sol = 1.0 - 0.5 * R_sol
    t_sol = 0.5 * M_sol / R_sol

    D_p  = N.array([0.042,  1.35,  4.82])
    Cs_p = N.array([  2.7,  16.2,  40.0])
    A_p  = N.array([ 33.3,  70.0, 133.1])
    h_p  = N.array([0.164, 0.167, 0.170])

    N = 200
    
    D  = linspace(D_p[0],   D_p[2], num=N)
    Cs = linspace(Cs_p[0], Cs_p[2], num=N)
    A  = linspace(A_p[0],   A_p[2], num=N)
    h  = linspace(h_p[0],   h_p[2], num=N)

    #
    # Higuchi equation: M(t)/M(oo) = K * sqrt(t)
    #

    K_ref = sqrt( 8.0*D_p[1]*Cs_p[1]*( A_p[1] - 0.5*Cs_p[1] ))/( A_p[1]*h_p[1] )

    fig_histo = Figure()
    plot0 = subplot(111)
    plot0.hist(res)
    plot0.scatter(res, M_sol)
    plot0.scatter(res, t_sol)
    
    show()

    fig = Figure()

    colormap = cm.gray
    origin = 'lower'
    nlevels = 8
    extend = 'neither'
    subplots_adjust(wspace=0.0, hspace=0.35)

    #---------------------------------------------------------------------------------------------
    #
    #       PLOT 1
    #

    plot1 = subplot(231)

    X, Y = meshgrid(Cs, D)
    K    = sqrt( 8.0*Y*X*( A_p[1] - 0.5*X ))/( A_p[1]*h_p[1] )
    Z    = log( abs( K/K_ref - 1.0 ) )

    plot1.scatter(Cs_sol, D_sol, c='blue')

    LineContour1 = plot1.contour(X, Y, Z,
                                 colors = 'k',
                                 origin=origin,
                                 extend = extend,
                                 hold='on'
                                 )
    plot1.xaxis.set_major_locator(AutoLocator())
    # plot1.xaxis.set_major_locator(LinearLocator())
    #plot1.xaxis.set_minor_locator(MultipleLocator(0.2))
    plot1.xaxis.set_major_formatter(OldScalarFormatter())
     
    plot1.yaxis.set_major_locator(AutoLocator())
    # plot1.yaxis.set_minor_locator(MultipleLocator(1.0e3))
    plot1.yaxis.set_major_formatter(OldScalarFormatter())
    # plot1.yaxis.set_major_formatter(ScalarFormatter(useOffset=False, useMathText=False))

    xlabel(r'C$_\mathrm{s}$ (mg/cm$^3$)')
    ylabel(r'D$/10^{-5}$ (cm$^2/$day)')


    #---------------------------------------------------------------------------------------------
    #
    # PLOT 2
    #
    
    plot2 = subplot(232, sharey=plot1)

    X, Y = meshgrid(A, D)
    K    = sqrt( 8.0*Y*Cs_p[1]*( X - 0.5*Cs_p[1] ))/( X*h_p[1] )
    Z    = log( abs( K/K_ref - 1.0 ) )

    plot2.scatter(C0_sol, D_sol, c='blue')

    LineContour2 = plot2.contour(X, Y, Z,
                                 colors = 'k',
                                 origin=origin,
                                 hold='on'
                                 )
    #    plot2.scatter(C0_sol, D_sol)

    setp(plot2.get_yticklabels(), visible=False)
    xlabel(r'C (mg/cm$^3$)')

    #---------------------------------------------------------------------------------------------
    #
    # PLOT 3
    #
    
    plot3 = subplot(233, sharey=plot1)

    X, Y = meshgrid(h, D)
    K    = sqrt( 8.0*Y*Cs_p[1]*( A_p[1] - 0.5*Cs_p[1] ))/( A_p[1]*X )
    Z    = log( abs( K/K_ref - 1.0 ) )
    
    plot3.scatter(L_sol, D_sol, c='blue')
    LineContour3 = plot3.contour(X, Y, Z,
                                 colors = 'k',
                                 origin=origin,
                                 hold='on'
                                 )
    #    plot3.scatter(2.0*L_sol, D_sol)
    
    setp(plot2.get_yticklabels(), visible=False)
    plot3.set_xticks(plot3.get_xticks()[1:])
    xlabel(r'L (cm)')
    
    #---------------------------------------------------------------------------------------------
    #
    # PLOT 4
    #
    
    plot4 = subplot(234)
    
    X, Y = meshgrid(A, Cs)
    K    = sqrt( 8.0*D_p[1]*Y*( X - 0.5*Y ))/( X*h_p[1] )
    Z    = log( abs( K/K_ref - 1.0 ) )

    plot4.scatter(C0_sol, Cs_sol, c='blue')

    LineContour4 = plot4.contour(X, Y, Z,
                                 colors = 'k',
                                 origin=origin,
                                 hold='on'
                                 )

    #    plot4.scatter(C0_sol, Cs_sol)
    
    xlabel(r'C (mg/cm$^3$)')
    ylabel(r'C$_\mathrm{s}$ (mg/cm$^3$)')
    
    #---------------------------------------------------------------------------------------------
    #
    # PLOT 5
    #
    
    plot5 = subplot(235, sharey=plot4)
    
    X, Y = meshgrid(h, Cs)
    K    = sqrt( 8.0*D_p[1]*Y*( A_p[1] - 0.5*Y ))/( A_p[1]*X )
    Z    = log( abs( K/K_ref - 1.0 ) )

    plot5.scatter(L_sol, Cs_sol)

    LineContour5 = plot5.contour(X, Y, Z,
                                 colors = 'k',
                                 origin=origin,
                                 hold='on'
                                 )
    
    #    plot5.scatter(2.0*L_sol, Cs_sol)

    setp(plot5.get_yticklabels(), visible=False)
    plot5.set_xticks(plot5.get_xticks()[1:])
    xlabel(r'L (cm)')

    #---------------------------------------------------------------------------------------------
    #
    # PLOT 6
    #

    plot6 = subplot(236)
    
    X, Y = meshgrid(h, A)
    K    = sqrt( 8.0*D_p[1]*Cs_p[1]*( Y - 0.5*Cs_p[1] ))/( Y*X )
    Z    = log( abs( K/K_ref - 1.0 ) )

    plot6.scatter(L_sol, C0_sol, c='blue')

    LineContour6 = plot6.contour(X, Y, Z,
                                 colors = 'k',
                                 origin=origin,
                                 hold='on'
                                 )
    
    #    plot6.scatter(2.0*L_sol, C0_sol)

    plot6.set_xticks(plot6.get_xticks()[1:])
    setp(plot6.get_yticklabels(), visible=False)
    plot6.yaxis.tick_right()
    xlabel(r'L (cm)')
    ylabel(r'C (mg/cm$^3$)')
    plot6.yaxis.set_label_position('right')
    
    show()

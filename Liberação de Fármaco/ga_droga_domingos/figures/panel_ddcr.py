#!/usr/bin/env python
#
# $Id$
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


def setaxislines(ax, lbrt=1100, labels=00):
    """
    Set which borders of the axis are visible.  Note that subsequent calls
    to plot usually change these settings.

    lbrt - either a list of 4 values or a number with 4 digits. The values
            set which lines are visible: [left bottom right top]

    Example: setaxislines(ax, 1100) sets only the bottom and top axes visible
    """
    from matplotlib.lines import Line2D

    if isinstance(lbrt, int):
        lbrt = '%04d' % lbrt
    if isinstance(lbrt, str):
        lbrt = [int(x) for x in lbrt]

    if isinstance(labels, int):
        labels = '%04d' % labels
    if isinstance(labels, str):
        labels = [int(x) for x in labels]

    ax.set_frame_on(0)
    # Specify a line in axes coords to represent the left and bottom axes.
    val = 0
    if lbrt[0]:
        ax.add_line(Line2D([val, val], [0, 1], transform=ax.transAxes, c='k'))
    if lbrt[1]:
        ax.add_line(Line2D([0, 1], [val, val], transform=ax.transAxes, c='k'))
    if lbrt[2]:
        ax.add_line(Line2D([1, 1], [val, 1-val], transform=ax.transAxes, c='k'))
    if lbrt[3]:
        ax.add_line(Line2D([val, 1-val], [1, 1], transform=ax.transAxes, c='k'))

    if not labels[0]:
        setp(ax.get_xticklabels(), visible=False)
    if not labels[1]:
        setp(ax.get_yticklabels(), visible=False)

#------------------------------------------------------------------------------
if __name__ == '__main__':
    from matplotlib.ticker import ScalarFormatter, OldScalarFormatter

    table = AsciiData(filename='release_solutions.dat', ncols=5, comment_char='#')
    D_sol  = array(table[0])
    Cs_sol = array(table[1])
    C0_sol = array(table[2])
    L_sol  = array(table[3]) / 2.0  # L is actually the half-height of the device
    
    R_sol  = Cs_sol/C0_sol


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
    # test function
    #
    t = arange(0.01, 10.0, 0.01)
    s1 = exp(t)

    #
    # Higuchi equation: M(t)/M(oo) = K * sqrt(t)
    #

    K_ref = sqrt( 8.0*D_p[1]*Cs_p[1]*( A_p[1] - 0.5*Cs_p[1] ))/( A_p[1]*h_p[1] )

    fig = Figure()

    colormap = cm.gray
    origin = 'lower'
    nlevels = 8
    extend = 'neither'
    subplots_adjust(wspace=0.0, hspace=0.35)

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

    plot1.fill([8.13,10.17,10.17,8.13],[2.175,2.175,2.455,2.455],'k',fill=True,clip_on=True)

    plot1.text(10.2, 2.5,'(a)', horizontalalignment='left', fontsize=10,
               verticalalignment='baseline',)

    FillContour1 = plot1.contourf(X, Y, Z, nlevels,      #FILLED CONTOUR
                                  origin=origin,
                                  extend = extend,
                                  cmap=colormap
                                  )

    LineContour1 = plot1.contour(X, Y, Z, FillContour1.levels,   #LINE CONTOUR
                                 colors = 'k',
                                 origin=origin,
                                 extend = extend,
                                 hold='on'
                                 )

    plot1.plot(Cs_sol, D_sol)

    setaxislines(plot1, '1101', labels='11')
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


    vmin = min(vmin, amin(Z))
    vmax = max(vmax, amax(Z))

    #---------------------------------------------------------------------------------------------
    #
    # PLOT 2
    #
    
    plot2 = subplot(232, sharey=plot1)

    X, Y = meshgrid(A, D)
    K    = sqrt( 8.0*Y*Cs_p[1]*( X - 0.5*Cs_p[1] ))/( X*h_p[1] )
    Z    = log( abs( K/K_ref - 1.0 ) )

    plot2.fill([75.42,80.55,80.55,75.42],[1.406,1.406,1.523,1.523],'k',fill=True,clip_on=True)
    plot2.text(74.42, 1.523,'(b)', horizontalalignment='center', fontsize=10,
               verticalalignment='baseline',)

    FillContour2 = plot2.contourf(X, Y, Z, nlevels,      #FILLED CONTOUR
                                  origin=origin,
                                  cmap=colormap
                                  )
    LineContour2 = plot2.contour(X, Y, Z, FillContour2.levels,   #LINE CONTOUR
                                 colors = 'k',
                                 origin=origin,
                                 hold='on'
                                 )
    plot2.scatter(C0_sol, D_sol)

    setaxislines(plot2, '1111', labels='10')
    xlabel(r'C (mg/cm$^3$)')

    vmin = min(vmin, amin(Z))
    vmax = max(vmax, amax(Z))

    #---------------------------------------------------------------------------------------------
    #
    # PLOT 3
    #
    
    plot3 = subplot(233, sharey=plot1)

    X, Y = meshgrid(h, D)
    K    = sqrt( 8.0*Y*Cs_p[1]*( A_p[1] - 0.5*Cs_p[1] ))/( A_p[1]*X )
    Z    = log( abs( K/K_ref - 1.0 ) )
    
    plot3.fill([0.1663,0.1675,0.1675,0.1663],[1.315,1.315,1.379,1.379],'k',fill=True,clip_on=True)
    plot3.text(0.1663, 1.379,'(c)', horizontalalignment='right', fontsize=10,
               verticalalignment='baseline',)
    FillContour3 = plot3.contourf(X, Y, Z, nlevels,      #FILLED CONTOUR
                                  origin=origin,
                                  cmap=colormap
                                  )
    LineContour3 = plot3.contour(X, Y, Z, FillContour3.levels,   #LINE CONTOUR
                                 colors = 'k',
                                 origin=origin,
                                 hold='on'
                                 )
    plot3.scatter(2.0*L_sol, D_sol)
    
    setaxislines(plot3, '0111', labels='10')
    plot3.set_xticks(plot3.get_xticks()[1:])
    xlabel(r'L (cm)')
    
    vmin = min(vmin, amin(Z))
    vmax = max(vmax, amax(Z))

    #---------------------------------------------------------------------------------------------
    #
    # PLOT 4
    #
    
    plot4 = subplot(234)
    
    X, Y = meshgrid(A, Cs)
    K    = sqrt( 8.0*D_p[1]*Y*( X - 0.5*Y ))/( X*h_p[1] )
    Z    = log( abs( K/K_ref - 1.0 ) )

    plot4.fill([41.11,49.97,49.97,41.11],[9.78,9.78,11.14,11.14],'k',fill=True,clip_on=True)
    plot4.text(41.11, 11.14,'(d)', horizontalalignment='left', fontsize=10,
               verticalalignment='baseline',)
    FillContour4 = plot4.contourf(X, Y, Z, nlevels,      #FILLED CONTOUR
                                  origin=origin,
                                  cmap=colormap
                                  )
    LineContour4 = plot4.contour(X, Y, Z, FillContour4.levels,   #LINE CONTOUR
                                 colors = 'k',
                                 origin=origin,
                                 hold='on'
                                 )

    plot4.scatter(C0_sol, Cs_sol)
    
    setaxislines(plot4, '1101', labels='11')
    xlabel(r'C (mg/cm$^3$)')
    ylabel(r'C$_\mathrm{s}$ (mg/cm$^3$)')
    
    vmin = min(vmin, amin(Z))
    vmax = max(vmax, amax(Z))

    #---------------------------------------------------------------------------------------------
    #
    # PLOT 5
    #
    
    plot5 = subplot(235, sharey=plot4)
    
    X, Y = meshgrid(h, Cs)
    K    = sqrt( 8.0*D_p[1]*Y*( A_p[1] - 0.5*Y ))/( A_p[1]*X )
    Z    = log( abs( K/K_ref - 1.0 ) )

    plot5.fill([0.1657,0.1668,0.1668,0.1657],[15.182,15.182,16.172,16.172],'k',fill=True,clip_on=True)
    plot5.text(0.1657, 16.172,'(e)', horizontalalignment='left', fontsize=10,
               verticalalignment='baseline',)
    FillContour5 = plot5.contourf(X, Y, Z, nlevels,      #FILLED CONTOUR
                                  origin=origin,
                                  cmap=colormap
                                  )
    LineContour5 = plot5.contour(X, Y, Z, FillContour5.levels,   #LINE CONTOUR
                                 colors = 'k',
                                 origin=origin,
                                 hold='on'
                                 )
    
    plot5.scatter(2.0*L_sol, Cs_sol)

    setaxislines(plot5, '1111', labels='10')
    plot5.set_xticks(plot5.get_xticks()[1:])
    xlabel(r'L (cm)')

    vmin = min(vmin, amin(Z))
    vmax = max(vmax, amax(Z))

    #---------------------------------------------------------------------------------------------
    #
    # PLOT 6
    #

    plot6 = subplot(236)
    
    X, Y = meshgrid(h, A)
    K    = sqrt( 8.0*D_p[1]*Cs_p[1]*( Y - 0.5*Cs_p[1] ))/( Y*X )
    Z    = log( abs( K/K_ref - 1.0 ) )

    plot6.fill([0.1653,0.1661,0.1661,0.1653],[70.44,70.44,72.46,72.46],'k',fill=True,clip_on=True)
    plot6.text(0.1653, 72.46,'(f)', horizontalalignment='left', fontsize=10,
               verticalalignment='baseline',)
    FillContour6 = plot6.contourf(X, Y, Z, nlevels,      #FILLED CONTOUR
                                  origin=origin,
                                  cmap=colormap
                                  )
    LineContour6 = plot6.contour(X, Y, Z, FillContour6.levels,   #LINE CONTOUR
                                 colors = 'k',
                                 origin=origin,
                                 hold='on'
                                 )
    
    plot6.scatter(2.0*L_sol, C0_sol)

    setaxislines(plot6, '0111', labels='10')
    plot6.set_xticks(plot6.get_xticks()[1:])
    setp(plot6.get_yticklabels(), visible=False)
    plot6.yaxis.tick_right()
    xlabel(r'L (cm)')
    ylabel(r'C (mg/cm$^3$)')
    plot6.yaxis.set_label_position('right')
    
    vmin = min(vmin, amin(Z))
    vmax = max(vmax, amax(Z))

    #---------------------------------------------------------------------------------------------
    #
    # NOW PLACE THE COLORBAR
    #
    norm = colors.Normalize(vmin=vmin, vmax=vmax)
    FillContour1.set_norm(norm)
    FillContour2.set_norm(norm)
    FillContour3.set_norm(norm)
    FillContour4.set_norm(norm)
    FillContour5.set_norm(norm)
    FillContour6.set_norm(norm)

    cax = axes([0.2, 0.05, 0.6, 0.04])
    cx = colorbar(FillContour1, cax=cax, orientation='horizontal',spacing='proportional')
    cx.set_label('fitness')

    #savefig('higuchi.eps')
    show()
    

    #show()

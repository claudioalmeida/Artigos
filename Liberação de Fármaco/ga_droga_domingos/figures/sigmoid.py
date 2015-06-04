#!/usr/bin/env python
from pylab import *
from matplotlib.widgets import Slider, Button, RadioButtons

#--------------------------------------------------------------
# Genetic Operators
#--------------------------------------------------------------

def predator(M, D):
    sig = M + D
    arg = (f - M + D)/sig
    return( 1.0 / ( 1.0 + exp( arg ) ) )

def habitat(Rm):
    arg = Rm*(rij_rm - 1.0)
    return( 1.0 / ( 1.0 + exp( -arg ) ) )

def immigration(M, D, Ai):
    sig = M + D
    arg = (M - Ai)/sig
    return ( 0.5 * fhab / ( 1.0 + exp( arg ) ) )

def crossover1D(M, D):
    sig = M + D
    arg = (f - M - D)/sig
    return( 1.0 / ( 1.0 + exp( - arg ) ) )

def crossover2D(M, D):
    sig = M + D
    arg1 = (X - M - D)/sig
    arg2 = (Y - M - D)/sig
    cross1 = 1.0 / (1.0+exp(-arg1))
    cross2 = 1.0 / (1.0+exp(-arg2))
    return(cross1*cross2)

def mutation(M, D):
    sig = M + D
    arg = (f - M + D)/sig
    return( 1.0 / ( 1.0 + exp( arg ) ) )

def update_param(val):
    M_upd   = M.val
    D_upd   = D.val
    Rm_upd  = Rm.val
    Ai_upd  = Ai.val

    predator_plot.set_ydata( predator(M_upd, D_upd) )
    habitat_plot.set_ydata( habitat(Rm_upd) )
    immigration_plot.set_ydata( immigration(M_upd, D_upd, Ai_upd) )
    mutation_plot.set_ydata( mutation(M_upd, D_upd) )
    cross_plot.set_ydata( crossover1D(M_upd, D_upd) )

    draw()

def reset(event):
    M.reset()
    D.reset()
    Rm.reset()
    Ai.reset()

#-------------------------------------------------------------------------
if __name__ == '__main__':
    """
    fuzzy membership functions
    """
    #
    # -- initial value parameters 
    M_0  = -2.5
    D_0  =  0.1
    Rm_0 =  0.13
    Ai_0 =  1.3

    #
    # -- continuous variables
    f      = linspace(  -8.0, 2.0, num = 50)     # PREDATOR: fitness
    rij_rm = linspace(   0.0, 1.0, num = 50)     # HABITAT: euclidean distance
    fhab   = linspace(   0.0, 1.0, num = 50)     # IMMIGRATION:  Fraction of eliminations

    ax1 = subplot(231)
    predator_plot,  = ax1.plot(f, predator(M_0, D_0))
    #ax1.set_title(r'Predator')
    ax1.set_xlabel(r'$\mathcal{F}_i$')
    ax1.set_ylabel(r'$P_\textrm{p}(\mathcal{F}_i, M, D)$')

    ax2 = subplot(232)
    habitat_plot,   = ax2.plot(rij_rm, habitat(Rm_0))
    #ax2.set_title(r'Habitat')
    ax2.set_xlabel(r'$x = R_\textrm{ij}/R_m$')
    ax2.set_ylabel(r'$P_\textrm{hab}(x)$')

    ax3 = subplot(233)
    immigration_plot, = ax3.plot(fhab, immigration(M_0, D_0, Ai_0))
    #ax3.set_title(r'Immigration')
    ax3.set_xlabel(r'$N_\textrm{p+hab}/N_\textrm{tot}$')
    ax3.set_ylabel(r'$N(N_\textrm{p+hab}, M, D)/N_\textrm{tot}$')

    ax4 = subplot(234)
    mutation_plot, = ax4.plot(f, mutation(M_0, D_0))
    #ax4.set_title(r'Mutation')
    ax4.set_xlabel(r'$\mathcal{F}_i$')
    ax4.set_ylabel(r'$P_\textrm{p}(\mathcal{F}_i, M, D)$')

    ax5 = subplot(235)
    cross_plot, = ax5.plot(f, crossover1D(M_0, D_0))
    #ax5.set_title(r'Mutation')
    ax5.set_xlabel(r'$\mathcal{F}_i$')
    ax5.set_ylabel(r'$P_\textrm{p}(\mathcal{F}_i, M, D)$')

    #ax6 = subplot(326)
    #X, Y = meshgrid(f, f)
    #Z = crossover2D(M_0, D_0)
    #contour = ax6.contour(X, Y, Z,
    #                      8,
    #                      colors = 'k',
    #                      origin = 'lower',
    #                      hold = 'on',
    #                      extend = 'max',
    #                      extent = [-8.0,0.0,-8.0,0.0]
    #                      )
    #ax6.clabel(contour, inline=1)
    ##ax6.set_title(r'Crossover')
    #ax6.set_xlabel(r'$\mathcal{F}_i$')
    #ax6.set_ylabel(r'$\mathcal{F}_j$')
    
    #
    #---------------------------------

    subplots_adjust(left=0.1, bottom=0.25, wspace=0.4)
    axcolor = 'lightgoldenrodyellow'

    param_M  = axes([0.15, 0.01, 0.7, 0.02], axisbg=axcolor)
    param_D  = axes([0.15, 0.05, 0.7, 0.02], axisbg=axcolor)
    param_Rm = axes([0.15, 0.09, 0.7, 0.02], axisbg=axcolor)
    param_Ai = axes([0.15, 0.12, 0.7, 0.02], axisbg=axcolor)

    M  = Slider(param_M,  r'$M$',    -10.0,  0.0, valinit = M_0)
    D  = Slider(param_D,  r'$D$',      0.0,  0.4, valinit = D_0)
    Rm = Slider(param_Rm, r'$R_m$',    0.0,  1.0, valinit = Rm_0)
    Ai = Slider(param_Ai, r'$A_i$',   -2.0,  2.0, valinit = Ai_0)
    

    M.on_changed(update_param)
    D.on_changed(update_param)
    Rm.on_changed(update_param)
    Ai.on_changed(update_param)

    resetax = axes([0.01, 0.025, 0.06, 0.04])
    button = Button(resetax, 'Reset')
    button.on_clicked(reset)
    show()


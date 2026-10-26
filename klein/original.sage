# Garrafa de Klein + única semireta vermelha (origem fixa, L=10, sem eixos)
from sage.all import *
from sage.plot.plot3d.shapes import arrow3d

@interact
def klein_semireta(
    # --- parâmetros da Garrafa de Klein ---
    r = slider(0, 3, step_size=0.5, default=3, label='r (raio relativo do tubo)'),
    a = slider(0.1, 2, step_size=0.05, default=1, label='a (multiplicador do intervalo de v)'),

    # --- direção da semireta (somente θ, φ) ---
    theta = slider(0, pi, 0.01, default=pi/2, label='θ (polar)'),
    phi   = slider(0, 2*pi, 0.01, default=2.30, label='φ (azimute)')
):

    # ===== Garrafa de Klein =====
    var('u v')

    x = -(4/15)*cos(u)*(
            3*r*cos(v)
          - 30*sin(u)
          + 90*cos(u)**4*sin(u)
          - 60*cos(u)**6*sin(u)
          + 5*cos(u)*(r*cos(v))*sin(u)
    )

    y = -(2/15)*sin(u)*(
            3*r*cos(v)
          - 3*cos(u)**2*(r*cos(v))
          - 48*cos(u)**4*(r*cos(v))
          + 48*cos(u)**6*(r*cos(v))
          - 60*sin(u)
          + 5*cos(u)*(r*cos(v))*sin(u)
          - 5*cos(u)**3*(r*cos(v))*sin(u)
          - 80*cos(u)**5*(r*cos(v))*sin(u)
          + 80*cos(u)**7*(r*cos(v))*sin(u)
    )

    z = (4/15)*(3 + 5*cos(u)*sin(u))*(r*sin(v))

    K = parametric_plot3d(
        (x, y, z),
        (u, 0, pi), (v, 0, a*pi),
        color='lightgray',
        mesh=True,
        opacity=1,          # opacidade fixa
        frame=False,
        axes=False,         # sem eixos
        aspect_ratio=(1,1,1),
        plot_points=[80, 80]
    )

    # ===== Semirreta =====
    P = vector([0, 1.5, 0])   # ORIGEM FIXA
    L = 10                  # comprimento fixo

    v_dir = vector([sin(theta)*cos(phi), sin(theta)*sin(phi), cos(theta)])
    A = P
    B = P + L * v_dir

    pt  = point3d(P, size=40, color='blue')
    seg = line3d([A, B], thickness=4, color='red')
    arr = arrow3d(A, B, thickness=1, color='red')

    show(K + pt + seg + arr, frame=False, axes=False, aspect_ratio=(1,1,1))

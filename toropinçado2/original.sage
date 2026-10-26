# SageMath Cell

var('u v')

# Parâmetros do toro usual
R, r = 2, 1

# Toro usual
Tx(u,v) = (R + r*cos(v))*cos(u)
Ty(u,v) = (R + r*cos(v))*sin(u)
Tz(u,v) = r*sin(v)

@interact
def deform_pinched_torus(t=slider(0,1,0.1,default=0.5,label="Deformação t"),
                         k=slider(1,10,1,default=8,label="Número de pinçamentos")):
    # Toro pinçado com k pinchamentos
    g(u,v) = R + sin(k*u/2)*cos(v)
    Px(u,v) = g(u,v)*cos(u)
    Py(u,v) = g(u,v)*sin(u)
    Pz(u,v) = sin(k*u/2)*sin(v)

    # Interpolação
    X(u,v) = (1-t)*Tx(u,v) + t*Px(u,v)
    Y(u,v) = (1-t)*Ty(u,v) + t*Py(u,v)
    Z(u,v) = (1-t)*Tz(u,v) + t*Pz(u,v)

    surface = parametric_plot3d(
        (X, Y, Z),
        (u, 0, 2*pi),
        (v, 0, 2*pi),
        color="orange",mesh=True,
        opacity=0.9,
        plot_points=[100,100]
    )

    show(surface, frame=False, aspect_ratio=(1,1,1))

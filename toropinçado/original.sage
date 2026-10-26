# SageMath Cell

var('x y')

@interact
def plot_pinched_torus(radius=slider(0.1,1.0,0.1,default=0.3,label="Raio da esfera")):
    # Função auxiliar
    g(x,y) = 2 + sin(x/2)*cos(y)

    # Parametrização do toro pinçado
    X(x,y) = g(x,y)*cos(x)
    Y(x,y) = g(x,y)*sin(x)
    Z(x,y) = sin(x/2)*sin(y)

    # Toro pinçado
    pinched = parametric_plot3d(
        (X, Y, Z),
        (x, 0, 2*pi),
        (y, 0, 2*pi),
        color="orange",mesh=True,
        opacity=0.9,
        plot_points=[50,50]
    )

    # Ponto singular (x=0, y=0) => (2,0,0)
    singular_point = (2,0,0)

    # Esfera centrada no ponto singular, raio variável
    sphere_plot = sphere(center=singular_point, size=radius, color="blue", opacity=0.4)

    # Combina os dois plots
    show(pinched + sphere_plot, frame=False, aspect_ratio=(1,1,1))

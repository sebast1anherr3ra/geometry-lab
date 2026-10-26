# ============================================================
# IMPORTAÇÕES E VARIÁVEIS
# ============================================================

from sage.plot.plot3d.implicit_plot3d import implicit_plot3d

var('x y z')


# ============================================================
# 1. DEFINIÇÃO DAS DUAS SUPERFÍCIES
# ============================================================

# Superfície 1
F1 = (
    2*y*(y^2 - 3*x^2)*(1 - z^2)
    + (x^2 + y^2)^2
    - (9*z^2 - 1)*(1 - z^2)
)

# Superfície 2: soma conexa de dois toros
F2 = (
    (4*x^2*(1 - x^2) - y^2)^2
    + z^2
    - 1/4
)


# ============================================================
# 2. DADOS DE CADA SUPERFÍCIE
# ============================================================

def dados_da_superficie(escolha):

    # Compatibilidade com diferentes versões do SageCell:
    # a primeira opção pode ser devolvida como 0
    # ou como o texto "Superfície 1".
    primeira_superficie = (
        escolha == 0
        or escolha == "Superfície 1"
    )

    if primeira_superficie:

        return {
            'funcao': F1,
            'x_min': -2,
            'x_max': 2,
            'y_min': -2,
            'y_max': 2,
            'z_min': -1,
            'z_max': 1,
            'cor': 'lightblue',
            'titulo': 'Superfície 1'
        }

    else:

        return {
            'funcao': F2,
            'x_min': -1.1,
            'x_max': 1.1,
            'y_min': -1.3,
            'y_max': 1.3,
            'z_min': -0.55,
            'z_max': 0.55,
            'cor': 'steelblue',
            'titulo': 'Superfície de gênero 2'
        }


# ============================================================
# 3. FUNÇÃO QUE CONSTRÓI OS GRÁFICOS
# ============================================================

def plot_intersection(escolha, C_val):

    # Obter os dados da superfície selecionada
    dados = dados_da_superficie(escolha)

    F = dados['funcao']

    x_min = dados['x_min']
    x_max = dados['x_max']

    y_min = dados['y_min']
    y_max = dados['y_max']

    z_min = dados['z_min']
    z_max = dados['z_max']

    cor = dados['cor']
    titulo = dados['titulo']


    # --------------------------------------------------------
    # Superfície implícita F(x,y,z) = 0
    # --------------------------------------------------------

    surface = implicit_plot3d(
        F,
        (x, x_min, x_max),
        (y, y_min, y_max),
        (z, z_min, z_max),
        contour=0,
        plot_points=70,
        color=cor,
        opacity=0.75,
        smooth=True
    )


    # --------------------------------------------------------
    # Plano horizontal z = C
    # --------------------------------------------------------

    plane = implicit_plot3d(
        z - C_val,
        (x, x_min, x_max),
        (y, y_min, y_max),
        (z, z_min, z_max),
        contour=0,
        plot_points=30,
        color='green',
        opacity=0.30
    )


    # --------------------------------------------------------
    # Restrição da equação ao plano z = C
    # --------------------------------------------------------

    F_corte = F.subs(z=C_val)


    # --------------------------------------------------------
    # Curva de interseção F(x,y,C) = 0 no plano xy
    # --------------------------------------------------------

    curve = implicit_plot(
        F_corte,
        (x, x_min, x_max),
        (y, y_min, y_max),
        contours=[0],
        fill=False,
        plot_points=150,
        color='red'
    )


    # --------------------------------------------------------
    # Mostrar a superfície e o plano
    # --------------------------------------------------------

    show(
        surface + plane,
        viewer='threejs',
        aspect_ratio=1,
        axes=True,
        frame=False
    )


    # --------------------------------------------------------
    # Mostrar separadamente a curva de interseção
    # --------------------------------------------------------

    show(
        curve,
        aspect_ratio=1,
        axes=True,
        frame=True,
        axes_labels=['x', 'y'],
        title=titulo + ': corte em z = ' + str(C_val)
    )


# ============================================================
# 4. INTERFACE INTERATIVA
# ============================================================

@interact
def interactive_plot(

    superficie=selector(
        [
            "Superfície 1",
            "Superfície 2"
        ],
        default="Superfície 1",
        label="Escolha a superfície",
        buttons=True
    ),

    altura_do_corte=slider(
        -1,
        1,
        0.05,
        default=0,
        label="Altura do corte"
    )
):

    plot_intersection(
        superficie,
        altura_do_corte
    )

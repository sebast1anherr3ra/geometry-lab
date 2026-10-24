# ==========================================================
# FIBRACAO DE HOPF: DOIS PONTOS E DUAS FIBRAS
# S^1 -> S^3 -> S^2
# SageMath / SageCell
# ==========================================================

var('t s v')

# ----------------------------------------------------------
# 1. Parametros da regiao U
# ----------------------------------------------------------

eta_min = 0.35
eta_max = 0.65

phi_min = -0.50
phi_max = 0.50


# ----------------------------------------------------------
# 2. Projecao estereografica de S^3 em R^3
# ----------------------------------------------------------

def proj_hopf(eta, phi, t):
    x1 = cos(eta)*cos(t)
    x2 = cos(eta)*sin(t)
    x3 = sin(eta)*cos(t + phi)
    x4 = sin(eta)*sin(t + phi)

    d = 1 - x4
    return (x1/d, x2/d, x3/d)


# ----------------------------------------------------------
# 3. Base S^2: regiao U, bordas e dois pontos
# ----------------------------------------------------------

def grafico_base(eta0, phi0, eta1, phi1):
    B = sphere(
        (0, 0, 0), 1,
        color='#D3D3D3',
        opacity=0.25,
        mesh=False
    )

    # Regiao U
    B += parametric_plot3d(
        (
            sin(2*s)*cos(v),
            sin(2*s)*sin(v),
            cos(2*s)
        ),
        (s, eta_min, eta_max),
        (v, phi_min, phi_max),
        color='#B9DDF5',
        opacity=0.85,
        plot_points=[30, 30]
    )

    # Bordas eta constante: verde
    for e in [eta_min, eta_max]:
        B += parametric_plot3d(
            (
                sin(2*e)*cos(v),
                sin(2*e)*sin(v),
                cos(2*e)
            ),
            (v, phi_min, phi_max),
            color='green',
            thickness=4,
            plot_points=70
        )

    # Bordas phi constante: vermelho
    for f in [phi_min, phi_max]:
        B += parametric_plot3d(
            (
                sin(2*s)*cos(f),
                sin(2*s)*sin(f),
                cos(2*s)
            ),
            (s, eta_min, eta_max),
            color='red',
            thickness=4,
            plot_points=70
        )

    # Ponto azul
    p0 = (
        sin(2*eta0)*cos(phi0),
        sin(2*eta0)*sin(phi0),
        cos(2*eta0)
    )
    B += point3d(p0, color='darkblue', size=60)

    # Ponto amarelo
    p1 = (
        sin(2*eta1)*cos(phi1),
        sin(2*eta1)*sin(phi1),
        cos(2*eta1)
    )
    B += point3d(p1, color='#E6B800', size=60)

    return B


# ----------------------------------------------------------
# 4. Superficies da preimagem das bordas
# ----------------------------------------------------------

def parede_eta(eta_const, cor='#DCEEFF', opacidade=0.22):
    X, Y, Z = proj_hopf(eta_const, v, t)

    return parametric_plot3d(
        (X, Y, Z),
        (t, 0, 2*pi),
        (v, phi_min, phi_max),
        color=cor,
        opacity=opacidade,
        plot_points=[65, 24]
    )


def parede_phi(phi_const, cor='#DCEEFF', opacidade=0.22):
    X, Y, Z = proj_hopf(s, phi_const, t)

    return parametric_plot3d(
        (X, Y, Z),
        (t, 0, 2*pi),
        (s, eta_min, eta_max),
        color=cor,
        opacity=opacidade,
        plot_points=[65, 24]
    )


# ----------------------------------------------------------
# 5. Preimagem com duas fibras
# ----------------------------------------------------------

def grafico_preimagem(eta0, phi0, eta1, phi1):
    P = Graphics()

    # Superficies laterais de fundo
    P += parede_eta(eta_min, '#DCEEFF', 0.18)
    P += parede_eta(eta_max, '#DCEEFF', 0.18)
    P += parede_phi(phi_min, '#DCEEFF', 0.18)
    P += parede_phi(phi_max, '#DCEEFF', 0.18)

    # Preimagens eta constante: verde pastel
    P += parede_eta(eta_min, '#B7E4C7', 0.65)
    P += parede_eta(eta_max, '#B7E4C7', 0.65)

    # Preimagens phi constante: vermelho pastel
    P += parede_phi(phi_min, '#F7C6C7', 0.65)
    P += parede_phi(phi_max, '#F7C6C7', 0.65)

    # Fibra do ponto azul
    X0, Y0, Z0 = proj_hopf(eta0, phi0, t)

    P += parametric_plot3d(
        (X0, Y0, Z0),
        (t, 0, 2*pi),
        color='darkblue',
        thickness=5,
        plot_points=250
    )

    # Fibra do ponto amarelo
    X1, Y1, Z1 = proj_hopf(eta1, phi1, t)

    P += parametric_plot3d(
        (X1, Y1, Z1),
        (t, 0, 2*pi),
        color='#E6B800',
        thickness=5,
        plot_points=250
    )

    return P


# ----------------------------------------------------------
# 6. Interface interativa com quatro deslizadores
# ----------------------------------------------------------

@interact
def explorar_hopf(
    eta0=slider(
        eta_min, eta_max, 0.01,
        default=0.45,
        label='eta azul'
    ),
    phi0=slider(
        phi_min, phi_max, 0.01,
        default=-0.20,
        label='phi azul'
    ),
    eta1=slider(
        eta_min, eta_max, 0.01,
        default=0.55,
        label='eta amarelo'
    ),
    phi1=slider(
        phi_min, phi_max, 0.01,
        default=0.25,
        label='phi amarelo'
    )
):
    print("Base S^2: pontos azul e amarelo")

    show(
        grafico_base(eta0, phi0, eta1, phi1),
        viewer='threejs',
        figsize=5,
        aspect_ratio=1,
        axes_labels=['u', 'v', 'w'],
        frame=False
    )

    print("Preimagem em R^3: fibras azul e amarela")

    show(
        grafico_preimagem(eta0, phi0, eta1, phi1),
        viewer='threejs',
        figsize=7,
        aspect_ratio=1,
        axes_labels=['X', 'Y', 'Z'],
        frame=False
    )

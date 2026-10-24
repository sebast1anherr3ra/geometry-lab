@interact
def identificacao_quadrado(
    tipo=selector(["Toro", "Garrafa de Klein"], label="Superfície"),
    s=slider(0,1,0.02,0,label="1. Fechar lados verdes"),
    t=slider(0,1,0.02,0,label="2. Identificar extremos vermelhos"),
    u0=slider(0,1,0.01,0.35,label="Posição horizontal do ponto"),
    v0=slider(0,1,0.01,0.60,label="Posição vertical do ponto")
):

    var('u v')

    r = 0.25
    rK = 1.25
    R = 1.4

    def F_cilindro(u,v):
        return (
            2*u - 1,
            r*cos(2*pi*v),
            r*sin(2*pi*v)
        )

    def F_toro_final(u,v):
        U = 2*pi*u
        V = 2*pi*v

        return (
            (R + r*cos(V))*cos(U),
            (R + r*cos(V))*sin(U),
            r*sin(V)
        )

    def F_klein_final(u,v):
        U = pi*u
        V = 2*pi*v

        x = -(4/15)*cos(U)*(
                3*rK*cos(V)
              - 30*sin(U)
              + 90*cos(U)^4*sin(U)
              - 60*cos(U)^6*sin(U)
              + 5*cos(U)*(rK*cos(V))*sin(U)
        )

        y = -(2/15)*sin(U)*(
                3*rK*cos(V)
              - 3*cos(U)^2*(rK*cos(V))
              - 48*cos(U)^4*(rK*cos(V))
              + 48*cos(U)^6*(rK*cos(V))
              - 60*sin(U)
              + 5*cos(U)*(rK*cos(V))*sin(U)
              - 5*cos(U)^3*(rK*cos(V))*sin(U)
              - 80*cos(U)^5*(rK*cos(V))*sin(U)
              + 80*cos(U)^7*(rK*cos(V))*sin(U)
        )

        z = (4/15)*(3 + 5*cos(U)*sin(U))*(rK*sin(V))

        return (x, y, z)

    def F(u,v):
        X0 = 2*u - 1
        Y0 = v - 0.5
        Z0 = 0

        X1,Y1,Z1 = F_cilindro(u,v)

        if tipo == "Toro":
            X2,Y2,Z2 = F_toro_final(u,v)
        else:
            X2,Y2,Z2 = F_klein_final(u,v)

        A = (
            (1-s)*X0 + s*X1,
            (1-s)*Y0 + s*Y1,
            (1-s)*Z0 + s*Z1
        )

        return (
            (1-t)*A[0] + t*X2,
            (1-t)*A[1] + t*Y2,
            (1-t)*A[2] + t*Z2
        )

    # ----------------------------
    # Setas 3D menores
    # ----------------------------

    def seta_3d_bordo_u(u_const, a, direcao, cor):
        eps = 0.035
        if direcao == 1:
            p = F(u_const, a - eps)
            q = F(u_const, a + eps)
        else:
            p = F(u_const, a + eps)
            q = F(u_const, a - eps)

        return arrow3d(p, q, color=cor, width=2)

    def seta_3d_bordo_v(v_const, a, direcao, cor):
        eps = 0.035
        if direcao == 1:
            p = F(a - eps, v_const)
            q = F(a + eps, v_const)
        else:
            p = F(a + eps, v_const)
            q = F(a - eps, v_const)

        return arrow3d(p, q, color=cor, width=2)

    titulo = tipo

    # ----------------------------
    # Quadrado original com setas
    # ----------------------------

    quadrado = polygon2d(
        [(0,0),(1,0),(1,1),(0,1)],
        color="lightblue",
        alpha=0.35,
        edgecolor="black"
    )

    bordo_inf = line2d([(0,0),(1,0)], color="green", thickness=4)
    bordo_sup = line2d([(0,1),(1,1)], color="green", thickness=4)

    bordo_esq = line2d([(0,0),(0,1)], color="red", thickness=4)
    bordo_dir = line2d([(1,0),(1,1)], color="red", thickness=4)

    # Setas verdes 2D: 4 em cada bordo
    setas_verdes_2d = (
        arrow((0.14,0.03), (0.22,0.03), color="green", width=1)
        + arrow((0.36,0.03), (0.44,0.03), color="green", width=1)
        + arrow((0.58,0.03), (0.66,0.03), color="green", width=1)
        + arrow((0.80,0.03), (0.88,0.03), color="green", width=1)

        + arrow((0.14,0.97), (0.22,0.97), color="green", width=1)
        + arrow((0.36,0.97), (0.44,0.97), color="green", width=1)
        + arrow((0.58,0.97), (0.66,0.97), color="green", width=1)
        + arrow((0.80,0.97), (0.88,0.97), color="green", width=1)
    )

    # Setas vermelhas 2D: 4 em cada bordo
    if tipo == "Toro":
        setas_vermelhas_2d = (
            arrow((0.03,0.14), (0.03,0.22), color="red", width=1)
            + arrow((0.03,0.36), (0.03,0.44), color="red", width=1)
            + arrow((0.03,0.58), (0.03,0.66), color="red", width=1)
            + arrow((0.03,0.80), (0.03,0.88), color="red", width=1)

            + arrow((0.97,0.14), (0.97,0.22), color="red", width=1)
            + arrow((0.97,0.36), (0.97,0.44), color="red", width=1)
            + arrow((0.97,0.58), (0.97,0.66), color="red", width=1)
            + arrow((0.97,0.80), (0.97,0.88), color="red", width=1)
        )
    else:
        setas_vermelhas_2d = (
            arrow((0.03,0.14), (0.03,0.22), color="red", width=1)
            + arrow((0.03,0.36), (0.03,0.44), color="red", width=1)
            + arrow((0.03,0.58), (0.03,0.66), color="red", width=1)
            + arrow((0.03,0.80), (0.03,0.88), color="red", width=1)

            + arrow((0.97,0.22), (0.97,0.14), color="red", width=1)
            + arrow((0.97,0.44), (0.97,0.36), color="red", width=1)
            + arrow((0.97,0.66), (0.97,0.58), color="red", width=1)
            + arrow((0.97,0.88), (0.97,0.80), color="red", width=1)
        )

    ponto_quadrado = point2d(
        [(u0,v0)],
        size=45,
        color=(0.10,0.25,0.85)
    )

    texto = text(titulo, (0.5,1.12), fontsize=13, color="black")

    show(
        quadrado
        + bordo_inf + bordo_sup
        + bordo_esq + bordo_dir
        + setas_verdes_2d
        + setas_vermelhas_2d
        + ponto_quadrado
        + texto,
        aspect_ratio=1,
        axes=False,
        xmin=-0.15,
        xmax=1.15,
        ymin=-0.15,
        ymax=1.2,
        figsize=4
    )

    # ----------------------------
    # Superfície em 3D com setas
    # ----------------------------

    X,Y,Z = F(u,v)

    superficie = parametric_plot3d(
        (X,Y,Z),
        (u,0,1),
        (v,0,1),
        mesh=True,
        opacity=0.75,
        color="lightblue",
        frame=False,
        axes=False,
        plot_points=[90,90]
    )

    bordo_v0 = parametric_plot3d(F(u,0), (u,0,1), color="green", thickness=5)
    bordo_v1 = parametric_plot3d(F(u,1), (u,0,1), color="green", thickness=5)

    bordo_u0 = parametric_plot3d(F(0,v), (v,0,1), color="red", thickness=5)
    bordo_u1 = parametric_plot3d(F(1,v), (v,0,1), color="red", thickness=5)

    # Posições das 4 setas em cada bordo
    pos = [0.18, 0.38, 0.62, 0.82]

    setas_verdes_3d = sum(
        [seta_3d_bordo_v(0, a, 1, "green") for a in pos]
        + [seta_3d_bordo_v(1, a, 1, "green") for a in pos]
    )

    dir_u1 = 1 if tipo == "Toro" else -1

    setas_vermelhas_3d = sum(
        [seta_3d_bordo_u(0, a, 1, "red") for a in pos]
        + [seta_3d_bordo_u(1, a, dir_u1, "red") for a in pos]
    )

    ponto_superficie = point3d(
        [F(u0,v0)],
        size=35,
        color=(0.10,0.25,0.85)
    )

    show(
        superficie
        + bordo_v0 + bordo_v1
        + bordo_u0 + bordo_u1
        + setas_verdes_3d
        + setas_vermelhas_3d
        + ponto_superficie,
        aspect_ratio=1,
        figsize=6
    )

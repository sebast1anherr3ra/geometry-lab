# Importar as funções interativas
@interact
def frenet_approximation(curve=selector(['Curva 1', 'Curva 2', 'Curva 3'], label="Selecione a curva"),
                         t0=slider(-2*pi, 2*pi, 0.1, default=0, label="Parâmetro t0")):
    
    # Definir o parâmetro t
    t = var('t')

    # Lista de curvas parametrizadas
    if curve == 'Curva 1':
        r = vector([cos(t)*cos(2*t), cos(t)*sin(2*t), sin(t)])
    elif curve == 'Curva 2':
        # Parâmetros da Rhumb line
        r_rhumb = 2  # raio da esfera
        k = 0.5      # Constante do ângulo (tangente do ângulo de inclinação)
        phi = arctan(k * t)  # Latitude (φ)
        lambda_ = t*10/pi          # Longitude (λ)
        # Coordenadas paramétricas da Rhumb line
        x_rhumb = r_rhumb * cos(phi) * cos(lambda_)
        y_rhumb = r_rhumb * cos(phi) * sin(lambda_)
        z_rhumb = r_rhumb * sin(phi)
        # Definir a curva Rhumb line em R^3
        r = vector([x_rhumb, y_rhumb, z_rhumb])
    elif curve == 'Curva 3':
        r = vector([sin(t), cos(t), t])
    
    # Definir as componentes x, y, z da curva selecionada
    x, y, z = r[0], r[1], r[2]

    # Calcular as expansões de Taylor até grau 4 em torno de t0
    taylor_x_1 = x.taylor(t, t0, 1)
    taylor_y_1 = y.taylor(t, t0, 1)
    taylor_z_1 = z.taylor(t, t0, 1)
    
    taylor_x_2 = x.taylor(t, t0, 2)
    taylor_y_2 = y.taylor(t, t0, 2)
    taylor_z_2 = z.taylor(t, t0, 2)

    taylor_x_3 = x.taylor(t, t0, 3)
    taylor_y_3 = y.taylor(t, t0, 3)
    taylor_z_3 = z.taylor(t, t0, 3)

    taylor_x_4 = x.taylor(t, t0, 4)
    taylor_y_4 = y.taylor(t, t0, 4)
    taylor_z_4 = z.taylor(t, t0, 4)

    # Desenhar manualmente os eixos com vetores
    eixo_x = arrow3d((0,0,0), (1/2,0,0), color='green', thickness=2)
    eixo_y = arrow3d((0,0,0), (0,1/2,0), color='red', thickness=2)
    eixo_z = arrow3d((0,0,0), (0,0,1/2), color='blue', thickness=2)

    # Calcular o vetor tangente T(t)
    T = 1/2*diff(r, t).normalized()

    # Calcular o vetor normal N(t)
    N = 1/2*diff(T, t).normalized()

    # Calcular o vetor binormal B(t)
    B =1/2*(2*T).cross_product(2*N)

    # Substituir t=t0 para calcular as componentes no ponto de interesse
    r_t_value = r.subs(t=t0)
    T_t_value = T.subs(t=t0)
    N_t_value = N.subs(t=t0)
    B_t_value = B.subs(t=t0)

    # Plotar o triedro móvel no ponto correspondente
    origin = point3d(r_t_value, size=10, color='red')
    tangent_vector = arrow3d(r_t_value, r_t_value + T_t_value, color='green')
    normal_vector = arrow3d(r_t_value, r_t_value + N_t_value, color='red')
    binormal_vector = arrow3d(r_t_value, r_t_value + B_t_value, color='blue')

    # Adicionar rótulos para os vetores T, N, B
    label_T = text3d("T", r_t_value + vector((0.15, 0.15, 0.15)), color='green', fontsize=18)
    label_N = text3d("N", r_t_value + vector((-0.15, -0.15, -0.15)), color='red', fontsize=18)
    label_B = text3d("B", r_t_value + vector((0.15, -0.15, 0.15)), color='blue', fontsize=18)

    # Criar o plano osculador (superfície) usando os vetores T e N
    s, v = var('s v')  # Definir os parâmetros da superfície
    plane_point = r_t_value + s*T_t_value + v*N_t_value  # Pontos do plano osculador
    osculating_plane = parametric_plot3d(plane_point, (s, -0.5, 0.5), (v, -0.5, 0.5), color=(0.7, 0.7, 0.7, 0.3))  # Cor cinza com transparência

    # Criar os gráficos da curva original e das aproximações
    original_curve = parametric_plot3d((x, y, z), (t, -2*pi, 2*pi), color='blue', linestyle="--", frame=False, legend_label='Curva Original', thickness=2, plot_points=200)
    
    approx_curve_1 = parametric_plot3d((taylor_x_1, taylor_y_1, taylor_z_1), (t, t0-0.5, t0+0.5), color='orange', thickness=2, frame=False, linestyle="--", legend_label='Aproximação Grau 1')
    label_approx_1 = text3d("Aproximação Grau 1", r_t_value + vector((0.75, 0.75, 0.75)), color='orange', fontsize=12)

    approx_curve_2 = parametric_plot3d((taylor_x_2, taylor_y_2, taylor_z_2), (t, t0-0.5, t0+0.5), color='red', thickness=2, frame=False, linestyle="--", legend_label='Aproximação Grau 2')
    label_approx_2 = text3d("Aproximação Grau 2", r_t_value + vector((1, 1, 1)), color='red', fontsize=12)

    approx_curve_3 = parametric_plot3d((taylor_x_3, taylor_y_3, taylor_z_3), (t, t0-1, t0+1), color='green', thickness=2, frame=False, linestyle="--", legend_label='Aproximação Grau 3')
    label_approx_3 = text3d("Aproximação Grau 3", r_t_value + vector((1.2, 1.2, 1.2)), color='green', fontsize=12)

    approx_curve_4 = parametric_plot3d((taylor_x_4, taylor_y_4, taylor_z_4), (t, t0-1, t0+1), color='purple', thickness=2, frame=False, linestyle="--", legend_label='Aproximação Grau 4')
    label_approx_4 = text3d("Aproximação Grau 4", r_t_value + vector((1.5, 1.5, 1.5)), color='purple', fontsize=10)

    # Mostrar os gráficos juntos
    show(original_curve + approx_curve_1 + approx_curve_2 + approx_curve_3 + approx_curve_4 +
         eixo_x + eixo_y + eixo_z + origin +
         tangent_vector + normal_vector + binormal_vector +
         label_T + label_N + label_B + label_approx_1 +
         label_approx_2 + label_approx_3 + label_approx_4 + osculating_plane)

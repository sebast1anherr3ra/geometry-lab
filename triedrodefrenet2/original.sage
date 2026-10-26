# Exemplo de código SageMath com deslizador interativo para Rhumb line
# Definir as variáveis
t = var('t')
x, y, z = var('x y z')  # Definir as variáveis x, y, z para a esfera

# Parâmetros da Rhumb line
r_rhumb = 2  # raio da esfera
k = 0.5      # Constante do ângulo (tangente do ângulo de inclinação)
phi = arctan(k * t)  # Latitude (φ)
lambda_ = t          # Longitude (λ)

# Coordenadas paramétricas da Rhumb line
x_rhumb = r_rhumb * cos(phi) * cos(lambda_)
y_rhumb = r_rhumb * cos(phi) * sin(lambda_)
z_rhumb = r_rhumb * sin(phi)

# Definir a curva Rhumb line em R^3
r = vector([x_rhumb, y_rhumb, z_rhumb])

# Calcular o vetor tangente T(t)
T = diff(r, t).normalized()

# Calcular o vetor normal N(t)
N = diff(T, t).normalized()

# Calcular o vetor binormal B(t)
B = T.cross_product(N)

# Calcular a curvatura kappa(t)
kappa = diff(T, t).norm()

# Definir a esfera de raio 2
esfera = implicit_plot3d(x^2 + y^2 + z^2 - 4, (x, -3, 3), (y, -3, 3), (z, -3, 3), 
                         color="lightblue", opacity=0.3)

# Criar o gráfico interativo com o deslizador
@interact
def plot_frenet_triedro(t_value=slider(-10, 10, 0.5, default=0)):
    r_t_value = r.subs(t=t_value)
    T_t_value = T.subs(t=t_value)
    N_t_value = N.subs(t=t_value)
    B_t_value = B.subs(t=t_value)
    
    # Plotar a curva Rhumb line
    curve_plot = parametric_plot3d(r, (t, -20, 20), color='purple', thickness=2, opacity=0.8,
                                   frame=False, axes=False, viewer='threejs', aspect_ratio=[5, 5, 5],plot_points=300)
    
    # Plotar o triedro móvel no ponto correspondente
    origin = point3d(r_t_value, size=10, color='red')
    tangent_vector = arrow3d(r_t_value, r_t_value + T_t_value, color='green')
    normal_vector = arrow3d(r_t_value, r_t_value + N_t_value, color='red')
    binormal_vector = arrow3d(r_t_value, r_t_value + B_t_value, color='blue')
    
    # Desenhar manualmente os eixos com vetores
    eixo_x = arrow3d((0, 0, 0), (1, 0, 0), color='green', thickness=2)
    eixo_y = arrow3d((0, 0, 0), (0, 1, 0), color='red', thickness=2)
    eixo_z = arrow3d((0, 0, 0), (0, 0, 1), color='blue', thickness=2)
    
    # Combinar os gráficos em um único plot (incluindo a esfera)
    plot_total = esfera + curve_plot + origin + tangent_vector + normal_vector + binormal_vector + eixo_x + eixo_y + eixo_z
    
    # Mostrar o gráfico
    show(plot_total, figsize=[8, 8])

# Plotar o gráfico da curvatura kappa(t) com limite no eixo y de 0 a 5
curvature_plot = plot(kappa, (t, -10, 10), color='purple', thickness=2, 
                      title='Curvatura κ(t)', figsize=[6,4], ymin=0, ymax=2)

# Mostrar o gráfico da curvatura
curvature_plot.show()

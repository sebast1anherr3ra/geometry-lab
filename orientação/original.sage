# Definindo as variáveis
var('u v')

# Função para plotar a superfície e os vetores normais, com controle do parâmetro a e do número de vetores
@interact
def plot_surface_with_normals(a=slider(1, 5, 1, default=2,label="Número de torções"),num_vectors=slider(1, 100, 1, default=5, label="Número de vetores")):
    # Definindo a parametrização da superfície com o parâmetro a
    x(u, v) = cos(u)*(2 + v*sin(a*u/2))
    y(u, v) = sin(u)*(2 + v*sin(a*u/2))
    z(u, v) = v*cos(a*u/2)
    
    # Definindo o vetor r como a parametrização (x, y, z)
    r = vector([x, y, z])

    # Derivadas parciais em relação a u e v
    r_u = r.diff(u)
    r_v = r.diff(v)

    # Produto vetorial das derivadas (normal à superfície)
    normal = r_u.cross_product(r_v)

    # Vetor normal unitário
    normal_unit = normal / normal.norm()

    # Criando a superfície parametrizada
    surface = parametric_plot3d((x, y, z), (u, -pi, pi), (v, -1, 1), color="cyan", axes=False, frame=False, opacity=0.8)

    # Plotando a curva v = 0
    curve_v_0 = parametric_plot3d((x(u, 0), y(u, 0), z(u, 0)), (u, -pi, pi), color="blue", thickness=3)

    # Definindo os pontos em u para plotar os vetores normais com base no número selecionado pelo usuário
    u_vals = [u_val for u_val in srange(-pi, pi, (2*pi) / num_vectors)]

    # Plotando os vetores normais sobre a curva v = 0
    normals_plot = sum([arrow3d(r(u_val, 0), r(u_val, 0) + 0.5*normal_unit(u_val, 0), color="red") 
                        for u_val in u_vals])

    # Mostrando o gráfico
    show(surface + curve_v_0 + normals_plot)

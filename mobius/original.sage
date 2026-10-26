# Definição dos parâmetros
var('u v')
u_min, u_max = 0, 4 * pi
v_min, v_max = -1/2, 1/2

# Definição das curvas beta e delta
beta = vector([cos(u), sin(u), 0])
delta = vector([cos(u/2) * cos(u), cos(u/2) * sin(u), sin(u/2)])

# Parametrização da superfície sigma
sigma = beta + v * delta

# Criação dos gráficos das curvas beta e delta
grafico_beta = parametric_plot3d(beta, (u, u_min, u_max), color='red', thickness=2, legend_label=r"$\beta(u)$")
grafico_delta = parametric_plot3d(delta, (u, u_min, u_max), color='orange', thickness=2, legend_label=r"$\delta(u)$")

# Criação do gráfico da superfície sigma
grafico_sigma = parametric_plot3d(sigma, (u, u_min, u_max), (v, v_min, v_max), color=(0.5, 0.7, 1), opacity=0.6, legend_label=r"$\sigma(u, v)$")


# Combinação dos gráficos
grafico_total = grafico_beta + grafico_delta + grafico_sigma
grafico_total.show(aspect_ratio=1, axes=False, frame=False)

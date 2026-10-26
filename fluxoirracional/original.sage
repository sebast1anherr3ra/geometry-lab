# Importa as variáveis simbólicas
var('theta phi')

# Parâmetros do toro
R = 5       # Raio do círculo central
r = 3       # Raio dos círculos menores

# Função de mapa do toro S^1 x S^1 -> R^3
def torus_map(theta, phi):
    x = (R + r * cos(theta)) * cos(phi)
    y = (R + r * cos(theta)) * sin(phi)
    z = r * sin(theta)
    return (x, y, z)

# Função para limitar o valor em [0, 2*pi)
def wrap_angle(angle):
    return angle - floor(angle / (2*pi)) * (2*pi)

# Função para calcular pontos de uma linha de fluxo até t_max para f_*X
def fluxo_traj_X(theta0, phi0, t_max, lambda1, lambda2, num_points=1000):
    traj_points = []
    for t in srange(0, t_max, t_max/num_points):
        theta = wrap_angle(theta0 + lambda1 * t)
        phi = wrap_angle(phi0 + lambda2 * t)
        traj_points.append(torus_map(theta, phi))
    return traj_points

# Função para calcular pontos de uma linha de fluxo até t_max para f_*Y
def fluxo_traj_Y(theta0, phi0, t_max, lambda1, lambda2, num_points=1000):
    traj_points = []
    for t in srange(0, t_max, t_max/num_points):
        theta = wrap_angle(theta0 - lambda2 * t)
        phi = wrap_angle(phi0 + lambda1 * t)
        traj_points.append(torus_map(theta, phi))
    return traj_points

# Função para calcular o vetor tangente no ponto final da curva integral
def vetor_tangente(theta0, phi0, t_max, lambda1, lambda2, tipo):
    if tipo == 'X':
        theta_final = wrap_angle(theta0 + lambda1 * t_max)
        phi_final = wrap_angle(phi0 + lambda2 * t_max)
        dx_dt = lambda1 * diff(torus_map(theta, phi)[0], theta) + lambda2 * diff(torus_map(theta, phi)[0], phi)
        dy_dt = lambda1 * diff(torus_map(theta, phi)[1], theta) + lambda2 * diff(torus_map(theta, phi)[1], phi)
        dz_dt = lambda1 * diff(torus_map(theta, phi)[2], theta) + lambda2 * diff(torus_map(theta, phi)[2], phi)
    else:
        theta_final = wrap_angle(theta0 - lambda2 * t_max)
        phi_final = wrap_angle(phi0 + lambda1 * t_max)
        dx_dt = -lambda2 * diff(torus_map(theta, phi)[0], theta) + lambda1 * diff(torus_map(theta, phi)[0], phi)
        dy_dt = -lambda2 * diff(torus_map(theta, phi)[1], theta) + lambda1 * diff(torus_map(theta, phi)[1], phi)
        dz_dt = -lambda2 * diff(torus_map(theta, phi)[2], theta) + lambda1 * diff(torus_map(theta, phi)[2], phi)
    
    # Avalia o vetor tangente no ponto final (theta_final, phi_final)
    vec_tangent = (dx_dt.subs({theta: theta_final, phi: phi_final}),
                   dy_dt.subs({theta: theta_final, phi: phi_final}),
                   dz_dt.subs({theta: theta_final, phi: phi_final}))
    return torus_map(theta_final, phi_final), vec_tangent

# Interatividade para plotar o toro e as curvas integrais com o vetor tangente
@interact
def plot_torus_curvas(t_max=slider(0, 100, step_size=0.1, default=5, label="Comprimento da curva integral (t_max)"),
                      lambda1=selector([1, 2, 3, 4, 5, 6, 7, 8, 9, sqrt(2), pi, e], label="lambda1"),
                      lambda2=selector([1, 2, 3, 4, 5, 6, 7, 8, 9, sqrt(2), pi, e], label="lambda2"),
                      fluxo=selector(['Nenhum', 'Curva integral de f_*X (vermelho)', 'Curva integral de f_*Y (azul)', 'Ambos'],
                                     label="Exibir curvas integrais")):
    
    # Plot da superfície do toro
    torus_plot = parametric_plot3d(torus_map(theta, phi), (theta, 0, 2*pi), (phi, 0, 2*pi), color="lightgray", opacity=0.7)

    # Condição inicial para as linhas de fluxo
    theta0, phi0 = pi/4, pi/4
    fluxo_points_X = fluxo_traj_X(theta0, phi0, t_max, lambda1, lambda2)
    fluxo_points_Y = fluxo_traj_Y(theta0, phi0, t_max, lambda1, lambda2)

    # Adiciona o ponto azul no início da curva integral
    ponto_inicial_X = torus_map(theta0, phi0)
    ponto_inicial_Y = torus_map(theta0, phi0)

    ponto_inicial_plot_X = point3d(ponto_inicial_X, color="blue", size=50) if fluxo in ['Curva integral de f_*X (vermelho)', 'Ambos'] else Graphics()
    ponto_inicial_plot_Y = point3d(ponto_inicial_Y, color="blue", size=50) if fluxo in ['Curva integral de f_*Y (azul)', 'Ambos'] else Graphics()

    # Plota a linha de fluxo para f_*X em vermelho
    fluxo_plot_X = line3d(fluxo_points_X, color="red", thickness=2.5) if fluxo in ['Curva integral de f_*X (vermelho)', 'Ambos'] else Graphics()

    # Plota a linha de fluxo para f_*Y em azul
    fluxo_plot_Y = line3d(fluxo_points_Y, color="blue", thickness=2.5) if fluxo in ['Curva integral de f_*Y (azul)', 'Ambos'] else Graphics()

    # Calcula e plota o vetor tangente no ponto final da curva f_*X
    vetor_tangente_X_plot = Graphics()
    if fluxo in ['Curva integral de f_*X (vermelho)', 'Ambos']:
        ponto_final_X, vetor_X = vetor_tangente(theta0, phi0, t_max, lambda1, lambda2, 'X')
        vetor_tangente_X_plot = arrow3d(ponto_final_X, (ponto_final_X[0] + 0.2 * vetor_X[0], 
                                                        ponto_final_X[1] + 0.2 * vetor_X[1], 
                                                        ponto_final_X[2] + 0.2 * vetor_X[2]),
                                        color="blue", radius=0.05)

    # Calcula e plota o vetor tangente no ponto final da curva f_*Y
    vetor_tangente_Y_plot = Graphics()
    if fluxo in ['Curva integral de f_*Y (azul)', 'Ambos']:
        ponto_final_Y, vetor_Y = vetor_tangente(theta0, phi0, t_max, lambda1, lambda2, 'Y')
        vetor_tangente_Y_plot = arrow3d(ponto_final_Y, (ponto_final_Y[0] + 0.2 * vetor_Y[0], 
                                                        ponto_final_Y[1] + 0.2 * vetor_Y[1], 
                                                        ponto_final_Y[2] + 0.2 * vetor_Y[2]),
                                        color="blue", radius=0.05)

    # Exibir o plot final com o toro, as linhas de fluxo, os vetores tangentes no ponto final e os pontos iniciais
    show(torus_plot + fluxo_plot_X + fluxo_plot_Y + vetor_tangente_X_plot + vetor_tangente_Y_plot + ponto_inicial_plot_X + ponto_inicial_plot_Y, 
         frame=False, axes=True, figsize=8)

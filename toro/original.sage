# toro pinçado com plot dos campos sobre ele. sem o deslizador de deformação
# SageMath Cell

# Variáveis
var('theta phi')

# Parâmetros base
R, r = 2, 1

# Função do toro pinçado (dependendo de k)
def pinched_torus_map(theta, phi, k):
    g = R + sin(k*theta/2)*cos(phi)
    x = g*cos(theta)
    y = g*sin(theta)
    z = sin(k*theta/2)*sin(phi)
    return (x, y, z)

# Função para limitar ângulos em [0, 2*pi)
def wrap_angle(angle):
    return angle - floor(angle / (2*pi)) * (2*pi)

# Curvas integrais de f_*X
def fluxo_traj_X(theta0, phi0, t_max, lambda1, lambda2, k, num_points=1000):
    traj_points = []
    for t in srange(0, t_max, t_max/num_points):
        theta_t = wrap_angle(theta0 + lambda1 * t)
        phi_t = wrap_angle(phi0 + lambda2 * t)
        traj_points.append(pinched_torus_map(theta_t, phi_t, k))
    return traj_points

# Curvas integrais de f_*Y
def fluxo_traj_Y(theta0, phi0, t_max, lambda1, lambda2, k, num_points=1000):
    traj_points = []
    for t in srange(0, t_max, t_max/num_points):
        theta_t = wrap_angle(theta0 - lambda2 * t)
        phi_t = wrap_angle(phi0 + lambda1 * t)
        traj_points.append(pinched_torus_map(theta_t, phi_t, k))
    return traj_points

# Vetor tangente no ponto final
def vetor_tangente(theta0, phi0, t_max, lambda1, lambda2, tipo, k, dx_dtheta, dy_dtheta, dz_dtheta, dx_dphi, dy_dphi, dz_dphi):
    if tipo == 'X':
        theta_f = wrap_angle(theta0 + lambda1 * t_max)
        phi_f = wrap_angle(phi0 + lambda2 * t_max)
        dx_dt = lambda1*dx_dtheta + lambda2*dx_dphi
        dy_dt = lambda1*dy_dtheta + lambda2*dy_dphi
        dz_dt = lambda1*dz_dtheta + lambda2*dz_dphi
    else:
        theta_f = wrap_angle(theta0 - lambda2 * t_max)
        phi_f = wrap_angle(phi0 + lambda1 * t_max)
        dx_dt = -lambda2*dx_dtheta + lambda1*dx_dphi
        dy_dt = -lambda2*dy_dtheta + lambda1*dy_dphi
        dz_dt = -lambda2*dz_dtheta + lambda1*dz_dphi

    vec_tangent = (dx_dt.subs({theta: theta_f, phi: phi_f}),
                   dy_dt.subs({theta: theta_f, phi: phi_f}),
                   dz_dt.subs({theta: theta_f, phi: phi_f}))
    return pinched_torus_map(theta_f, phi_f, k), vec_tangent

# Interatividade
@interact
def plot_pinched_torus(k=slider(1, 10, 1, default=4, label="Número de pinçamentos"),
                       a=slider(4, 40, 2, default=14, label="Densidade do campo vetorial"),
                       t_max=slider(0, 50, step_size=0.5, default=10, label="Comprimento da curva integral (t_max)"),
                       lambda1=selector([1, 2, 3, sqrt(2), pi, e], label="lambda1"),
                       lambda2=selector([1, 2, 3, sqrt(2), pi, e], label="lambda2"),
                       campo=selector(['Nenhum', 'Campo f_*X (vermelho)', 'Campo f_*Y (azul)', 'Ambos'],
                                      label="Exibir campo vetorial"),
                       fluxo=selector(['Nenhum', 'Curva integral de f_*X (vermelho)', 
                                       'Curva integral de f_*Y (azul)', 'Ambos'],
                                      label="Exibir curvas integrais")):
    
    # Recalcular derivadas com k atual
    x, y, z = pinched_torus_map(theta, phi, k)
    dx_dtheta = diff(x, theta); dy_dtheta = diff(y, theta); dz_dtheta = diff(z, theta)
    dx_dphi   = diff(x, phi);   dy_dphi   = diff(y, phi);   dz_dphi   = diff(z, phi)

    # Plot do toro pinçado
    torus_plot = parametric_plot3d((x, y, z), 
                                   (theta, 0, 2*pi), (phi, 0, 2*pi),
                                   color="orange", opacity=0.7, mesh=False, plot_points=[80,80])

    # Campo vetorial f_*X
    vector_field_x_plot = Graphics()
    if campo in ['Campo f_*X (vermelho)', 'Ambos']:
        for th in srange(0, 2*pi, pi/a):
            for ph in srange(0, 2*pi, pi/a):
                pos = pinched_torus_map(th, ph, k)
                vec_x = ((lambda1*dx_dtheta + lambda2*dx_dphi).subs({theta:th,phi:ph}),
                         (lambda1*dy_dtheta + lambda2*dy_dphi).subs({theta:th,phi:ph}),
                         (lambda1*dz_dtheta + lambda2*dz_dphi).subs({theta:th,phi:ph}))
                vector_field_x_plot += arrow3d(pos, (pos[0]+0.2*vec_x[0],
                                                     pos[1]+0.2*vec_x[1],
                                                     pos[2]+0.2*vec_x[2]),
                                               color="red", radius=0.04)

    # Campo vetorial f_*Y
    vector_field_y_plot = Graphics()
    if campo in ['Campo f_*Y (azul)', 'Ambos']:
        for th in srange(0, 2*pi, pi/a):
            for ph in srange(0, 2*pi, pi/a):
                pos = pinched_torus_map(th, ph, k)
                vec_y = ((-lambda2*dx_dtheta + lambda1*dx_dphi).subs({theta:th,phi:ph}),
                         (-lambda2*dy_dtheta + lambda1*dy_dphi).subs({theta:th,phi:ph}),
                         (-lambda2*dz_dtheta + lambda1*dz_dphi).subs({theta:th,phi:ph}))
                vector_field_y_plot += arrow3d(pos, (pos[0]+0.2*vec_y[0],
                                                     pos[1]+0.2*vec_y[1],
                                                     pos[2]+0.2*vec_y[2]),
                                               color="blue", radius=0.04)

    # Condição inicial
    theta0, phi0 = pi/4, pi/4
    fluxo_points_X = fluxo_traj_X(theta0, phi0, t_max, lambda1, lambda2, k)
    fluxo_points_Y = fluxo_traj_Y(theta0, phi0, t_max, lambda1, lambda2, k)

    # Curvas de fluxo
    fluxo_plot_X = line3d(fluxo_points_X, color="red", thickness=2.5) if fluxo in ['Curva integral de f_*X (vermelho)', 'Ambos'] else Graphics()
    fluxo_plot_Y = line3d(fluxo_points_Y, color="blue", thickness=2.5) if fluxo in ['Curva integral de f_*Y (azul)', 'Ambos'] else Graphics()

    # Vetores tangentes
    vetor_tangente_X_plot = Graphics()
    if fluxo in ['Curva integral de f_*X (vermelho)', 'Ambos']:
        ponto_final_X, vetor_X = vetor_tangente(theta0, phi0, t_max, lambda1, lambda2, 'X', k,
                                                dx_dtheta, dy_dtheta, dz_dtheta, dx_dphi, dy_dphi, dz_dphi)
        vetor_tangente_X_plot = arrow3d(ponto_final_X, (ponto_final_X[0] + 0.3*vetor_X[0],
                                                        ponto_final_X[1] + 0.3*vetor_X[1],
                                                        ponto_final_X[2] + 0.3*vetor_X[2]),
                                        color="red", radius=0.06)

    vetor_tangente_Y_plot = Graphics()
    if fluxo in ['Curva integral de f_*Y (azul)', 'Ambos']:
        ponto_final_Y, vetor_Y = vetor_tangente(theta0, phi0, t_max, lambda1, lambda2, 'Y', k,
                                                dx_dtheta, dy_dtheta, dz_dtheta, dx_dphi, dy_dphi, dz_dphi)
        vetor_tangente_Y_plot = arrow3d(ponto_final_Y, (ponto_final_Y[0] + 0.3*vetor_Y[0],
                                                        ponto_final_Y[1] + 0.3*vetor_Y[1],
                                                        ponto_final_Y[2] + 0.3*vetor_Y[2]),
                                        color="blue", radius=0.06)

    # Mostrar tudo
    show(torus_plot + vector_field_x_plot + vector_field_y_plot + 
         fluxo_plot_X + fluxo_plot_Y + vetor_tangente_X_plot + vetor_tangente_Y_plot,
         frame=False, axes=True, figsize=8)

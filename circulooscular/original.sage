# Definir a variável 't'
var('t')

# Parâmetro para a catenária
a = 1

# Definir o raio do círculo fixo e do círculo móvel para hipocicloides
r = 1

# Definir as curvas
curvas = {
    "Catenária": vector([t, a * cosh(t / a)]),  # Catenária: (t, a * cosh(t/a))
    "Parábola": vector([t, t^2]),  # Parábola: (t, t^2)
    "Hipocicloide de 3 cúspides": vector([(3 - r) * cos(t) + r * cos((3 - r) * t / r),
                                          (3 - r) * sin(t) - r * sin((3 - r) * t / r)]),
    "Hipocicloide de 4 cúspides": vector([(4 - r) * cos(t) + r * cos((4 - r) * t / r),
                                          (4 - r) * sin(t) - r * sin((4 - r) * t / r)]),
    "Hipocicloide de 5 cúspides": vector([(5 - r) * cos(t) + r * cos((5 - r) * t / r),
                                          (5 - r) * sin(t) - r * sin((5 - r) * t / r)])
}

# Função para gerar a animação
@interact
def animacao(curva_nome=selector(list(curvas.keys()), label="Selecione a curva")):
    # Selecionar a curva
    curva = curvas[curva_nome]

    # Lista de quadros da animação
    frames = []

    # Valores do parâmetro t0 que serão animados
    t0_vals = srange(-3.2, 3.2, 0.1)

    # Criar cada quadro da animação
    for t0 in t0_vals:
        # Calcular a derivada da curva
        r_t = curva.diff(t)
        r_tt = r_t.diff(t)

        # Calcular a curvatura para curvas no plano
        curvatura = abs(r_t[0]*r_tt[1] - r_t[1]*r_tt[0]) / norm(r_t)^3
        raio_osculador = 1 / curvatura

        # Ponto específico onde vamos calcular (usando o valor atual de t0)
        P = curva.substitute(t=t0)  # Ponto na curva
        T = r_t.substitute(t=t0).normalized()  # Vetor tangente unitário
        N = vector([-T[1], T[0]])  # Vetor normal unitário (perpendicular ao tangente)

        # Centro do círculo osculador
        centro_osculador = P + raio_osculador.substitute(t=t0) * N

        # Plot da curva
        plot_curva = parametric_plot((curva[0], curva[1]), (t, -3.2, 3.2), color='blue',axes=False)

        # Plot do círculo osculador
        circulo_osculador = circle((centro_osculador[0], centro_osculador[1]), raio_osculador.substitute(t=t0), color='red')

        # Plot do ponto de contato
        ponto_contato = point((P[0], P[1]), color='green', size=30)

        # Texto exibindo a curvatura e o raio do círculo osculador
        curvatura_texto = text(f'Curvatura: {float(curvatura.substitute(t=t0)):.4f}', (P[0] + 1, P[1] + 1), color='black', fontsize=10)
        raio_texto = text(f'Raio: {float(raio_osculador.substitute(t=t0)):.4f}', (P[0] + 1, P[1] + 0.5), color='black', fontsize=10)

        # Combinar os plots e adicionar à lista de quadros
        frame = plot_curva + circulo_osculador + ponto_contato + curvatura_texto + raio_texto
        frames.append(frame)

    # Criar a animação
    anim = animate(frames, figsize=[6, 6])

    # Definir a função de curvatura
    curvatura_func = abs(r_t[0]*r_tt[1] - r_t[1]*r_tt[0]) / norm(r_t)^3

    # Gerar o gráfico da função de curvatura
    grafico_curvatura = plot(curvatura_func, (t, -3.2, 3.2), color='red', legend_label='Curvatura',axes=False)

    # Mostrar a animação
    show(anim)
    
    # Mostrar o gráfico da curvatura como função
    grafico_curvatura.show()

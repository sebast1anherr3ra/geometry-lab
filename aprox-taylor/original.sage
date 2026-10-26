# Importando a biblioteca necessária
from sage.all import *

# Definindo as variáveis
var('x y')

# Lista de funções
functions = {
    'f1: sqrt(x^2 + y^2 + 1)': sqrt(x^2 + y^2 + 1),
    'f2: log(cos(x)) - log(cos(y))': log(cos(x)) - log(cos(y)),
    'f3: (x^2 + y^2)*exp(1-x^2-y^2)': (x^2 + y^2)*exp(1-x^2-y^2)
}

# Deslizadores para as coordenadas do ponto de aproximação e para selecionar a função
@interact
def plot_surface(função=list(functions.keys()), x0=slider(-2, 2, 0.1, default=1, label='x0'), 
                 y0=slider(-2, 2, 0.1, default=1, label='y0')):
    
    # Selecionando a função
    f = functions[função]
    
    # Calculando o valor de f e suas derivadas em (x0, y0)
    f_x = diff(f, x)
    f_y = diff(f, y)
    f_xx = diff(f_x, x)
    f_xy = diff(f_x, y)
    f_yy = diff(f_y, y)
    
    # Derivadas de terceira ordem
    f_xxx = diff(f_xx, x)
    f_xxy = diff(f_xx, y)
    f_xyy = diff(f_xy, y)
    f_yyy = diff(f_yy, y)
    
    # Avaliando cada derivada em (x0, y0)
    f_value = f(x=x0, y=y0)
    f_x_value = f_x(x=x0, y=y0)
    f_y_value = f_y(x=x0, y=y0)
    f_xx_value = f_xx(x=x0, y=y0)
    f_xy_value = f_xy(x=x0, y=y0)
    f_yy_value = f_yy(x=x0, y=y0)
    f_xxx_value = f_xxx(x=x0, y=y0)
    f_xxy_value = f_xxy(x=x0, y=y0)
    f_xyy_value = f_xyy(x=x0, y=y0)
    f_yyy_value = f_yyy(x=x0, y=y0)
    
    # Construindo a aproximação linear (plano tangente)
    L = f_value + f_x_value * (x - x0) + f_y_value * (y - y0)

    # Construindo a aproximação quadrática
    Q = (f_value 
         + f_x_value * (x - x0) 
         + f_y_value * (y - y0) 
         + 0.5 * f_xx_value * (x - x0)^2 
         + f_xy_value * (x - x0) * (y - y0) 
         + 0.5 * f_yy_value * (y - y0)^2)

    # Construindo a aproximação cúbica
    C = (f_value 
         + f_x_value * (x - x0) 
         + f_y_value * (y - y0) 
         + 0.5 * f_xx_value * (x - x0)^2 
         + f_xy_value * (x - x0) * (y - y0) 
         + 0.5 * f_yy_value * (y - y0)^2
         + (1/6) * f_xxx_value * (x - x0)^3 
         + 0.5 * f_xxy_value * (x - x0)^2 * (y - y0) 
         + 0.5 * f_xyy_value * (x - x0) * (y - y0)^2 
         + (1/6) * f_yyy_value * (y - y0)^3)
    
    # Definindo os domínios para os gráficos
    x_range_function = (-5, 5)
    y_range_function = (-5, 5)
    x_range_tangent = (x0 - 0.5, x0 + 0.5)
    y_range_tangent = (y0 - 0.5, y0 + 0.5)
    x_range_quadratic = (x0 - 1, x0 + 1)
    y_range_quadratic = (y0 - 1, y0 + 1)
    x_range_cubic = (x0 - 1, x0 + 1)
    y_range_cubic = (y0 - 1, y0 + 1)

    # Gráficos da função original
    plot_f = plot3d(f, x_range_function, y_range_function, opacity=0.5, color="lightblue")
    
    # Gráfico do plano tangente
    plot_L = plot3d(L, x_range_tangent, y_range_tangent, opacity=0.5, color="yellow", mesh=True)

    # Gráfico da aproximação quadrática
    plot_Q = plot3d(Q, x_range_quadratic, y_range_quadratic, opacity=0.5, color="red", mesh=True)

    # Gráfico da aproximação cúbica
    plot_C = plot3d(C, x_range_cubic, y_range_cubic, opacity=0.5, color="purple", mesh=True)
    
    # Adicionando o ponto de aproximação
    point = point3d((x0, y0, f_value), color="green", size=20)
    
    # Exibindo todos os gráficos juntos
    (plot_f + plot_L + plot_Q + plot_C + point).show(axes=False,frame=False)

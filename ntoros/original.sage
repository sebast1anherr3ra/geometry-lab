@interact
def bitoro_grosso(
    h=slider(1, 4, 1, default=3, label="Número de buracos (gênero h)"),
    b=slider(0.3, 1, 0.1, default=0.4, label="Distância entre os buracos (parâmetro b)"),
    k=slider(0.4, 10, 0.1, default=8.0, label="Espessura da superfície (expoente k)"),
    zoom=slider(2, 25, 1, default=12, label="Zoom (alcance da moldura)")
):
    var('x y z')
    a = (2*h + 1)*b
    xh = x/h

    F0 = a^2 - (xh - a)^2 - y^2

    Fprod = 1
    for i in range(1, h+1):
        xi = (4*i - 1)*b
        Fprod *= ((xh - xi)^2 + y^2 - b^2)

    # Equação com controle de espessura
    F = (z^2)^k - F0 * Fprod

    # Intervalos controlados pelo zoom
    x_range = (x, 0, 2*a + zoom)
    y_range = (y, -zoom, zoom)
    z_range = (z, -zoom, zoom)

    # Plot
    show(implicit_plot3d(F == 0, x_range, y_range, z_range,
                         opacity=0.8, color='darkgreen',
                         mesh=False, plot_points=100,
                         frame=False))
      <script>
        (function() {
          // The root element's background fills the whole page. As in CSS,
          // the body's background is used when the root element has none.
          function getPageBackgroundColor() {
            var docStyle = window.getComputedStyle(document.documentElement);
            var color = docStyle.backgroundColor;
            if ((color === 'rgba(0, 0, 0, 0)' || color === 'transparent') &&
                docStyle.backgroundImage === 'none' && document.body) {
              color = window.getComputedStyle(document.body).backgroundColor;
            }
            return color || '';
          }

          var lastReportedColor = '';
          function reportBackgroundColor() {
            try {
              var color = getPageBackgroundColor();
              if (color === lastReportedColor) return;
              lastReportedColor = color;
              window.parent.postMessage({
                type: 'ATARI_CODE_EMBED_BACKGROUND_COLOR',
                backgroundColor: color
              }, '*');
            } catch (e) {}
          }

          // The page background usually changes through an attribute on html
          // or body (for example a theme class), a style sheet in head, or the
          // system color scheme.
          if (typeof MutationObserver !== 'undefined') {
            var observer = new MutationObserver(reportBackgroundColor);
            observer.observe(document.documentElement, {attributes: true});
            if (document.body) {
              observer.observe(document.body, {attributes: true});
            }
            if (document.head) {
              observer.observe(document.head, {
                attributes: true,
                childList: true,
                subtree: true,
                characterData: true
              });
            }
          }
          var colorSchemeQuery =
              window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)');
          if (colorSchemeQuery && colorSchemeQuery.addEventListener) {
            colorSchemeQuery.addEventListener('change', reportBackgroundColor);
          }
          window.addEventListener('load', reportBackgroundColor);
          window.addEventListener('transitionend', reportBackgroundColor);
          window.addEventListener('animationend', reportBackgroundColor);
          reportBackgroundColor();
        })();

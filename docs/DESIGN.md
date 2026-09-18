# Diseño

**Propuesta, no decisión.** La cierran Mayte y Juan; hasta entonces esto es el punto de partida para no
empezar cada pantalla de cero. Escrito el 18 de septiembre de 2026.

El plan ([`PLAN.md`](PLAN.md)) pone el presupuesto de diseño donde toca: **el fichero del tema, una
vez, esta semana**. El jurado no puntúa la presentación — "rough is fine, careless is not" — y lo que
sí puntúa es que el ciclo funcione. Nada de rediseñar pantallas en la semana 3.

## El principio

**La moneda es la protagonista y no hay nada más gritando en pantalla.** Cada pantalla tiene una sola
cosa fuerte: la cantidad. Todo lo demás, callado.

Sale del producto: esto no es una lista de tareas, es un mercado doméstico donde se pone precio, se
negocia, se cobra y se multa. La personalidad viene de las apuestas y del recuento, no de la
decoración. Y como el modo familia queda fuera del MVP y el vídeo se graba con el perfil de pareja, lo
que se ve son dos adultos negociando, no un cuadro de tareas infantil.

## Paleta

| Token | Hex | RGB | Dónde |
|---|---|---|---|
| `tinta` | `#1A1636` | 26, 22, 54 | Texto y barra superior. Índigo muy oscuro, con fondo azul violáceo |
| `jabón` | `#E8F0E9` | 232, 240, 233 | Fondo. Blanco roto con un verde muy lavado: la casa limpia es el tema |
| `papel` | `#FFFFFF` | 255, 255, 255 | Tarjetas y hojas |
| `moneda` | `#F5B21A` | 245, 178, 26 | **Solo** cantidades y cartera |
| `multa` | `#C73E1D` | 199, 62, 29 | Multas y saldo en negativo |

**La regla del ámbar:** `moneda` no toca ningún botón, icono ni borde que no sea una cantidad. En
cuanto se usa para otra cosa deja de significar "monedas" y la pantalla pierde su único punto de
atención.

El fondo y el texto no compiten a propósito: un verde casi blanco contra un índigo casi negro. El
único color saturado de la interfaz es el del dinero.

## Tipografía

**Sin decidir.** Archivo, que es lo que hay ahora, es una grotesca neutra que no dice nada. Tres
opciones, todas en Google Fonts, que ya está en el `pubspec`:

| Opción | Cantidades | Interfaz | Por qué |
|---|---|---|---|
| **1. Mercado** (recomendada) | Fraunces | Hanken Grotesk | Una serif suave y variable, con ejes de *wonk* y *soft*. Un precio en serif se lee como el cartel de un puesto de mercado, que es justo lo que es la app |
| **2. Una sola familia** | Bricolage Grotesque | Bricolage Grotesque | Grotesca con irregularidades deliberadas, de fino a muy negro. Juguetona por sus detalles raros, no por ser redondita. La más barata de mantener |
| **3. La arriesgada** | Syne ExtraBold | Gabarito | Gabarito cálida y geométrica abajo; Syne da a los números una forma que no se olvida. La que más divide |

Descartadas de entrada: **Nunito, Quicksand, Baloo**. Son lo que sale al buscar "playful" y llevan
directas al cuadro de tareas infantil.

Dos reglas que valen para cualquiera de las tres:

- **Cifras tabulares** (`FontFeature.tabularFigures()`). Sin eso, el historial de movimientos no
  alinea en columna.
- **Empaquetar el `.ttf` en `assets/fonts`** en vez de dejar que `google_fonts` lo descargue en
  tiempo de ejecución. Si no, la primera carga enseña un instante la fuente del sistema — y eso pasa
  en el vídeo y en la primera visita del jurado.

## Movimiento

Solo dos momentos, y son los dos golpes del vídeo:

1. El voto del otro que **llega por el stream**, sin recargar.
2. Las **monedas entrando** en la cartera al validarse la tarea.

Nada de animaciones de entrada en cada tarjeta ni transiciones al pasar por encima de todo. Eso es lo
que hace que una interfaz parezca generada.

## Lo que evitamos

Mascota, confeti, degradados de adorno, y el kit de tarjetas redondeadas todas iguales con la misma
sombra gris debajo de cada bloque.

## Pendiente

- Elegir entre las tres opciones de tipografía.
- `main.dart` tiene `themeMode` clavado en `ThemeMode.light` aunque define un `darkTheme`. Elegir uno
  y cuidarlo; el otro, o se hace bien o se quita.
- Mayte revisa la paleta y los mockups (#34 y sus sub-issues).

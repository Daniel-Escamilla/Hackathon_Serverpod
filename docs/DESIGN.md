# Estándar de diseño

**Playful UI.** Es el estándar vigente desde el 21 de septiembre de 2026. Lo lleva Mayte, y este
documento recoge cómo está hecho en el código para que cualquier pantalla nueva —la haga quien la
haga, persona o agente— salga igual que las demás.

La app es un juego de monedas entre gente que vive junta, y el "playful" sale de ahí: del **tacto**
(los botones rebotan), del **sonido** (pops, un "bling" al cobrar) y de la **forma** (redondeada,
colores planos). No sale de mascotas, confeti ni degradados.

El jurado no puntúa la presentación, pero sí el acabado. El estándar existe para que el acabado
salga gratis: está dentro de los componentes, así que no hay que acordarse de él en cada pantalla.

---

## Reglas para una pantalla nueva

1. **Botones: siempre `AppButton`.** Nunca un `FilledButton`, `OutlinedButton` o `TextButton` en una
   pantalla. El rebote, la vibración y el sonido van dentro.
2. **Algo que se toca y no es un botón** (una tarjeta de tarea, una recompensa): envuélvelo en
   `Pressable`.
3. **Cantidades de monedas: siempre `CoinAmount`**, para que se lean igual en todas partes.
4. **Avisos: `showMessage`.** Lo que no se puede deshacer pasa antes por `confirmAction`, y su botón
   dice lo que hace ("Expulsar", no "Sí").
5. **Ningún texto escrito a mano**: todo va al ARB (`lib/l10n/app_es.arb`).
6. **Colores y tipos, del tema** (`lib/app_theme.dart`), nunca un `Color(0x…)` suelto en una pantalla.

## Componentes (`lib/ui/`)

| Componente | Para qué |
|---|---|
| `AppButton` | Todos los botones. Tipos abajo |
| `Pressable` | Cualquier cosa tocable que no sea un botón: mismo rebote, vibración y sonido |
| `CoinAmount` | Una cantidad de monedas con su icono y cifras tabulares |
| `showMessage` | Aviso abajo. Si es error, suena el "bonk" solo |
| `confirmAction` | Pregunta antes de algo destructivo |

### Los cuatro tipos de `AppButton`

| Tipo | Aspecto | Cuándo | Suena |
|---|---|---|---|
| `primary` | Relleno violeta | Lo que la pantalla existe para hacer. **Uno por pantalla** como mucho | pop |
| `secondary` | Contorno violeta | Una alternativa real al principal | pop |
| `quiet` | Solo texto | Lo de poco peso: "Cancelar", "Copiar", "Volver a intentarlo" | nada |
| `danger` | Texto coral | Lo que destruye algo. Siempre detrás de `confirmAction` | nada |

Dos variantes que se combinan con cualquiera:

- **`onBrand`**: el botón está sobre una superficie violeta y se vuelve blanco para verse.
- **`compact`**: del ancho de su texto, para ir en fila con otros. Sin ella, el botón ocupa todo el
  ancho, que es lo que marca el tema.

Y `loading: true` cambia el texto por una ruedita y lo bloquea mientras hay una petición en marcha.

## Tokens (`lib/app_theme.dart`)

| Token | Hex | Uso |
|---|---|---|
| `appInk` | `#12152A` | Texto |
| `appViolet` | `#6558F5` | Marca: botón principal, tarjetas destacadas |
| `appCream` | `#F7F4EC` | Fondo |
| `appLime` | `#DDFB69` | Acento alegre: insignia de admin, lo positivo |
| `appSky` | `#A8D7FF` | Acento suave: la insignia de "tú" |
| `appCoral` | `#FF776D` | Error, multa, acción destructiva |
| `appMuted` | `#687086` | Texto secundario |

**Tipografía**: Fredoka para los títulos (redondeada, es la que pone el tono) y Nunito Sans para
todo lo demás. **Esquinas**: 20 en controles, 30 en tarjetas.

## Movimiento

**El rebote al pulsar.** El control se hunde al 94 % en 80 ms y vuelve con un pequeño sobrepaso
(`easeOutBack`, 280 ms). Bajar rápido y subir con rebote es lo que se lee como juego y no como
parpadeo. Lo aplica `PressScale`, que usan `AppButton` y `Pressable`.

**Quien tenga las animaciones reducidas en su sistema no ve el rebote.** No hay que hacer nada: lo
comprueba el propio componente.

## Sonido

Cinco sonidos, y **cada uno significa siempre lo mismo**. Un sonido que se usa para dos cosas deja de
significar ninguna.

| Sonido | Suena como | Cuándo |
|---|---|---|
| `tap` | Un pop | Pulsar un botón `primary` o `secondary` (automático) |
| `success` | Arpegio que sube | Algo que hizo el usuario ha salido: grupo creado, voto enviado, tarea propuesta |
| `coin` | "Bling" de moneda | **Entran monedas.** El momento estrella del vídeo |
| `fine` | "Womp" que baja | Salen monedas por una multa |
| `error` | "Bonk" suave | Algo ha fallado (automático con `showMessage(isError: true)`) |

Para hacer sonar uno a mano: `uiSounds.play(AppSound.success)`.

- **Menos es más.** Las acciones `quiet` y `danger` no suenan, y copiar o cancelar tampoco. Si todo
  suena, nada destaca.
- **Son nuestros.** Los genera `tool/generate_ui_sounds.dart` a partir de ondas simples. No hay nada
  que licenciar, y el reglamento pide que el vídeo no lleve música de terceros. Para cambiar uno, se
  toca su receta en ese fichero y se vuelve a ejecutar: `dart run tool/generate_ui_sounds.dart`.
- **Nunca rompen nada.** Si el audio no carga, la app se queda en silencio y sigue funcionando.
- **Hay un interruptor general** (`UiSounds.muted`). Todavía no tiene botón en ajustes.

## Vibración

Una vibración ligera (`lightImpact`) al pulsar un botón principal y un toque más fino
(`selectionClick`) en el resto. En la web no hace nada, y no hace falta tratarlo.

## Pendiente

- **`coin` y `fine` todavía no suenan en ningún sitio**: se enganchan cuando se cobra una tarea (#61)
  y cuando llegan las multas (#63). Ahí es donde el sonido más se nota en el vídeo.
- El botón de silenciar en ajustes.

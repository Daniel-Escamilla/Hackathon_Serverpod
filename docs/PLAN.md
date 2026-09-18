# Plan de implementación

Qué se hace, quién lo hace y cuándo. [`PRODUCT.md`](PRODUCT.md) manda sobre **qué** es la app y sus
reglas; este documento manda sobre el **calendario y el reparto**. Escrito el **18 de septiembre de
2026** con las decisiones que se listan en [§8](#8-decisiones-tomadas-el-18-de-septiembre).

Quedan **26 días**. La entrega cierra el **14 de octubre a las 23:59** y las reglas dicen "sin
prórrogas".

---

## 1. El MVP

El MVP es **lo que sale en el vídeo** ([§2](#2-el-guion-del-vídeo)). Todo lo que no aparezca ahí no es
MVP. El jurado penaliza lo que está a medias mucho más de lo que premia lo que sobra, y "que funcione"
pesa un 30 %.

### Entra

| Bloque | Qué incluye |
|---|---|
| Entrada | Registro e inicio de sesión con email (ya está montado) |
| Grupo | Crear grupo **piso o pareja**, unirse con código, ver miembros y el código |
| Ciclo | Proponer → votar → contraoferta → hacer y reclamar → validar → cobrar |
| Multas | Propuesta denegada, validación denegada y votación expirada |
| Plazos | Cierre automático de votaciones con `FutureCall`, **con la ventana configurable** |
| Cartera | Saldo e historial de movimientos, calculados en el servidor |
| Tienda | Plantilla del perfil, proponer y votar recompensas, comprar eligiendo quién la cumple, aceptar, negarse (multa y devolución) y marcar entregada |
| Tiempo real | Un stream por grupo: los votos y los avisos se ven sin recargar |
| Plataformas | Web servida por Serverpod en Cloud (es por donde entra el jurado) y APK de Android |

### No entra

**Todo el modo familia** — tutores, hijos, control parental y la entrada de los hijos con código.
Motivo: la entrada de los hijos sin email sigue sin resolverse, el vídeo se graba con el perfil de
pareja y con las horas que hay no cabe. `Group.type` deja hueco para `family`, pero al crear un grupo
solo se ofrecen piso y pareja.

Tampoco entran, por este orden si sobrara tiempo: **misiones periódicas**, **ranking semanal**,
**expulsar, ceder el cargo y salir del grupo**, **unidades de stock**, **catálogo de tareas típicas**.

Fuera del todo: ruleta, registro con Google, invitación por QR, notificaciones push, **iOS** y dibujar
la casa. iOS se descarta a propósito: la revisión de TestFlight no cabe en el calendario.

### Terminado quiere decir

1. Funciona en la **web desplegada en Cloud**, con dos cuentas de verdad.
2. **Ningún dato falso en pantalla**: fuera el `_members` fijo de `group_screen.dart`, el `_items` en
   memoria de `todo_list_screen.dart` y el `_coins = 0` de `main.dart`.
3. **Decide el servidor**: mayorías, saldos y plazos se calculan en Serverpod, no en Flutter.
4. El ciclo entero se puede **grabar de una sentada**, sin cortes ni trampas.

## 2. El guion del vídeo

Menos de 2 minutos, público, perfil de **pareja**, dos sesiones abiertas a la vez. Es la referencia de
qué tiene que funcionar: si algo no se puede grabar, no está terminado.

| Tiempo | Qué se ve |
|---|---|
| 0:00–0:15 | El problema en una frase. Dos cuentas, A y B, con el grupo ya montado |
| 0:15–0:40 | A propone "Limpiar el baño, 25 monedas". A B le salta el aviso **en vivo**. B contraoferta 20. A acepta y **la votación empieza de cero**. B aprueba → la tarea queda disponible |
| 0:40–1:10 | B limpia el baño y pulsa "hecha". A recibe la validación y aprueba. **Las 20 monedas entran en la cartera de B**, con su movimiento en el historial |
| 1:10–1:35 | B abre la tienda y compra "Elijo yo la serie esta noche" por 20, **eligiendo a A** para que la cumpla. A la acepta |
| 1:35–1:50 | B pulsa "hecha" en una tarea que no ha hecho. A la rechaza. **B se lleva la multa** y el saldo baja a la vista |
| 1:50–2:00 | Cierre: el trato lo decide el grupo, no quien escribe la tarea |

Narración o subtítulos **en inglés**. La interfaz va en español, que las reglas lo permiten.

## 3. Quién hace qué

| Persona | Área | Horas/semana |
|---|---|---|
| **Juan** | Frontend entero, PM, representante | ~20 |
| **Daniel** | Backend: grupos y ciclo de tareas. Además PO y QA | ~10 |
| **Segovia** | Backend: cartera, multas, plazos, tienda y tiempo real | ~10 |
| **Mayte** | Diseño y comunidad | ~10 |

Unas 200 horas de equipo en total. El MVP cabe; los extras casi seguro que no.

**El frontend no espera al backend.** La semana 1 se sube el contrato (los `.spy.yaml` y las firmas de
los endpoints, aunque el cuerpo lance `UnimplementedError`), se genera el cliente y Juan trabaja en
paralelo desde ahí. Esos cuerpos vacíos son para desarrollar: **no pueden llegar al vídeo**.

**El diseño tampoco bloquea.** Juan arranca con el tema que ya hay (claro, Archivo, pestañas
deslizables) y ajusta cuando llegue lo de Mayte.

## 4. Las cuatro semanas

Cada semana es su milestone en GitHub.

### Semana 1 · 17–23 sep — el contrato y los grupos

| Quién | Qué |
|---|---|
| Juan | **Registrar el equipo en BuilderBase** (sin esto no hay entrega ni premio de feedback) |
| Equipo | **Decidir el nombre de la app**: hace falta para el vídeo, el post, la interfaz y el nombre del servicio en Cloud |
| Daniel | `Group` y `GroupMember` en `.spy.yaml`, migración, y `GroupEndpoint`: crear, unirse por código, listar miembros |
| Segovia | `CoinTransaction`, `RewardItem`, `RewardVote` y `Purchase`; firmas de `WalletEndpoint` y `ShopEndpoint`; plantillas de recompensas como lista en código |
| Daniel + Segovia | **Contrato en `develop` antes del domingo 21**: todos los `.spy.yaml` y las firmas de los cuatro endpoints |
| Juan | Base de la app: navegación, tema, estado, cliente y sesión. Crear grupo y unirse con código. **i18n con ARB desde la primera pantalla** |
| Mayte | Pantallas del ciclo: tablero, detalle de tarea y proponer |

### Semana 2 · 24–30 sep — el ciclo y el primer despliegue

| Quién | Qué |
|---|---|
| Daniel | `TaskEndpoint` entero: proponer, votar, contraofertar, aceptar o retirar, marcar hecha y votar la validación. Estado `counterOffered` en `Task`. Marcar hecha va **en transacción**: gana quien pulsa primero |
| Segovia | Libro de cuentas y saldo, **en transacción**. Las tres multas. Cierre de votaciones con `FutureCall` y ventana configurable. Stream del grupo |
| Juan | Pestaña de tareas (lo que espera tu voto, disponibles, en validación), detalle con voto y contraoferta, proponer tarea, y engancharse al stream |
| Mayte | Pantallas de tienda y cartera |
| **30 sep** | **El ciclo funciona de punta a punta en local** y se hace el **primer despliegue a Serverpod Cloud** |

El despliegue del 30 es el hito de riesgo: es cuando se descubre si los correos de verificación salen
de verdad y si la web servida por Serverpod se ve bien. Lo lanza Juan, que es quien registra la cuenta,
con Segovia al lado. Crear el servicio es **decisión del equipo**, no de quien esté tocando código ese
día.

### Semana 3 · 1–7 oct — tienda, cartera y pruebas

| Quién | Qué |
|---|---|
| Segovia | `ShopEndpoint` entero: listar, crear recompensa y votarla, comprar eligiendo quién cumple, aceptar, negarse con multa y devolución, marcar entregada. Copiar la plantilla al crear el grupo |
| Daniel | Pruebas con `serverpod_test`: mayorías en grupos de 2 a 6, expiración, las tres multas y la carrera de dos "hecha" a la vez. Arreglar lo que salga |
| Juan | Tienda, detalle de recompensa y compra, compras pendientes, pestaña de grupo (miembros, código, historial) y cartera |
| Mayte | Ajustes visuales, y el guion del vídeo cerrado con Juan |
| **7 oct** | **El MVP entero, desplegado y usable en la web de Cloud** |

### Semana 4 · 8–14 oct — cierre y entrega

| Cuándo | Qué |
|---|---|
| 8–10 oct | Arreglos y pulido. **El 10 se congelan las funcionalidades**: a partir de ahí solo se corrigen fallos |
| Segovia | Script que siembra las **dos cuentas de pareja** con grupo, tareas, tienda e historial, y que se puede volver a lanzar si alguien lo deja hecho un desastre |
| Juan | Grabar y montar el **vídeo** (menos de 2 minutos, público, en inglés) |
| Daniel | **Descripción en inglés**, que **tiene que declarar el uso de IA y de herramientas agénticas**, más las instrucciones de compilación (el `README.md` ya es casi eso) |
| Mayte | **Post público** con `#buildsomethingreal` |
| Equipo | Pasar `docs/FEEDBACK.md` al **formulario de feedback** antes del cierre |
| **13 oct** | **Enviar la entrega**, un día antes del cierre. Se puede seguir editando hasta el 14 |
| 14 oct 23:59 | Cierre |

## 5. Fechas que no se mueven

| Fecha | Qué | Quién |
|---|---|---|
| 21 sep | Contrato de endpoints en `develop` | Daniel y Segovia |
| 23 sep | Equipo registrado en BuilderBase | Juan |
| 23 sep | Nombre de la app decidido | Equipo |
| 30 sep | Ciclo completo y primer despliegue en Cloud | Todos |
| 7 oct | MVP entero desplegado | Todos |
| 10 oct | Congelación de funcionalidades | Todos |
| 13 oct | Entrega enviada | Juan |
| 14 oct 23:59 | Cierre de la entrega, sin prórrogas | — |
| 20 oct 17:00 | Fin del jurado: **el despliegue sigue en pie hasta aquí** | — |

El mes gratis de Serverpod Cloud se activa con el despliegue del 30 de septiembre y llega de sobra al
20 de octubre.

## 6. Si vamos tarde

El 30 de septiembre se mira si el ciclo está. Si no lo está, se recorta **en este orden**:

1. La votación de recompensas nuevas: la tienda se queda solo con la plantilla del perfil.
2. La contraoferta: la propuesta se vota sí o no.
3. Las multas por votación expirada: la votación caduca y ya está.

**Nunca se recorta** el ciclo proponer → votar → hacer → validar → cobrar, ni el tiempo real. Sin eso
no hay vídeo, y sin vídeo no hay nota.

## 7. Los otros dos premios

Se acumulan con el principal y cuestan poco mientras se construye:

- **Mejor feedback:** se apunta la fricción con Serverpod en `docs/FEEDBACK.md` **según aparece**, no
  reconstruida el 14 de octubre. Sirven fallos, mejoras de interfaz y pegas de los SDK o la
  documentación. Ya hay una anotada.
- **Mejor post:** el de Mayte, con `#buildsomethingreal`, publicado dentro del plazo.

## 8. Decisiones tomadas el 18 de septiembre

| Qué | Decisión |
|---|---|
| Recorte del MVP | Piso y pareja. **El modo familia queda fuera** |
| Contraoferta | **La primera congela la votación**: nadie más contraoferta y el autor acepta (se vota de cero) o retira |
| Ventana de votación | Configurable, para poder probarla y enseñarla en el vídeo |
| Despliegue | 30 de septiembre, al cerrar la semana 2 |
| Congelación | 10 de octubre |
| Idioma de la app | Español, con ARB desde el primer día. La traducción al inglés, solo si sobra |
| iOS | Fuera |
| Backend | Daniel: grupos y ciclo. Segovia: cartera, multas, plazos, tienda y tiempo real |
| Frontend | Juan, todas las pantallas, sin esperar al diseño |
| Vídeo | Juan |
| Post | Mayte |
| Descripción y build | Daniel |
| Cuentas de prueba | Segovia |

## 9. Lo que sigue sin decidir

| Qué | Para cuándo |
|---|---|
| **Nombre de la app** | 23 de septiembre |
| **Misiones periódicas** | Cómo se comporta cada repetición, si llegan a entrar |
| **Ranking semanal** | En qué zona horaria se cierra la semana, si llega a entrar |
| **Plantillas de recompensas** | Mayte revisa el borrador de [`PRODUCT.md` §6](PRODUCT.md#6-tienda-y-recompensas) |
| **Entrada de los hijos sin email** | Solo si el modo familia vuelve a entrar en alcance |

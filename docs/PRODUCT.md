# Producto: qué construimos y cómo

App de tareas del hogar con recompensas, para el hackathon **Build Something Real** de Serverpod.
Este documento recoge lo que el equipo decidió el **17 de septiembre de 2026** y manda sobre
cualquier idea anterior. Lo que sigue sin decidir está en [Decisiones pendientes](#13-decisiones-pendientes).

El nombre de la app **está sin decidir**; en el documento aparece como "la app".

---

## 1. Qué es

Una casa compartida tiene tareas que nadie quiere hacer y ninguna forma justa de repartirlas. La app
convierte esas tareas en un trato explícito entre las personas que viven juntas: alguien propone una
tarea y lo que vale, **el grupo acepta el trato antes de que exista la tarea**, cualquiera la hace y
pide su recompensa, y **el grupo confirma que está hecha** antes de pagar. Las monedas se acumulan en
una cartera y se gastan en recompensas que pone el propio grupo.

Lo que la distingue de una lista de tareas cualquiera: nada se aprueba en solitario. El precio de una
tarea y el hecho de que esté hecha los decide el grupo, no quien la escribe.

## 2. Para quién

Tres perfiles, que se eligen al crear el grupo y cambian la plantilla de la tienda y las reglas:

| Perfil | Quiénes | Ejemplo de recompensa |
|---|---|---|
| **Piso compartido** | Compañeros de piso, iguales entre sí | "Unas cervezas y pago yo" |
| **Pareja** | Normalmente dos personas | "Un masaje" |
| **Familia** | Tutores e hijos, con control parental | "Una PS5", "un día en el parque de atracciones" |

En piso y pareja todos tienen el mismo poder de voto. En familia, no: ver [§8](#8-modo-familia-y-control-parental).

## 3. El ciclo

Es el núcleo de la app y lo que se graba en el vídeo. Todo lo demás está al servicio de esto.

```
 PROPUESTA                     VOTACIÓN 1
 título, descripción,  ──►  ¿la acepta el grupo?
 monedas                     │        │        │
                            sí   contraoferta  no
                             │        │        │
                             │        ▼        ▼
                             │   el autor la acepta      se descarta
                             │   (se vota de nuevo)      y multa a quien la propuso
                             │   o la retira sin multa
                             ▼
                        DISPONIBLE
                             │  alguien la hace y pulsa "hecha"
                             ▼
                        EN VALIDACIÓN  (bloqueada: gana quien pulsa primero)
                             │
                        VOTACIÓN 2: ¿está hecha?
                             │                  │
                            sí                  no
                             ▼                  ▼
                     cobra las monedas     multa a quien pulsó "hecha"
                                           y vuelve a DISPONIBLE
```

- **No se reserva nada.** Nadie coge una tarea antes de hacerla: se hace y se reclama. Así lo que se
  asigna es el mérito, después de hacer el trabajo.
- Las monedas se cobran **al validarse**, nunca al pulsar "hecha".
- **Riesgo asumido:** dos personas pueden hacer la misma tarea sin saberlo, y solo cobra la primera
  que la reclama.

## 4. Reglas

### 4.1 Mayoría: la mitad de los demás

Una votación sale adelante con los votos a favor de **al menos la mitad de los miembros restantes**,
redondeando hacia arriba. Quien propone o reclama **no vota** su propia tarea.

| Tamaño del grupo | Votos a favor necesarios |
|---|---|
| 2 | 1 |
| 3 | 1 |
| 4 | 2 |
| 5 | 2 |
| 6 | 3 |

Fórmula: `techo((miembros − 1) / 2)`.

### 4.2 Ventana de 24 horas

Cada votación está abierta **24 horas**, y **se cierra antes** en cuanto el resultado ya no puede
cambiar: se reúnen los votos a favor, o los que quedan por votar ya no bastan para reunirlos. En una
pareja, el voto del otro resuelve al instante.

- **Se deniega** cuando los votos en contra hacen imposible aprobarla.
- **Expira** si a las 24 horas no se ha decidido. Una votación que expira **cuenta como rechazada**.

La duración es **configurable por entorno**: 24 horas en producción y minutos en desarrollo y en la
grabación del vídeo. Sin eso no hay forma de probar una expiración ni de enseñarla.

### 4.3 Contraoferta

Si lo único que no convence es el precio, quien vota una propuesta puede **contraofertar** otro precio
en lugar de rechazarla. El autor elige:

- **Aceptar:** la votación **empieza de cero** con el nuevo precio, porque los votos anteriores
  aprobaban otro trato.
- **Retirar la propuesta**, sin multa.

**La primera contraoferta congela la votación:** mientras el autor no decide, nadie más vota ni
contraoferta. Así hay siempre una sola oferta sobre la mesa, también en un piso de seis.

### 4.4 Multas

| Qué pasa | Quién paga | Porcentaje sobre |
|---|---|---|
| Una votación expira sin decidirse | Quien no votó | El valor de la tarea |
| Se deniega una propuesta | Quien la propuso | El valor de la tarea |
| Se deniega una validación | Quien pulsó "hecha" | El valor de la tarea |
| Alguien se niega a cumplir una recompensa comprada | Esa persona | El precio de la recompensa |

**Sin multa:** contraofertar, retirar una propuesta y todo lo que se vota en la tienda. Cuando una
votación expira, paga quien no votó, no el autor: el autor solo paga si el grupo le dice que no.

La multa es un **porcentaje configurable por grupo, del 20 % por defecto**, redondeado hacia arriba.
Una tarea de 25 monedas multa con 5; una de 12, con 3.

En familia **no hay multas** ([§8](#8-modo-familia-y-control-parental)).

### 4.5 Escala de monedas

Una tarea típica vale **unas 10 monedas**. La escala sirve de referencia para las plantillas y los
precios sugeridos:

| Tareas | | Recompensas | |
|---|---|---|---|
| Sacar la basura | 5 | Elegir la peli | 20 |
| Fregar los platos | 10 | Un masaje | 50 |
| Limpiar el baño | 25 | Cena pagada | 150 |
| Limpieza general | 50 | Parque de atracciones | 1.500 |
| | | PS5 | 5.000 |

### 4.6 Cartera y ranking

- Cada persona tiene una cartera con su saldo en monedas.
- **El saldo puede quedar en negativo** por las multas. Con saldo negativo **no se puede comprar** en
  la tienda, pero sí se pueden seguir haciendo tareas: se sale del agujero trabajando.
- Toda la actividad queda en un **historial de movimientos** (ganado, multado, gastado, devuelto). De
  ahí salen el saldo y el ranking.
- Quien sale o es expulsado del grupo **pierde su saldo**; su rastro en el historial se mantiene, para
  que las tareas que hizo no desaparezcan.
- **Ranking semanal:** monedas ganadas menos multas (lo gastado en la tienda no resta). Se reinicia
  cada lunes para que quien va por detrás pueda remontar, y se guarda quién ganó cada semana.

## 5. Tareas y misiones

Dos formas de la misma cosa, y se elige al proponerla:

- **Tarea puntual:** se hace una vez y desaparece del tablón.
- **Misión periódica:** vuelve a aparecer cada día, semana o mes ("sacar la basura cada lunes"). Se
  propone y se vota una vez; sus repeticiones ya no se vuelven a votar. **No se acumulan:** si la del
  periodo anterior sigue sin hacer, no aparece otra.

Una tarea lleva **título, descripción y monedas**, y nada más: sin fecha límite, sin habitación y sin
foto de prueba. Es a propósito — la prueba de que está hecha es el voto del grupo, no una foto.

Quien propone una tarea **también puede hacerla y cobrarla**: el precio ya lo aprobó el grupo, así que
no saca ventaja. "Yo limpio el horno por 30" es un uso normal.

## 6. Tienda y recompensas

- Cada grupo arranca con una **plantilla de recompensas propia de su perfil** (piso, pareja o
  familia), con precios sugeridos según [§4.5](#45-escala-de-monedas). El grupo la edita y borra lo que
  no le encaje.
- En **piso y pareja**, cualquiera puede añadir una recompensa, **y se vota** igual que una tarea: el
  grupo acepta la recompensa y su precio antes de que aparezca en la tienda. Si se rechaza, **no hay
  multa**: proponer recompensas es ofrecer algo, y multarlo vaciaría la tienda.
- Las recompensas son **ilimitadas por defecto**, con la opción de ponerles unidades.
- **Al comprar, quien compra elige a quién le toca cumplirla**, entre los demás miembros. La compra
  descuenta las monedas y queda pendiente de que esa persona la acepte.
- La persona elegida **puede negarse, pero paga multa**: la compra se anula y **el comprador recupera
  sus monedas**.
- Aceptada la compra, queda pendiente hasta que quien la cumple la marca como **entregada**.

### Plantillas (borrador, a revisar por Mayte)

Precios según la escala de [§4.5](#45-escala-de-monedas): una tarea típica vale unas 10 monedas.

| Piso compartido | | Pareja | | Familia (para los hijos) | |
|---|---|---|---|---|---|
| Ducha larga sin que nadie llame | 15 | Elijo yo la serie esta noche | 20 | Media hora más de pantalla | 20 |
| Elegir la peli de la noche | 20 | Desayuno en la cama | 40 | Elegir la cena del viernes | 25 |
| El sofá y el mando toda la tarde | 25 | Un masaje | 50 | Elegir la peli del finde | 25 |
| Elijo yo la cena | 30 | El plan del sábado lo elijo yo | 60 | Postre especial | 30 |
| Te libras de fregar hoy | 30 | Te libras de una tarea | 80 | Acostarse más tarde el finde | 40 |
| Traigo el desayuno el domingo | 40 | Hago tus tareas un día entero | 120 | Invitar a un amigo a dormir | 100 |
| Unas cervezas y pago yo | 60 | Cena fuera, pago yo | 150 | Cine con palomitas | 150 |
| Te hago la compra esta semana | 80 | Escapada de fin de semana | 1.000 | Un día en la piscina | 300 |
| Te cambio el turno de limpieza | 100 | | | Un juego nuevo | 1.000 |
| Cena pagada fuera | 150 | | | Parque de atracciones | 1.500 |
| | | | | Una PS5 | 5.000 |

## 7. Grupos, roles y permisos

- **Una persona pertenece a un solo grupo.** Simplifica toda la app; el precio es que alguien no puede
  tener a la vez el grupo de familia y el de pareja.
- El grupo se crea eligiendo su perfil, y **el perfil ya no se cambia**.
- **No hay límite de miembros** en ningún perfil: el perfil cambia la plantilla y las reglas, no el
  tamaño.
- En piso y pareja se entra con el **código del grupo**, que se comparte por WhatsApp o por donde sea,
  y **se entra directamente**, sin aprobación. Si entra quien no debe, el admin lo expulsa.
- Manda **quien crea el grupo**, y puede ceder el cargo. Si el admin se va sin cederlo, **pasa al
  miembro más antiguo**.

Solo el admin puede **expulsar miembros**, **borrar tareas y recompensas** y **configurar el grupo**
(nombre, porcentaje de multa).

Lo que **nadie** puede, ni el admin: **forzar una aprobación**. Ninguna tarea se da por buena
saltándose la votación.

## 8. Modo familia y control parental

En un grupo de tipo familia hay dos roles: **tutor** e **hijo**.

### Tareas y dinero

- **Solo los tutores crean y validan tareas.** Los hijos no votan.
- **Basta con un tutor** para aprobar o validar, aunque haya varios.
- Los **hijos sí pueden proponer** tareas ("te lavo el coche por 50") y un tutor las acepta o las
  rechaza.
- **Los tutores no tienen cartera** y no hacen tareas: administran. Solo los hijos ganan monedas.
- **No hay multas en familia.** Como un tutor decide en solitario, multar por no votar no tiene sentido.

### Tienda y control parental

- **Los tutores ponen las recompensas y los precios.** El hijo puede **pedir un deseo** (la PS5), y un
  tutor decide cuánto cuesta y lo publica.
- **Un tutor aprueba cada compra del hijo**, y la puede cumplir **cualquier tutor**.
- Los tutores **ven toda la actividad** del hijo: tareas, monedas y compras.

### Quién entra y quién manda

- El segundo tutor (y los siguientes) entra con el **código del grupo, y el admin lo confirma** antes de
  que pueda validar nada. Sin esa confirmación, un hijo con el código podría entrar como tutor.
- Los hijos **no entran con el código del grupo**, sino con el suyo propio ([Menores](#menores)).
- El cargo de admin **nunca pasa a un hijo**: si el admin se va, pasa al tutor más antiguo.
- Si se va **el último tutor, el grupo se borra**, con las monedas y el historial de los hijos. La app
  tiene que avisarlo antes de confirmar.

### Menores

Punto delicado y decidido a conciencia: en España, por debajo de **14 años** un menor no puede
consentir por sí mismo el tratamiento de sus datos (LOPDGDD, art. 7).

- El **tutor crea el perfil del hijo** desde su propia cuenta. El hijo **no da email ni datos
  personales**: un nombre para mostrar y ya.
- El hijo entra en su móvil con un **código que genera el tutor**, de **un solo uso y que caduca en
  24 horas**. Si el hijo cambia de móvil, el tutor genera otro y el móvil anterior queda fuera.
- Al añadir un hijo se muestra un **aviso** recomendando que tenga edad de usar un móvil. **No se
  pregunta la fecha de nacimiento**: cuanto menos dato de un menor se guarde, mejor.

## 9. Alcance por prioridad

Quedan cuatro semanas (la entrega cierra el **14 de octubre a las 23:59**) y los equipos suelen
terminar bastante menos de lo que planean. El jurado penaliza lo que está a medias mucho más de lo que
premia lo que sobra: "que funcione" pesa un 30 % y lo que está fingido cuenta en contra.

El recorte se cerró el **18 de septiembre**. El calendario y el reparto están en
[`PLAN.md`](PLAN.md).

**El MVP** — es lo que sale en el vídeo, y tiene que funcionar de verdad:

- Registro y entrada con email
- Crear grupo **de piso o de pareja** y unirse con código
- Ciclo completo: proponer → votar → hacer y reclamar → validar → cobrar, con contraoferta
- Multas y votaciones con plazo
- Cartera con historial
- Tienda: plantilla del perfil y recompensas propias, compra eligiendo quién la cumple
- Avisos en tiempo real dentro de la app

**Fuera del MVP, todo el modo familia** ([§8](#8-modo-familia-y-control-parental)): tutores, hijos,
control parental y la entrada de los hijos con código. La entrada de los hijos sin email sigue sin
resolverse, el vídeo se graba con el perfil de pareja y con las horas que hay no cabe. El modelo deja
sitio para `family`, pero al crear un grupo solo se ofrecen piso y pareja.

**Si da tiempo, por este orden:**

- Misiones periódicas
- Ranking semanal
- Expulsar, ceder el cargo y salir del grupo
- Unidades de stock en la tienda
- Catálogo de tareas típicas para añadirlas de un toque
- Traducción al inglés (los textos salen en ARB desde el primer día, así que es traducir, no rehacer)

**Descartado:** ruleta de asignación aleatoria · registro con Google · invitación por QR ·
notificaciones push · **iOS**, porque la revisión de TestFlight no cabe en el calendario · dibujar la
casa.

## 10. Arquitectura

### 10.1 Reparto

Serverpod es el backend y **hace el trabajo de verdad**: las reglas de voto, el dinero y los plazos
viven en el servidor. La app de Flutter enseña estado y manda acciones, y **no calcula saldos ni decide
si una votación ha salido**. Es también lo que mide el jurado: un 25 % de la nota es el uso real de la
pila de Serverpod.

Convención del repositorio (ver `hackathon_serverpod/AGENTS.md`): cada funcionalidad es un directorio
bajo `hackathon_serverpod_server/lib/src/`, con sus modelos `.spy.yaml` y su endpoint al lado.

```
lib/src/
  groups/      Group, GroupMember, ChildLoginCode, invitaciones y roles
  tasks/       Task, TaskVote, el ciclo, las votaciones y las contraofertas
  shop/        RewardItem, RewardVote, Purchase
  wallet/      CoinTransaction, saldo, ranking
  events/      el stream de novedades del grupo
  auth/        ya existe (email + JWT)
```

### 10.2 Modelos

| Modelo | Campos principales | Notas |
|---|---|---|
| `Group` | `name`, `type` (sharedFlat/couple/family), `inviteCode`, `finePercent`, `createdAt` | El código de invitación es único |
| `GroupMember` | `group`, `authUserId`, `displayName`, `role` (admin/member/guardian/child), `status` (active/pending), `balance`, `joinedAt`, `leftAt` | La cartera vive aquí; `balance` es el resultado del historial, guardado por rapidez. `pending` es el tutor sin confirmar |
| `ChildLoginCode` | `member`, `codeHash`, `expiresAt`, `usedAt` | Se guarda el hash, nunca el código |
| `Task` | `group`, `title`, `description`, `reward`, `kind` (oneOff/mission), `recurrence`, `status`, `proposedBy`, `doneBy`, `voteClosesAt` | Estados: `proposed` → `open` → `inValidation` → `done`, y `rejected`/`withdrawn` |
| `TaskVote` | `task`, `member`, `phase` (proposal/completion), `approve`, `counterReward` | Un voto por persona y fase; `counterReward` lleva la contraoferta |
| `RewardItem` | `group`, `title`, `description`, `price`, `status`, `createdBy`, `stock` | `status` cubre la votación en piso y pareja |
| `RewardVote` | `item`, `member`, `approve` | Igual que `TaskVote`, para la tienda |
| `Purchase` | `group`, `item`, `buyer`, `provider`, `status` (pendingApproval/pending/accepted/delivered/refused) | `provider` es quien la cumple; `pendingApproval` es la compra de un hijo que aún no ha aprobado un tutor |
| `CoinTransaction` | `group`, `member`, `amount`, `reason`, `taskId`, `purchaseId`, `createdAt` | El libro de cuentas: de aquí salen saldo, historial y ranking |

Las recompensas de plantilla **no son una tabla**: son una lista en el código que se copia a
`RewardItem` al crear el grupo, ya con el perfil elegido.

Todo lo que mueve monedas va **dentro de una transacción** de base de datos: apuntar el movimiento y
actualizar el saldo no pueden quedar a medias. Pulsar "hecha" también: dos personas a la vez sobre la
misma tarea, y solo una puede ganar.

### 10.3 Endpoints

- `GroupEndpoint` — crear, unirse por código, confirmar tutores, ver miembros, expulsar, ceder el
  cargo, salir, configurar, añadir un hijo y generar su código.
- `TaskEndpoint` — proponer, listar, votar la propuesta, contraofertar, aceptar la contraoferta o
  retirar, marcar hecha, votar la validación.
- `ShopEndpoint` — listar, crear recompensa, votarla, pedir un deseo, comprar, aprobar la compra de un
  hijo, aceptar o negarse, marcar entregada.
- `WalletEndpoint` — saldo, historial, ranking.

Ninguno se fía del cliente: cada llamada comprueba a qué grupo pertenece quien llama y con qué rol.

### 10.4 Tiempo real

Un `Stream` de Serverpod por grupo. Cuando pasa algo — una propuesta, un voto, una contraoferta, una
validación, una compra — el servidor publica el suceso y todos los móviles del grupo se enteran al
momento, sin recargar. Es lo que hace que la votación se vea viva en el vídeo.

Son **avisos dentro de la app**, no notificaciones push: el push necesita Firebase y configuración por
plataforma, y queda para el final.

### 10.5 Plazos: trabajos programados

Con `FutureCall` de Serverpod, sin depender de que nadie tenga la app abierta:

- **Cierre de votaciones.** Se programa al abrir cada votación. Al vencer las 24 horas, si sigue
  abierta, la da por expirada, multa a quien no votó y publica el suceso en el stream.
- **Misiones periódicas.** Al empezar cada periodo, publica la misión si la anterior está hecha.
- **Ranking.** Cada lunes cierra la semana y guarda quién ganó.

### 10.6 Autenticación

Ya está montada en `lib/server.dart`: identidad por email con JWT (`serverpod_auth_idp`). En
desarrollo, los códigos de verificación salen por la consola del servidor, así que se puede probar sin
correo. En Serverpod Cloud los correos se envían de verdad.

La **entrada de los hijos con código** no encaja de serie en el proveedor de email y hay que resolverla
(ver [Decisiones pendientes](#13-decisiones-pendientes)); está en "si da tiempo".

### 10.7 Despliegue y plataformas

- **Android** (APK) y **web**, y también **iOS**, que es viable porque el equipo tiene Mac y cuenta de
  desarrollador de Apple. Ojo con el calendario: la revisión de TestFlight tarda, así que iOS no puede
  quedarse para los últimos días.
- Los jueces entran por la **web servida por el propio Serverpod** en Serverpod Cloud: un enlace,
  gratis y sin instalar nada. Es el acceso de prueba que exigen las reglas.
- Desplegar es decisión del equipo, no un efecto secundario: `serverpod cloud launch` crea un servicio
  vivo y facturable. El **mes gratis de Serverpod Cloud** empieza a contar cuando se activa, y el
  despliegue tiene que seguir en pie hasta que termine el jurado el **20 de octubre**: activarlo antes
  del 21 de septiembre se queda corto a mitad de las votaciones.

## 11. Flujo de pantallas

```
Entrada
  ├─ Registro / inicio de sesión (email)
  │    └─ ¿tiene grupo?
  │         ├─ no ─► Crear grupo (nombre + perfil)  ó  Unirse con código
  │         └─ sí ─► Inicio
  └─ "Soy un hijo: tengo un código" ─► Inicio
```

**Inicio**, con la cartera siempre visible arriba (ya está en la app) y tres pestañas deslizables:

| Pestaña | Qué hay |
|---|---|
| **Tareas** | Arriba, lo que **espera tu voto** (propuestas, contraofertas y validaciones, con el tiempo que queda). Debajo, las **disponibles**, las **tuyas en validación** y las **misiones** |
| **Tienda** | Recompensas del grupo, tus compras pendientes y lo que otros esperan que cumplas. Botón de añadir recompensa (o de pedir un deseo, si eres hijo) |
| **Grupo** | Miembros, ranking, código de invitación para compartir, historial de movimientos, ajustes (admin), tutores por confirmar (admin) y añadir hijo (tutor) |

Pantallas de detalle: **tarea** (votar, contraofertar, pulsar "hecha", ver quién ha votado),
**recompensa** (comprar y elegir a quién le toca) y **proponer tarea** (título, descripción, monedas,
puntual o misión).

Diseño: Mayte lo está preparando. Mientras tanto vale lo que hay — tema claro, tipografía Archivo,
pestañas deslizables y las monedas en la barra superior.

## 12. Idioma

La interfaz va en **español e inglés**: se desarrolla en español y se traduce (está en "si da tiempo",
pero conviene no dejarlo para el último día, porque el jurado es internacional). Los **materiales de la
entrega van en inglés obligatoriamente**: descripción, instrucciones y vídeo.

## 13. Decisiones pendientes

Las que se cerraron el 18 de septiembre están en
[`PLAN.md` §8](PLAN.md#8-decisiones-tomadas-el-18-de-septiembre).

| Qué | Estado |
|---|---|
| **Nombre de la app** | Sin decidir. Fecha tope: **23 de septiembre**; hace falta para el vídeo, el post y el nombre del servicio en Cloud |
| **Listas de las plantillas** | Borrador escrito en [§6](#plantillas-borrador-a-revisar-por-mayte); falta que Mayte lo revise |
| **Misiones periódicas** | Si llegan a entrar, falta decir si cada repetición se vuelve a validar |
| **Ranking semanal** | Si llega a entrar, falta decir en qué zona horaria se cierra la semana |
| **Entrada de los hijos con código** | Aparcada: el modo familia queda fuera del MVP ([§9](#9-alcance-por-prioridad)) |
| **Ruleta** | Descartada ([§9](#9-alcance-por-prioridad)) |

## 14. Equipo y calendario

| Persona | Papel |
|---|---|
| Mayte | Diseño de producto y community manager |
| Juan | Product manager y frontend — **representante del equipo** |
| Segovia | Backend |
| Daniel | Product owner, QA y backend |

El **representante es Juan**: registra al equipo, envía la entrega y es a quien se le paga el premio,
que se reparte a partes iguales (ver `TEAM.md`).

El calendario, el reparto por persona y las fechas que no se mueven están en
[`PLAN.md`](PLAN.md), escrito el 18 de septiembre. Aquí solo queda quién es quién.

Entregables que no son código, y que puntúan:

- **Vídeo de menos de 2 minutos**, público, grabado con el **perfil de pareja** (el caso más claro: dos
  personas, un voto que resuelve al instante, y el ciclo entero cabe en el tiempo). Los jueces pueden no
  llegar a abrir la app, así que el vídeo tiene que enseñar el ciclo completándose de verdad.
- **Descripción del proyecto** en inglés, que **debe declarar el uso de IA y de herramientas
  agénticas**. Usarlas está bien visto; no declararlo incumple las reglas.
- **Instrucciones de compilación y ejecución** (ya casi están en el `README.md`).
- **Acceso de prueba gratuito** hasta que termine el jurado, y aquí hay un problema propio de esta app:
  **un ciclo necesita dos personas y el juez la abre solo**. Se resuelve entregando **las credenciales
  de dos cuentas de una pareja**, con un grupo ya montado (tareas propuestas, tienda con recompensas y
  algo de historial), para que abra las dos y vea la votación decidir al instante. Hace falta un script
  que siembre ese grupo en el servidor desplegado y volver a sembrarlo si alguien lo deja hecho un
  desastre.
- Dos premios aparte, que se acumulan: el **formulario de feedback** (apuntar la fricción con Serverpod
  según aparece, no reconstruirla el 14 de octubre) y un **post público** con `#buildsomethingreal`.

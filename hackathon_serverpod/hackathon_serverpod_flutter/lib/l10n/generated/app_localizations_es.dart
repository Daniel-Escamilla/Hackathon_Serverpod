// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Prototipo de tareas';

  @override
  String get retry => 'Reintentar';

  @override
  String get coinsLabel => 'monedas';

  @override
  String get reject => 'Rechazar';

  @override
  String get navTasks => 'Tareas';

  @override
  String get navShop => 'Tienda';

  @override
  String get navWallet => 'Cartera';

  @override
  String get navGroup => 'Grupo';

  @override
  String get proposeTask => 'Proponer';

  @override
  String get activityTitle => 'Actividad';

  @override
  String get activityEmptyMessage =>
      'Todavía no hay un listado de actividad del servidor.';

  @override
  String get groupCheckError => 'No se pudo comprobar tu grupo.';

  @override
  String get welcomeHeadline => 'Las tareas,\npor fin justas.';

  @override
  String get welcomeSubtitle => 'Los acuerdos de casa se deciden entre todos.';

  @override
  String get welcomeSignIn => 'Entrar con email';

  @override
  String get welcomeCreateAccount => 'Crear una cuenta';

  @override
  String get signInTitle => 'Entra en tu cuenta';

  @override
  String get emailFieldLabel => 'Email';

  @override
  String get emailHint => 'mayte@email.com';

  @override
  String get passwordFieldLabel => 'Contraseña';

  @override
  String get passwordHint => '••••••••';

  @override
  String get signInSubmit => 'Entrar';

  @override
  String get signInErrorInvalidCredentials => 'Email o contraseña incorrectos.';

  @override
  String get authErrorTooManyAttempts =>
      'Demasiados intentos. Prueba en unos minutos.';

  @override
  String get signInErrorUnknown => 'No se pudo iniciar sesión.';

  @override
  String get createAccountTitle => 'Crea tu cuenta';

  @override
  String get createAccountContinue => 'Continuar';

  @override
  String get createAccountErrorGeneric =>
      'No se pudo empezar el registro. ¿Ya tienes cuenta con ese email?';

  @override
  String get createAccountErrorStart => 'No se pudo empezar el registro.';

  @override
  String get verifyEmailTitle => 'Revisa tu email';

  @override
  String verifyEmailSubtitle(String email) {
    return 'Hemos enviado un código de verificación a $email.';
  }

  @override
  String get codeHint => '284619';

  @override
  String get verifyButton => 'Verificar';

  @override
  String get codeErrorExpired => 'El código ha caducado. Vuelve a empezar.';

  @override
  String get codeErrorInvalid => 'Código incorrecto.';

  @override
  String get codeErrorGeneric => 'No se pudo verificar el código.';

  @override
  String get choosePasswordTitle => 'Elige una contraseña';

  @override
  String get createAccountButton => 'Crear cuenta';

  @override
  String get passwordErrorPolicy => 'La contraseña no cumple los requisitos.';

  @override
  String get passwordErrorExpired =>
      'La sesión de registro ha caducado. Vuelve a empezar.';

  @override
  String get passwordErrorGeneric => 'No se pudo crear la cuenta.';

  @override
  String get groupChoiceGreeting => '¡Hola!';

  @override
  String get groupChoiceQuestion => '¿Cómo quieres\nempezar?';

  @override
  String get createGroupTitle => 'Crear un grupo';

  @override
  String get createGroupSubtitle => 'Prepara vuestro espacio';

  @override
  String get joinGroupTitle => 'Unirme con un código';

  @override
  String get joinGroupSubtitle => 'Introduce el código que te han compartido.';

  @override
  String get createGroupHeadline => 'Crea vuestro grupo';

  @override
  String get createGroupHint => 'Elige cómo compartís casa';

  @override
  String get profileSharedFlat => 'Piso compartido';

  @override
  String get profileCouple => 'Pareja';

  @override
  String get groupNameLabel => 'Nombre del grupo';

  @override
  String get groupNameHint => 'Casa de Mayte y Juan';

  @override
  String get createGroupSubmit => 'Crear grupo';

  @override
  String get createGroupErrorEmpty => 'Ponle un nombre al grupo.';

  @override
  String get createGroupErrorGeneric => 'No se pudo crear el grupo.';

  @override
  String get joinGroupHeadline => 'Únete a tu gente';

  @override
  String get joinGroupCodeHint => 'NIDO-482';

  @override
  String get joinGroupCaseNote => 'El código no distingue mayúsculas';

  @override
  String get joinGroupSubmit => 'Entrar al grupo';

  @override
  String get joinGroupError => 'No se encontró ningún grupo con ese código.';

  @override
  String get groupSuccessTitle => '¡Ya tenéis casa!';

  @override
  String get groupCodeLabel => 'Código del grupo';

  @override
  String get shareCode => 'Compartir código';

  @override
  String get goToTasks => 'Ir a las tareas';

  @override
  String get groupPendingNotice =>
      'Datos de ejemplo: falta un endpoint para pedir tu grupo y sus miembros al servidor.';

  @override
  String get membersTitle => 'Miembros';

  @override
  String get groupSettings => 'Configuración del grupo';

  @override
  String get codeCopied => 'Código copiado';

  @override
  String get tasksLoadError => 'No se pudieron cargar las tareas.';

  @override
  String get tasksEmpty => 'Todavía no hay tareas. Propón la primera.';

  @override
  String get sectionAwaitingVote => 'Esperan un voto';

  @override
  String get sectionCounterOffered => 'Contraofertadas';

  @override
  String get sectionAvailable => 'Disponibles';

  @override
  String get sectionInValidation => 'En validación';

  @override
  String get statusProposal => 'Propuesta';

  @override
  String get statusCounterOffer => 'Contraoferta';

  @override
  String get statusAvailable => 'Disponible';

  @override
  String get statusValidation => 'Validación';

  @override
  String get waitingYourVote => 'Esperando tu voto';

  @override
  String get votingClosingSoon => 'La votación está a punto de cerrar';

  @override
  String remainingTime(int hours, int minutes) {
    return 'Quedan $hours h $minutes min';
  }

  @override
  String get approve => 'Aprobar';

  @override
  String get counterOffer => 'Contraofertar';

  @override
  String get voteApproved => 'Has aprobado la propuesta';

  @override
  String get voteRejected => 'Propuesta rechazada';

  @override
  String get voteError => 'No se pudo registrar tu voto';

  @override
  String get counterOfferError => 'No se pudo enviar la contraoferta';

  @override
  String get counterOfferSheetTitle => 'Haz una contraoferta';

  @override
  String get counterOfferSheetSubtitle =>
      '¿Cuántas monedas te parecerían justas?';

  @override
  String get counterOfferPauseNotice =>
      'La votación se pausará hasta que el autor responda';

  @override
  String get sendCounterOffer => 'Enviar contraoferta';

  @override
  String get counterOfferPausedStatus => 'Votación pausada';

  @override
  String get counterOfferDecisionNotice =>
      'Han contraofertado un nuevo precio para esta tarea. Si aceptas, la votación empieza de cero con esa cifra.';

  @override
  String get acceptCounterOffer => 'Aceptar la contraoferta';

  @override
  String get withdrawNoFine => 'Retirar sin multa';

  @override
  String get counterOfferAccepted => 'Contraoferta aceptada';

  @override
  String get proposalWithdrawn => 'Propuesta retirada';

  @override
  String get counterOfferDecisionError => 'No se pudo procesar tu decisión';

  @override
  String get notReserved => 'No se reserva: reclama cuando esté hecha';

  @override
  String get markDone => 'Ya está hecha';

  @override
  String get claimedTitle => '¡Reclamada!';

  @override
  String get claimedMessage => 'Ahora el grupo debe confirmar que está hecha.';

  @override
  String inValidationValue(int reward) {
    return 'En validación · $reward monedas';
  }

  @override
  String get backToTasks => 'Volver a tareas';

  @override
  String get claimError =>
      'No se pudo reclamar. Puede que ya la haya cogido otra persona.';

  @override
  String get validationPendingNotice =>
      'Todavía no se puede votar la validación: falta el endpoint en el backend.';

  @override
  String get newTaskTitle => 'Nueva tarea';

  @override
  String get titleFieldLabel => 'Título';

  @override
  String get taskTitleHint => 'Limpiar el baño';

  @override
  String get descriptionLabel => 'Descripción';

  @override
  String get taskDescriptionHint => 'Ducha, lavabo, espejo y suelo';

  @override
  String get rewardLabel => 'Recompensa';

  @override
  String get rewardHintNote => 'Una tarea normal suele valer 10';

  @override
  String get reviewProposal => 'Revisar propuesta';

  @override
  String get taskTitleEmptyError => 'Ponle un título a la tarea.';

  @override
  String get reviewDealStatus => 'Revisa el trato';

  @override
  String get voteWindowNotice => 'El grupo tendrá 24 horas para votar';

  @override
  String get rejectFineNotice =>
      'Si la rechazan, recibirás una multa sobre estas monedas';

  @override
  String get submitToVote => 'Enviar a votación';

  @override
  String get sentToVoteTitle => 'Enviada a votación';

  @override
  String get sentToVoteMessage =>
      'Avisaremos al grupo para que decida el trato.';

  @override
  String rewardAmount(int reward) {
    return '$reward monedas';
  }

  @override
  String get proposeError => 'No se pudo enviar la propuesta';

  @override
  String get shopSubtitle => 'Convierte tus monedas en planes';

  @override
  String get shopLoadError => 'No se pudo cargar la tienda.';

  @override
  String get shopEmpty => 'Todavía no hay recompensas. Propón la primera.';

  @override
  String get awaitingVoteSection => 'Esperando votación';

  @override
  String get awaitingYourVote => 'Espera tu voto';

  @override
  String get approveReward => 'Aprobar recompensa';

  @override
  String get rewardApproved => 'Recompensa aprobada';

  @override
  String get rewardRejected => 'Recompensa rechazada';

  @override
  String get newRewardTitle => 'Nueva recompensa';

  @override
  String get rewardTitleHint => 'Desayuno en la cama';

  @override
  String get rewardDescriptionHint => 'Café, tostadas y fruta';

  @override
  String get priceLabel => 'Precio';

  @override
  String get rewardVotingNotice => 'El grupo votará antes de publicarla';

  @override
  String get rewardTitleEmptyError => 'Ponle un título a la recompensa.';

  @override
  String get rewardSentToVote => 'Recompensa enviada a votación';

  @override
  String get rewardSubmitError => 'No se pudo enviar la recompensa';

  @override
  String get sending => 'Enviando…';

  @override
  String get whoWillFulfil => '¿Quién la cumplirá?';

  @override
  String get membersEndpointNotice =>
      'Elegir a quién le toca necesita el listado de miembros del grupo, que todavía no tiene endpoint.';

  @override
  String get purchaseBlockedNotice =>
      'La compra se activará en cuanto el backend lo exponga.';

  @override
  String get walletLoadError => 'No se pudo cargar la cartera.';

  @override
  String get negativeBalanceNotice =>
      'Con saldo negativo no puedes comprar en la tienda, pero sí seguir haciendo tareas para recuperarte.';

  @override
  String get recentMovements => 'Últimos movimientos';

  @override
  String get noMovements => 'Todavía no hay movimientos.';

  @override
  String get reasonEarned => 'Tarea completada';

  @override
  String get reasonFined => 'Multa';

  @override
  String get reasonSpent => 'Compra en la tienda';

  @override
  String get reasonRefunded => 'Devolución';
}

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('es')];

  /// No description provided for @appTitle.
  ///
  /// In es, this message translates to:
  /// **'Prototipo de tareas'**
  String get appTitle;

  /// No description provided for @retry.
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get retry;

  /// No description provided for @coinsLabel.
  ///
  /// In es, this message translates to:
  /// **'monedas'**
  String get coinsLabel;

  /// No description provided for @reject.
  ///
  /// In es, this message translates to:
  /// **'Rechazar'**
  String get reject;

  /// No description provided for @decreaseAmount.
  ///
  /// In es, this message translates to:
  /// **'Restar'**
  String get decreaseAmount;

  /// No description provided for @increaseAmount.
  ///
  /// In es, this message translates to:
  /// **'Sumar'**
  String get increaseAmount;

  /// Tooltip of the eye in a password field while the password is hidden
  ///
  /// In es, this message translates to:
  /// **'Mostrar contraseña'**
  String get showPassword;

  /// Tooltip of the eye in a password field while the password is shown
  ///
  /// In es, this message translates to:
  /// **'Ocultar contraseña'**
  String get hidePassword;

  /// No description provided for @navTasks.
  ///
  /// In es, this message translates to:
  /// **'Tareas'**
  String get navTasks;

  /// No description provided for @navShop.
  ///
  /// In es, this message translates to:
  /// **'Tienda'**
  String get navShop;

  /// No description provided for @navWallet.
  ///
  /// In es, this message translates to:
  /// **'Cartera'**
  String get navWallet;

  /// No description provided for @navGroup.
  ///
  /// In es, this message translates to:
  /// **'Grupo'**
  String get navGroup;

  /// No description provided for @proposeTask.
  ///
  /// In es, this message translates to:
  /// **'Proponer'**
  String get proposeTask;

  /// No description provided for @activityTitle.
  ///
  /// In es, this message translates to:
  /// **'Actividad'**
  String get activityTitle;

  /// No description provided for @activityEmptyMessage.
  ///
  /// In es, this message translates to:
  /// **'Todavía no hay un listado de actividad del servidor.'**
  String get activityEmptyMessage;

  /// No description provided for @groupCheckError.
  ///
  /// In es, this message translates to:
  /// **'No se pudo comprobar tu grupo.'**
  String get groupCheckError;

  /// No description provided for @welcomeHeadline.
  ///
  /// In es, this message translates to:
  /// **'Las tareas,\npor fin justas.'**
  String get welcomeHeadline;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Los acuerdos de casa se deciden entre todos.'**
  String get welcomeSubtitle;

  /// No description provided for @welcomeSignIn.
  ///
  /// In es, this message translates to:
  /// **'Entrar con email'**
  String get welcomeSignIn;

  /// No description provided for @welcomeCreateAccount.
  ///
  /// In es, this message translates to:
  /// **'Crear una cuenta'**
  String get welcomeCreateAccount;

  /// No description provided for @signInTitle.
  ///
  /// In es, this message translates to:
  /// **'Entra en tu cuenta'**
  String get signInTitle;

  /// No description provided for @emailFieldLabel.
  ///
  /// In es, this message translates to:
  /// **'Email'**
  String get emailFieldLabel;

  /// No description provided for @emailHint.
  ///
  /// In es, this message translates to:
  /// **'mayte@email.com'**
  String get emailHint;

  /// No description provided for @passwordFieldLabel.
  ///
  /// In es, this message translates to:
  /// **'Contraseña'**
  String get passwordFieldLabel;

  /// No description provided for @passwordHint.
  ///
  /// In es, this message translates to:
  /// **'••••••••'**
  String get passwordHint;

  /// No description provided for @signInSubmit.
  ///
  /// In es, this message translates to:
  /// **'Entrar'**
  String get signInSubmit;

  /// No description provided for @signInErrorInvalidCredentials.
  ///
  /// In es, this message translates to:
  /// **'Email o contraseña incorrectos.'**
  String get signInErrorInvalidCredentials;

  /// No description provided for @authErrorTooManyAttempts.
  ///
  /// In es, this message translates to:
  /// **'Demasiados intentos. Prueba en unos minutos.'**
  String get authErrorTooManyAttempts;

  /// No description provided for @signInErrorUnknown.
  ///
  /// In es, this message translates to:
  /// **'No se pudo iniciar sesión.'**
  String get signInErrorUnknown;

  /// No description provided for @createAccountTitle.
  ///
  /// In es, this message translates to:
  /// **'Crea tu cuenta'**
  String get createAccountTitle;

  /// No description provided for @createAccountContinue.
  ///
  /// In es, this message translates to:
  /// **'Continuar'**
  String get createAccountContinue;

  /// No description provided for @createAccountErrorGeneric.
  ///
  /// In es, this message translates to:
  /// **'No se pudo empezar el registro. ¿Ya tienes cuenta con ese email?'**
  String get createAccountErrorGeneric;

  /// No description provided for @createAccountErrorStart.
  ///
  /// In es, this message translates to:
  /// **'No se pudo empezar el registro.'**
  String get createAccountErrorStart;

  /// No description provided for @verifyEmailTitle.
  ///
  /// In es, this message translates to:
  /// **'Revisa tu email'**
  String get verifyEmailTitle;

  /// No description provided for @verifyEmailSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Hemos enviado un código de verificación a {email}.'**
  String verifyEmailSubtitle(String email);

  /// No description provided for @codeHint.
  ///
  /// In es, this message translates to:
  /// **'284619'**
  String get codeHint;

  /// No description provided for @verifyButton.
  ///
  /// In es, this message translates to:
  /// **'Verificar'**
  String get verifyButton;

  /// No description provided for @codeErrorExpired.
  ///
  /// In es, this message translates to:
  /// **'El código ha caducado. Vuelve a empezar.'**
  String get codeErrorExpired;

  /// No description provided for @codeErrorInvalid.
  ///
  /// In es, this message translates to:
  /// **'Código incorrecto.'**
  String get codeErrorInvalid;

  /// No description provided for @codeErrorGeneric.
  ///
  /// In es, this message translates to:
  /// **'No se pudo verificar el código.'**
  String get codeErrorGeneric;

  /// No description provided for @choosePasswordTitle.
  ///
  /// In es, this message translates to:
  /// **'Elige una contraseña'**
  String get choosePasswordTitle;

  /// No description provided for @createAccountButton.
  ///
  /// In es, this message translates to:
  /// **'Crear cuenta'**
  String get createAccountButton;

  /// No description provided for @passwordErrorPolicy.
  ///
  /// In es, this message translates to:
  /// **'La contraseña no cumple los requisitos.'**
  String get passwordErrorPolicy;

  /// No description provided for @passwordErrorExpired.
  ///
  /// In es, this message translates to:
  /// **'La sesión de registro ha caducado. Vuelve a empezar.'**
  String get passwordErrorExpired;

  /// No description provided for @passwordErrorGeneric.
  ///
  /// In es, this message translates to:
  /// **'No se pudo crear la cuenta.'**
  String get passwordErrorGeneric;

  /// Link under the sign-in form that starts the password reset.
  ///
  /// In es, this message translates to:
  /// **'¿Has olvidado la contraseña?'**
  String get forgotPasswordLink;

  /// Title of the first password reset step, where the email is typed.
  ///
  /// In es, this message translates to:
  /// **'Recupera tu contraseña'**
  String get resetPasswordTitle;

  /// Explains what happens after typing the email in the password reset.
  ///
  /// In es, this message translates to:
  /// **'Te enviaremos un código para elegir una nueva.'**
  String get resetPasswordSubtitle;

  /// Button that asks the server to email the password reset code.
  ///
  /// In es, this message translates to:
  /// **'Enviar código'**
  String get resetPasswordSendCode;

  /// Title of the last password reset step.
  ///
  /// In es, this message translates to:
  /// **'Elige una contraseña nueva'**
  String get newPasswordTitle;

  /// Button that saves the new password and ends the reset.
  ///
  /// In es, this message translates to:
  /// **'Cambiar contraseña'**
  String get newPasswordButton;

  /// Message shown back on the sign-in screen once the password has been reset.
  ///
  /// In es, this message translates to:
  /// **'Contraseña cambiada. Entra con la nueva.'**
  String get passwordChanged;

  /// No description provided for @groupChoiceGreeting.
  ///
  /// In es, this message translates to:
  /// **'¡Hola!'**
  String get groupChoiceGreeting;

  /// No description provided for @groupChoiceQuestion.
  ///
  /// In es, this message translates to:
  /// **'¿Cómo quieres\nempezar?'**
  String get groupChoiceQuestion;

  /// No description provided for @createGroupTitle.
  ///
  /// In es, this message translates to:
  /// **'Crear un grupo'**
  String get createGroupTitle;

  /// No description provided for @createGroupSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Prepara vuestro espacio'**
  String get createGroupSubtitle;

  /// No description provided for @joinGroupTitle.
  ///
  /// In es, this message translates to:
  /// **'Unirme con un código'**
  String get joinGroupTitle;

  /// No description provided for @joinGroupCardSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Entra en un grupo existente'**
  String get joinGroupCardSubtitle;

  /// No description provided for @createGroupHeadline.
  ///
  /// In es, this message translates to:
  /// **'Crea vuestro grupo'**
  String get createGroupHeadline;

  /// No description provided for @createGroupHint.
  ///
  /// In es, this message translates to:
  /// **'Elige cómo compartís casa'**
  String get createGroupHint;

  /// No description provided for @profileSharedFlat.
  ///
  /// In es, this message translates to:
  /// **'Piso compartido'**
  String get profileSharedFlat;

  /// No description provided for @profileCouple.
  ///
  /// In es, this message translates to:
  /// **'Pareja'**
  String get profileCouple;

  /// No description provided for @profileFamily.
  ///
  /// In es, this message translates to:
  /// **'Familia'**
  String get profileFamily;

  /// No description provided for @groupNameLabel.
  ///
  /// In es, this message translates to:
  /// **'Nombre del grupo'**
  String get groupNameLabel;

  /// No description provided for @groupNameHint.
  ///
  /// In es, this message translates to:
  /// **'Casa de Mayte y Juan'**
  String get groupNameHint;

  /// No description provided for @createGroupSubmit.
  ///
  /// In es, this message translates to:
  /// **'Crear grupo'**
  String get createGroupSubmit;

  /// No description provided for @createGroupErrorEmpty.
  ///
  /// In es, this message translates to:
  /// **'Ponle un nombre al grupo.'**
  String get createGroupErrorEmpty;

  /// No description provided for @createGroupErrorGeneric.
  ///
  /// In es, this message translates to:
  /// **'No se pudo crear el grupo.'**
  String get createGroupErrorGeneric;

  /// No description provided for @joinGroupHeadline.
  ///
  /// In es, this message translates to:
  /// **'Únete a tu gente'**
  String get joinGroupHeadline;

  /// No description provided for @joinGroupSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Introduce el código que te han compartido.'**
  String get joinGroupSubtitle;

  /// No description provided for @joinGroupCodeHint.
  ///
  /// In es, this message translates to:
  /// **'NIDO-482'**
  String get joinGroupCodeHint;

  /// No description provided for @joinGroupCaseNote.
  ///
  /// In es, this message translates to:
  /// **'El código no distingue mayúsculas'**
  String get joinGroupCaseNote;

  /// No description provided for @joinGroupSubmit.
  ///
  /// In es, this message translates to:
  /// **'Entrar al grupo'**
  String get joinGroupSubmit;

  /// No description provided for @joinGroupError.
  ///
  /// In es, this message translates to:
  /// **'No se encontró ningún grupo con ese código.'**
  String get joinGroupError;

  /// No description provided for @groupSuccessTitle.
  ///
  /// In es, this message translates to:
  /// **'¡Ya tenéis casa!'**
  String get groupSuccessTitle;

  /// No description provided for @groupCodeLabel.
  ///
  /// In es, this message translates to:
  /// **'Código del grupo'**
  String get groupCodeLabel;

  /// No description provided for @shareCode.
  ///
  /// In es, this message translates to:
  /// **'Compartir código'**
  String get shareCode;

  /// No description provided for @goToTasks.
  ///
  /// In es, this message translates to:
  /// **'Ir a las tareas'**
  String get goToTasks;

  /// No description provided for @groupPendingNotice.
  ///
  /// In es, this message translates to:
  /// **'Datos de ejemplo: falta un endpoint para pedir tu grupo y sus miembros al servidor.'**
  String get groupPendingNotice;

  /// No description provided for @membersTitle.
  ///
  /// In es, this message translates to:
  /// **'Miembros'**
  String get membersTitle;

  /// No description provided for @groupSettings.
  ///
  /// In es, this message translates to:
  /// **'Configuración del grupo'**
  String get groupSettings;

  /// Label above the fine percentage slider in the group settings screen
  ///
  /// In es, this message translates to:
  /// **'Multa'**
  String get groupSettingsFineLabel;

  /// Explains what the fine percentage applies to, under its label
  ///
  /// In es, this message translates to:
  /// **'Lo que paga quien recibe una multa, sobre el valor de la tarea o de la recompensa.'**
  String get groupSettingsFineHint;

  /// The fine percentage currently picked on the slider
  ///
  /// In es, this message translates to:
  /// **'{percent} %'**
  String groupSettingsFineValue(int percent);

  /// Primary button that saves the group's name and fine percentage
  ///
  /// In es, this message translates to:
  /// **'Guardar cambios'**
  String get groupSettingsSave;

  /// Message after the group settings are saved
  ///
  /// In es, this message translates to:
  /// **'Configuración guardada.'**
  String get groupSettingsSaved;

  /// No description provided for @codeCopied.
  ///
  /// In es, this message translates to:
  /// **'Código copiado'**
  String get codeCopied;

  /// No description provided for @copyCode.
  ///
  /// In es, this message translates to:
  /// **'Copiar código'**
  String get copyCode;

  /// No description provided for @tasksLoadError.
  ///
  /// In es, this message translates to:
  /// **'No se pudieron cargar las tareas.'**
  String get tasksLoadError;

  /// No description provided for @tasksEmpty.
  ///
  /// In es, this message translates to:
  /// **'Todavía no hay tareas. Propón la primera.'**
  String get tasksEmpty;

  /// No description provided for @sectionAwaitingVote.
  ///
  /// In es, this message translates to:
  /// **'Esperan un voto'**
  String get sectionAwaitingVote;

  /// No description provided for @sectionCounterOffered.
  ///
  /// In es, this message translates to:
  /// **'Contraofertadas'**
  String get sectionCounterOffered;

  /// No description provided for @sectionAvailable.
  ///
  /// In es, this message translates to:
  /// **'Disponibles'**
  String get sectionAvailable;

  /// No description provided for @sectionInValidation.
  ///
  /// In es, this message translates to:
  /// **'En validación'**
  String get sectionInValidation;

  /// No description provided for @statusProposal.
  ///
  /// In es, this message translates to:
  /// **'Propuesta'**
  String get statusProposal;

  /// No description provided for @statusCounterOffer.
  ///
  /// In es, this message translates to:
  /// **'Contraoferta'**
  String get statusCounterOffer;

  /// No description provided for @statusAvailable.
  ///
  /// In es, this message translates to:
  /// **'Disponible'**
  String get statusAvailable;

  /// No description provided for @statusValidation.
  ///
  /// In es, this message translates to:
  /// **'Validación'**
  String get statusValidation;

  /// No description provided for @waitingYourVote.
  ///
  /// In es, this message translates to:
  /// **'Esperando tu voto'**
  String get waitingYourVote;

  /// No description provided for @votingClosingSoon.
  ///
  /// In es, this message translates to:
  /// **'La votación está a punto de cerrar'**
  String get votingClosingSoon;

  /// No description provided for @remainingTime.
  ///
  /// In es, this message translates to:
  /// **'Quedan {hours} h {minutes} min'**
  String remainingTime(int hours, int minutes);

  /// No description provided for @approve.
  ///
  /// In es, this message translates to:
  /// **'Aprobar'**
  String get approve;

  /// No description provided for @counterOffer.
  ///
  /// In es, this message translates to:
  /// **'Contraofertar'**
  String get counterOffer;

  /// No description provided for @voteApproved.
  ///
  /// In es, this message translates to:
  /// **'Has aprobado la propuesta'**
  String get voteApproved;

  /// No description provided for @voteRejected.
  ///
  /// In es, this message translates to:
  /// **'Propuesta rechazada'**
  String get voteRejected;

  /// No description provided for @voteError.
  ///
  /// In es, this message translates to:
  /// **'No se pudo registrar tu voto'**
  String get voteError;

  /// No description provided for @counterOfferError.
  ///
  /// In es, this message translates to:
  /// **'No se pudo enviar la contraoferta'**
  String get counterOfferError;

  /// No description provided for @counterOfferSheetTitle.
  ///
  /// In es, this message translates to:
  /// **'Haz una contraoferta'**
  String get counterOfferSheetTitle;

  /// No description provided for @counterOfferSheetSubtitle.
  ///
  /// In es, this message translates to:
  /// **'¿Cuántas monedas te parecerían justas?'**
  String get counterOfferSheetSubtitle;

  /// No description provided for @counterOfferPauseNotice.
  ///
  /// In es, this message translates to:
  /// **'La votación se pausará hasta que el autor responda'**
  String get counterOfferPauseNotice;

  /// No description provided for @sendCounterOffer.
  ///
  /// In es, this message translates to:
  /// **'Enviar contraoferta'**
  String get sendCounterOffer;

  /// No description provided for @counterOfferPausedStatus.
  ///
  /// In es, this message translates to:
  /// **'Votación pausada'**
  String get counterOfferPausedStatus;

  /// No description provided for @counterOfferDecisionNotice.
  ///
  /// In es, this message translates to:
  /// **'Han contraofertado un nuevo precio para esta tarea. Si aceptas, la votación empieza de cero con esa cifra.'**
  String get counterOfferDecisionNotice;

  /// No description provided for @acceptCounterOffer.
  ///
  /// In es, this message translates to:
  /// **'Aceptar la contraoferta'**
  String get acceptCounterOffer;

  /// No description provided for @withdrawNoFine.
  ///
  /// In es, this message translates to:
  /// **'Retirar sin multa'**
  String get withdrawNoFine;

  /// No description provided for @counterOfferAccepted.
  ///
  /// In es, this message translates to:
  /// **'Contraoferta aceptada'**
  String get counterOfferAccepted;

  /// No description provided for @proposalWithdrawn.
  ///
  /// In es, this message translates to:
  /// **'Propuesta retirada'**
  String get proposalWithdrawn;

  /// No description provided for @counterOfferDecisionError.
  ///
  /// In es, this message translates to:
  /// **'No se pudo procesar tu decisión'**
  String get counterOfferDecisionError;

  /// No description provided for @notReserved.
  ///
  /// In es, this message translates to:
  /// **'No se reserva: reclama cuando esté hecha'**
  String get notReserved;

  /// No description provided for @markDone.
  ///
  /// In es, this message translates to:
  /// **'Ya está hecha'**
  String get markDone;

  /// No description provided for @claimedTitle.
  ///
  /// In es, this message translates to:
  /// **'¡Reclamada!'**
  String get claimedTitle;

  /// No description provided for @claimedMessage.
  ///
  /// In es, this message translates to:
  /// **'Ahora el grupo debe confirmar que está hecha.'**
  String get claimedMessage;

  /// No description provided for @inValidationValue.
  ///
  /// In es, this message translates to:
  /// **'En validación · {reward} monedas'**
  String inValidationValue(int reward);

  /// No description provided for @backToTasks.
  ///
  /// In es, this message translates to:
  /// **'Volver a tareas'**
  String get backToTasks;

  /// No description provided for @claimError.
  ///
  /// In es, this message translates to:
  /// **'No se pudo reclamar. Puede que ya la haya cogido otra persona.'**
  String get claimError;

  /// Shown to the group on a task someone has claimed as done
  ///
  /// In es, this message translates to:
  /// **'¿Está hecha de verdad? Si la mayoría dice que sí, se paga la recompensa.'**
  String get validationQuestion;

  /// Shown instead of the vote buttons to whoever claimed the task
  ///
  /// In es, this message translates to:
  /// **'La has reclamado tú: ahora el grupo decide si está hecha.'**
  String get validationYourOwn;

  /// Button that votes a claimed task as done
  ///
  /// In es, this message translates to:
  /// **'Sí, está hecha'**
  String get validationApprove;

  /// Button that votes a claimed task as not done, and the confirm button of its dialog
  ///
  /// In es, this message translates to:
  /// **'No está hecha'**
  String get validationDeny;

  /// Title of the dialog before voting a claimed task as not done
  ///
  /// In es, this message translates to:
  /// **'¿Seguro que no está hecha?'**
  String get validationDenyTitle;

  /// Body of the dialog before voting a claimed task as not done
  ///
  /// In es, this message translates to:
  /// **'Si la mayoría vota que no, quien la reclamó paga una multa y la tarea vuelve a estar disponible.'**
  String get validationDenyBody;

  /// Message after voting a claimed task as done
  ///
  /// In es, this message translates to:
  /// **'Has votado que está hecha'**
  String get validationApproved;

  /// Message after voting a claimed task as not done
  ///
  /// In es, this message translates to:
  /// **'Has votado que no está hecha'**
  String get validationDenied;

  /// No description provided for @newTaskTitle.
  ///
  /// In es, this message translates to:
  /// **'Nueva tarea'**
  String get newTaskTitle;

  /// No description provided for @titleFieldLabel.
  ///
  /// In es, this message translates to:
  /// **'Título'**
  String get titleFieldLabel;

  /// No description provided for @taskTitleHint.
  ///
  /// In es, this message translates to:
  /// **'Limpiar el baño'**
  String get taskTitleHint;

  /// No description provided for @descriptionLabel.
  ///
  /// In es, this message translates to:
  /// **'Descripción'**
  String get descriptionLabel;

  /// No description provided for @taskDescriptionHint.
  ///
  /// In es, this message translates to:
  /// **'Ducha, lavabo, espejo y suelo'**
  String get taskDescriptionHint;

  /// No description provided for @rewardLabel.
  ///
  /// In es, this message translates to:
  /// **'Recompensa'**
  String get rewardLabel;

  /// No description provided for @rewardHintNote.
  ///
  /// In es, this message translates to:
  /// **'Una tarea normal suele valer 10'**
  String get rewardHintNote;

  /// No description provided for @reviewProposal.
  ///
  /// In es, this message translates to:
  /// **'Revisar propuesta'**
  String get reviewProposal;

  /// No description provided for @taskTitleEmptyError.
  ///
  /// In es, this message translates to:
  /// **'Ponle un título a la tarea.'**
  String get taskTitleEmptyError;

  /// No description provided for @reviewDealStatus.
  ///
  /// In es, this message translates to:
  /// **'Revisa el trato'**
  String get reviewDealStatus;

  /// No description provided for @voteWindowNotice.
  ///
  /// In es, this message translates to:
  /// **'El grupo tendrá 24 horas para votar'**
  String get voteWindowNotice;

  /// No description provided for @rejectFineNotice.
  ///
  /// In es, this message translates to:
  /// **'Si la rechazan, recibirás una multa sobre estas monedas'**
  String get rejectFineNotice;

  /// No description provided for @submitToVote.
  ///
  /// In es, this message translates to:
  /// **'Enviar a votación'**
  String get submitToVote;

  /// No description provided for @sentToVoteTitle.
  ///
  /// In es, this message translates to:
  /// **'Enviada a votación'**
  String get sentToVoteTitle;

  /// No description provided for @sentToVoteMessage.
  ///
  /// In es, this message translates to:
  /// **'Avisaremos al grupo para que decida el trato.'**
  String get sentToVoteMessage;

  /// No description provided for @rewardAmount.
  ///
  /// In es, this message translates to:
  /// **'{reward} monedas'**
  String rewardAmount(int reward);

  /// No description provided for @proposeError.
  ///
  /// In es, this message translates to:
  /// **'No se pudo enviar la propuesta'**
  String get proposeError;

  /// No description provided for @shopSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Convierte tus monedas en planes'**
  String get shopSubtitle;

  /// No description provided for @shopLoadError.
  ///
  /// In es, this message translates to:
  /// **'No se pudo cargar la tienda.'**
  String get shopLoadError;

  /// No description provided for @shopEmpty.
  ///
  /// In es, this message translates to:
  /// **'Todavía no hay recompensas. Propón la primera.'**
  String get shopEmpty;

  /// No description provided for @awaitingVoteSection.
  ///
  /// In es, this message translates to:
  /// **'Esperando votación'**
  String get awaitingVoteSection;

  /// No description provided for @awaitingYourVote.
  ///
  /// In es, this message translates to:
  /// **'Espera tu voto'**
  String get awaitingYourVote;

  /// No description provided for @approveReward.
  ///
  /// In es, this message translates to:
  /// **'Aprobar recompensa'**
  String get approveReward;

  /// No description provided for @rewardApproved.
  ///
  /// In es, this message translates to:
  /// **'Recompensa aprobada'**
  String get rewardApproved;

  /// No description provided for @rewardRejected.
  ///
  /// In es, this message translates to:
  /// **'Recompensa rechazada'**
  String get rewardRejected;

  /// No description provided for @newRewardTitle.
  ///
  /// In es, this message translates to:
  /// **'Nueva recompensa'**
  String get newRewardTitle;

  /// No description provided for @rewardTitleHint.
  ///
  /// In es, this message translates to:
  /// **'Desayuno en la cama'**
  String get rewardTitleHint;

  /// No description provided for @rewardDescriptionHint.
  ///
  /// In es, this message translates to:
  /// **'Café, tostadas y fruta'**
  String get rewardDescriptionHint;

  /// No description provided for @priceLabel.
  ///
  /// In es, this message translates to:
  /// **'Precio'**
  String get priceLabel;

  /// No description provided for @rewardVotingNotice.
  ///
  /// In es, this message translates to:
  /// **'El grupo votará antes de publicarla'**
  String get rewardVotingNotice;

  /// No description provided for @rewardTitleEmptyError.
  ///
  /// In es, this message translates to:
  /// **'Ponle un título a la recompensa.'**
  String get rewardTitleEmptyError;

  /// No description provided for @rewardSentToVote.
  ///
  /// In es, this message translates to:
  /// **'Recompensa enviada a votación'**
  String get rewardSentToVote;

  /// No description provided for @rewardSubmitError.
  ///
  /// In es, this message translates to:
  /// **'No se pudo enviar la recompensa'**
  String get rewardSubmitError;

  /// No description provided for @whoWillFulfil.
  ///
  /// In es, this message translates to:
  /// **'¿Quién la cumplirá?'**
  String get whoWillFulfil;

  /// No description provided for @selectMember.
  ///
  /// In es, this message translates to:
  /// **'Selecciona a una persona'**
  String get selectMember;

  /// No description provided for @noOtherMembers.
  ///
  /// In es, this message translates to:
  /// **'Todavía no hay nadie más en el grupo para cumplirla.'**
  String get noOtherMembers;

  /// No description provided for @purchaseSentTitle.
  ///
  /// In es, this message translates to:
  /// **'Compra enviada'**
  String get purchaseSentTitle;

  /// No description provided for @purchaseSentMessage.
  ///
  /// In es, this message translates to:
  /// **'Debe aceptar antes de cumplirla.'**
  String get purchaseSentMessage;

  /// No description provided for @backToShop.
  ///
  /// In es, this message translates to:
  /// **'Volver a la tienda'**
  String get backToShop;

  /// No description provided for @purchaseError.
  ///
  /// In es, this message translates to:
  /// **'No se pudo completar la compra'**
  String get purchaseError;

  /// No description provided for @walletLoadError.
  ///
  /// In es, this message translates to:
  /// **'No se pudo cargar la cartera.'**
  String get walletLoadError;

  /// No description provided for @negativeBalanceNotice.
  ///
  /// In es, this message translates to:
  /// **'Con saldo negativo no puedes comprar en la tienda, pero sí seguir haciendo tareas para recuperarte.'**
  String get negativeBalanceNotice;

  /// No description provided for @recentMovements.
  ///
  /// In es, this message translates to:
  /// **'Últimos movimientos'**
  String get recentMovements;

  /// No description provided for @noMovements.
  ///
  /// In es, this message translates to:
  /// **'Todavía no hay movimientos.'**
  String get noMovements;

  /// No description provided for @reasonEarned.
  ///
  /// In es, this message translates to:
  /// **'Tarea completada'**
  String get reasonEarned;

  /// No description provided for @reasonFined.
  ///
  /// In es, this message translates to:
  /// **'Multa'**
  String get reasonFined;

  /// No description provided for @reasonSpent.
  ///
  /// In es, this message translates to:
  /// **'Compra en la tienda'**
  String get reasonSpent;

  /// No description provided for @reasonRefunded.
  ///
  /// In es, this message translates to:
  /// **'Devolución'**
  String get reasonRefunded;

  /// No description provided for @reasonProposalDenied.
  ///
  /// In es, this message translates to:
  /// **'Propuesta rechazada'**
  String get reasonProposalDenied;

  /// No description provided for @reasonValidationDenied.
  ///
  /// In es, this message translates to:
  /// **'Validación rechazada'**
  String get reasonValidationDenied;

  /// No description provided for @reasonVoteExpired.
  ///
  /// In es, this message translates to:
  /// **'No votaste a tiempo'**
  String get reasonVoteExpired;

  /// Dismisses a confirmation without doing anything
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// Badge on the member who administers the group
  ///
  /// In es, this message translates to:
  /// **'Admin'**
  String get memberRoleAdmin;

  /// Badge on the signed-in user's own row
  ///
  /// In es, this message translates to:
  /// **'Tú'**
  String get memberYou;

  /// Admin action that removes a member from the group
  ///
  /// In es, this message translates to:
  /// **'Expulsar'**
  String get expelAction;

  /// Title of the confirmation before expelling a member
  ///
  /// In es, this message translates to:
  /// **'¿Expulsar a {name}?'**
  String expelTitle(String name);

  /// Explains the consequences of expelling a member
  ///
  /// In es, this message translates to:
  /// **'Saldrá del grupo y perderá su saldo. Lo que hizo seguirá en el historial de todos.'**
  String get expelBody;

  /// Confirmation after a member is expelled
  ///
  /// In es, this message translates to:
  /// **'{name} ya no está en el grupo.'**
  String expelDone(String name);

  /// Admin button that replaces the invite code
  ///
  /// In es, this message translates to:
  /// **'Cambiar el código'**
  String get groupInviteRegenerate;

  /// Title of the confirmation before replacing the invite code
  ///
  /// In es, this message translates to:
  /// **'¿Cambiar el código?'**
  String get groupInviteRegenerateTitle;

  /// Explains what replacing the invite code does and does not affect
  ///
  /// In es, this message translates to:
  /// **'El código de ahora dejará de valer. Quien ya está en el grupo sigue dentro.'**
  String get groupInviteRegenerateBody;

  /// Confirmation after the invite code is replaced
  ///
  /// In es, this message translates to:
  /// **'Código cambiado. El anterior ya no sirve.'**
  String get groupInviteRegenerated;

  /// Shown when no group matches the invite code
  ///
  /// In es, this message translates to:
  /// **'Ese código no existe. Compruébalo con quien te lo pasó.'**
  String get errorInviteCode;

  /// Shown when the user already has an active membership
  ///
  /// In es, this message translates to:
  /// **'Ya estás en un grupo. Sal de él antes de entrar en otro.'**
  String get errorAlreadyInGroup;

  /// Shown when a non-admin tries an admin-only action
  ///
  /// In es, this message translates to:
  /// **'Solo quien administra el grupo puede hacer esto.'**
  String get errorNotAdmin;

  /// Shown when the member to act on has left or is in another group
  ///
  /// In es, this message translates to:
  /// **'Esa persona ya no está en el grupo.'**
  String get errorMemberNotFound;

  /// Shown when the admin tries to expel themselves
  ///
  /// In es, this message translates to:
  /// **'No puedes expulsarte a ti del grupo.'**
  String get errorCannotExpelSelf;

  /// Shown when the admin tries to hand the role to themselves or to a child
  ///
  /// In es, this message translates to:
  /// **'El cargo de admin solo se puede ceder a otra persona adulta del grupo.'**
  String get errorCannotTransferAdmin;

  /// No description provided for @errorGeneric.
  ///
  /// In es, this message translates to:
  /// **'Algo ha fallado. Inténtalo otra vez.'**
  String get errorGeneric;

  /// Shop section: purchases the signed-in member was chosen to fulfil
  ///
  /// In es, this message translates to:
  /// **'Te toca cumplir'**
  String get purchasesToFulfil;

  /// Shop section: the signed-in member's purchases still in progress
  ///
  /// In es, this message translates to:
  /// **'Tus compras'**
  String get purchasesMine;

  /// Title of a purchase whose reward is no longer in the shop list
  ///
  /// In es, this message translates to:
  /// **'Recompensa'**
  String get purchaseUnknownReward;

  /// Name shown for a member who is no longer in the group
  ///
  /// In es, this message translates to:
  /// **'Alguien'**
  String get purchaseSomeone;

  /// Button: the provider takes the purchase on
  ///
  /// In es, this message translates to:
  /// **'Aceptar'**
  String get purchaseAccept;

  /// Button: the provider refuses the purchase, and the confirm button of its dialog
  ///
  /// In es, this message translates to:
  /// **'Negarme'**
  String get purchaseRefuse;

  /// Title of the dialog before refusing a purchase
  ///
  /// In es, this message translates to:
  /// **'¿Negarte a cumplirla?'**
  String get purchaseRefuseTitle;

  /// Warns the provider what refusing a purchase costs
  ///
  /// In es, this message translates to:
  /// **'Si te niegas pagas una multa, y quien compró recupera sus monedas.'**
  String get purchaseRefuseNotice;

  /// Button: the provider has fulfilled an accepted purchase
  ///
  /// In es, this message translates to:
  /// **'Marcar como entregada'**
  String get purchaseMarkDelivered;

  /// Message after accepting a purchase
  ///
  /// In es, this message translates to:
  /// **'Compra aceptada: ahora te toca cumplirla'**
  String get purchaseAccepted;

  /// Message after refusing a purchase
  ///
  /// In es, this message translates to:
  /// **'Te has negado: se ha cobrado la multa'**
  String get purchaseRefused;

  /// Message after marking a purchase delivered
  ///
  /// In es, this message translates to:
  /// **'Entregada. ¡Bien hecho!'**
  String get purchaseDelivered;

  /// Purchase status: a child's purchase waiting for a guardian
  ///
  /// In es, this message translates to:
  /// **'Esperando al tutor'**
  String get purchaseStatusPendingApproval;

  /// Purchase status: waiting for the provider to accept
  ///
  /// In es, this message translates to:
  /// **'Por aceptar'**
  String get purchaseStatusPending;

  /// Purchase status: accepted, not yet delivered
  ///
  /// In es, this message translates to:
  /// **'Aceptada'**
  String get purchaseStatusAccepted;

  /// Purchase status: fulfilled
  ///
  /// In es, this message translates to:
  /// **'Entregada'**
  String get purchaseStatusDelivered;

  /// Purchase status: the provider refused it
  ///
  /// In es, this message translates to:
  /// **'Rechazada'**
  String get purchaseStatusRefused;

  /// Who bought a purchase
  ///
  /// In es, this message translates to:
  /// **'La compró {name}'**
  String purchaseBoughtBy(String name);

  /// Who has to fulfil a purchase
  ///
  /// In es, this message translates to:
  /// **'Le toca cumplirla a {name}'**
  String purchaseProvidedBy(String name);

  /// Button at the bottom of the group tab, and the confirm button of its dialog
  ///
  /// In es, this message translates to:
  /// **'Cerrar sesión'**
  String get signOut;

  /// Title of the dialog that confirms signing out
  ///
  /// In es, this message translates to:
  /// **'¿Cerrar sesión?'**
  String get signOutTitle;

  /// Body of the dialog that confirms signing out
  ///
  /// In es, this message translates to:
  /// **'Volverás a la pantalla de inicio y podrás entrar con otra cuenta.'**
  String get signOutBody;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

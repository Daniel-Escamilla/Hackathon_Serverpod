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
/// import 'l10n/app_localizations.dart';
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

  /// Name of the app, shown in the app bar and the task switcher
  ///
  /// In es, this message translates to:
  /// **'Tareas de casa'**
  String get appTitle;

  /// Headline on the sign-in screen
  ///
  /// In es, this message translates to:
  /// **'Las tareas de casa,\nen un trato'**
  String get signInTitle;

  /// Explains the email code flow under the sign-in headline
  ///
  /// In es, this message translates to:
  /// **'Entra con tu correo. Te enviamos un código para confirmar que eres tú.'**
  String get signInSubtitle;

  /// Confirmation shown once the email code is accepted
  ///
  /// In es, this message translates to:
  /// **'Sesión iniciada.'**
  String get signInDone;

  /// Shown when the identity provider rejects the sign-in
  ///
  /// In es, this message translates to:
  /// **'No se ha podido entrar: {error}'**
  String signInFailed(String error);

  /// Label under the coin balance on the home screen
  ///
  /// In es, this message translates to:
  /// **'monedas en tu cartera'**
  String get walletCoins;

  /// Replaces the balance label when the balance is below zero
  ///
  /// In es, this message translates to:
  /// **'Estás en números rojos. Haz una tarea para salir.'**
  String get walletNegative;

  /// Headline shown to a signed-in user with no group yet
  ///
  /// In es, this message translates to:
  /// **'Todavía no estás en ningún grupo'**
  String get noGroupTitle;

  /// Explains the two ways into a group
  ///
  /// In es, this message translates to:
  /// **'Crea uno para tu casa o entra en el de alguien con su código.'**
  String get noGroupBody;

  /// Button that runs the failed request again
  ///
  /// In es, this message translates to:
  /// **'Volver a intentarlo'**
  String get retry;

  /// Button that opens the create-group screen
  ///
  /// In es, this message translates to:
  /// **'Crear un grupo'**
  String get createGroupAction;

  /// Title of the create-group screen
  ///
  /// In es, this message translates to:
  /// **'Tu grupo'**
  String get createGroupTitle;

  /// Label of the group name field
  ///
  /// In es, this message translates to:
  /// **'¿Cómo se llama?'**
  String get createGroupNameLabel;

  /// Example group name shown inside the empty field
  ///
  /// In es, this message translates to:
  /// **'Piso de la calle Mayor'**
  String get createGroupNameHint;

  /// Validation error when the group name is left empty
  ///
  /// In es, this message translates to:
  /// **'Ponle un nombre para reconocerlo.'**
  String get createGroupNameEmpty;

  /// Label above the group profile choice
  ///
  /// In es, this message translates to:
  /// **'¿Quiénes sois?'**
  String get createGroupTypeLabel;

  /// Group profile: flatmates, all equal
  ///
  /// In es, this message translates to:
  /// **'Piso compartido'**
  String get groupTypeSharedFlat;

  /// Group profile: two people
  ///
  /// In es, this message translates to:
  /// **'Pareja'**
  String get groupTypeCouple;

  /// Button that creates the group
  ///
  /// In es, this message translates to:
  /// **'Crear el grupo'**
  String get createGroupSubmit;

  /// Headline after a group is created
  ///
  /// In es, this message translates to:
  /// **'Grupo creado'**
  String get groupReadyTitle;

  /// Explains what the invite code is for
  ///
  /// In es, this message translates to:
  /// **'Pásales este código para que entren.'**
  String get groupReadyBody;

  /// Button that closes the invite-code screen
  ///
  /// In es, this message translates to:
  /// **'Listo'**
  String get groupReadyDone;

  /// Button that opens the join-group screen
  ///
  /// In es, this message translates to:
  /// **'Entrar con un código'**
  String get joinGroupAction;

  /// Title of the join-group screen
  ///
  /// In es, this message translates to:
  /// **'Entrar en un grupo'**
  String get joinGroupTitle;

  /// Label of the invite code field
  ///
  /// In es, this message translates to:
  /// **'Código del grupo'**
  String get joinGroupCodeLabel;

  /// Validation error when the invite code is left empty
  ///
  /// In es, this message translates to:
  /// **'Escribe el código que te han pasado.'**
  String get joinGroupCodeEmpty;

  /// Button that joins the group
  ///
  /// In es, this message translates to:
  /// **'Entrar'**
  String get joinGroupSubmit;

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

  /// Fallback for a server error we cannot be specific about
  ///
  /// In es, this message translates to:
  /// **'Algo ha fallado. Inténtalo otra vez.'**
  String get errorGeneric;

  /// Title of the wallet screen
  ///
  /// In es, this message translates to:
  /// **'Cartera'**
  String get walletTitle;

  /// Heading above the list of coin movements
  ///
  /// In es, this message translates to:
  /// **'Últimos movimientos'**
  String get walletMovements;

  /// Shown when the member has no coin movements yet
  ///
  /// In es, this message translates to:
  /// **'Todavía no hay movimientos. Haz una tarea y cobra.'**
  String get walletEmpty;

  /// Movement reason: coins earned by completing a task
  ///
  /// In es, this message translates to:
  /// **'Tarea cobrada'**
  String get reasonEarned;

  /// Movement reason: coins taken as a penalty
  ///
  /// In es, this message translates to:
  /// **'Multa'**
  String get reasonFined;

  /// Movement reason: coins spent on a reward
  ///
  /// In es, this message translates to:
  /// **'Compra en la tienda'**
  String get reasonSpent;

  /// Movement reason: coins returned after a refused purchase
  ///
  /// In es, this message translates to:
  /// **'Compra devuelta'**
  String get reasonRefunded;

  /// Second line of a movement that has a title: what kind of movement, then when
  ///
  /// In es, this message translates to:
  /// **'{reason} · {when}'**
  String movementDetail(String reason, String when);

  /// When a movement happened, as date and time
  ///
  /// In es, this message translates to:
  /// **'{date}, {time}'**
  String movementAt(String date, String time);
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

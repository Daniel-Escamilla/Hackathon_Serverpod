// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Tareas de casa';

  @override
  String get signInTitle => 'Las tareas de casa,\nen un trato';

  @override
  String get signInSubtitle =>
      'Entra con tu correo. Te enviamos un código para confirmar que eres tú.';

  @override
  String get signInDone => 'Sesión iniciada.';

  @override
  String signInFailed(String error) {
    return 'No se ha podido entrar: $error';
  }

  @override
  String get walletCoins => 'monedas en tu cartera';

  @override
  String get walletNegative =>
      'Estás en números rojos. Haz una tarea para salir.';

  @override
  String get noGroupTitle => 'Todavía no estás en ningún grupo';

  @override
  String get noGroupBody =>
      'Crea uno para tu casa o entra en el de alguien con su código.';

  @override
  String get retry => 'Volver a intentarlo';

  @override
  String get cancel => 'Cancelar';

  @override
  String get groupTitle => 'Grupo';

  @override
  String get groupInviteLabel => 'Código para entrar';

  @override
  String get groupInviteCopy => 'Copiar';

  @override
  String get groupInviteCopied => 'Código copiado. Pásalo por donde quieras.';

  @override
  String get groupInviteRegenerate => 'Cambiar el código';

  @override
  String get groupInviteRegenerateTitle => '¿Cambiar el código?';

  @override
  String get groupInviteRegenerateBody =>
      'El código de ahora dejará de valer. Quien ya está en el grupo sigue dentro.';

  @override
  String get groupInviteRegenerated =>
      'Código cambiado. El anterior ya no sirve.';

  @override
  String get groupMembers => 'Miembros';

  @override
  String get memberRoleAdmin => 'Admin';

  @override
  String get memberYou => 'Tú';

  @override
  String get expelAction => 'Expulsar';

  @override
  String expelTitle(String name) {
    return '¿Expulsar a $name?';
  }

  @override
  String get expelBody =>
      'Saldrá del grupo y perderá su saldo. Lo que hizo seguirá en el historial de todos.';

  @override
  String expelDone(String name) {
    return '$name ya no está en el grupo.';
  }

  @override
  String get createGroupAction => 'Crear un grupo';

  @override
  String get createGroupTitle => 'Tu grupo';

  @override
  String get createGroupNameLabel => '¿Cómo se llama?';

  @override
  String get createGroupNameHint => 'Piso de la calle Mayor';

  @override
  String get createGroupNameEmpty => 'Ponle un nombre para reconocerlo.';

  @override
  String get createGroupTypeLabel => '¿Quiénes sois?';

  @override
  String get groupTypeSharedFlat => 'Piso compartido';

  @override
  String get groupTypeCouple => 'Pareja';

  @override
  String get createGroupSubmit => 'Crear el grupo';

  @override
  String get groupReadyTitle => 'Grupo creado';

  @override
  String get groupReadyBody => 'Pásales este código para que entren.';

  @override
  String get groupReadyDone => 'Listo';

  @override
  String get joinGroupAction => 'Entrar con un código';

  @override
  String get joinGroupTitle => 'Entrar en un grupo';

  @override
  String get joinGroupCodeLabel => 'Código del grupo';

  @override
  String get joinGroupCodeEmpty => 'Escribe el código que te han pasado.';

  @override
  String get joinGroupSubmit => 'Entrar';

  @override
  String get errorInviteCode =>
      'Ese código no existe. Compruébalo con quien te lo pasó.';

  @override
  String get errorAlreadyInGroup =>
      'Ya estás en un grupo. Sal de él antes de entrar en otro.';

  @override
  String get errorNotAdmin =>
      'Solo quien administra el grupo puede hacer esto.';

  @override
  String get errorMemberNotFound => 'Esa persona ya no está en el grupo.';

  @override
  String get errorCannotExpelSelf => 'No puedes expulsarte a ti del grupo.';

  @override
  String get errorGeneric => 'Algo ha fallado. Inténtalo otra vez.';

  @override
  String get walletTitle => 'Cartera';

  @override
  String get walletMovements => 'Últimos movimientos';

  @override
  String get walletEmpty =>
      'Todavía no hay movimientos. Haz una tarea y cobra.';

  @override
  String get reasonEarned => 'Tarea cobrada';

  @override
  String get reasonFined => 'Multa';

  @override
  String get reasonSpent => 'Compra en la tienda';

  @override
  String get reasonRefunded => 'Compra devuelta';

  @override
  String movementDetail(String reason, String when) {
    return '$reason · $when';
  }

  @override
  String movementAt(String date, String time) {
    return '$date, $time';
  }
}

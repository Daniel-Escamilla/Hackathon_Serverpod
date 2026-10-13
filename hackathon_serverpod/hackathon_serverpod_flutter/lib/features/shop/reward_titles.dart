import '../../l10n/generated/app_localizations.dart';

/// The title of a reward as the member should read it. The rewards a new home
/// starts with are copied in Spanish by the server (`reward_templates.dart`),
/// so this recognises those titles and shows them in the app's language; any
/// other title is the member's own words and stays as written.
String rewardTitle(AppLocalizations l10n, String title) =>
    _templateTitles(l10n)[title] ?? title;

Map<String, String> _templateTitles(AppLocalizations l10n) => {
  'Ducha larga sin que nadie llame': l10n.rewardTemplateShower,
  'Elegir la peli de la noche': l10n.rewardTemplateMovie,
  'El sofá y el mando toda la tarde': l10n.rewardTemplateSofa,
  'Elijo yo la cena': l10n.rewardTemplateDinner,
  'Te libras de fregar hoy': l10n.rewardTemplateSkipDishes,
  'Traigo el desayuno el domingo': l10n.rewardTemplateBreakfast,
  'Unas cervezas y pago yo': l10n.rewardTemplateBeers,
  'Te hago la compra esta semana': l10n.rewardTemplateShopping,
  'Te cambio el turno de limpieza': l10n.rewardTemplateCleaningTurn,
  'Cena pagada fuera': l10n.rewardTemplateDinnerOutFlat,
  'Elijo yo la serie esta noche': l10n.rewardTemplateSeries,
  'Desayuno en la cama': l10n.rewardTemplateBreakfastInBed,
  'Un masaje': l10n.rewardTemplateMassage,
  'El plan del sábado lo elijo yo': l10n.rewardTemplateSaturday,
  'Te libras de una tarea': l10n.rewardTemplateSkipChore,
  'Hago tus tareas un día entero': l10n.rewardTemplateMyChoresForADay,
  'Cena fuera, pago yo': l10n.rewardTemplateDinnerOutCouple,
  'Escapada de fin de semana': l10n.rewardTemplateWeekend,
};

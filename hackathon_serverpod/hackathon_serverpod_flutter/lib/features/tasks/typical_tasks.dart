import '../../l10n/generated/app_localizations.dart';

/// A chore most homes have, with a fair starting price, so proposing one
/// is a tap instead of typing (PRODUCT.md §14, "catálogo de tareas típicas").
/// The price is only a suggestion: the home still votes on the deal.
typedef TypicalTask = ({String title, int reward});

List<TypicalTask> typicalTasks(AppLocalizations l10n) => [
  (title: l10n.typicalTaskTrash, reward: 5),
  (title: l10n.typicalTaskPlants, reward: 5),
  (title: l10n.typicalTaskDishes, reward: 10),
  (title: l10n.typicalTaskLaundry, reward: 10),
  (title: l10n.typicalTaskSheets, reward: 10),
  (title: l10n.typicalTaskShopping, reward: 15),
  (title: l10n.typicalTaskHoover, reward: 15),
  (title: l10n.typicalTaskDinner, reward: 20),
  (title: l10n.typicalTaskFridge, reward: 20),
  (title: l10n.typicalTaskBathroom, reward: 25),
];

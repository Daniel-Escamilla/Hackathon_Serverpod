import '../generated/protocol.dart';

/// A reward template's title and suggested price (PRODUCT.md §6, draft pending Mayte's
/// review). Not a database table: copied into `RewardItem` rows, already `active`, when a
/// group is created for its profile — templates skip the vote that member-proposed
/// rewards go through.
class RewardTemplate {
  const RewardTemplate(this.title, this.price);

  final String title;
  final int price;
}

/// Family has no entry: out of MVP scope (PLAN.md §1).
const Map<GroupType, List<RewardTemplate>> rewardTemplatesByGroupType = {
  GroupType.sharedFlat: [
    RewardTemplate('Ducha larga sin que nadie llame', 15),
    RewardTemplate('Elegir la peli de la noche', 20),
    RewardTemplate('El sofá y el mando toda la tarde', 25),
    RewardTemplate('Elijo yo la cena', 30),
    RewardTemplate('Te libras de fregar hoy', 30),
    RewardTemplate('Traigo el desayuno el domingo', 40),
    RewardTemplate('Unas cervezas y pago yo', 60),
    RewardTemplate('Te hago la compra esta semana', 80),
    RewardTemplate('Te cambio el turno de limpieza', 100),
    RewardTemplate('Cena pagada fuera', 150),
  ],
  GroupType.couple: [
    RewardTemplate('Elijo yo la serie esta noche', 20),
    RewardTemplate('Desayuno en la cama', 40),
    RewardTemplate('Un masaje', 50),
    RewardTemplate('El plan del sábado lo elijo yo', 60),
    RewardTemplate('Te libras de una tarea', 80),
    RewardTemplate('Hago tus tareas un día entero', 120),
    RewardTemplate('Cena fuera, pago yo', 150),
    RewardTemplate('Escapada de fin de semana', 1000),
  ],
};

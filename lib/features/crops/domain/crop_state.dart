import 'package:flutter_application_1/core/json.dart';

// Representa el estado actual del ciclo de vida de un cultivo.
//
// Cada estado es un tipo diferente y contiene únicamente los datos que
/// tienen sentido mientras el cultivo se encuentra en ese estado.
sealed class CropState {
  const CropState();

  /// Convierte el estado recibido desde JSON en un estado del dominio.
  factory CropState.fromJson(Map<String, dynamic> json) {
    final type = readText(json, 'type');

    return switch (type) {
      'planned' => Planned(readDate(json, 'plannedDate')),
      'growing' => Growing(
        readDate(json, 'lastInspection'),
        readText(json, 'observations'),
      ),
      'harvested' => Harvested(
        readDate(json, 'harvestDate'),
        readDecimal(json, 'harvestedQuantityKg'),
      ),
      _ => throw InvalidField('state.type', 'must be a known crop state', type),
    };
  }

  /// Convierte el estado del dominio a su representación JSON.
  Map<String, dynamic> toJson() => switch (this) {
    Planned(:final plannedDate) => {
      'type': 'planned',
      'plannedDate': plannedDate.toUtc().toIso8601String(),
    },
    Growing(:final lastInspection, :final observations) => {
      'type': 'growing',
      'lastInspection': lastInspection.toUtc().toIso8601String(),
      'observations': observations,
    },
    Harvested(:final harvestDate, :final harvestedQuantityKg) => {
      'type': 'harvested',
      'harvestDate': harvestDate.toUtc().toIso8601String(),
      'harvestedQuantityKg': harvestedQuantityKg,
    },
  };
}

/// El cultivo está planificado, pero todavía no está en crecimiento.
final class Planned extends CropState {
  const Planned(this.plannedDate);

  final DateTime plannedDate;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Planned && other.plannedDate == plannedDate;

  @override
  int get hashCode => Object.hash(runtimeType, plannedDate);

  @override
  String toString() => 'Planned($plannedDate)';
}

/// El cultivo está creciendo y tiene información de su última inspección.
final class Growing extends CropState {
  const Growing(this.lastInspection, this.observations);

  final DateTime lastInspection;
  final String observations;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Growing &&
          other.lastInspection == lastInspection &&
          other.observations == observations;

  @override
  int get hashCode => Object.hash(runtimeType, lastInspection, observations);

  @override
  String toString() => 'Growing($lastInspection, $observations)';
}

/// El cultivo ya fue cosechado y registra la cantidad obtenida.
final class Harvested extends CropState {
  const Harvested(this.harvestDate, this.harvestedQuantityKg);

  final DateTime harvestDate;
  final double harvestedQuantityKg;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Harvested &&
          other.harvestDate == harvestDate &&
          other.harvestedQuantityKg == harvestedQuantityKg;

  @override
  int get hashCode =>
      Object.hash(runtimeType, harvestDate, harvestedQuantityKg);

  @override
  String toString() => 'Harvested($harvestDate, $harvestedQuantityKg kg)';
}

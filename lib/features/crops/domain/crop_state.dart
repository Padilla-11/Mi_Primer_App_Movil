import 'package:flutter_application_1/core/json.dart';

/// Representa el estado actual del ciclo de vida de un cultivo.
///
/// Cada estado es un tipo diferente y contiene únicamente los datos que
/// tienen sentido mientras el cultivo se encuentra en ese estado.
sealed class CropState {
  const CropState();

  /// Convierte el estado recibido desde JSON en un estado del dominio.
  factory CropState.fromJson(Map<String, dynamic> json) {
    final type = readText(json, 'type');

    return switch (type) {
      'planned' => const Planned(),
      'planted' => Planted(readDate(json, 'plantedAt')),
      'growing' => Growing(readDate(json, 'startedAt')),
      'harvested' => Harvested(
        readDate(json, 'harvestedAt'),
        readDecimal(json, 'yieldKg'),
      ),
      'cancelled' => Cancelled(readText(json, 'reason')),
      _ => throw InvalidField('state.type', 'must be a known crop state', type),
    };
  }

  /// Convierte el estado del dominio a su representación JSON.
  Map<String, dynamic> toJson() => switch (this) {
    Planned() => {'type': 'planned'},
    Planted(:final plantedAt) => {
      'type': 'planted',
      'plantedAt': plantedAt.toUtc().toIso8601String(),
    },
    Growing(:final startedAt) => {
      'type': 'growing',
      'startedAt': startedAt.toUtc().toIso8601String(),
    },
    Harvested(:final harvestedAt, :final yieldKg) => {
      'type': 'harvested',
      'harvestedAt': harvestedAt.toUtc().toIso8601String(),
      'yieldKg': yieldKg,
    },
    Cancelled(:final reason) => {'type': 'cancelled', 'reason': reason},
  };
}

/// Indica que el cultivo está planeado pero todavía no ha sido sembrado.
final class Planned extends CropState {
  const Planned();

  @override
  bool operator ==(Object other) => other is Planned;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() => 'Planned()';
}

/// Indica que el cultivo ya fue sembrado.
final class Planted extends CropState {
  const Planted(this.plantedAt);

  final DateTime plantedAt;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Planted && other.plantedAt == plantedAt;

  @override
  int get hashCode => Object.hash(runtimeType, plantedAt);

  @override
  String toString() => 'Planted($plantedAt)';
}

/// Indica que el cultivo se encuentra actualmente en crecimiento.
final class Growing extends CropState {
  const Growing(this.startedAt);

  final DateTime startedAt;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Growing && other.startedAt == startedAt;

  @override
  int get hashCode => Object.hash(runtimeType, startedAt);

  @override
  String toString() => 'Growing($startedAt)';
}

/// Indica que el cultivo ya fue cosechado.
final class Harvested extends CropState {
  const Harvested(this.harvestedAt, this.yieldKg);

  final DateTime harvestedAt;
  final double yieldKg;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Harvested &&
          other.harvestedAt == harvestedAt &&
          other.yieldKg == yieldKg;

  @override
  int get hashCode => Object.hash(runtimeType, harvestedAt, yieldKg);

  @override
  String toString() => 'Harvested($harvestedAt, $yieldKg kg)';
}

/// Indica que el cultivo fue cancelado antes de completar su ciclo.
final class Cancelled extends CropState {
  const Cancelled(this.reason);

  final String reason;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Cancelled && other.reason == reason;

  @override
  int get hashCode => Object.hash(runtimeType, reason);

  @override
  String toString() => 'Cancelled($reason)';
}

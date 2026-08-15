import 'package:flutter_application_1/core/json.dart';

/// Representa el período temporal asociado a un cultivo.
///
/// Es un objeto de valor porque se compara por el contenido de sus fechas
/// y no posee un identificador propio.
class CropPeriod {
  const CropPeriod({this.plantingDate, required this.estimatedHarvestDate});

  /// Crea un período a partir de los datos recibidos en formato JSON.
  ///
  /// La fecha de siembra es opcional porque un cultivo planificado puede
  /// todavía no haber sido sembrado.
  factory CropPeriod.fromJson(Map<String, dynamic> json) {
    final plantingDate = json.containsKey('plantingDate')
        ? readDate(json, 'plantingDate')
        : null;

    final estimatedHarvestDate = readDate(json, 'estimatedHarvestDate');

    _validateDates(plantingDate, estimatedHarvestDate);

    return CropPeriod(
      plantingDate: plantingDate,
      estimatedHarvestDate: estimatedHarvestDate,
    );
  }

  final DateTime? plantingDate;
  final DateTime estimatedHarvestDate;

  /// Convierte el período a un mapa compatible con JSON.
  Map<String, dynamic> toJson() => {
    if (plantingDate != null)
      'plantingDate': plantingDate!.toUtc().toIso8601String(),
    'estimatedHarvestDate': estimatedHarvestDate.toUtc().toIso8601String(),
  };

  /// Valida que la fecha de siembra no sea posterior a la cosecha estimada.
  static void _validateDates(
    DateTime? plantingDate,
    DateTime estimatedHarvestDate,
  ) {
    if (plantingDate != null && plantingDate.isAfter(estimatedHarvestDate)) {
      throw ArgumentError(
        'La fecha de siembra no puede ser posterior '
        'a la cosecha estimada',
      );
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CropPeriod &&
          other.plantingDate == plantingDate &&
          other.estimatedHarvestDate == estimatedHarvestDate;

  @override
  int get hashCode => Object.hash(plantingDate, estimatedHarvestDate);

  @override
  String toString() => 'CropPeriod($plantingDate, $estimatedHarvestDate)';
}

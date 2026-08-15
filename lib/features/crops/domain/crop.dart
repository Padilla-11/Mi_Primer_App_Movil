import 'package:flutter_application_1/core/json.dart';
import 'package:flutter_application_1/features/crops/domain/crop_period.dart';
import 'package:flutter_application_1/features/crops/domain/crop_state.dart';

/// Representa un cultivo registrado dentro de una finca.
///
/// Es una entidad porque tiene su propia identidad mediante `id`.
class Crop {
  const Crop({
    required this.id,
    required this.name,
    required this.cropType,
    required this.period,
    required this.state,
    required this.responsibleId,
  });

  /// Crea un cultivo a partir de un mapa JSON.
  factory Crop.fromJson(Map<String, dynamic> json) => Crop(
    id: readText(json, 'id'),
    name: readText(json, 'name'),
    cropType: readText(json, 'type'),
    period: CropPeriod.fromJson(readMap(json, 'period')),
    state: CropState.fromJson(readMap(json, 'state')),
    responsibleId: readText(json, 'responsibleId'),
  );

  final String id;
  final String name;
  final String cropType;
  final CropPeriod period;
  final CropState state;
  final String responsibleId;

  /// Convierte el cultivo en un mapa compatible con JSON.
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'type': cropType,
    'period': period.toJson(),
    'state': state.toJson(),
    'responsibleId': responsibleId,
  };

  /// Indica si el cultivo puede ser cosechado actualmente.
  bool get canBeHarvested => state is Growing;

  /// Indica si la fecha estimada de cosecha ya ha pasado.
  ///
  /// El momento actual se recibe como parámetro para que la regla
  /// sea determinista y pueda probarse sin depender del reloj del sistema.
  bool isOverdue(DateTime now) => now.isAfter(period.estimatedHarvestDate);

  /// Crea una nueva instancia conservando la identidad del cultivo.
  Crop copyWith({
    String? name,
    String? cropType,
    CropPeriod? period,
    CropState? state,
    String? responsibleId,
  }) => Crop(
    id: id,
    name: name ?? this.name,
    cropType: cropType ?? this.cropType,
    period: period ?? this.period,
    state: state ?? this.state,
    responsibleId: responsibleId ?? this.responsibleId,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Crop &&
          other.id == id &&
          other.name == name &&
          other.cropType == cropType &&
          other.period == period &&
          other.state == state &&
          other.responsibleId == responsibleId;

  @override
  int get hashCode =>
      Object.hash(id, name, cropType, period, state, responsibleId);

  @override
  String toString() => 'Crop($id, $name, ${state.runtimeType})';
}

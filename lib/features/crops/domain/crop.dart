import 'package:flutter_application_1/core/comparisons.dart';
import 'package:flutter_application_1/core/json.dart';
import 'package:flutter_application_1/features/crops/domain/crop_period.dart';
import 'package:flutter_application_1/features/crops/domain/crop_state.dart';

/// Representa un cultivo registrado dentro de una finca.
///
/// Es una entidad porque posee una identidad propia mediante `id`.
class Crop {
  const Crop({
    required this.id,
    required this.name,
    required this.cropType,
    required this.location,
    required this.period,
    required this.state,
    required this.notes,
    this.photos = const <String>[],
  });

  /// Crea un cultivo a partir de un mapa JSON.
  factory Crop.fromJson(Map<String, dynamic> json) => Crop(
    id: readText(json, 'id'),
    name: readText(json, 'name'),
    cropType: readText(json, 'cropType'),
    location: readText(json, 'location'),
    period: CropPeriod.fromJson(readMap(json, 'period')),
    state: CropState.fromJson(readMap(json, 'state')),
    notes: readText(json, 'notes'),
    photos: readStrings(json, 'photos'),
  );

  final String id;
  final String name;
  final String cropType;
  final String location;
  final CropPeriod period;
  final CropState state;
  final String notes;
  final List<String> photos;

  /// Convierte el cultivo a un mapa compatible con JSON.
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'cropType': cropType,
    'location': location,
    'period': period.toJson(),
    'state': state.toJson(),
    'notes': notes,
    'photos': photos,
  };

  /// Indica si el cultivo tiene al menos una fotografía registrada.
  bool get hasPhotos => photos.isNotEmpty;

  /// Indica si el cultivo se encuentra en una etapa en la que puede ser cosechado.
  bool get canBeHarvested => state is Growing;

  /// Indica si la fecha estimada de cosecha ya pasó.
  ///
  /// El momento actual se recibe como parámetro para que la regla sea
  /// determinista y pueda probarse sin depender del reloj del sistema.
  bool isOverdue(DateTime now) => now.isAfter(period.estimatedHarvestDate);

  /// Crea una nueva instancia conservando la identidad del cultivo.
  Crop copyWith({
    String? name,
    String? cropType,
    String? location,
    CropPeriod? period,
    CropState? state,
    String? notes,
    List<String>? photos,
  }) => Crop(
    id: id,
    name: name ?? this.name,
    cropType: cropType ?? this.cropType,
    location: location ?? this.location,
    period: period ?? this.period,
    state: state ?? this.state,
    notes: notes ?? this.notes,
    photos: photos ?? this.photos,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Crop &&
          other.id == id &&
          other.name == name &&
          other.cropType == cropType &&
          other.location == location &&
          other.period == period &&
          other.state == state &&
          other.notes == notes &&
          listsEqual(other.photos, photos);

  @override
  int get hashCode => Object.hash(
    id,
    name,
    cropType,
    location,
    period,
    state,
    notes,
    Object.hashAll(photos),
  );

  @override
  String toString() => 'Crop($id, $name, ${state.runtimeType})';
}

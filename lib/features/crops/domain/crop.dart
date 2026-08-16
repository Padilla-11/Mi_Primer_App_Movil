import 'package:flutter_application_1/core/json.dart';
import 'package:flutter_application_1/features/crops/domain/crop_period.dart';
import 'package:flutter_application_1/features/crops/domain/crop_state.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'crop.freezed.dart';

/// Representa un cultivo registrado dentro de una finca.
///
/// Freezed genera automáticamente:
/// - igualdad
/// - hashCode
/// - toString
/// - copyWith
///
/// La serialización JSON permanece manual para conservar nuestros
/// mensajes de error InvalidField.
@freezed
abstract class Crop with _$Crop {
  const factory Crop({
    required String id,
    required String name,
    required String cropType,
    required CropPeriod period,
    required CropState state,
    required String responsibleId,
  }) = _Crop;

  const Crop._();

  /// Crea un cultivo a partir de un mapa JSON.
  ///
  /// Se mantiene manual para conservar los errores InvalidField.
  static Crop fromJson(Map<String, dynamic> json) => Crop(
    id: readText(json, 'id'),
    name: readText(json, 'name'),
    cropType: readText(json, 'type'),
    period: CropPeriod.fromJson(readMap(json, 'period')),
    state: CropState.fromJson(readMap(json, 'state')),
    responsibleId: readText(json, 'responsibleId'),
  );

  /// Convierte el cultivo a un mapa compatible con JSON.
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

  /// Indica si la fecha estimada de cosecha ya pasó.
  bool isOverdue(DateTime now) => now.isAfter(period.estimatedHarvestDate);
}

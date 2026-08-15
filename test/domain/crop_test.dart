import 'dart:convert';

import 'package:flutter_application_1/core/json.dart';
import 'package:flutter_application_1/features/crops/domain/crop.dart';
import 'package:flutter_application_1/features/crops/domain/crop_period.dart';
import 'package:flutter_application_1/features/crops/domain/crop_state.dart';
import 'package:flutter_test/flutter_test.dart';

Crop exampleCrop({CropState? state, List<String>? photos}) => Crop(
  id: 'crop-001',
  name: 'Maíz amarillo',
  cropType: 'Maíz',
  location: 'Lote Norte',
  period: CropPeriod(
    plantingDate: DateTime.utc(2026, 7, 1),
    estimatedHarvestDate: DateTime.utc(2026, 9, 1),
  ),
  state: state ?? const Planned(),
  notes: 'Cultivo de prueba para el lote norte.',
  photos: photos ?? const <String>[],
);

void main() {
  group('serialización', () {
    test('un cultivo sobrevive la ida y vuelta a JSON sin perder datos', () {
      final original = exampleCrop(
        state: Planted(DateTime.utc(2026, 7, 1, 8)),
        photos: const ['https://ejemplo.co/crops/1.jpg'],
      );

      final text = jsonEncode(original.toJson());
      final decoded = jsonDecode(text) as Map<String, dynamic>;
      final result = Crop.fromJson(decoded);

      expect(result, equals(original));
    });

    test('un cultivo sin la clave photos se lee con la lista vacía', () {
      final json = exampleCrop().toJson()..remove('photos');

      final result = Crop.fromJson(json);

      expect(result.photos, isEmpty);
    });

    test('un cultivo sin nombre indica qué campo es inválido', () {
      final json = exampleCrop().toJson()..remove('name');

      expect(
        () => Crop.fromJson(json),
        throwsA(
          isA<InvalidField>().having((error) => error.field, 'campo', 'name'),
        ),
      );
    });

    test('una fecha que no es ISO 8601 es rechazada', () {
      final json = exampleCrop().toJson();
      final period = json['period'] as Map<String, dynamic>;
      period['estimatedHarvestDate'] = 'una fecha inválida';

      expect(() => Crop.fromJson(json), throwsA(isA<InvalidField>()));
    });

    test('la fecha se conserva en UTC al serializar', () {
      final crop = exampleCrop();

      final json = crop.toJson();
      final period = json['period'] as Map<String, dynamic>;

      expect(period['estimatedHarvestDate'], '2026-09-01T00:00:00.000Z');
    });
  });

  group('igualdad y copia', () {
    test('dos cultivos con los mismos datos son iguales', () {
      expect(exampleCrop(), equals(exampleCrop()));
    });

    test('dos cultivos con los mismos datos comparten hashCode', () {
      final first = exampleCrop();
      final second = exampleCrop();

      expect(first.hashCode, equals(second.hashCode));
      expect({first, second}.length, 1);
    });

    test('dos cultivos con fotos distintas no son iguales', () {
      final first = exampleCrop(photos: const ['foto-a.jpg']);

      final second = exampleCrop(photos: const ['foto-b.jpg']);

      expect(first, isNot(equals(second)));
    });

    test('copyWith cambia solamente los datos indicados', () {
      final original = exampleCrop();

      final copy = original.copyWith(name: 'Arroz');

      expect(copy.name, 'Arroz');
      expect(copy.id, original.id);
      expect(copy.cropType, original.cropType);
      expect(copy.location, original.location);
      expect(copy.period, original.period);
      expect(copy.state, original.state);
      expect(copy.notes, original.notes);
      expect(copy.photos, original.photos);
    });
  });

  group('reglas de negocio', () {
    test('un cultivo con fotografías tiene evidencia', () {
      final crop = exampleCrop(photos: const ['foto-1.jpg']);

      expect(crop.hasPhotos, isTrue);
    });

    test('un cultivo en crecimiento puede ser cosechado', () {
      final crop = exampleCrop(state: Growing(DateTime.utc(2026, 7, 15)));

      expect(crop.canBeHarvested, isTrue);
    });

    test('un cultivo cuya fecha estimada ya pasó está vencido', () {
      final crop = exampleCrop();

      final now = DateTime.utc(2026, 9, 20);

      expect(crop.isOverdue(now), isTrue);
    });
  });
}

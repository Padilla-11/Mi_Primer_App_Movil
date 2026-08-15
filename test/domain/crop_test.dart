import 'dart:convert';

import 'package:flutter_application_1/core/json.dart';
import 'package:flutter_application_1/features/crops/domain/crop.dart';
import 'package:flutter_application_1/features/crops/domain/crop_period.dart';
import 'package:flutter_application_1/features/crops/domain/crop_state.dart';
import 'package:flutter_test/flutter_test.dart';

Crop exampleCrop({CropState? state}) => Crop(
  id: 'crop-001',
  name: 'Maíz amarillo',
  cropType: 'Corn',
  period: CropPeriod(
    plantingDate: DateTime.utc(2026, 7, 1),
    estimatedHarvestDate: DateTime.utc(2026, 9, 1),
  ),
  state: state ?? Planned(DateTime.utc(2026, 8, 14, 15, 30)),
  responsibleId: 'usr-001',
);

void main() {
  group('serialización', () {
    test('un cultivo sobrevive la ida y vuelta a JSON sin perder datos', () {
      final original = exampleCrop(
        state: Growing(
          DateTime.utc(2026, 8, 14, 14),
          'El cultivo presenta crecimiento uniforme y buen estado general.',
        ),
      );

      final text = jsonEncode(original.toJson());
      final decoded = jsonDecode(text) as Map<String, dynamic>;
      final result = Crop.fromJson(decoded);

      expect(result, equals(original));
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

    test('las fechas se conservan en UTC al serializar', () {
      final crop = exampleCrop();

      final json = crop.toJson();
      final period = json['period'] as Map<String, dynamic>;

      expect(period['estimatedHarvestDate'], '2026-09-01T00:00:00.000Z');
    });

    test('cada estado conserva sus datos al serializar y leer', () {
      final states = <CropState>[
        Planned(DateTime.utc(2026, 8, 14, 15, 30)),
        Growing(DateTime.utc(2026, 8, 14, 14), 'Crecimiento uniforme.'),
        Harvested(DateTime.utc(2026, 8, 10, 15), 1840),
      ];

      for (final state in states) {
        final crop = exampleCrop(state: state);
        final result = Crop.fromJson(
          jsonDecode(jsonEncode(crop.toJson())) as Map<String, dynamic>,
        );

        expect(result.state, equals(state));
      }
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

    test('dos cultivos con datos diferentes no son iguales', () {
      final first = exampleCrop();

      final second = Crop(
        id: 'crop-002',
        name: 'Tomate',
        cropType: 'Tomato',
        period: CropPeriod(
          plantingDate: DateTime.utc(2026, 7, 1),
          estimatedHarvestDate: DateTime.utc(2026, 10, 1),
        ),
        state: Planned(DateTime.utc(2026, 8, 14)),
        responsibleId: 'usr-002',
      );

      expect(first, isNot(equals(second)));
    });

    test('copyWith cambia solamente los datos indicados', () {
      final original = exampleCrop();

      final copy = original.copyWith(name: 'Arroz');

      expect(copy.name, 'Arroz');
      expect(copy.id, original.id);
      expect(copy.cropType, original.cropType);
      expect(copy.period, original.period);
      expect(copy.state, original.state);
      expect(copy.responsibleId, original.responsibleId);
    });
  });

  group('reglas de negocio', () {
    test('un cultivo en crecimiento puede ser cosechado', () {
      final crop = exampleCrop(
        state: Growing(DateTime.utc(2026, 8, 14), 'Crecimiento uniforme.'),
      );

      expect(crop.canBeHarvested, isTrue);
    });

    test('un cultivo planificado todavía no puede ser cosechado', () {
      final crop = exampleCrop(state: Planned(DateTime.utc(2026, 8, 20)));

      expect(crop.canBeHarvested, isFalse);
    });

    test('un cultivo cuya fecha estimada ya pasó está vencido', () {
      final crop = exampleCrop();

      final now = DateTime.utc(2026, 9, 20);

      expect(crop.isOverdue(now), isTrue);
    });

    test('un cultivo cuya fecha estimada no ha pasado no está vencido', () {
      final crop = exampleCrop();

      final now = DateTime.utc(2026, 8, 15);

      expect(crop.isOverdue(now), isFalse);
    });
  });
}

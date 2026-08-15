import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_application_1/core/json.dart';
import 'package:flutter_application_1/features/crops/data/crops_local.dart';
import 'package:flutter_test/flutter_test.dart';

const _json = '''
[
  {
    "id": "cult-001",
    "name": "Maíz híbrido Valledupar",
    "type": "Corn",
    "period": {
      "plantingDate": "2026-07-15T13:00:00Z",
      "estimatedHarvestDate": "2026-11-15T13:00:00Z"
    },
    "state": {
      "type": "growing",
      "lastInspection": "2026-08-14T14:00:00Z",
      "observations": "El cultivo presenta crecimiento uniforme y buen estado general."
    },
    "responsibleId": "usr-001"
  }
]
''';

void main() {
  test('lee la lista completa de cultivos', () async {
    final repository = CropsLocal(reader: (_) async => _json);

    final crops = await repository.getAll();

    expect(crops.length, 1);
    expect(crops.first.id, 'cult-001');
  });

  test('busca un cultivo por id', () async {
    final repository = CropsLocal(reader: (_) async => _json);

    final crop = await repository.getById('cult-001');

    expect(crop, isNotNull);
    expect(crop!.name, 'Maíz híbrido Valledupar');
  });

  test('devuelve null cuando el cultivo no existe', () async {
    final repository = CropsLocal(reader: (_) async => _json);

    final crop = await repository.getById('no-existe');

    expect(crop, isNull);
  });

  test('rechaza un archivo cuya raíz no es una lista', () async {
    final repository = CropsLocal(reader: (_) async => '{"id": "cult-001"}');

    expect(repository.getAll(), throwsA(isA<InvalidField>()));
  });

  test('el asset real existe y puede convertirse en cultivos', () async {
    TestWidgetsFlutterBinding.ensureInitialized();

    final repository = CropsLocal(reader: rootBundle.loadString);

    final crops = await repository.getAll();

    expect(crops.length, greaterThanOrEqualTo(3));
  });
}

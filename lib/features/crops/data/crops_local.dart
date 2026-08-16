import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_application_1/core/json.dart';
import 'package:flutter_application_1/features/crops/domain/crop.dart';
import 'package:flutter_application_1/features/crops/domain/crops_repository.dart';

/// Función utilizada para leer un archivo de assets.
///
/// Se inyecta para que las pruebas no dependan del bundle de Flutter.
typedef AssetReader = Future<String> Function(String path);

class CropsLocal implements CropsRepository {
  CropsLocal({AssetReader? reader, this.path = 'assets/data/crops.json'})
    : _reader = reader ?? rootBundle.loadString;

  final AssetReader _reader;
  final String path;

  List<Crop>? _cache;

  @override
  Future<List<Crop>> getAll() async {
    final cached = _cache;

    if (cached != null) {
      return cached;
    }

    final raw = await _reader(path);
    final decoded = jsonDecode(raw);

    if (decoded is! List) {
      throw const InvalidField('(root)', 'the file must contain a list', null);
    }

    final crops = decoded
        .map((item) => Crop.fromJson(item as Map<String, dynamic>))
        .toList(growable: false);

    _cache = crops;

    return crops;
  }

  @override
  Future<Crop?> getById(String id) async {
    for (final crop in await getAll()) {
      if (crop.id == id) {
        return crop;
      }
    }

    return null;
  }
}

import 'package:flutter_application_1/features/crops/domain/crop.dart';

/// Define las operaciones que la aplicación necesita para trabajar
/// con los cultivos.
///
/// La interfaz pertenece al dominio, por lo que no conoce si los datos
/// vienen de un archivo local, una API o Firestore.
abstract interface class CropsRepository {
  Future<List<Crop>> getAll();

  Future<Crop?> getById(String id);
}

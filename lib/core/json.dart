/// Lectura defensiva de mapas JSON.
///
/// Estas funciones validan los datos que llegan desde fuentes externas y
/// generan errores que indican exactamente qué campo es inválido.

/// Indica que un campo del JSON no tiene la forma esperada.
class InvalidField implements Exception {
  const InvalidField(this.field, this.reason, this.value);

  final String field;
  final String reason;
  final Object? value;

  @override
  String toString() => 'InvalidField: \'$field\' $reason (llegó: $value)';
}

/// Lee un texto obligatorio y no vacío.
String readText(Map<String, dynamic> json, String field) {
  final value = json[field];

  if (value is String && value.trim().isNotEmpty) {
    return value;
  }

  throw InvalidField(field, 'debe ser un texto no vacío', value);
}

/// Lee un texto opcional.
///
/// Un campo ausente y un campo con valor null se consideran equivalentes.
String? readOptionalText(Map<String, dynamic> json, String field) {
  final value = json[field];

  if (value == null) return null;

  if (value is String) return value;

  throw InvalidField(
    field,
    'debe ser un texto o venir ausente',
    value,
  );
}

/// Lee un número y lo convierte a double.
///
/// Se utiliza num porque JSON puede representar un número entero o decimal.
double readDecimal(Map<String, dynamic> json, String field) {
  final value = json[field];

  if (value is num) {
    return value.toDouble();
  }

  throw InvalidField(field, 'debe ser un número', value);
}

/// Lee un número entero.
int readInteger(Map<String, dynamic> json, String field) {
  final value = json[field];

  if (value is int) {
    return value;
  }

  throw InvalidField(field, 'debe ser un número entero', value);
}

/// Lee una fecha ISO 8601 y la normaliza a UTC.
DateTime readDate(Map<String, dynamic> json, String field) {
  final value = json[field];

  if (value is! String) {
    throw InvalidField(
      field,
      'debe ser una fecha ISO 8601 en texto',
      value,
    );
  }

  final date = DateTime.tryParse(value);

  if (date == null) {
    throw InvalidField(
      field,
      'no es una fecha ISO 8601',
      value,
    );
  }

  return date.toUtc();
}

/// Lee un objeto JSON como un mapa.
Map<String, dynamic> readMap(
  Map<String, dynamic> json,
  String field,
) {
  final value = json[field];

  if (value is Map<String, dynamic>) {
    return value;
  }

  throw InvalidField(field, 'debe ser un objeto', value);
}

/// Lee una lista de textos.
///
/// Si el campo no existe o es null, devuelve una lista vacía.
List<String> readStrings(
  Map<String, dynamic> json,
  String field,
) {
  final value = json[field];

  if (value == null) return const <String>[];

  if (value is! List) {
    throw InvalidField(field, 'debe ser una lista', value);
  }

  return List<String>.unmodifiable(
    value.map(
      (element) => element is String
          ? element
          : throw InvalidField(
              field,
              'todos sus elementos deben ser texto',
              element,
            ),
    ),
  );
}
/// Compara dos listas elemento a elemento.
///
/// En Dart, dos listas con el mismo contenido no son iguales usando ==.
/// Esta función permite comparar su contenido directamente.
bool listsEqual<T>(List<T> a, List<T> b) {
  if (identical(a, b)) return true;

  if (a.length != b.length) return false;

  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }

  return true;
}
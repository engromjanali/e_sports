class TypeConverterHelper {
    static bool readBool(dynamic value) {
    return value == true || value?.toString() == '1' || value?.toString().toLowerCase() == 'true';
  }

  static int? readInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }

  /// Reads a list of ints from either a JSON array (e.g. [1, 2, 3]) or a
  /// comma-separated string (e.g. "1,2,3").
  static List<int> readIntList(dynamic value) {
    if (value == null) return const [];
    if (value is List) {
      return value.map(readInt).whereType<int>().toList();
    }
    return value
        .toString()
        .split(',')
        .map((e) => readInt(e.trim()))
        .whereType<int>()
        .toList();
  }
}

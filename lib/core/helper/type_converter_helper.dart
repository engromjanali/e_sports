class TypeConverterHelper {
    static bool readBool(dynamic value) {
    return value == true || value?.toString() == '1' || value?.toString().toLowerCase() == 'true';
  }
}
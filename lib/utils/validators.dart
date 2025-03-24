// lib/utils/validators.dart
String? validateNotEmpty(String? value, String fieldName) {
  if (value == null || value.isEmpty) {
    return 'Please enter $fieldName';
  }
  return null;
}
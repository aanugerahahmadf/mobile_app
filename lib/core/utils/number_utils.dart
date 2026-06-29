double parseDouble(dynamic v, [double defaultValue = 0.0]) {
  if (v == null) return defaultValue;
  if (v is double) return v;
  if (v is int) return v.toDouble();
  if (v is String) return double.tryParse(v) ?? defaultValue;
  return defaultValue;
}

int parseInt(dynamic v, [int defaultValue = 0]) {
  if (v == null) return defaultValue;
  if (v is int) return v;
  if (v is double) return v.toInt();
  if (v is String) return int.tryParse(v) ?? defaultValue;
  return defaultValue;
}

int? parseIntNullable(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  if (v is double) return v.toInt();
  if (v is String) return int.tryParse(v);
  return null;
}

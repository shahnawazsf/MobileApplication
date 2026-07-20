/// Up to two uppercase initials from a display name, e.g. "Ahmed Al-Rashid" -> "AA".
/// Falls back to "?" when there's no usable name.
String initialsOf(String? name) {
  if (name == null || name.trim().isEmpty) return '?';
  final parts = name.trim().split(RegExp(r'\s+'));
  return parts.take(2).map((p) => p[0].toUpperCase()).join();
}

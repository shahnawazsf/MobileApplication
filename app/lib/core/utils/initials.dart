/// Up to two uppercase initials from a display name, e.g. "Ahmed Al-Rashid" -> "AA".
/// Falls back to "?" when there's no usable name.
String initialsOf(String? name) {
  if (name == null || name.trim().isEmpty) return '?'; // no usable name to initialize
  final parts = name.trim().split(RegExp(r'\s+')); // split on any run of whitespace, so extra spaces don't create empty parts
  return parts.take(2).map((p) => p[0].toUpperCase()).join(); // first letter of at most the first two words, uppercased
}

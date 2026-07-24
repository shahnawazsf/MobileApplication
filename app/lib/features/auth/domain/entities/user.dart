/// The signed-in user's identity as the rest of the app consumes it.
///
/// This is a "domain entity" — a plain, immutable data class that describes
/// what a User *means* to this app, independent of how the backend happens
/// to shape its JSON. AuthRepository is responsible for converting the raw
/// API response (see LoginResponseModel) into one of these.
class User {
  // Login form's typed user ID — not returned by the backend, threaded in by AuthRepository
  final String id;
  // Display name from the backend's "userName" field
  final String name;
  // Backend's "userGroupId" — the user's permission/role group
  final String groupId;
  // Backend's "userEmpCode" — employee code
  final String empCode;
  // Backend's "userDesc" — human-readable role description, e.g. "Administrator"
  final String description;

  // `const` constructor: since every field is `final`, instances can be
  // built at compile time and are safe to share/compare without worrying
  // about their fields changing later.
  const User({
    required this.id,
    required this.name,
    required this.groupId,
    required this.empCode,
    required this.description,
  });
}

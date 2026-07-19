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

  const User({
    required this.id,
    required this.name,
    required this.groupId,
    required this.empCode,
    required this.description,
  });
}

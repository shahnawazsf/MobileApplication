import 'package:freezed_annotation/freezed_annotation.dart'; // @freezed annotation and generated-class helpers
import '../../domain/entities/user.dart'; // User entity this model converts into

part 'login_response_model.freezed.dart'; // generated: copyWith/==/toString for LoginResponseModel
part 'login_response_model.g.dart'; // generated: fromJson/toJson for LoginResponseModel

@freezed // marks this class for code generation (immutability, copyWith, equality)
class LoginResponseModel with _$LoginResponseModel { // mixin brings in the generated implementation
  const LoginResponseModel._(); // private constructor required so we can add the toEntity() method below

  const factory LoginResponseModel({
    required bool success, // true/false flag the backend uses to signal login success, not HTTP status
    required String message, // human-readable message, e.g. "Administrator" on success or an error reason on failure
    String? token, // bearer token; currently always null — this backend doesn't issue one yet
    // Only guaranteed present on a successful login — a failure response may
    // return just success/message, so these must be nullable or fromJson
    // throws before the caller ever gets to check `success`.
    String? userName, // backend's "userName" — display name
    String? userGroupId, // backend's "userGroupId" — permission/role group
    String? userEmpCode, // backend's "userEmpCode" — employee code
    String? userDesc, // backend's "userDesc" — role description
    String? status, // backend's "status" field, e.g. "TRUE"/"FALSE" as a string
  }) = _LoginResponseModel; // the generated concrete implementation class

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) => // parses a decoded JSON map into this model
      _$LoginResponseModelFromJson(json); // delegates to the generated deserializer

  /// [loginUserId] is the ID typed into the login form — the response body
  /// doesn't include a stable user identifier, so the caller supplies it.
  /// Only meaningful when [success] is true.
  User toEntity(String loginUserId) => User( // maps this flat API response onto the app's domain User
        id: loginUserId, // use the typed-in login ID since the response has no id field
        name: userName ?? loginUserId, // fall back to the login ID if userName is somehow missing
        groupId: userGroupId ?? '', // empty string fallback keeps User's fields non-nullable
        empCode: userEmpCode ?? '',
        description: userDesc ?? '',
      );
}

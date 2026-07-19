// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

LoginResponseModel _$LoginResponseModelFromJson(Map<String, dynamic> json) {
  return _LoginResponseModel.fromJson(json);
}

/// @nodoc
mixin _$LoginResponseModel {
  bool get success => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  String? get token =>
      throw _privateConstructorUsedError; // Only guaranteed present on a successful login — a failure response may
  // return just success/message, so these must be nullable or fromJson
  // throws before the caller ever gets to check `success`.
  String? get userName => throw _privateConstructorUsedError;
  String? get userGroupId => throw _privateConstructorUsedError;
  String? get userEmpCode => throw _privateConstructorUsedError;
  String? get userDesc => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;

  /// Serializes this LoginResponseModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LoginResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LoginResponseModelCopyWith<LoginResponseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoginResponseModelCopyWith<$Res> {
  factory $LoginResponseModelCopyWith(
    LoginResponseModel value,
    $Res Function(LoginResponseModel) then,
  ) = _$LoginResponseModelCopyWithImpl<$Res, LoginResponseModel>;
  @useResult
  $Res call({
    bool success,
    String message,
    String? token,
    String? userName,
    String? userGroupId,
    String? userEmpCode,
    String? userDesc,
    String? status,
  });
}

/// @nodoc
class _$LoginResponseModelCopyWithImpl<$Res, $Val extends LoginResponseModel>
    implements $LoginResponseModelCopyWith<$Res> {
  _$LoginResponseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LoginResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? message = null,
    Object? token = freezed,
    Object? userName = freezed,
    Object? userGroupId = freezed,
    Object? userEmpCode = freezed,
    Object? userDesc = freezed,
    Object? status = freezed,
  }) {
    return _then(
      _value.copyWith(
            success: null == success
                ? _value.success
                : success // ignore: cast_nullable_to_non_nullable
                      as bool,
            message: null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String,
            token: freezed == token
                ? _value.token
                : token // ignore: cast_nullable_to_non_nullable
                      as String?,
            userName: freezed == userName
                ? _value.userName
                : userName // ignore: cast_nullable_to_non_nullable
                      as String?,
            userGroupId: freezed == userGroupId
                ? _value.userGroupId
                : userGroupId // ignore: cast_nullable_to_non_nullable
                      as String?,
            userEmpCode: freezed == userEmpCode
                ? _value.userEmpCode
                : userEmpCode // ignore: cast_nullable_to_non_nullable
                      as String?,
            userDesc: freezed == userDesc
                ? _value.userDesc
                : userDesc // ignore: cast_nullable_to_non_nullable
                      as String?,
            status: freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LoginResponseModelImplCopyWith<$Res>
    implements $LoginResponseModelCopyWith<$Res> {
  factory _$$LoginResponseModelImplCopyWith(
    _$LoginResponseModelImpl value,
    $Res Function(_$LoginResponseModelImpl) then,
  ) = __$$LoginResponseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool success,
    String message,
    String? token,
    String? userName,
    String? userGroupId,
    String? userEmpCode,
    String? userDesc,
    String? status,
  });
}

/// @nodoc
class __$$LoginResponseModelImplCopyWithImpl<$Res>
    extends _$LoginResponseModelCopyWithImpl<$Res, _$LoginResponseModelImpl>
    implements _$$LoginResponseModelImplCopyWith<$Res> {
  __$$LoginResponseModelImplCopyWithImpl(
    _$LoginResponseModelImpl _value,
    $Res Function(_$LoginResponseModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LoginResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? message = null,
    Object? token = freezed,
    Object? userName = freezed,
    Object? userGroupId = freezed,
    Object? userEmpCode = freezed,
    Object? userDesc = freezed,
    Object? status = freezed,
  }) {
    return _then(
      _$LoginResponseModelImpl(
        success: null == success
            ? _value.success
            : success // ignore: cast_nullable_to_non_nullable
                  as bool,
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        token: freezed == token
            ? _value.token
            : token // ignore: cast_nullable_to_non_nullable
                  as String?,
        userName: freezed == userName
            ? _value.userName
            : userName // ignore: cast_nullable_to_non_nullable
                  as String?,
        userGroupId: freezed == userGroupId
            ? _value.userGroupId
            : userGroupId // ignore: cast_nullable_to_non_nullable
                  as String?,
        userEmpCode: freezed == userEmpCode
            ? _value.userEmpCode
            : userEmpCode // ignore: cast_nullable_to_non_nullable
                  as String?,
        userDesc: freezed == userDesc
            ? _value.userDesc
            : userDesc // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: freezed == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LoginResponseModelImpl extends _LoginResponseModel {
  const _$LoginResponseModelImpl({
    required this.success,
    required this.message,
    this.token,
    this.userName,
    this.userGroupId,
    this.userEmpCode,
    this.userDesc,
    this.status,
  }) : super._();

  factory _$LoginResponseModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$LoginResponseModelImplFromJson(json);

  @override
  final bool success;
  @override
  final String message;
  @override
  final String? token;
  // Only guaranteed present on a successful login — a failure response may
  // return just success/message, so these must be nullable or fromJson
  // throws before the caller ever gets to check `success`.
  @override
  final String? userName;
  @override
  final String? userGroupId;
  @override
  final String? userEmpCode;
  @override
  final String? userDesc;
  @override
  final String? status;

  @override
  String toString() {
    return 'LoginResponseModel(success: $success, message: $message, token: $token, userName: $userName, userGroupId: $userGroupId, userEmpCode: $userEmpCode, userDesc: $userDesc, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoginResponseModelImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.userGroupId, userGroupId) ||
                other.userGroupId == userGroupId) &&
            (identical(other.userEmpCode, userEmpCode) ||
                other.userEmpCode == userEmpCode) &&
            (identical(other.userDesc, userDesc) ||
                other.userDesc == userDesc) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    success,
    message,
    token,
    userName,
    userGroupId,
    userEmpCode,
    userDesc,
    status,
  );

  /// Create a copy of LoginResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoginResponseModelImplCopyWith<_$LoginResponseModelImpl> get copyWith =>
      __$$LoginResponseModelImplCopyWithImpl<_$LoginResponseModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$LoginResponseModelImplToJson(this);
  }
}

abstract class _LoginResponseModel extends LoginResponseModel {
  const factory _LoginResponseModel({
    required final bool success,
    required final String message,
    final String? token,
    final String? userName,
    final String? userGroupId,
    final String? userEmpCode,
    final String? userDesc,
    final String? status,
  }) = _$LoginResponseModelImpl;
  const _LoginResponseModel._() : super._();

  factory _LoginResponseModel.fromJson(Map<String, dynamic> json) =
      _$LoginResponseModelImpl.fromJson;

  @override
  bool get success;
  @override
  String get message;
  @override
  String? get token; // Only guaranteed present on a successful login — a failure response may
  // return just success/message, so these must be nullable or fromJson
  // throws before the caller ever gets to check `success`.
  @override
  String? get userName;
  @override
  String? get userGroupId;
  @override
  String? get userEmpCode;
  @override
  String? get userDesc;
  @override
  String? get status;

  /// Create a copy of LoginResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoginResponseModelImplCopyWith<_$LoginResponseModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

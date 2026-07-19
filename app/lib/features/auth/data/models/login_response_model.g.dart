// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LoginResponseModelImpl _$$LoginResponseModelImplFromJson(
  Map<String, dynamic> json,
) => _$LoginResponseModelImpl(
  success: json['success'] as bool,
  message: json['message'] as String,
  token: json['token'] as String?,
  userName: json['userName'] as String?,
  userGroupId: json['userGroupId'] as String?,
  userEmpCode: json['userEmpCode'] as String?,
  userDesc: json['userDesc'] as String?,
  status: json['status'] as String?,
);

Map<String, dynamic> _$$LoginResponseModelImplToJson(
  _$LoginResponseModelImpl instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'token': instance.token,
  'userName': instance.userName,
  'userGroupId': instance.userGroupId,
  'userEmpCode': instance.userEmpCode,
  'userDesc': instance.userDesc,
  'status': instance.status,
};

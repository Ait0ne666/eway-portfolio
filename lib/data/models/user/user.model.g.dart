// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return UserModel(
    id: json['id'] as int?,
    name: json['name'] as String?,
    email_confirmed: json['email_confirmed'] as bool,
    email: json['email'] as String?,
    phone: json['phone'] as String,
    showWelcome: json['showWelcome'] as bool,
    avatarUrl: json['avatarUrl'] as String?,
  );
}

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'phone': instance.phone,
      'name': instance.name,
      'email': instance.email,
      'email_confirmed': instance.email_confirmed,
      'showWelcome': instance.showWelcome,
      'avatarUrl': instance.avatarUrl,
    };

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.model.g.dart';


@JsonSerializable()
class UserModel extends Equatable {
  final int? id;
  final String phone;
  final String? name;
  final String? email;
  final bool email_confirmed;
  final bool showWelcome;
  final String? avatarUrl;
  



  const UserModel({this.id, this.name, required this.email_confirmed, this.email, required this.phone, required this.showWelcome, this.avatarUrl});



  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel copyWith({

    int? id,
   String? phone,
   String? name,
   String? email,
   bool? email_confirmed,
   bool? showWelcome,
    String? avatarurl,
  
  }) {
    return UserModel(
      id: id?? this.id,
      email: email ?? this.email,
      email_confirmed:  email_confirmed ?? this.email_confirmed,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      showWelcome: showWelcome ?? this.showWelcome,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  @override
  List<Object?> get props => [id, email_confirmed, email, name, phone, showWelcome, avatarUrl];
  
}
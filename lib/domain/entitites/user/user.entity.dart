import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int? id;
  final String phone;
  final String? name;
  final String? email;
  final bool showWelcome;
  final bool email_confirmed;
  final bool aggreedToNews;
  final String? avatarUrl;
  



  const User({this.id, this.name, this.email, required this.email_confirmed, this.avatarUrl, required this.phone, required this.showWelcome, required this.aggreedToNews});



  User copyWith({

    int? id,
    String? email,
    String? name,
    String? phone,
    bool? email_confirmed,
    bool? showWelcome,
    String? avatarUrl,
    bool? aggreedToNews,
  }) {
    return User(
      id: id?? this.id,
      email_confirmed: email_confirmed ?? this.email_confirmed,
      email:  email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      showWelcome: showWelcome ?? this.showWelcome,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      aggreedToNews: aggreedToNews ?? this.aggreedToNews,
    );
  }

  @override
  List<Object?> get props => [id, name, phone, showWelcome, email_confirmed, email, avatarUrl, aggreedToNews];



}
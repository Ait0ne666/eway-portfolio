import 'package:lseway/data/models/user/user.model.dart';
import 'package:lseway/domain/entitites/user/user.entity.dart';

User mapModelToUser(UserModel model) {
  return User(
      showWelcome: model.showWelcome,
      email_confirmed: model.email_confirmed,
      phone: model.phone,
      name: model.name,
      email: model.email,
      id: model.id,
      avatarUrl: model.avatarUrl,
      aggreedToNews: model.aggreedToNews,
      endAt80: model.endAt80
      );
}

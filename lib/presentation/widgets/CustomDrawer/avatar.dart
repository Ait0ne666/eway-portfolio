import 'package:flutter/material.dart';
import 'package:lseway/domain/entitites/user/user.entity.dart';
import 'package:outline_gradient_button/outline_gradient_button.dart';

class CustomAvatar extends StatelessWidget {
  final User user;
  final Color? bg;
  const CustomAvatar({Key? key, required this.user, this.bg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // var users = user.copyWith(avatarUrl: 'https://i.pinimg.com/originals/33/85/f2/3385f2e1ae928f80fda6304ce36c6165.jpg');
    var users = user;
    return Container(
      width: 82,
      height: 82,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(45),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(225, 225, 225, 0.4),
              offset: Offset(0, 8),
              blurRadius: 26,
            )
          ]),
      child: OutlineGradientButton(
        radius: const Radius.circular(36.5),
        child: Container(
          width: 73,
          height: 73,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(36.5)),
          child: Center(
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  color: bg ?? const Color(0xffF0F1F6)),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: users.avatarUrl != null
                      ? Image.network(users.avatarUrl!, fit: BoxFit.cover,)
                      : Image.asset('assets/avatar.png'),
                      
                      ),
            ),
          ),
        ),
        strokeWidth: 4.5,
        gradient: users.avatarUrl != null
            ? const LinearGradient(
                colors: [Color(0xff7dd8b7), Color(0xff9ee193)],
                end: Alignment.topCenter,
                begin: Alignment.bottomCenter)
            : const LinearGradient(
                colors: [Color(0xffB2B6BC), Color(0xffCCD0DC)],
                end: Alignment.centerRight,
                begin: Alignment.centerLeft),
      ),
    );
  }
}

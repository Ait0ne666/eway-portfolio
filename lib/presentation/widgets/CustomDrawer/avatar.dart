import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lseway/core/toast/toast.dart';
import 'package:lseway/domain/entitites/user/user.entity.dart';
import 'package:lseway/presentation/bloc/user/user.bloc.dart';
import 'package:lseway/presentation/bloc/user/user.event.dart';
import 'package:lseway/presentation/bloc/user/user.state.dart';
import 'package:lseway/utils/UserAgent/user_agent.dart';
import 'package:outline_gradient_button/outline_gradient_button.dart';

class CustomAvatar extends StatefulWidget {
  final User user;
  final Color? bg;
  const CustomAvatar({Key? key, required this.user, this.bg}) : super(key: key);

  @override
  State<CustomAvatar> createState() => _CustomAvatarState();
}

class _CustomAvatarState extends State<CustomAvatar> {
  ImageProvider? avatar;

  @override
  void initState() {
    if (widget.user.avatarUrl != null) {
      var userAgent = UserAgentService.getUserAgent();
      avatar = NetworkImage(widget.user.avatarUrl!,
          headers: {'User-Agent': userAgent ?? ''});
    }

    super.initState();
  }

  @override
  void didUpdateWidget(oldWidget) {
    if (widget.user.avatarUrl != null &&
        widget.user.avatarUrl != oldWidget.user.avatarUrl) {
      var userAgent = UserAgentService.getUserAgent();
      avatar = NetworkImage(widget.user.avatarUrl!,
          headers: {'User-Agent': userAgent ?? ''});
    }

    super.didUpdateWidget(oldWidget);
  }

  void pickImage(String type) async {
    final picker = ImagePicker();
    FocusScope.of(context).requestFocus(new FocusNode());
    final pickedFile = await picker.getImage(
        source: type == 'camera' ? ImageSource.camera : ImageSource.gallery);
    Navigator.of(context).pop();
    if (pickedFile != null) {
      setState(() {
        avatar = FileImage(File(pickedFile.path));
      });
      String imagePath = pickedFile.path;
      BlocProvider.of<UserBloc>(context).add(UploadFile(filePath: imagePath));
    }
  }

  void changeAvatar() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: 200,
            child: Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: InkWell(
                      onTap: () => pickImage('camera'),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ShaderMask(
                            shaderCallback: (Rect bounds) {
                              return const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: <Color>[
                                  Color(0xff41C696),
                                  Color(0xff6BD15A)
                                ],
                                tileMode: TileMode.repeated,
                              ).createShader(bounds);
                            },
                            child: const Icon(
                              Icons.camera,
                              color: Colors.white,
                              size: 80,
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            "Камера",
                            style: TextStyle(
                                color: Color(0xff41C696), fontSize: 16),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                  Center(
                    child: InkWell(
                      onTap: () => pickImage('gallery'),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ShaderMask(
                            shaderCallback: (Rect bounds) {
                              return const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: <Color>[
                                  Color(0xff41C696),
                                  Color(0xff6BD15A)
                                ],
                                tileMode: TileMode.repeated,
                              ).createShader(bounds);
                            },
                            child: const Icon(
                              Icons.image,
                              color: Colors.white,
                              size: 80,
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            "Галерея",
                            style: TextStyle(
                                color: Color(0xff41C696), fontSize: 16),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        backgroundColor: Colors.white.withOpacity(0.9),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ));
  }

  void userListener(BuildContext context, UserState state) {
    if (state is AvatarUploadError) {
      Toast.showToast(context, state.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    // var users = user.copyWith(avatarUrl: 'https://i.pinimg.com/originals/33/85/f2/3385f2e1ae928f80fda6304ce36c6165.jpg');
    var users = widget.user;
    return BlocConsumer<UserBloc, UserState>(
        listener: userListener,
        builder: (context, state) {
          return InkWell(
            onTap: state is AvatarUploadingUserState ? () {} : changeAvatar,
            child: Container(
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
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(36.5)),
                  child: Stack(
                    children: [
                      Center(
                          child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 32,
                        foregroundImage:
                            avatar ?? const AssetImage('assets/avatar.png'),
                      )),
                      state is AvatarUploadingUserState
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(32),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                child: Container(
                                  width: 66,
                                  height: 66,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(33)),
                                ),
                              ),
                            )
                          : const SizedBox()
                    ],
                  ),
                ),
                strokeWidth: 4.5,
                gradient: avatar != null
                    ? const LinearGradient(
                        colors: [Color(0xff7dd8b7), Color(0xff9ee193)],
                        end: Alignment.topCenter,
                        begin: Alignment.bottomCenter)
                    : const LinearGradient(
                        colors: [Color(0xffB2B6BC), Color(0xffCCD0DC)],
                        end: Alignment.centerRight,
                        begin: Alignment.centerLeft),
              ),
            ),
          );
        });
  }
}

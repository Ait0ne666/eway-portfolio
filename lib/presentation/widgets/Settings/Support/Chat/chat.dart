import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:intl/intl.dart';
import 'package:lseway/domain/entitites/chat/message.entity.dart';
import 'package:lseway/presentation/bloc/chat/chat.bloc.dart';
import 'package:lseway/presentation/bloc/chat/chat.event.dart';
import 'package:lseway/presentation/bloc/chat/chat.state.dart';
import 'package:lseway/presentation/bloc/user/user.bloc.dart';
import 'package:lseway/presentation/widgets/Settings/Support/Chat/message.dart';
import 'package:lseway/utils/utils.dart';

class ChatWidget extends StatefulWidget {
  const ChatWidget({Key? key}) : super(key: key);

  @override
  _ChatWidgetState createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    BlocProvider.of<ChatBloc>(context).add(LoadChat());
    super.initState();
  }

  void onSend() {
    var text = _controller.value.text;

    if (text.isEmpty) return;

    var userId = BlocProvider.of<UserBloc>(context).state.user!.id!;

    Message messageToSend = Message(
      createdAt: DateTime.now(),
      senderId: userId,
      text: text,
      status: MessageStatus.NOT_SENT,
    );
    _controller.value = const TextEditingValue(text: '');
    BlocProvider.of<ChatBloc>(context).add(SendMessage(message: messageToSend));
  }

  String getDateString(DateTime date) {
    DateFormat format = DateFormat('d MMMM', 'ru');
    if (isSameDay(date, DateTime.now())) {
      return 'Сегодня';
    } else {
      return format.format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: BlocBuilder<ChatBloc, ChatState>(builder: (context, state) {
      if (state is ChatLoadingState || state.chat == null) {
        return Container(
          child: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.error),
            ),
          ),
        );
      }
      var manager = state.chat!.manager;
      var messages = state.chat!.messages;
      messages.sort((a, b) {
        if (a.createdAt.isBefore(b.createdAt)) return 1;
        if (b.createdAt.isBefore(a.createdAt)) return -1;
        return 0;
      });
      return Column(
        children: [
          Container(
            padding:
                const EdgeInsets.only(left: 24, right: 10, top: 10, bottom: 10),
            constraints: const BoxConstraints(minHeight: 82),
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                      offset: Offset(0, 8),
                      blurRadius: 26,
                      color: Color.fromRGBO(247, 247, 247, 0.3))
                ]),
            child: Row(
              children: [
                Container(
                  width: 62,
                  height: 62,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(31),
                        child: Container(
                          width: 62,
                          height: 62,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(31)),
                          child: Image.asset('assets/manager.png'),
                        ),
                      ),
                      Positioned(
                        bottom: 3,
                        right: 1,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.all(3),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7),
                                gradient: manager.online
                                    ? const LinearGradient(
                                        colors: [
                                            Color(0xff41C696),
                                            Color(0xff6BD15A),
                                          ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight)
                                    : const LinearGradient(
                                        colors: [
                                            Color(0xffE01E1D),
                                            Color(0xffF41D25),
                                          ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight)),
                            width: 13,
                            height: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'На связи менеджер',
                      style: TextStyle(
                          fontFamily: 'Circe',
                          fontSize: 16,
                          color: Color(0xffADAFBB)),
                    ),
                    Text(
                      manager.name,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          ?.copyWith(fontSize: 20),
                    )
                  ],
                )),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.only(bottom: 20),
              itemBuilder: (context, index) {
                var user = BlocProvider.of<UserBloc>(context).state.user;

                var message = messages[index];

                var isMessageFromUser = message.senderId == user?.id;

                return MessageWidget(
                  isMessageFromUser: isMessageFromUser,
                  message: message,
                  manager: manager,
                );
              },
              separatorBuilder: (context, index) {
                if (messages[index].createdAt.day !=
                    messages[index + 1].createdAt.day) {
                  return Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 22),
                      child: Text(
                        getDateString(messages[index].createdAt),
                        style: const TextStyle(
                            fontFamily: 'Circe',
                            fontSize: 16,
                            color: Color(0xffADAFBB)),
                      ),
                    ),
                  );
                }

                return const SizedBox(
                  height: 18,
                );
              },
              itemCount: messages.length,
              physics: BouncingScrollPhysics(),
              reverse: true,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height * 0.07),
            child: Container(
                width: double.infinity,
                height: 58,
                decoration: BoxDecoration(
                    border:
                        Border.all(width: 1.5, color: const Color(0xffE0E0EB)),
                    borderRadius: BorderRadius.circular(100),
                    color: const Color(0xffEAEAF2),
                    boxShadow: const [
                      BoxShadow(
                          offset: Offset(0, 8),
                          blurRadius: 26,
                          color: Color.fromRGBO(247, 247, 247, 0.3))
                    ]),
                child: Neumorphic(
                  style: NeumorphicStyle(
                    color: Colors.transparent,
                    boxShape: NeumorphicBoxShape.roundRect(
                        BorderRadius.circular(100)),
                    depth: -3,
                    shadowDarkColorEmboss: Colors.white.withOpacity(0.3),
                    shadowLightColorEmboss: Colors.white.withOpacity(0.3),
                  ),
                  child: Container(
                    padding: const EdgeInsets.only(
                        top: 6, left: 26, right: 8, bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                            child: TextFormField(
                          focusNode: focusNode,
                          autofocus: false,
                          controller: _controller,
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            fontSize: 16,
                            color: const Color(0xff1A1D21),
                            fontWeight: FontWeight.normal,
                            height: 1,
                            fontFamily: 'Circe',
                            decoration: TextDecoration.none,
                          ),
                          maxLines: 1,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Ваше сообщение...',
                            hintStyle:
                                Theme.of(context).textTheme.bodyText1?.copyWith(
                                    fontSize: 16,
                                    color: const Color(
                                      0xffADAFBB,
                                    ),
                                    fontWeight: FontWeight.normal,
                                    height: 1),
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                          ),
                          cursorColor: const Color(0xff1A1D21),
                          cursorWidth: 1,
                        )),
                        const SizedBox(
                          width: 5,
                        ),
                        InkWell(
                          onTap: onSend,
                          child: Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(23),
                                color: const Color(0xffEAEAF2),
                                boxShadow: const [
                                  BoxShadow(
                                      offset: Offset(0, 8),
                                      blurRadius: 26,
                                      color: Color.fromRGBO(247, 247, 247, 0.3))
                                ]),
                            child: Image.asset(
                              'assets/send.png',
                              width: 46,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
          )
        ],
      );
    }));
  }
}

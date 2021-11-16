import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:lseway/domain/entitites/chat/chat.entity.dart';
import 'package:lseway/domain/entitites/chat/message.entity.dart';
import 'package:lseway/presentation/bloc/user/user.bloc.dart';

class MessageWidget extends StatelessWidget {
  final Message message;
  final bool isMessageFromUser;
  final Manager manager;
  final DateFormat format = DateFormat('HH:mm');
  MessageWidget(
      {Key? key,
      required this.isMessageFromUser,
      required this.message,
      required this.manager})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var user = BlocProvider.of<UserBloc>(context).state.user;
    return Align(
      alignment:
          isMessageFromUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7 - 25,
            minWidth: 0),
        padding:
            const EdgeInsets.only(left: 23, right: 13, top: 24, bottom: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(25),
            topRight: const Radius.circular(25),
            bottomLeft: isMessageFromUser
                ? const Radius.circular(25)
                : const Radius.circular(0),
            bottomRight: isMessageFromUser
                ? const Radius.circular(0)
                : const Radius.circular(25),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: Text(
                  isMessageFromUser ? user?.name ?? '' : manager.name,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      ?.copyWith(fontSize: 16),
                )),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  format.format(message.createdAt),
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      ?.copyWith(fontSize: 13, color: const Color(0xff898D93)),
                )
              ],
            ),
            const SizedBox(
              height: 2,
            ),
            Text(message.text,
                textAlign: TextAlign.start,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    ?.copyWith(fontSize: 15, color: const Color(0xff171E2F))),
            const SizedBox(
              height: 2,
            ),
            isMessageFromUser
                ? AnimatedCrossFade(
                    firstChild: const Align(
                      alignment: Alignment.topRight,
                      child: Icon(
                        Icons.schedule_outlined,
                        color: Colors.grey,
                        size: 15,
                      ),
                    ),
                    secondChild: Align(
                        alignment: Alignment.topRight,
                        child: SvgPicture.asset(
                          'assets/sent.svg',
                        )),
                    crossFadeState: message.status == MessageStatus.NOT_SENT
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    duration: Duration(milliseconds: 200),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}

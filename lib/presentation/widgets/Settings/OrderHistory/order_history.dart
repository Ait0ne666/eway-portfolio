import 'dart:math' as Math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:lseway/core/toast/toast.dart';
import 'package:lseway/domain/entitites/history/history.entity.dart';
import 'package:lseway/presentation/bloc/history/history.bloc.dart';
import 'package:lseway/presentation/bloc/history/history.event.dart';
import 'package:lseway/presentation/bloc/history/history.state.dart';
import 'package:lseway/presentation/widgets/Core/GreenContainer/green_container.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({Key? key}) : super(key: key);

  @override
  _OrderHistoryState createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  @override
  void initState() {
    BlocProvider.of<HistoryBloc>(context).add(FetchHistory());
    super.initState();
  }

  void handleBill(HistoryItem item) async {
    var link = item.refundReceiptUrl ?? item.receiptUrl;
   
    if (link != null) {

      if (await canLaunch(link)) {
        launch(link);
      } else {
        Toast.showToast(context, 'Невозможно открыть ссылку');
      }
    } else {
      Toast.showToast(context, 'Чек станет доступен позднее');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryBloc, HistoryState>(builder: (context, state) {
      if (state is HistoryInitialState) {
        return const Expanded(
          child: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xffF41D25)),
            ),
          ),
        );
      } else if (state.history.isEmpty) {
        return Expanded(
          child: Center(
              child: Container(
            padding: const EdgeInsets.only(bottom: 80),
            child: Text(
              'У вас пока не было заказов',
              style:
                  Theme.of(context).textTheme.bodyText2?.copyWith(fontSize: 16),
            ),
          )),
        );
      } else {
        var items = [...state.history];

        items.sort((a, b) {
          if (a.date.isBefore(b.date)) return 1;
          if (b.date.isBefore(a.date)) return -1;
          return 0;
        });

        return Expanded(
          child: ListView.separated(
              padding: const EdgeInsets.only(bottom: 20),
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                var item = items[index];
                var dateFormat = DateFormat('dd.MM.yyyy');
                var timeFormat = DateFormat('HH:mm');

                var mod = item.amount % 100;

                var format = NumberFormat.currency(
                    locale: 'ru_RU',
                    symbol: '',
                    decimalDigits: mod == 0 ? 0 : 2);

                return Container(
                  // height: 87,
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                      top: 10, left: 24, right: 10, bottom: 10),
                  decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: [Color(0xffffffff), Color(0xf9faffff)],
                          stops: [0.7, 0.9],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight),
                      borderRadius: BorderRadius.circular(13)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              item.address,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  ?.copyWith(fontSize: 17),
                            ),
                            const SizedBox(
                              height: 9,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Center(
                                    child: SvgPicture.asset(
                                        'assets/calendar.svg')),
                                const SizedBox(width: 5),
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(dateFormat.format(item.date),
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1
                                          ?.copyWith(fontSize: 16, height: 1)),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  width: 3,
                                  height: 3,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(2),
                                      color: Color(0xffB6B8C2)),
                                ),
                                const SizedBox(width: 9),
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    timeFormat.format(item.date),
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1
                                        ?.copyWith(fontSize: 16, height: 1),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      const SizedBox(width: 5),
                      InkWell(
                        onTap: () => handleBill(item),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          height: 62,
                          width: 72,
                          decoration: BoxDecoration(
                              color: const Color(0xffEDEDF3),
                              borderRadius: BorderRadius.circular(11)),
                          child: Center(
                            child: Image.asset('assets/bill.png', width: 24),
                          ),
                        ),
                      ),
                      const SizedBox(width: 7),
                      GreenContainer(
                          borderRadius: 11,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            height: 62,
                            width: 72,
                            child: Center(
                              child: FittedBox(
                                child: Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: format.format(item.amount),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2
                                            ?.copyWith(
                                              fontSize: 19,
                                              color: Colors.white,
                                            ),
                                      ),
                                      TextSpan(
                                        text: '₽',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            ?.copyWith(
                                                fontSize: 19,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w800),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ))
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(
                  height: 18,
                );
              },
              itemCount: state.history.length),
        );
      }
    });
  }
}

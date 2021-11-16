import 'dart:async';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lseway/presentation/bloc/booking/booking.bloc.dart';
import 'package:lseway/presentation/bloc/booking/booking.event.dart';
import 'package:lseway/presentation/bloc/history/history.bloc.dart';
import 'package:lseway/presentation/bloc/history/history.event.dart';
import 'package:lseway/presentation/bloc/payment/payment.bloc.dart';
import 'package:lseway/presentation/bloc/payment/payment.event.dart';
import 'package:lseway/presentation/bloc/points/points.bloc.dart';
import 'package:lseway/presentation/bloc/points/points.event.dart';
import 'package:lseway/presentation/bloc/user/user.bloc.dart';
import 'package:lseway/presentation/bloc/user/user.event.dart';
import 'package:lseway/presentation/bloc/user/user.state.dart';

import 'package:lseway/presentation/navigation/app_router.dart';
import 'package:lseway/presentation/navigation/main_router.dart';
import 'package:uni_links/uni_links.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _appKey = GlobalKey<NavigatorState>();
  Timer? timer;
  StreamSubscription? _uniLinksSub;

  @override
  void initState() {
    // timer = Timer.periodic(const Duration(minutes: 5), (timer) {
    //   handleRefresh();
    // });
    super.initState();
    initUniLinks();
    BlocProvider.of<PaymentBloc>(context).add(FetchCards());
    BlocProvider.of<HistoryBloc>(context).add(FetchHistory());
    BlocProvider.of<BookingBloc>(context).add(CheckBookings());
    BlocProvider.of<PointsBloc>(context).add(FetchChargingPoint());
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp
    ]);
  }

  Future<void> initUniLinks() async {
    try {
      _uniLinksSub = linkStream.listen((String? link) {
        if (link == 'lseway://emailconfirmation') {
          AppRouter.router.navigateTo(context, '/email/success',
              transition: TransitionType.cupertino);
        }
      });
    } catch (err) {}
  }

  @override
  void dispose() {
    timer?.cancel();
    if (_uniLinksSub != null) {
      _uniLinksSub?.cancel();
    }
    super.dispose();
  }

  void handleRefresh() {
    BlocProvider.of<UserBloc>(context).add(RefreshToken());
  }

  Future<bool> didPopRoute() {
    final NavigatorState? navigator = _appKey.currentState;
    assert(navigator != null);

    return navigator!.maybePop();
  }

  void authListener(BuildContext context, UserState state) {
    if (state is UserUnauthorizedState) {
      MainRouter.router.navigateTo(context, '/login',
          clearStack: true, transition: TransitionType.cupertino);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return !await didPopRoute();
      },
      child: BlocListener<UserBloc, UserState>(
        listener: authListener,
        child: Navigator(
          key: _appKey,
          onGenerateRoute: AppRouter.router.generator,
          initialRoute: '/',
        ),
      ),
    );
  }
}

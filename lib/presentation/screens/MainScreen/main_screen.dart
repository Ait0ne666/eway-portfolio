import 'dart:async';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lseway/core/toast/toast.dart';
import 'package:lseway/data/data-sources/user/user_local_data_source.dart';
import 'package:lseway/domain/entitites/charge/charge_ended_result.dart';
import 'package:lseway/domain/repositories/user/user.repository.dart';
import 'package:lseway/presentation/bloc/booking/booking.bloc.dart';
import 'package:lseway/presentation/bloc/booking/booking.event.dart';
import 'package:lseway/presentation/bloc/charge/charge.bloc.dart';
import 'package:lseway/presentation/bloc/charge/charge.event.dart';
import 'package:lseway/presentation/bloc/charge/charge.state.dart';
import 'package:lseway/presentation/bloc/history/history.bloc.dart';
import 'package:lseway/presentation/bloc/history/history.event.dart';
import 'package:lseway/presentation/bloc/payment/payment.bloc.dart';
import 'package:lseway/presentation/bloc/payment/payment.event.dart';
import 'package:lseway/presentation/bloc/pointInfo/pointInfo.event.dart';
import 'package:lseway/presentation/bloc/pointInfo/pointinfo.bloc.dart';
import 'package:lseway/presentation/bloc/points/points.bloc.dart';
import 'package:lseway/presentation/bloc/points/points.event.dart';
import 'package:lseway/presentation/bloc/user/user.bloc.dart';
import 'package:lseway/presentation/bloc/user/user.event.dart';
import 'package:lseway/presentation/bloc/user/user.state.dart';

import 'package:lseway/presentation/navigation/app_router.dart';
import 'package:lseway/presentation/navigation/main_router.dart';
import 'package:lseway/presentation/notifications/push_notifications.dart';
import 'package:lseway/presentation/widgets/ChargeResultModal/charge_result_modal.dart';
import 'package:lseway/presentation/widgets/Main/Map/Point/Charge/charge_80_dialog.dart';
import 'package:uni_links/uni_links.dart';
import '../../../injection_container.dart' as di;

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _appKey = GlobalKey<NavigatorState>();
  Timer? timer;
  Timer? timerForData;
  StreamSubscription? _uniLinksSub;
  late UserRepository userRepository;

  @override
  void initState() {
    // timer = Timer.periodic(const Duration(minutes: 5), (timer) {
    //   handleRefresh();
    // });
    userRepository = di.sl<UserRepository>();
    timer = Timer(Duration(milliseconds: 4000), () {
      BlocProvider.of<ChargeBloc>(context).add(FetchUnpaidCharge());
    });
    super.initState();
    initUniLinks();
    initDynamicLinks();

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
              transition: TransitionType.inFromLeft);
        }
      });
    } catch (err) {}
  }

  void initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData? dynamicLink) async {
      final Uri? deepLink = dynamicLink?.link;

      if (deepLink != null) {
        var queryParams = deepLink.queryParameters;
        if (queryParams.containsKey("point_number")) {
          var pointId = queryParams["point_number"] ?? '';

          Timer(Duration(milliseconds: 1000), () {
            BlocProvider.of<PointInfoBloc>(context)
                .add(ShowPoint(pointId: int.parse(pointId)));
          });
        }
      }
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });

    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;

    if (deepLink != null) {
      var queryParams = deepLink.queryParameters;
      if (queryParams.containsKey("point_number")) {
        var pointId = queryParams["point_number"] ?? '';

        Timer(Duration(milliseconds: 4000), () {
          BlocProvider.of<PointInfoBloc>(context)
              .add(ShowPoint(pointId: int.parse(pointId)));
        });
      }
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    timerForData?.cancel();
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

  void showChargeResultScreen(ChargeEndedResult result) {
    Future(() => showGeneralDialog(
          context: context,
          useRootNavigator: true,
          // useSafeArea: false,
          barrierDismissible: false,
          barrierColor: Color(0x00ffffff),

          transitionDuration: Duration(milliseconds: 300),
          pageBuilder: (context, anim1, anim2) {
            return Dialog(
                insetPadding: EdgeInsets.zero,
                backgroundColor: Color(0x00ffffff),
                child: SingleChildScrollView(
                  child: Container(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height,
                    ),
                    width: MediaQuery.of(context).size.width,
                    color: Color(0x00ffffff),
                    child: Stack(
                      children: [
                        Opacity(
                          opacity: anim1.value,
                          child: Container(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            color: Colors.white.withOpacity(0),
                          ),
                        ),
                        Container(
                          constraints: BoxConstraints(
                            minHeight: MediaQuery.of(context).size.height,
                          ),
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 80),
                          child: ChargeResultModal(
                            result: result,
                          ),
                        )
                      ],
                    ),
                  ),
                ));
          },
          transitionBuilder: (context, anim1, anim2, child) {
            return Transform.translate(
              offset: Offset(
                  0, (1 - anim1.value) * MediaQuery.of(context).size.height),
              child: WillPopScope(
                onWillPop: () async {
                  return false;
                  // return true;
                },
                child: Dialog(
                  insetPadding: EdgeInsets.zero,
                  backgroundColor: Color(0x00ffffff),
                  child: SingleChildScrollView(
                    child: Container(
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height,
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: Stack(
                        children: [
                          Container(
                            constraints: BoxConstraints(
                              minHeight: MediaQuery.of(context).size.height,
                            ),
                            width: MediaQuery.of(context).size.width,
                            color: Colors.transparent,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 80),
                            child: ChargeResultModal(
                              result: result,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ));
  }

  void chargeListener(BuildContext context, ChargeState state) {
    if (state is ChargeEndedState) {
      var result = state.result;

      showChargeResultScreen(result);
    } else if (state is ChargeEndedRemotelyState) {
      var result = state.result;

      showChargeResultScreen(result);
    } else if (state is ChargeEndedAutomaticState) {
      var result = state.result;

      showChargeResultScreen(result);
    } else if (state is UnpaidChargeState) {
      var result = state.result;

      showChargeResultScreen(result);
    } else if (state is ChargeInProgressState) {
      
      if (state.progress?.progress != null &&
          (state.progress!.progress! >= 80) 
          ) {
        show80Dialog(state.progress!.pointId);
      }
    }
  }

  void show80Dialog(int pointId) {
      var phone = BlocProvider.of<UserBloc>(context).state.user!.phone;
      var shown = userRepository.stopChargeAt80DialogShown(phone);

      if (!shown) {
        Navigator.of(context).popUntil((route) {
          print(route.settings.name);

          return route.settings.name == '/main';
        });
        showCharge80Dialog(context, pointId, dontPop: true);
      }

  }

  @override
  Widget build(BuildContext context) {
    return PushNotificationsProvider(
      child: WillPopScope(
        onWillPop: () async {
          return !await didPopRoute();
        },
        child: BlocListener<ChargeBloc, ChargeState>(
          listener: chargeListener,
          child: BlocListener<UserBloc, UserState>(
            listener: authListener,
            child: Navigator(
              key: _appKey,
              onGenerateRoute: AppRouter.router.generator,
              initialRoute: '/',
            ),
          ),
        ),
      ),
    );
  }
}

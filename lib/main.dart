import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:lseway/domain/use-cases/booking/booking_use_case.dart';
import 'package:lseway/domain/use-cases/charge/charge_use_case.dart';
import 'package:lseway/presentation/bloc/activePoints/active_points_bloc.dart';
import 'package:lseway/presentation/bloc/booking/booking.bloc.dart';
import 'package:lseway/presentation/bloc/charge/charge.bloc.dart';
import 'package:lseway/presentation/bloc/history/history.bloc.dart';
import 'package:lseway/presentation/bloc/nearestPoints/nearest_points.bloc.dart';
import 'package:lseway/presentation/bloc/payment/payment.bloc.dart';
import 'package:lseway/presentation/bloc/pointInfo/pointinfo.bloc.dart';
import 'package:lseway/presentation/bloc/points/points.bloc.dart';
import 'package:lseway/presentation/bloc/topplaces/top_places.bloc.dart';
import 'package:lseway/presentation/bloc/user/user.event.dart';
import 'package:lseway/presentation/bloc/user/user.state.dart';
import 'package:lseway/presentation/navigation/app_router.dart';
import 'package:lseway/presentation/navigation/main_router.dart';
import 'package:lseway/presentation/widgets/global.dart';
import "./injection_container.dart" as di;
import "presentation/bloc/user/user.bloc.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Paint.enableDithering = true;
  MainRouter.setupRouter();
  AppRouter.setupRouter();
  await initializeDateFormatting();
  await Hive.initFlutter();
  await Hive.openBox('session');
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ChargeBloc chargeBloc;
  late ActivePointsBloc activePointsBloc;
  late BookingBloc bookingBloc;

  @override
  void initState() {
    activePointsBloc = ActivePointsBloc();

    chargeBloc = ChargeBloc(
        usecase: di.sl<ChargeUseCase>(), activePointsBloc: activePointsBloc);
    bookingBloc = BookingBloc(
        usecase: di.sl<BookingUseCase>(), activePointsBloc: activePointsBloc);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.sl<UserBloc>(),
        ),
        BlocProvider(
          create: (_) => di.sl<PointsBloc>(),
        ),
        BlocProvider(
          create: (_) => di.sl<PointInfoBloc>(),
        ),
        BlocProvider(
          create: (_) => di.sl<HistoryBloc>(),
        ),
        BlocProvider(
          create: (_) => di.sl<TopPlacesBloc>(),
        ),
        BlocProvider(
          create: (_) => di.sl<PaymentBloc>(),
        ),
        BlocProvider(
          create: (_) => activePointsBloc,
        ),
        BlocProvider(
          create: (_) => chargeBloc,
        ),
        BlocProvider(
          create: (_) => bookingBloc,
        ),
        BlocProvider(
          create: (_) => di.sl<NearestPointsBloc>(),
        ),
      ],
      child: MaterialApp(
        navigatorKey: NavigationService.navigatorKey,
        title: 'E-way',
        theme: ThemeData(
            primaryColor: const Color(0xffF7F7FA),
            colorScheme: const ColorScheme(
                primary: Color(0xffF7F7FA),
                background: Color(0xffF7F7FA),
                brightness: Brightness.light,
                error: Color(0xffF41D25),
                onBackground: Color(0xffE01E1D),
                onError: Colors.white,
                onPrimary: Color(0xff1A1D21),
                onSecondary: Color(0xff1A1D21),
                secondary: Color(0xffF0F1F6),
                secondaryVariant: Color(0xffF0F1F6),
                primaryVariant: Colors.white,
                surface: Color(0xff2B2727),
                onSurface: Color(0xff41C696)),
            visualDensity: VisualDensity.adaptivePlatformDensity,
            textTheme: const TextTheme(
              headline4: TextStyle(
                  fontSize: 27,
                  color: Color(0xff1A1D21),
                  fontFamily: 'URWGeometricExt'),
              headline5: TextStyle(
                  fontSize: 25,
                  color: Color(0xff1A1D21),
                  fontFamily: 'URWGeometricExt'),
              bodyText2: TextStyle(
                  fontSize: 24,
                  color: Color(0xff1A1D21),
                  fontWeight: FontWeight.normal,
                  fontFamily: 'URWGeometricExt'),
              button: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Circe'),
              subtitle1: TextStyle(
                  color: Color(0xffB6B8C2), fontSize: 15, fontFamily: 'Circe'),
              overline: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: Colors.white),
              headline6: TextStyle(
                  color: Color(0xff1A1D21),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontFamily: 'Circe'),
              subtitle2: TextStyle(
                  fontSize: 18,
                  color: Color(0xff1A1D21),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Circe'),
              bodyText1: TextStyle(
                  fontSize: 16,
                  color: Color(0xffADAFBB),
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Circe'),
            )),
        onGenerateRoute: MainRouter.router.generator,
        home: const LoadingScreen(),
      ),
    );
  }
}

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<UserBloc>(context).add(CheckAuth());
  }

  void authListener(BuildContext context, UserState state) {
    if (state is UserAuthorizedState) {
      MainRouter.router.navigateTo(context, '/main',
          clearStack: true, transition: TransitionType.none);
    } else if (state is UserUnauthorizedState) {
      MainRouter.router.navigateTo(context, '/login',
          transition: TransitionType.cupertino, clearStack: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: authListener,
      child: Scaffold(
        backgroundColor: const Color(0xffF7F7FA),
        body: Center(
          child: Image.asset('assets/logo.png'),
        ),
      ),
    );
  }
}

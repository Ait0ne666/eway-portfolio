import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lseway/domain/entitites/filter/filter.dart';
import 'package:lseway/presentation/bloc/charge/charge.bloc.dart';
import 'package:lseway/presentation/bloc/charge/charge.event.dart';
import 'package:lseway/presentation/bloc/history/history.bloc.dart';
import 'package:lseway/presentation/bloc/history/history.state.dart';
import 'package:lseway/presentation/bloc/payment/payment.bloc.dart';
import 'package:lseway/presentation/bloc/pointInfo/pointInfo.event.dart';
import 'package:lseway/presentation/bloc/pointInfo/pointInfo.state.dart';
import 'package:lseway/presentation/bloc/pointInfo/pointinfo.bloc.dart';
import 'package:lseway/presentation/widgets/AnimatedBattery/animated_battery.dart';
import 'package:lseway/presentation/widgets/Main/Map/Point/Charge/charge_80_dialog.dart';
import 'package:lseway/presentation/widgets/Main/Map/Point/Charge/charge_view.dart';
import 'package:lseway/presentation/widgets/Main/Map/Point/NoPaymentMethodsDialog/no_payment_methods_dialog.dart';
import 'package:lseway/presentation/widgets/Main/Map/Point/point_content.dart';
import 'package:lseway/presentation/widgets/Main/Map/geolocation.dart';
import 'package:lseway/presentation/widgets/global.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../../../../../injection_container.dart' as di;

int? currentPointShown;

void showPoint(BuildContext context, int pointId, bool isActive) {
  if ( currentPointShown != pointId) {
    if (currentPointShown != null ) {
      Navigator.of(context).pop();
    }
    currentPointShown = pointId;
    showMaterialModalBottomSheet(
        context: context,
        barrierColor: const Color.fromRGBO(38, 38, 50, 0.2),
        backgroundColor: Colors.transparent,
        useRootNavigator: true,
        builder: (dialogContext) {
          return isActive
              ? ChargeView(
                  pointId: pointId,
                )
              : PointView(
                  pointId: pointId,
                  parentCtx: context,
                );
        }).then((value) {
          currentPointShown = null;
      if (isActive) {
        var currentPercent =
            BlocProvider.of<ChargeBloc>(context).state.progress?.progress;
        if (currentPercent == 100) {
          BlocProvider.of<ChargeBloc>(context)
              .add(StopChargeAutomatic(pointId: pointId));
        }
      }
    });
  }
  // showCharge80Dialog(context, pointId);
}

class PointView extends StatefulWidget {
  final int pointId;
  final BuildContext parentCtx;
  const PointView({Key? key, required this.pointId, required this.parentCtx})
      : super(key: key);

  @override
  _PointViewState createState() => _PointViewState();
}

class _PointViewState extends State<PointView> {
  ConnectorTypes? _connector;
  late GeolocatorService geolocatorService;

  @override
  void initState() {
    geolocatorService = di.sl<GeolocatorService>();
    super.initState();
    BlocProvider.of<PointInfoBloc>(context)
        .add(LoadPoint(pointId: widget.pointId));
  }

  void showCharge(BuildContext ctx, bool dissmissPrev) {
    if (dissmissPrev) {
      Navigator.of(ctx, rootNavigator: true)
          .popUntil((route) => route.settings.name == '/main');
    }
    showMaterialModalBottomSheet(
        context: context,
        barrierColor: const Color.fromRGBO(38, 38, 50, 0.2),
        backgroundColor: Colors.transparent,
        builder: (dialogContext) {
          return ChargeView(
            pointId: widget.pointId,
          );
        }).then((value) {
      var globalContext = NavigationService.navigatorKey.currentContext;
      if (globalContext != null) {
        var currentPercent =
            BlocProvider.of<ChargeBloc>(globalContext).state.progress?.progress;
        if (currentPercent == 100) {
          BlocProvider.of<ChargeBloc>(globalContext)
              .add(StopChargeAutomatic(pointId: widget.pointId));
        }
      }
    });
  }

  double calculateTopPadding(BuildContext context, double height) {
    if (MediaQuery.of(context).size.height -
            MediaQuery.of(context).padding.vertical >
        height + 20) {
      return MediaQuery.of(context).size.height - height - 20;
    }

    return 135;
  }

  @override
  Widget build(BuildContext context) {
    var padding = calculateTopPadding(context, 780);
    return ConstrainedBox(
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Stack(
            children: [
              Container(
                // color: const Color.fromRGBO(38, 38, 50, 0.2),
                padding: EdgeInsets.only(
                    top: padding, bottom: 20, left: 20, right: 20),
                child: GestureDetector(
                  onTap: () {},
                  child: BlocBuilder<HistoryBloc, HistoryState>(
                      builder: (context, state) {
                    var shouldShowBook = state.history.isNotEmpty;
                    return Container(
                      height: shouldShowBook ? 725 : 670,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.white),
                      child: BlocBuilder<PointInfoBloc, PointInfoState>(
                          builder: (context, state) {
                        var currentPointExist =
                            state.points.containsKey(widget.pointId);

                        if (!currentPointExist) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).colorScheme.onSurface),
                                ),
                              ),
                            ],
                          );
                        }

                        var point = state.points[widget.pointId]!;
                        return Material(
                            color: Colors.transparent,
                            child: PointContent(
                              point: point,
                              geolocatorService: geolocatorService,
                              ctx: widget.parentCtx,
                              charge: showCharge,
                              shouldShowBooking: shouldShowBook,
                            ));
                      }),
                    );
                  }),
                ),
              ),
              Positioned(
                child: Center(
                  child: Image.asset('assets/point.png',
                      height: 1335 / 3.5, width: 876 / 3.5),
                ),
                top: (padding - 135) + 10,
                right: 0,
              ),
              Positioned(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xffECEDF2)),
                  width: 34,
                  height: 4,
                ),
                top: (padding - 135) + 153,
                left: MediaQuery.of(context).size.width / 2 - 17,
              ),
              // AnimatedBattery()
            ],
          ),
        ),
      ),
    );
  }
}

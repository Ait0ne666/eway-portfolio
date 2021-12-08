import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lseway/presentation/bloc/pointInfo/pointInfo.event.dart';
import 'package:lseway/presentation/bloc/pointInfo/pointinfo.bloc.dart';

import 'package:lseway/presentation/bloc/topplaces/top_places.bloc.dart';
import 'package:lseway/presentation/bloc/topplaces/top_places.event.dart';
import 'package:lseway/presentation/bloc/topplaces/top_places.state.dart';
import 'package:lseway/presentation/widgets/global.dart';

class TopPlaces extends StatefulWidget {
  const TopPlaces({Key? key}) : super(key: key);

  @override
  _TopPlacesState createState() => _TopPlacesState();
}

class _TopPlacesState extends State<TopPlaces> {
  @override
  void initState() {
    BlocProvider.of<TopPlacesBloc>(context).add(FetchTTopPlaces());

    super.initState();
  }

  void showPoint(int pointId) {
    // var globalCtx = NavigationService.navigatorKey.currentContext;
    // if (globalCtx != null) {
    //   Navigator.of(globalCtx).popUntil((route) {
    //     print(route.settings.name);

    //     return route.settings.name == '/main';
    //   });
    // }
    // Navigator.of(context).popUntil((route) {
    //   print(route.settings.name);

    //   return route.settings.name == '/';
    // });
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    BlocProvider.of<PointInfoBloc>(context).add(ShowPoint(pointId: pointId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TopPlacesBloc, TopPlacesState>(
        builder: (context, state) {
      if (state is TopPlacesInitialState) {
        return const Expanded(
          child: Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 80),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xffF41D25)),
              ),
            ),
          ),
        );
      } else if (state.topPlaces.isEmpty) {
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
        return Expanded(
          child: ListView.separated(
              padding: const EdgeInsets.only(bottom: 20),
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                var item = state.topPlaces[index];

                return InkWell(
                  onTap: () => showPoint(item.id),
                  child: Container(
                    // height: 87,
                    width: double.infinity,
                    padding: const EdgeInsets.only(
                        top: 10, left: 0, right: 10, bottom: 10),
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
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Image.asset(
                            'assets/green-star.png',
                            width: 68,
                          ),
                        ),
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
                                    ?.copyWith(fontSize: 19),
                              ),
                              Text(
                                item.city,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    ?.copyWith(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 5),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(
                  height: 18,
                );
              },
              itemCount: state.topPlaces.length),
        );
      }
    });
  }
}

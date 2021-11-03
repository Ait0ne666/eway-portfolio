import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lseway/domain/entitites/filter/filter.dart';
import 'package:lseway/presentation/bloc/points/points.bloc.dart';
import 'package:lseway/presentation/bloc/points/points.event.dart';
import 'package:lseway/presentation/bloc/points/points.state.dart';
import 'package:lseway/presentation/widgets/Core/CustomButton/custom_button.dart';
import 'package:lseway/presentation/widgets/Filter/FilterModal/filter_modal.dart';
import 'package:lseway/presentation/widgets/IconButton/icon_button.dart';

class CustomFilter extends StatelessWidget {
  const CustomFilter({Key? key}) : super(key: key);

  void openFilters(BuildContext context, Filter filter) {
    Future(() => showDialog(
        context: context,
        useRootNavigator: true,
        useSafeArea: false,
        builder: (dialogContext) {
          return Dialog(
            insetPadding: EdgeInsets.zero,
            child: FilterModal(
              filter: filter,
            ),
          );
        })).then((value) {
      if (value is Filter && !value.isEqual(filter)) {
        showFilterSaveDialog(context);
      }
    });
  }

  void showFilterSaveDialog(BuildContext context) {
    Future(() => showDialog(
        context: context,
        barrierDismissible: true,
        useRootNavigator: true,
        barrierColor: const Color.fromRGBO(38, 38, 50, 0.2),
        builder: (dialogContext) {
          return SimpleDialog(
            backgroundColor: Theme.of(context).colorScheme.primaryVariant,
            insetPadding: const EdgeInsets.all(20),
            contentPadding: EdgeInsets.all(0),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            elevation: 2,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 500),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20, top: 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/graphRed.png', width: 226/3, height: 80),
                          
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: Center(
                              child: Text(
                                'Хотите сохранить выбор в фильтре по-умолчанию?',
                                style: Theme.of(context).textTheme.bodyText2,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 45,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 53),
                            child: CustomButton(
                              text: 'Нет, спасибо',
                              type: ButtonTypes.SECONDARY,
                              onPress: () {
                                Navigator.of(dialogContext).pop();
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 19,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 53),
                            child: CustomButton(
                              text: 'Да, хочу',
                              onPress: () {
                                Navigator.of(dialogContext, rootNavigator: true)
                                    .pop(true);
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      top: 21,
                      right: 21,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(dialogContext, rootNavigator: true)
                              .pop();
                        },
                        child: SvgPicture.asset('assets/close.svg'),
                      ),
                    )
                  ],
                ),
              )
            ],
          );
        })).then((value) {
          if (value == true) {
            BlocProvider.of<PointsBloc>(context).add(SaveCurrentFilter());
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PointsBloc, PointsState>(builder: (context, state) {
      var filter = state.filter;
      return Stack(
        children: [
          CustomIconButton(
              onTap: () => openFilters(context, filter),
              icon: Image.asset(
                'assets/filter.png',
                width: 18,
                height: 19,
              )),
          state.filter.numberOfFilledFields > 0
              ? Positioned(
                  right: 0,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(
                          colors: [Color(0xffE01E1D), Color(0xffF41D25)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight),
                    ),
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: RadialGradient(
                          colors: [
                            Colors.white.withOpacity(0.0),
                            Colors.white.withOpacity(0.5),
                          ],
                          center: AlignmentDirectional(0.0, 0.0),
                          stops: [0.8, 1],
                        ),
                      ),
                      child: Center(
                          child: Text(
                        state.filter.numberOfFilledFields.toString(),
                        style: TextStyle(color: Colors.white, fontSize: 11),
                      )),
                    ),
                  ))
              : const SizedBox()
        ],
      );
    });
  }
}

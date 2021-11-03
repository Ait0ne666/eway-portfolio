import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lseway/presentation/bloc/topplaces/top_places.bloc.dart';
import 'package:lseway/presentation/widgets/CustomAppBar/custom_profile_bar.dart';
import 'package:lseway/presentation/widgets/Settings/TopPlaces/top_places.dart';
import '../../../../injection_container.dart' as di;


class TopPlacesScreen extends StatelessWidget {
  const TopPlacesScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
              
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xffF0F1F6),
      body: Container(
        padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: MediaQuery.of(context).viewPadding.top + 30),
        child: Column(
          children: const [
            CustomProfileBar(title: 'Топ мест', isCentered: true,),
            SizedBox(
              height: 52,
            ),
            TopPlaces()
          ],
        ),
      ),
    );
  }
}
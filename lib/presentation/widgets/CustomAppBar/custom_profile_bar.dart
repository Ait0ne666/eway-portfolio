import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lseway/presentation/widgets/IconButton/icon_button.dart';

class CustomProfileBar extends StatelessWidget {
  final String title; 
  final bool? isCentered;
  const CustomProfileBar({Key? key, required this.title, this.isCentered}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
                color: Color.fromRGBO(247, 247, 247, 0.3),
                blurRadius: 26,
                offset: Offset(0, 8))
          ]),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomIconButton(icon: SvgPicture.asset('assets/arrow-black.svg'), onTap: () {
                Navigator.of(context).pop();
              },
              diameter: 62,),
              isCentered == true ?
              Expanded(
              
                child: Text(title, style: Theme.of(context).textTheme.bodyText2?.copyWith(fontSize: 18), textAlign: TextAlign.center,))
                :
                Text(title, style: Theme.of(context).textTheme.bodyText2?.copyWith(fontSize: 18),),
              
               SizedBox(width: isCentered == true ? 0 : 62)
            ],
          ),
    );
  }
}

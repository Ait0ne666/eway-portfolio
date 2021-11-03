import 'package:flutter/material.dart';

class DrawerItem extends StatelessWidget {

  final Widget icon;
  final String title;
  final void Function() onTap;


  const DrawerItem({ Key? key, required this.icon, required this.onTap, required this.title }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          height: 56,
          width: double.infinity,
          padding: const EdgeInsets.only(right: 23, ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            boxShadow: const [
              BoxShadow(
                offset: Offset(0,8),
                blurRadius: 26,
                color: Color.fromRGBO(247, 247, 247, 0.3)
              )
            ],
            color: Colors.white
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
                Container(
                  width: 59,
                  child: Center(child: icon,),
                ),
                Text(title, style: Theme.of(context).textTheme.bodyText2?.copyWith(fontSize: 16),)
            ],
          ),
      ),
    );
  }
}
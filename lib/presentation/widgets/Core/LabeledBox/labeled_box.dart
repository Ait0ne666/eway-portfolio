import 'package:flutter/material.dart';

class LabeledBox extends StatelessWidget {
  final double? width;
  final double? height;
  final String label;
  final Widget text;
  final Widget icon;
  final double? paddingRight;

  const LabeledBox(
      {Key? key,
      required this.label,
      required this.text,
      this.height,
      this.width,
      required this.icon,
      this.paddingRight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height ?? 68,
      padding: EdgeInsets.only(left: 0, right: paddingRight ?? 22),
      decoration: BoxDecoration(
        color: Color(0xffF6F6FA),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
              width: 46,
              child: Align(alignment: Alignment.center, child: icon)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                // const SizedBox(
                //   height: 5,
                // ),
                text
              ],
            ),
          ),
        ],
      ),
    );
  }
}

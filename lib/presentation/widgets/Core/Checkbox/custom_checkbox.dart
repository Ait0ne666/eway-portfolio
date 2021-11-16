import 'package:flutter/material.dart';

class CustomCheckbox extends StatelessWidget {
  final void Function() onToggle;
  final String label;
  final bool checked;
  final double? size;
  final bool? reverse;
  final double? fontSize;
  const CustomCheckbox(
      {Key? key,
      required this.checked,
      required this.label,
      this.size,
      this.reverse,
      this.fontSize,
      required this.onToggle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onToggle,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: Container(
          child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: reverse == true
            ? [
                Container(
                  width: size ?? 53,
                  height: size ?? 53,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(27),
                    color: Colors.white,
                  ),
                  child: AnimatedSwitcher(
                    switchInCurve: Curves.easeInOut,
                    switchOutCurve: Curves.easeInOut,
                    child: checked
                        ? Image.asset('assets/check-large.png', width: 23)
                        : const SizedBox(),
                    duration: const Duration(milliseconds: 300),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Container(
                    
                    child: Text(
                      label,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          ?.copyWith(fontSize: fontSize ?? 20),
                    ),
                  ),
                ),
              ]
            : [
                Container(
                  width: 264,
                  child: Text(
                    label,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        ?.copyWith(fontSize: fontSize ?? 20),
                  ),
                ),
                Container(
                  width: size ?? 53,
                  height: size ?? 53,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(27),
                    color: Colors.white,
                  ),
                  child: AnimatedSwitcher(
                    switchInCurve: Curves.easeInOut,
                    switchOutCurve: Curves.easeInOut,
                    child: checked
                        ? Image.asset('assets/check-large.png', width: 23)
                        : const SizedBox(),
                    duration: const Duration(milliseconds: 300),
                  ),
                )
              ],
      )),
    );
  }
}

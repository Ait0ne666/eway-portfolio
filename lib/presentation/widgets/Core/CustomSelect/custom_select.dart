import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SelectOption<T> {
  T value;
  String label;
  Widget? icon;

  SelectOption({required this.value, required this.label, this.icon});
}

class CustomSelect<T> extends StatelessWidget {
  final T value;
  final void Function(T selected) onChange;
  final List<SelectOption<T>> options;
  final String label;
  final Widget icon;
  final double? width;
  final double? height;
  final Color? bgColor;
  final double? iconWidth;
  final double? paddingRight;
  final bool? blackCaret;
  const CustomSelect(
      {Key? key,
      required this.onChange,
      required this.value,
      required this.options,
      required this.label,
      required this.icon,
      this.height,
      this.width,
      this.bgColor,
      this.blackCaret,
      this.iconWidth,
      this.paddingRight})
      : super(key: key);

  void openPicker(BuildContext context) {
    Picker(
        adapter: PickerDataAdapter<T>(
            data: options
                .map((option) => PickerItem(
                      text: Center(child: Text(option.label)),
                      value: option.value,
                    ))
                .toList()),
        hideHeader: false,
        // confirm: TextButton(child: Text('Выбрать'), onPressed: () {},),
        confirmText: 'Выбрать',
        confirmTextStyle:
            TextStyle(color: Theme.of(context).colorScheme.onSecondary),
        cancelText: 'Отменить',
        itemExtent: 50,
        cancelTextStyle:
            TextStyle(color: Theme.of(context).colorScheme.onSecondary),
        onConfirm: (Picker picker, List value) {
          var selectedIndex = value[0];
          onChange(options[selectedIndex].value);
        }).showModal(context);
  }

  @override
  Widget build(BuildContext context) {
    var selectedOption = options.length > 0 ? options.firstWhere((opt) => opt.value == value) : null;

    return InkWell(
      onTap: options.length > 1 ? () => openPicker(context) : null,
      child: Container(
        width: width ?? double.infinity,
        height: height ?? 68,
        padding: EdgeInsets.only(left: 0, right: paddingRight ?? 28),
        decoration: BoxDecoration(
          color: bgColor ?? Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
                width: iconWidth ?? 55,
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
                  Text(
                    selectedOption!=null ? selectedOption.label : '',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ],
              ),
            ),
            options.length> 1 ? blackCaret == true ? SvgPicture.asset('assets/chevron-down.svg') : SvgPicture.asset('assets/caret-down.svg') : const SizedBox()
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:lseway/presentation/widgets/Core/Checkbox/custom_checkbox.dart';

class ChargeEndSwitcher extends StatefulWidget {
  const ChargeEndSwitcher({Key? key}) : super(key: key);

  @override
  _ChargeEndSwitcherState createState() => _ChargeEndSwitcherState();
}

class _ChargeEndSwitcherState extends State<ChargeEndSwitcher> {
  bool checked = false;

  void toggleCharge() {
    setState(() {
      checked = !checked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomCheckbox(
        checked: checked,
        label: 'Заканчивать зарядку при 80% заряда ',
        onToggle: toggleCharge);
  }
}

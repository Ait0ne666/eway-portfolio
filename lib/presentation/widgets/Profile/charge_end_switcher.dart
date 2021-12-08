import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lseway/core/toast/toast.dart';
import 'package:lseway/presentation/bloc/user/user.bloc.dart';
import 'package:lseway/presentation/bloc/user/user.event.dart';
import 'package:lseway/presentation/bloc/user/user.state.dart';
import 'package:lseway/presentation/widgets/Core/Checkbox/custom_checkbox.dart';

class ChargeEndSwitcher extends StatefulWidget {
  const ChargeEndSwitcher({Key? key}) : super(key: key);

  @override
  _ChargeEndSwitcherState createState() => _ChargeEndSwitcherState();
}

class _ChargeEndSwitcherState extends State<ChargeEndSwitcher> {


  @override
  void initState() {
    var endAt80 = BlocProvider.of<UserBloc>(context).state.user!.endAt80;
    checked = endAt80;

    super.initState();
  }

  bool checked = false;

  void toggleCharge() {
    var newValue = !checked;
    var phone = BlocProvider.of<UserBloc>(context).state.user!.phone;
    BlocProvider.of<UserBloc>(context)
        .add(Toggle80Percent(phone: phone, aggree: newValue));

    setState(() {
      checked = newValue;
    });
  }

  void toggle80Listener(BuildContext context, UserState state) {
    if (state is Toggle80ErrorState) {
      Toast.showToast(context, state.message);
      setState(() {
        checked = state.user!.endAt80;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: toggle80Listener,
      child: CustomCheckbox(
          checked: checked,
          label: 'Заканчивать зарядку при 80% заряда ',
          onToggle: toggleCharge),
    );
  }
}

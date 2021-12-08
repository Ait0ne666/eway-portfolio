class DialogState {

  final bool is80DialogShown;

  DialogState({required this.is80DialogShown});

}


class DialogInitialState extends DialogState {

  DialogInitialState(): super(is80DialogShown: false);

}


class DialogToggleState extends DialogState {

  DialogToggleState({required bool is80DialogShown}): super(is80DialogShown: is80DialogShown);

}
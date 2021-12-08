import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lseway/presentation/bloc/dialog/dialog.event.dart';
import 'package:lseway/presentation/bloc/dialog/dialog.state.dart';

class DialogBloc extends Bloc<DialogEvent, DialogState> {


  DialogBloc() : super(DialogInitialState()) {
    on<Toggle80Dialog>((event, emit) async {
      

      
      emit(DialogToggleState(is80DialogShown: event.shown));
    });

  }
}
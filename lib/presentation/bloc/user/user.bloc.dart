import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lseway/domain/entitites/user/user.entity.dart';
import 'package:lseway/domain/use-cases/user/user.use-case.dart';
import 'package:lseway/presentation/bloc/user/user.event.dart';
import 'package:lseway/presentation/bloc/user/user.state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {


  final UserUseCase useCase;



  User? user;

  UserBloc({required this.useCase}):super(const UserInitialState());


  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
      if (event is CheckAuth) {
        var result = await useCase.checkAuthorization();

        if (result != null) {
          user = result;
          yield UserAuthorizedState(user: user);
        } else {
          yield const UserUnauthorizedState();
        }
      } else  if (event is Toggle80Percent) {
          
          var result = await useCase.toggleEndAt80(event.aggree, event.phone);

          yield* result.fold((failure) async* {
            yield Toggle80ErrorState(message: failure.message, user: user);
          }, (result) async* {
            user = user!.copyWith(endAt80: result);
            yield Toggle80SuccessUserState(user: user);
          });
      }
       else  if (event is RegisterUser) {
          yield UserLoadingState(user: user);

          var result = await useCase.register(phone: event.phone, email: event.email, name: event.name, surname: event.surname, password: event.password);

          yield* result.fold((failure) async* {
            yield UserRegisterErrorState(message: failure.message, user: user);
          }, (success) async* {
            
            yield const UserRegisterSuccess();
          });
      } else  if (event is LoginUserWithEmail) {
          yield UserLoadingState(user: user);

          var result = await useCase.loginWithEmail(event.email, event.password);

          yield* result.fold((failure) async* {
            yield UserLoginWithEmailErrorState(message: failure.message, user: user);
          }, (result) async* {
            user = result;
            yield UserAuthorizedState(user: user);
          });
      } else if (event is Logout) {
          useCase.logout();
          user = null;
          yield const  UserUnauthorizedState();        
      } else if (event is RefreshToken) {
        useCase.refreshToken();
      } else if (event is RequestPhoneConfirmation) {
        yield UserLoadingState(user: user);


          var result = await useCase.requestPhoneConfirmation(event.phone);

          yield* result.fold((failure) async* {
            yield UserConfirmationCodeSentErrorState(message: failure.message, user: user);
          }, (result) async* {
            
            yield UserConfirmationCodeSentState(phone: result.message!);
          });
      } else if (event is ConfirmPhone) {
        yield UserConfirmingState(user: user);
          var result = await useCase.confirmPhone(event.phone, event.code);

          yield* result.fold((failure) async* {
            yield UserCodeConfirmationErrorState(message: failure.message, user: user);
          }, (result) async* {
            user = result;
            yield UserAuthorizedState(user: user);
          });
      } else if (event is ChangeName) {
          yield UserChangingState(user: user);
          var result = await useCase.changeName(event.name);

          yield* result.fold((failure) async* {
            yield UserChangeErrorState(message: failure.message, user: user);
          }, (result) async* {
            user = user?.copyWith(name: result);
            yield UserChangedState(user: user);
          });
      } else if (event is ChangeEmail) {
         yield UserChangingState(user: user);
          var result = await useCase.changeEmail(event.email, event.aggree);

          yield* result.fold((failure) async* {
            yield UserChangeErrorState(message: failure.message, user: user);
          }, (result) async* {
            user = user?.copyWith(email: result, email_confirmed: false, aggreedToNews: event.aggree);
            yield UserChangedState(user: user);
          });
      } else  if (event is ApplyForResetWithEmail) {
          yield UserLoadingState(user: user);
          var result = await useCase.resetAccess(email : event.email);

          yield* result.fold((failure) async* {
            yield ResetSendEmailErrorState(message: failure.message, user: user);
          }, (result) async* {
            
            yield ResetSendEmailSuccessState(user: user, email: result);
          });
      } else  if (event is ConfirmResetEmail) {
          yield UserLoadingState(user: user);
          var result = await useCase.confirmReset(email : event.email, code: event.code);

          yield* result.fold((failure) async* {
            yield ResetConfirmEmailErrorState(message: failure.message, user: user);
          }, (result) async* {
            
            yield ResetConfrimEmailSuccessState(user: user, email: result);
          });
      } else  if (event is SetNewPhoneEvent) {
          yield UserLoadingState(user: user);
          var result = await useCase.setNewPhone(email : event.email, phone: event.phone);

          yield* result.fold((failure) async* {
            yield ResetSetnewPhoneErrorState(message: failure.message, user: user);
          }, (result) async* {
            
            yield ResetSetnewPhoneSuccessState(user: user, email: result.email, phone: result.phone);
          });
           
      } else  if (event is ConfirmNewPhoneEvent) {
          yield UserLoadingState(user: user);
          var result = await useCase.confirmNewPhone(email : event.email, phone: event.phone, code: event.code);

          yield* result.fold((failure) async* {
            yield ResetConfirmNewPhoneErrorState(message: failure.message, user: user);
          }, (result) async* {
            
            yield UserAuthorizedState(user: user);
          });
      } else  if (event is UploadFile) {
          yield AvatarUploadingUserState(user: user);
          var result = await useCase.uploadFile(event.filePath);

          yield* result.fold((failure) async* {
            yield AvatarUploadError(message: failure.message, user: user);
          }, (result) async* {
            user = user!.copyWith(avatarUrl: result);
            yield AvatarUploadedUserState(user: user);
          });
      } 
       

  }

}
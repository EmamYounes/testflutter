import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginWithGoogleEvent>(_loginWithGoogle);
  }

  Future<void> _loginWithGoogle(
      LoginWithGoogleEvent event, Emitter<LoginState> emit) async {
    try {
      emit(LoginLoading());

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        emit(LoginError("Login cancelled"));
        return;
      }

      final GoogleSignInAuthentication auth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: auth.accessToken,
        idToken: auth.idToken,
      );

      UserCredential result =
      await FirebaseAuth.instance.signInWithCredential(credential);

      emit(LoginSuccess(result.user!));
    } catch (e) {
      emit(LoginError(e.toString()));
    }
  }
}
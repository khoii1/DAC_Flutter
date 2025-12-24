import 'package:firebase_auth/firebase_auth.dart';
import 'package:vipt/app/core/values/app_strings.dart';
import 'package:vipt/app/data/models/vipt_user.dart';
import 'package:vipt/app/data/providers/auth_provider.dart' as vipt_auth;
import 'package:vipt/app/data/providers/user_provider.dart';
import 'package:vipt/app/enums/app_enums.dart';

class AuthService {
  AuthService._privateConstructor();
  static final AuthService instance = AuthService._privateConstructor();

  final vipt_auth.AuthProvider _authProvider = vipt_auth.AuthProvider();
  final UserProvider _userProvider = UserProvider();

  SignInType _loginType = SignInType.none;
  User? get currentUser => FirebaseAuth.instance.currentUser;
  bool get isLogin => currentUser == null ? false : true;
  Future<bool> isHasData() async =>
      await _userProvider.checkIfUserExist(currentUser!.uid);
  SignInType get loginType => _loginType;

  Future<dynamic> signInWithEmail({
    required String email,
    required String password,
  }) async {
    _loginType = SignInType.withEmail;

    try {
      return await _authProvider.signInWithEmailPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case FirebaseExceptionString.operationNotAllow:
          return FirebaseExceptionString
              .exeception[FirebaseExceptionString.operationNotAllow];
        case FirebaseExceptionString.invalidCode:
          return FirebaseExceptionString
              .exeception[FirebaseExceptionString.invalidCode];
        case FirebaseExceptionString.invalidVerficationID:
          return FirebaseExceptionString
              .exeception[FirebaseExceptionString.invalidVerficationID];
        case FirebaseExceptionString.invalidCredential:
          return FirebaseExceptionString
              .exeception[FirebaseExceptionString.invalidCredential];
        case FirebaseExceptionString.diffCredential:
          return FirebaseExceptionString
              .exeception[FirebaseExceptionString.diffCredential];
        case FirebaseExceptionString.userDisable:
          return FirebaseExceptionString
              .exeception[FirebaseExceptionString.userDisable];
        case FirebaseExceptionString.userNotFound:
          return FirebaseExceptionString
              .exeception[FirebaseExceptionString.userNotFound];
        case FirebaseExceptionString.wrongPassword:
          return FirebaseExceptionString
              .exeception[FirebaseExceptionString.wrongPassword];
        default:
          return e.message ?? 'Đã xảy ra lỗi';
      }
    }
  }

  Future<dynamic> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    _loginType = SignInType.withEmail;

    try {
      return await _authProvider.signUpWithEmailPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case FirebaseExceptionString.operationNotAllow:
          return FirebaseExceptionString
              .exeception[FirebaseExceptionString.operationNotAllow];
        case 'email-already-in-use':
          return 'Email này đã được sử dụng';
        case 'weak-password':
          return 'Mật khẩu quá yếu (tối thiểu 6 ký tự)';
        case 'invalid-email':
          return 'Email không hợp lệ';
        default:
          return e.message ?? 'Đã xảy ra lỗi';
      }
    }
  }

  Future<void> signOut() async {
    // Email/password doesn't need separate sign out
    return await vipt_auth.AuthProvider().signOutFirebase();
  }

  Future<bool> checkIfUserExist(String uid) {
    return _userProvider.checkIfUserExist(uid);
  }

  Future<ViPTUser> createViPTUser(ViPTUser user) async {
    return await _userProvider.add(user);
  }
}

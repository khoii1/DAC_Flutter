import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vipt/app/core/values/colors.dart';
import 'package:vipt/app/data/services/auth_service.dart';
import 'package:vipt/app/data/services/data_service.dart';
import 'package:vipt/app/routes/pages.dart';

class AuthenticationController extends GetxController {

  Future<void> handleSignInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final dynamic result = await AuthService.instance.signInWithEmail(
        email: email,
        password: password,
      );

      if (result != null) {
        if (result is! String) {
          _handleSignInSucess(result);
        } else {
          _handleSignInFail(result);
        }
      }
    } catch (e) {
      _handleSignInFail(e.toString());
    }
  }

  Future<void> handleSignUpWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final dynamic result = await AuthService.instance.signUpWithEmail(
        email: email,
        password: password,
      );

      if (result != null) {
        if (result is! String) {
          _handleSignInSucess(result);
        } else {
          _handleSignInFail(result);
        }
      }
    } catch (e) {
      _handleSignInFail(e.toString());
    }
  }

  Future<bool> _checkUserExistence(String uid) async {
    return await AuthService.instance.checkIfUserExist(uid);
  }

  void _handleSignInSucess(UserCredential result) async {
    // Đợi user token được refresh để Firestore nhận diện authentication
    await result.user!.reload();
    await Future.delayed(const Duration(milliseconds: 100));
    
    // KHÔNG clear dữ liệu khi đăng nhập lại - dữ liệu sẽ được filter theo userID
    bool isExist = await _checkUserExistence(result.user!.uid);
    if (!isExist) {
      Get.offAllNamed(Routes.setupInfoIntro);
    } else {
      await DataService.instance.loadUserData();
      
      // Bắt đầu lắng nghe real-time streams sau khi đăng nhập thành công
      DataService.instance.startListeningToStreams();
      DataService.instance.startListeningToUserCollections();
      
      Get.offAllNamed(Routes.home);
    }
  }

  void _handleSignInFail(String message) {
    Get.snackbar(
      'Lỗi đăng nhập',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColor.errorColor.withOpacity(0.9),
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }
}

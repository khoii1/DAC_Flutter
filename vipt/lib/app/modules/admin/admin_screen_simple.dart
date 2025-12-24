import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:vipt/app/data/providers/auth_provider.dart' as vipt_auth;
import 'package:vipt/app/modules/admin/admin_manage_screen.dart';
import 'package:vipt/app/routes/pages.dart';

class AdminScreenSimple extends StatefulWidget {
  const AdminScreenSimple({Key? key}) : super(key: key);

  @override
  State<AdminScreenSimple> createState() => _AdminScreenSimpleState();
}

class _AdminScreenSimpleState extends State<AdminScreenSimple> {
  User? currentUser;
  final vipt_auth.AuthProvider _authProvider = vipt_auth.AuthProvider();
  StreamSubscription<User?>? _authSubscription;

  @override
  void initState() {
    super.initState();
    // Check if user is already signed in
    currentUser = _authProvider.getCurrentUser();
    if (currentUser == null) {
      // Redirect to login if not authenticated
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Get.offAllNamed(Routes.adminLogin);
        }
      });
    }
    // Listen to auth state changes
    _authSubscription = _authProvider.authStateChanges().listen((User? user) {
      if (mounted) {
        setState(() {
          currentUser = user;
        });
        if (user == null && mounted) {
          // Redirect to login if signed out
          Get.offAllNamed(Routes.adminLogin);
        }
      }
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // If not authenticated, show loading
    if (currentUser == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Show management screen
    return const AdminManageScreen();
  }
}

import 'package:flutter/material.dart';
import 'package:uminom/features/auth/presentation/views/sign_in_page.dart';

class UminomApp extends StatelessWidget {
  const UminomApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: SignInPage());
  }
}

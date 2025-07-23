import 'dart:io';

import 'package:flutter/material.dart';
import 'package:offlinebingo/app.dart';
import 'package:offlinebingo/providers/autho_provider.dart';
import 'package:provider/provider.dart';
import 'providers/game_provider.dart';
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) {
        print('⚠️ Bypassing SSL for $host');
        return true; // Accept all certificates
      };
  }
}
void main() {
  HttpOverrides.global = MyHttpOverrides(); 
  runApp(const BingoAppWrapper());
}

class BingoAppWrapper extends StatelessWidget {
  const BingoAppWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GameProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const BingoApp(),
    );
  }
}

/// Developed by Eng Mouaz M AlShahmeh
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'imports.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return ChangeNotifierProvider(
      create: (_) => MyProvider()..startGame(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Bounce Flutter Game',
        navigatorKey: navigatorKey,
        home: const GamePage(),
        theme: ThemeData.light().copyWith(
          textTheme: GoogleFonts.pressStart2pTextTheme(),
        ),
      ),
    );
  }
}

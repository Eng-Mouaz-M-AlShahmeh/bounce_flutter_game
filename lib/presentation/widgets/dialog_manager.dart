/// Developed by Eng Mouaz M AlShahmeh
import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../imports.dart';

class DialogManager {
  static showPauseDialog() {
    showDialog(
      context: navigatorKey.currentContext!,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Dialog(
            elevation: 0,
            insetPadding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  'LEVEL 1',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                InkWell(
                  onTap: () => Navigator.pop(navigatorKey.currentContext!),
                  child: Image.asset('assets/resume.png'),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(navigatorKey.currentContext!);
                    Provider.of<MyProvider>(navigatorKey.currentContext!,
                            listen: false)
                        .startGame();
                  },
                  child: Image.asset('assets/restart.png'),
                ),
                InkWell(
                  onTap: () {},
                  child: Image.asset('assets/sound_on.png'),
                ),
                InkWell(
                  onTap: () {},
                  child: Image.asset('assets/menu.png'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static showGameOverDialog() {
    showDialog(
      context: navigatorKey.currentContext!,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Dialog(
            elevation: 0,
            insetPadding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset('assets/game_over.png'),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Image.asset('assets/red_menu.png'),
                    ),
                    const SizedBox(width: 8),
                    Splash(
                        splashColor: Colors.black,
                        onTap: () {
                          Navigator.pop(navigatorKey.currentContext!);
                          Provider.of<MyProvider>(navigatorKey.currentContext!,
                                  listen: false)
                              .startGame();
                        },
                        child: Image.asset('assets/red_retry.png')),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static showLevelCompletedDialog(int score, int lives) {
    showDialog(
      context: navigatorKey.currentContext!,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (_) {
        return Dialog(
          elevation: 0,
          insetPadding: const EdgeInsets.all(80),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      children: [
                        Text(
                          'LEVEL 1',
                          style:
                              TextStyle(color: Colors.blueGrey, fontSize: 14),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'COMPLETE',
                          style:
                              TextStyle(color: Colors.blueGrey, fontSize: 14),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Image.asset('assets/blue_menu.png'),
                        const SizedBox(width: 8),
                        Splash(
                          splashColor: Colors.black,
                          onTap: () {
                            Navigator.pop(navigatorKey.currentContext!);
                            Provider.of<MyProvider>(
                                    navigatorKey.currentContext!,
                                    listen: false)
                                .startGame();
                          },
                          child: Image.asset('assets/blue_retry.png'),
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(width: 10),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: Countup(
                              begin: 0,
                              end: score.toDouble(),
                              style: const TextStyle(
                                  color: Colors.redAccent, fontSize: 22),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: Stack(
                              children: [
                                Row(
                                  children: List.generate(
                                      3,
                                      (index) =>
                                          Image.asset('assets/grey_star.png')),
                                ),
                                Row(
                                  children: List.generate(
                                      lives,
                                      (index) =>
                                          Image.asset('assets/yellow_star.png')),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                        onTap: () {},
                        child: Image.asset('assets/red_next.png')),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

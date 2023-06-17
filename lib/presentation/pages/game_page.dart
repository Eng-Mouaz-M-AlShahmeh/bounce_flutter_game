/// Developed by Eng Mouaz M AlShahmeh
import 'dart:math';
import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../imports.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  GamePageState createState() => GamePageState();
}

class GamePageState extends State<GamePage> {
  @override
  initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<MyProvider>(context, listen: false)
          .updateScreenSize(MediaQuery.of(context).size);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: Consumer<MyProvider>(
        builder: (context, provider, child) {
          final wall = provider.wall;
          return RepaintBoundary(
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.topLeft,
                        child: Stack(
                          fit: StackFit.expand,
                          children: List.generate(
                            50,
                            (index) => Align(
                              alignment:
                                  Alignment(-wall.dx + index * 0.18, 0),
                              child: WallObject(
                                wall: wall,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Expanded(flex: 4, child: Playground()),
                    Expanded(
                      child: Stack(
                        children: [
                          ...List.generate(
                            50,
                            (index) => Align(
                              alignment:
                                  Alignment(-wall.dx + index * 0.18, 0),
                              child: WallObject(
                                wall: wall,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 10,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(width: 20),
                      LeftButton(function: provider.moveLeft),
                      const SizedBox(width: 20),
                      RightButton(function: provider.moveRight),
                      const Spacer(),
                      JumpButton(function: provider.jump),
                      const SizedBox(width: 20),
                    ],
                  ),
                ),
                Positioned(
                  top: 20,
                  left: 20,
                  child: Row(
                    children: [
                      Transform.rotate(
                        angle: provider.rotationCoefficient * pi / 3,
                        child: Image.asset(
                          'assets/ball_small.png',
                          height: 25,
                          width: 25,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'X${provider.lives}',
                        style: const TextStyle(
                            color: Colors.white, fontSize: 16),
                      ),
                      const SizedBox(width: 12),
                      ...provider.ringsList
                          .skipWhile((e) => e.isCollected!)
                          .map(
                            (e) => Padding(
                              padding: const EdgeInsets.only(right: 4),
                              child: Image.asset(
                                'assets/score_ring.png',
                              ),
                            ),
                          ),
                    ],
                  ),
                ),
                Positioned(
                  top: 15,
                  right: 20,
                  child: Row(
                    children: [
                      Countup(
                        begin: 0.0,
                        end: provider.score.toDouble(),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 6),
                      Splash(
                        onTap: () => DialogManager.showPauseDialog(),
                        splashColor: Colors.white,
                        maxRadius: 30,
                        minRadius: 20,
                        child: const Icon(
                          Icons.pause_rounded,
                          size: 30,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class Playground extends StatelessWidget {
  const Playground({super.key});

  @override
  Widget build(BuildContext context) {
    return SkyBackground(
      child: Consumer<MyProvider>(
        builder: (context, provider, child) {
          final ball = provider.ball;
          final ring1 = provider.ring1;
          final ring2 = provider.ring2;
          final wall2x2 = provider.wall2x4;
          final thorn1 = provider.thorn1;
          final thorn2 = provider.thorn2;
          final movingThorn = provider.movingThorn;
          final finish = provider.finish;
          return RepaintBoundary(
            child: Stack(
              children: [
                Align(
                  alignment: Alignment(ball.dx, ball.dy),
                  child: Transform.rotate(
                    angle: pi * provider.rotationCoefficient,
                    child: BallObject(
                      ball: ball,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment(ring1.dx, ring1.dy),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    switchInCurve: Curves.bounceOut,
                    child: RingObject(
                      ring: ring1,
                      key: ValueKey(ring1.url),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment(ring2.dx, ring2.dy),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    switchInCurve: Curves.bounceOut,
                    child: RingObject(
                      ring: ring2,
                      key: ValueKey(ring2.url),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment(wall2x2.dx, wall2x2.dy),
                  child: Wall2x2Object(
                    wall2x2: wall2x2,
                  ),
                ),
                Align(
                  alignment: Alignment(thorn1.dx, thorn1.dy),
                  child: ThornObject(
                    thorn: thorn1,
                  ),
                ),
                Align(
                  alignment: Alignment(thorn2.dx, thorn2.dy),
                  child: ThornObject(
                    thorn: thorn2,
                  ),
                ),
                Align(
                  alignment: Alignment(movingThorn.dx, movingThorn.dy),
                  child: ThornObject(
                    thorn: movingThorn,
                  ),
                ),
                Align(
                  alignment: Alignment(finish.dx, finish.dy),
                  child: FinishObject(
                    finish: finish,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

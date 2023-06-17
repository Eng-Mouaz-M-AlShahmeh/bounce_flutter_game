/// Developed by Eng Mouaz M AlShahmeh
import 'package:flutter/cupertino.dart';

abstract class Actor {
  double dx;
  double dy;
  String url;
  double? impactDx;
  bool? isCollected;
  DismissDirection? direction;

  Actor({
    required this.dx,
    required this.dy,
    required this.url,
    this.impactDx,
    this.direction,
    this.isCollected,
  });

  @override
  String toString() => '$runtimeType(dx: $dx, dy: $dy, url: $url)';

  reset([double? toDx, double? toDy]);
}

class Ball extends Actor {
  Ball({
    double dx = -1.0,
    double dy = 1.0,
    String url = 'assets/ball_small.png',
  }) : super(dx: dx, dy: dy, url: url);

  @override
  reset([double? toDx, double? toDy]) {
    dx = -1.0;
    dy = 1.0;
    url = 'assets/ball_small.png';
  }
}

class Ring extends Actor {
  Ring({
    double dx = 0.25,
    double impactDx = 0.25 - 0.05,
    double dy = 0.9,
    String url = 'assets/ring.png',
    bool isCollected = false,
  }) : super(
          dx: dx,
          dy: dy,
          url: url,
          isCollected: isCollected,
          impactDx: impactDx,
        );

  @override
  reset([double? toDx, double? toDy]) {
    dx = toDx!;
    dy = toDy!;
    url = 'assets/ring.png';
    isCollected = false;
  }
}

class Wall extends Actor {
  Wall({
    double dx = 1.0,
    final double dy = 1.0,
    final String url = 'assets/wall.png',
  }) : super(dx: dx, dy: dy, url: url);

  @override
  reset([double? toDx, double? toDy]) {
    dx = 1.0;
  }
}

class Wall2x2 extends Actor {
  Wall2x2({
    double dx = 0.975,
    final double dy = 1.0,
    final String url = 'assets/wall_2x2.png',
  }) : super(dx: dx, dy: dy, url: url);

  @override
  reset([double? toDx, double? toDy]) {
    dx = 0.975;
  }
}

class Thorn extends Actor {
  Thorn({
    double dx = 2.12,
    final double dy = 1.0,
    final String url = 'assets/thorn.png',
    DismissDirection? direction,
  }) : super(dx: dx, dy: dy, url: url, direction: direction);

  @override
  reset([double? toDx, double? toDy]) {
    dx = toDx ?? 2.12;
  }
}

class Finish extends Actor {
  Finish({
    double dx = 7.0,
    final double dy = 1.0,
    final String url = 'assets/finish.png',
  }) : super(dx: dx, dy: dy, url: url);

  @override
  reset([double? toDx, double? toDy]) {
    dx = toDx ?? 7.0;
  }
}

/// Developed by Eng Mouaz M AlShahmeh
import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import '../../imports.dart';

class MyProvider extends ChangeNotifier {
  static const _delta = 0.0005;
  static const _deltaWall2x2 = _delta * 1.1;
  static const _deltaThorn = _delta * 0.95;
  static const _deltaRing = _delta * 0.55;
  static const _deltaRing2 = _delta * 0.95;
  static const _deltaFinish = _delta * 0.99;

  /// Actors
  final _ball = Ball();
  final _wall = Wall();
  final _wall2x2 = Wall2x2();
  final _ring1 = Ring();
  final _ring2 = Ring(dx: 0.85, impactDx: 0.85 - 0.05, dy: -0.54);
  final _ring3 = Ring(dx: 2.12, impactDx: 2.12 - 0.05, dy: -0.54);
  final _thorn1 = Thorn();
  final _thorn2 = Thorn(dx: 3.32);
  final _movingThorn = Thorn(dx: 7.0, url: 'assets/moving_thorn.png');
  final _finish = Finish(dx: 7.5);

  /// Components
  Position _position = Position(dx: -1.0, dy: 0.0);
  final Level _level = Level();
  Size? _screen;
  int _score = 0;
  final List<Ring> _ringsList = <Ring>[];

  /// Variables
  double _time = 0.0;
  double _height = 0.0;
  double? _initialHeight;
  bool isStopped = false;
  int _lives = 3;
  double _rotationCoefficient = 0.0;

  /// Timers
  final Duration _refreshDuration = const Duration(milliseconds: 1);

  /// Getters
  Ball get ball => _ball;
  Wall get wall => _wall;
  Wall2x2 get wall2x4 => _wall2x2;
  Ring get ring1 => _ring1;
  Ring get ring2 => _ring2;
  Ring get ring3 => _ring3;
  Thorn get thorn1 => _thorn1;
  Thorn get thorn2 => _thorn2;
  Thorn get movingThorn => _movingThorn;
  Finish get finish => _finish;
  Position get position => _position;
  Size? get screen => _screen;
  double get rotationCoefficient => _rotationCoefficient;
  int get lives => _lives;
  int get score => _score;
  List<Ring> get ringsList => _ringsList;

  /// Methods
  startGame() {
    _ring1.reset(0.25, 0.9);
    _ring2.reset(0.85, -0.54);
    _ring3.reset(2.12, -0.54);
    _ringsList.clear();
    _ringsList.addAll([_ring1, _ring2, _ring3]);
    _score = 0;
    _lives = 3;
    _level.reset();
    _ball.reset();
    _wall.reset();
    _wall2x2.reset();
    _thorn1.reset();
    _thorn2.reset(3.32);
    _movingThorn.reset(5.0);
    isStopped = false;
    _resetJump();
    _finish.reset(7.5);
    _position = Position.reset();
    notifyListeners();
  }

  moveLeft() {
    isStopped = false;
    Timer.periodic(
      _refreshDuration,
      (timer) {
        if (LeftButton.isHolding) {
          _rotationCoefficient += -_delta * 6;
          if (_wall.dx <= 1.0) {
            if (_ball.dx != -1.0) {
              _ball.dx += -_delta;
              _position.dx = _position.dx! + (-_delta);
            } else {
              _ball.dx = -1.0;
              _position.dx = -1.0;
            }
          } else {
            _wall.dx += -_delta;
            _ring1.dx += _delta;
            _ring2.dx += _deltaRing;
            _ring3.dx += _deltaRing2;
            _finish.dx += _deltaFinish;
            _thorn1.dx += _deltaThorn;
            _thorn2.dx += _deltaThorn;
            _movingThorn.dx += _deltaThorn;
            _movingThorn.dx += _deltaThorn;
            _wall2x2.dx += _deltaWall2x2;
            _position.dx = _position.dx! + (-_delta);
          }

          notifyListeners();
        } else {
          timer.cancel();
        }
      },
    );
  }

  moveRight() {
    Timer.periodic(
      _refreshDuration,
      (timer) {
        if (RightButton.isHolding) {
          _rotationCoefficient += _delta * 6;

          _checkBarriersAndMove();
          notifyListeners();
        } else {
          timer.cancel();
        }
      },
    );
  }

  jump() {
    if (_time != 0) {
    } else {
      _resetJump();
      Timer.periodic(_refreshDuration, (timer) {
        _time += 0.004;
        _height = -4.9 * pow(_time, 2) + 5.5 * _time;

        /// Check for barrier
        final List<Barrier> barriers = _level.barrierList;
        for (Barrier barrier in barriers) {
          final currentDx = double.parse(_position.dx!.toStringAsFixed(2));

          /// Collision Zone
          bool checkBreakPoints =
              ((barrier.dx! < currentDx && currentDx <= barrier.width!) ||
                  barrier.dx == currentDx);
          if (checkBreakPoints) {
            if (barrier.object == Finish) {
              barriers.clear();
              DialogManager.showLevelCompletedDialog(_score, _lives);
              break;
            }

            if (_ball.dy <= barrier.dy!) {
              if (barrier.object == Thorn) {
                _fallToGround(timer);
              } else {
                timer.cancel();
                _resetJump();
              }
            } else {
              _fallToGround(timer);
            }
          }

          /// Free2Go Zone
          else {
            _fallToGround(timer);
          }
        }
      });
    }
  }

  /// Helpers
  _checkIfRingCollected() {
    for (Actor ring in _ringsList) {
      if (!ring.isCollected! &&
          _position.dx! > ring.impactDx! &&
          _position.dx! < ring.impactDx! + 0.1 &&
          _ball.dy >= ring.dy) {
        if (ring.dy.isNegative) {
        } else {
          _smallJump();
        }
        ring.url = 'assets/ring_collected.png';
        ring.isCollected = true;
        _score += 2500;
        break;
      }
    }
  }

  updateScreenSize(Size size) {
    _screen = size;
    notifyListeners();
  }

  _resetJump() {
    _time = 0.0;
    _initialHeight = _ball.dy;
  }

  _fallToGround(Timer timer) {
    if (_initialHeight! - _height > 1) {
      /// Drag force
      _smallJump();
      _resetJump();
      timer.cancel();
    } else {
      _ball.dy = _initialHeight! - _height;
    }

    if (_ball.dy == 0.0) {
      timer.cancel();
    }
    notifyListeners();
  }

  _smallJump() {
    _resetJump();
    Timer.periodic(_refreshDuration, (timer) {
      _time += 0.004;
      _height = -4.9 * pow(_time, 2) + 1.5 * _time;

      if (_initialHeight! - _height > 1) {
        /// Drag force
        _resetJump();
        timer.cancel();
      } else {
        _ball.dy = _initialHeight! - _height;
      }

      if (_ball.dy == 0.0) {
        _resetJump();
        timer.cancel();
      }
    });
  }

  _increaseBallDistance() {
    _position.dx = _position.dx! + (_delta);
  }

  _checkBarriersAndMove() {
    final barriers = _level.barrierList;
    for (Barrier barrier in barriers) {
      final currentDx = double.parse(_position.dx!.toStringAsFixed(2));

      bool checkCollision = ((barrier.dx! < currentDx &&
              currentDx <= barrier.width! &&
              !barrier.isPassed!) ||
          barrier.dx == currentDx);

      /// Collision Zone
      if (checkCollision) {
        if (barrier.object == Finish) {
          barriers.clear();
          DialogManager.showLevelCompletedDialog(_score, _lives);

          break;
        }
        if (barrier.object == Thorn && _ball.dy >= barrier.dy!) {
          _ball.url = 'assets/ball_pop.png';
          Future.delayed(const Duration(milliseconds: 250)).then((value) {
            _gameOver();
          });
          barriers.clear();
          break;
        }

        if (barrier.object == Thorn) {
          if (_ball.dy < barrier.dy!) {
            isStopped = false;
            barrier.isPassed = true;
            _keepMoving();
            break;
          }
        }

        /// Conditions to Move:
        if (_ball.dy <= barrier.dy!) {
          if (RightButton.isHolding) {
            _ball.dy = barrier.dy! - 0.15;
            isStopped = false;
            _keepMoving();
          }
        }
        isStopped = true;
      } else if (currentDx > barrier.width! &&
          !barrier.isPassed! &&
          barrier.object != Thorn) {
        isStopped = false;
        barrier.isPassed = true;
        _smallJump();
        _keepMoving();
      }

      /// Free2Go Zone
      else {
        _keepMoving();
      }
    }
  }

  _keepMoving() {
    _checkIfRingCollected();

    if (!isStopped) {
      if (_position.dx! > 6.5) {
        _ball.dx += _delta;
        _position.dx = _position.dx! + (_delta);
      } else {
        if (_ball.dx > 0) {
          _wall.dx += _delta;
          _ring1.dx += -_delta;
          _ring2.dx += -_deltaRing;
          _ring3.dx += -_deltaRing2;
          _finish.dx += -_deltaFinish;
          _thorn1.dx += -_deltaThorn;
          _thorn2.dx += -_deltaThorn;
          _movingThorn.dx += -_deltaThorn;
          _wall2x2.dx += -_deltaWall2x2;
        } else {
          _ball.dx += _delta;
        }

        _increaseBallDistance();
      }
    } else {
      /// Stop
    }
  }

  _gameOver() {
    _lives -= 1;
    if (lives > 0) {
      /// Decrease 1 live and restart from start.
      _score = 0;
      _level.reset();
      _ball.reset();
      _wall.reset();
      _wall2x2.reset();
      _ring1.reset(0.25, 0.9);
      _ring2.reset(0.85, -0.54);
      _ring3.reset(2.12, -0.54);
      _thorn1.reset();
      _thorn2.reset(3.32);
      _movingThorn.reset(6.5);
      isStopped = false;
      _resetJump();
      _finish.reset(7.5);
      _position = Position.reset();

      notifyListeners();
    } else {
      /// Game Over
      DialogManager.showGameOverDialog();
    }
  }
}

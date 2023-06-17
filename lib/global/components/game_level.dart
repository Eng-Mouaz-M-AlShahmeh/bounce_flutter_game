/// Developed by Eng Mouaz M AlShahmeh
import '../../imports.dart';

class Level {
  List<Barrier> barrierList = [
    Barrier(
      object: Wall2x2,
      width: 1.1,
      dy: -0.2,
      dx: 0.65,
      isPassed: false,
    ),
    Barrier(
      object: Thorn,
      width: 2.16,
      dy: 0.9,
      dx: 2.12,
      isPassed: false,
    ),
    Barrier(
      object: Thorn,
      width: 3.42,
      dy: 0.9,
      dx: 3.38,
      isPassed: false,
    ),
    Barrier(
      object: Finish,
      width: 7.6,
      dy: 1.0,
      dx: 7.5,
      isPassed: false,
    ),
  ];

  reset() {
    barrierList = [
      Barrier(
        object: Wall2x2,
        width: 1.1,
        dy: -0.2,
        dx: 0.65,
        isPassed: false,
      ),
      Barrier(
        object: Thorn,
        width: 2.16,
        dy: 0.9,
        dx: 2.12,
        isPassed: false,
      ),
      Barrier(
        object: Thorn,
        width: 3.42,
        dy: 0.9,
        dx: 3.38,
        isPassed: false,
      ),
      Barrier(
        object: Finish,
        width: 7.6,
        dy: 1.0,
        dx: 7.5,
        isPassed: false,
      ),
    ];
  }
}

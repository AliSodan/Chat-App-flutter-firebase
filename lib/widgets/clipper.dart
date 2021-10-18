import 'package:flutter/cupertino.dart';

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height / 1.7);
    var p1 = Offset(size.width / 4, size.height / 5);
    var p2 = Offset(size.width / 1.9, size.height / 1.2);

    path.quadraticBezierTo(p1.dx, p1.dy, p2.dx, p2.dy);
    var p3 = Offset(size.width / 1.48, size.height / 0.9);
    var p4 = Offset(size.width / 1.3, size.height / 1.2);
    path.quadraticBezierTo(p3.dx, p3.dy, p4.dx, p4.dy);
    var p5 = Offset(size.width / 1.0, size.height / 20);
    var p6 = Offset(size.width, size.height - 0.01);
    path.quadraticBezierTo(p5.dx, p5.dy, p6.dx, p6.dy);

    path.lineTo(size.width, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    return true;
  }
}

class SignUpClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height / 1.1);
    var p1 = Offset(size.width / 4, size.height);
    var p2 = Offset(size.width, 0);
    path.quadraticBezierTo(p1.dx, p1.dy, p2.dx, p2.dy);
    var p3 = Offset(size.width / 2, size.height);
    var p4 = Offset(0, size.height / 6);
    path.quadraticBezierTo(p3.dx, p3.dy, p4.dx, p4.dy);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

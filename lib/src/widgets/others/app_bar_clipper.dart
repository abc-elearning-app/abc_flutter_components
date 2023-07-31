import 'package:flutter/material.dart';
class AppbarClipper extends CustomClipper<Path> {

  final int clipper;
  AppbarClipper({ this.clipper = 25 });

  @override
  Path getClip(Size _size) {
    Path path = Path();
    path.lineTo(0, _size.height - clipper);
    path.quadraticBezierTo( _size.width / 4, _size.height, _size.width / 2, _size.height);
    path.quadraticBezierTo( _size.width - (_size.width / 4), _size.height, _size.width, _size.height - clipper);
    path.lineTo(_size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget containerFeilds(
  dynamic height,
  dynamic width,
  dynamic margin,
  Color? color,
  Widget child,
) {
  return Container(
    height: height,
    width: width,
    margin: margin,
    decoration: BoxDecoration(
      borderRadius: const BorderRadius.all(
        Radius.circular(40),
      ),
      color: color,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 2,
          spreadRadius: 1,
          offset: const Offset(0, 2.9),
        ),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: child,
    ),
  );
}

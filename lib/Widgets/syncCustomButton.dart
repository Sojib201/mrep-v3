// ignore_for_file: file_names, camel_case_types, use_key_in_widget_constructors

import 'package:flutter/material.dart';

class syncCustomBuildButton extends StatelessWidget {
  final VoidCallback onClick;
  final bool isHome;

  final String title;
  final double sizeWidth;
  final Color color;

  // ignore: prefer_const_constructors_in_immutables
  syncCustomBuildButton({
    required this.onClick,
    required this.color,
    required this.title,
    required this.sizeWidth,  this.isHome=false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Card(
        color: color,
        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 0,
        child: Container(
          height: MediaQuery.of(context).size.height / 8,
          width: sizeWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                textAlign: TextAlign.center,
                title,
                style: const TextStyle(
                  color: Colors.black,
                  // fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}

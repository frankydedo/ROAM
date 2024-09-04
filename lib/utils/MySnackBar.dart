// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fleet_manager/providers/ColorsProvider.dart';

class MySnackBar extends StatelessWidget {

  final String text;

  const MySnackBar({super.key, required this.text});

  void show(BuildContext context) {
    final colorsModel = Provider.of<ColorsProvider>(context, listen: false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        behavior: SnackBarBehavior.floating,
        content: Text(
          text,
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        backgroundColor: colorsModel.coloreSecondario,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

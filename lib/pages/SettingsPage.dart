// ignore_for_file: prefer_const_constructors

import 'package:fleet_manager/providers/ColorsProvider.dart';
import 'package:fleet_manager/providers/ProjectProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<ColorsProvider, ProjectProvider>(
      builder: (context, colorsModel, mainModel, _){
        return Scaffold(
          appBar: AppBar(
            backgroundColor: colorsModel.backgroudColor,
            foregroundColor: colorsModel.coloreSecondario,
          ),
          backgroundColor: colorsModel.backgroudColor,
          body: Center(
            child: Text("Settings")
          ),
        );
      });
  }
}
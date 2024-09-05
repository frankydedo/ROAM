// ignore_for_file: must_be_immutable, deprecated_member_use


import 'package:fleet_manager/providers/ColorsProvider.dart';
import 'package:fleet_manager/providers/ProjectProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyAlertDialog extends StatelessWidget {

  String alert_msg;

  MyAlertDialog({super.key, required this.alert_msg});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ColorsProvider, ProjectProvider>(
      builder: (context, colorsModel, projectsModel, _) {
        return AlertDialog(
          backgroundColor: colorsModel.dialogBackgroudColor,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // icona [!]
              Icon(
                Icons.error_outline_rounded,
                color: colorsModel.coloreSecondario,
                size: 70,
              ),
              SizedBox(height: 20),
          
              // testo richiesta
              Text(
                alert_msg,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: colorsModel.textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
              SizedBox(height: 20),
          
              
              // tasti
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
          
                  // tasto ok
          
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                    }, 
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, 
                      backgroundColor: colorsModel.coloreSecondario,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      elevation: 5,
                      shadowColor: Colors.black,
                    ),                          
                    child: Text(
                      "Ok",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
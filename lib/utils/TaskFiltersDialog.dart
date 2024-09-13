// ignore_for_file: deprecated_member_use, must_be_immutable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:fleet_manager/providers/ColorsProvider.dart';
import 'package:fleet_manager/providers/ProjectProvider.dart';

class TaskFiltersDialog extends StatefulWidget {
  
  bool showUnderway;
  bool showCompleted;
  bool showStandby;
  bool showQueued;
  bool showCanceled;
  bool showFailed;

  TaskFiltersDialog({
    super.key,
    required this.showUnderway,
    required this.showCompleted,
    required this.showStandby,
    required this.showQueued,
    required this.showCanceled,
    required this.showFailed,
  });

  @override
  State<TaskFiltersDialog> createState() => _TaskFiltersDialogState();
}

class _TaskFiltersDialogState extends State<TaskFiltersDialog> with SingleTickerProviderStateMixin {
  late Map<String, bool> vals;

  @override
  void initState() {
    super.initState();

    vals = {
      "Underway": widget.showUnderway,
      "Completed": widget.showCompleted,
      "Queued": widget.showQueued,
      "Standby": widget.showStandby,
      "Canceled": widget.showCanceled,
      "Failed": widget.showFailed,
    };
  }

  Color coloreDaStato(String state) {
    final colorsProvider = Provider.of<ColorsProvider>(context, listen: false);

    switch (state.toLowerCase()) {
      case "underway":
        return colorsProvider.coloreSecondario;
      case "completed":
        return Colors.green;
      case "queued":
      case "standby":
        return Colors.yellow.shade700;
      case "canceled":
      case "failed":
        return Colors.red;
      default:
        return colorsProvider.coloreSecondario;
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Consumer2<ColorsProvider, ProjectProvider>(
      builder: (context, colorsModel, projectsModel, _) {
        return WillPopScope(
          onWillPop: () async {
            Navigator.pop(context, null);
            return false;
          },
          child: AlertDialog(
            backgroundColor: colorsModel.dialogBackgroudColor,
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Text(
                      "Scegli quali planning mostrare",
                      style: GoogleFonts.encodeSans(
                        color: colorsModel.coloreTitoli,
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(height: 30, width: screenWidth * 0.3,),

                  // Corpo della finestra di dialogo
                  SizedBox(
                    child: Column(
                      children: vals.keys.map((String key) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Center(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      vals[key] = ! vals[key]!;
                                    });
                                  },
                                  child: Container(
                                    height: 35,
                                    width: 200,
                                    decoration: BoxDecoration(
                                      color: vals[key]! ? coloreDaStato(key) : coloreDaStato(key).withOpacity(.5),
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          spreadRadius: 2,
                                          blurRadius: 3,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                      border: Border.all(
                                        color: vals[key]! ? Colors.white : Colors.white.withOpacity(.7),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        key,
                                        style: GoogleFonts.encodeSans(
                                          color: vals[key]! ? Colors.white : Colors.white.withOpacity(.7),
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Spacer()
                          ],
                        );
                      }).toList(),
                    ),
                  ),

                  SizedBox(height: 30),

                  // Tasti
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Tasto annulla
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context, null);
                        },
                        child: Text(
                          "Annulla",
                          style: TextStyle(
                            color: colorsModel.textColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      // Tasto invia
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context, vals.values.toList());
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: colorsModel.coloreSecondario,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 15,
                          ),
                          elevation: 5,
                          shadowColor: Colors.black,
                        ),
                        child: Text(
                          "Invia",
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
            ),
          ),
        );
      },
    );
  }
}

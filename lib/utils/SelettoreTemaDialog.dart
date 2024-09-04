// ignore_for_file: must_be_immutable

import 'package:fleet_manager/providers/ColorsProvider.dart';
import 'package:fleet_manager/providers/ProjectProvider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SelettoreTemaDialog extends StatefulWidget {
  String selezione;

  SelettoreTemaDialog({super.key, required this.selezione});

  @override
  State<SelettoreTemaDialog> createState() => _SelettoreTemaDialogState();
}

class _SelettoreTemaDialogState extends State<SelettoreTemaDialog> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<ColorsProvider, ProjectProvider>(
      builder: (context, colorsModel, ricetteModel, _) {
        return AlertDialog(
          backgroundColor: colorsModel.dialogBackgroudColor,
          content: SizedBox(
            width: 300,
            height: 400,
            child: Column(
              children: [
                widget.selezione == "Chiaro"
                    ? Icon(
                        Icons.light_mode_rounded,
                        color: colorsModel.coloreSecondario,
                        size: 50,
                      )
                    : widget.selezione == "Scuro"
                        ? Icon(
                            Icons.dark_mode_rounded,
                            color: colorsModel.coloreSecondario,
                            size: 50,
                          )
                        : Icon(
                            Icons.phonelink_setup_rounded,
                            color: colorsModel.coloreSecondario,
                            size: 50,
                          ),
                const SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RadioListTile<String>(
                            activeColor: colorsModel.coloreSecondario,
                            value: "Chiaro",
                            groupValue: widget.selezione,
                            onChanged: (val) {
                              setState(() {
                                widget.selezione = val!;
                              });
                            },
                            title: Text(
                              "Chiaro",
                              style: GoogleFonts.encodeSans(
                                color: colorsModel.textColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RadioListTile<String>(
                            activeColor: colorsModel.coloreSecondario,
                            value: "Scuro",
                            groupValue: widget.selezione,
                            onChanged: (val) {
                              setState(() {
                                widget.selezione = val!;
                              });
                            },
                            title: Text(
                              "Scuro",
                              style: GoogleFonts.encodeSans(
                                color: colorsModel.textColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RadioListTile<String>(
                            activeColor: colorsModel.coloreSecondario,
                            value: "Sistema Operativo",
                            groupValue: widget.selezione,
                            onChanged: (val) {
                              setState(() {
                                widget.selezione = val!;
                              });
                            },
                            title: Text(
                              "Sistema Operativo",
                              style: GoogleFonts.encodeSans(
                                color: colorsModel.textColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, widget.selezione);
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
                    "Fatto",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

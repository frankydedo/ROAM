// ignore_for_file: must_be_immutable, prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:fleet_manager/models/Project.dart';
import 'package:fleet_manager/models/Robot.dart';
import 'package:fleet_manager/providers/ColorsProvider.dart';
import 'package:fleet_manager/providers/ProjectProvider.dart';
import 'package:fleet_manager/utils/MySnackBar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class RobotTile extends StatefulWidget {
  final Project project;
  final Robot robot;
  final void Function() onHighlightTask;

  RobotTile({
    Key? key,
    required this.project,
    required this.robot,
    required this.onHighlightTask,
  }) : super(key: key);

  @override
  State<RobotTile> createState() => _RobotTileState();
}

class _RobotTileState extends State<RobotTile> with SingleTickerProviderStateMixin {
  bool isExpanded = false;

  Color coloreDaBatteria(double batteryLevel) {
    if (batteryLevel < 20.0) {
      return Colors.red;
    } else if (batteryLevel < 35) {
      return Colors.yellow.shade700;
    } else {
      return Colors.green;
    }
  }

  Color coloreDaStato(String state) {
    final colorsProvider = Provider.of<ColorsProvider>(context, listen: false);

    switch (state) {
      case "Working":
        return colorsProvider.coloreSecondario;
      case "Idle":
        return Colors.green;
      case "Charging":
        return Colors.yellow.shade700;
      case "Not Available":
        return Colors.red;
      default:
        return colorsProvider.coloreSecondario;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Consumer2<ColorsProvider, ProjectProvider>(
      builder: (context, colorsModel, projectsModel, _) {
        return GestureDetector(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: AnimatedSize(
            duration: Duration(milliseconds: 300),
            curve: Curves.fastOutSlowIn,
            child: Container(
              padding: EdgeInsets.all(12),
              width: 300,
              decoration: BoxDecoration(
                color: colorsModel.tileBackGroudColor,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Indicatore percentuale
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.robot.name,
                              style: GoogleFonts.encodeSans(
                                color: colorsModel.textColor,
                                fontSize: 25,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                widget.robot.fleet,
                                style: GoogleFonts.encodeSans(
                                  color: colorsModel.textColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        CircularPercentIndicator(
                          radius: 35,
                          lineWidth: 8,
                          percent: widget.robot.batteryLevel / 100,
                          progressColor: coloreDaBatteria(widget.robot.batteryLevel),
                          animationDuration: 700,
                          animation: true,
                          animateFromLastPercent: true,
                          circularStrokeCap: CircularStrokeCap.round,
                          center: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (widget.robot.status == "Charging")
                                Icon(Icons.bolt_rounded, color: colorsModel.coloreSecondario),
                              Text(
                                "${widget.robot.batteryLevel.round()}%",
                                style: GoogleFonts.encodeSans(
                                  color: colorsModel.coloreSecondario,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Indicatore di stato
                  Center(
                    child: Container(
                      height: 24,
                      width: 140,
                      decoration: BoxDecoration(
                        color: coloreDaStato(widget.robot.status),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Text(
                          widget.robot.status.toUpperCase(),
                          style: GoogleFonts.encodeSans(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Informazioni robot
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: Row(
                      children: [
                        Text(
                          "Location",
                          style: GoogleFonts.encodeSans(
                            color: const Color.fromRGBO(158, 158, 158, 1),
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Spacer(),
                        Text(
                          widget.robot.location.toString(),
                          style: GoogleFonts.encodeSans(
                            color: colorsModel.textColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Tasto mostra task (visibile solo se isExpanded è true)
                  if (isExpanded)
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Center(
                        child: ElevatedButton(
                          onPressed: () {
                            if (widget.robot.status == "Working") {
                              widget.onHighlightTask();
                            } else {
                              MySnackBar(text: "Questo robot al momento non è occupato.").show(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorsModel.tileBackGroudColor,
                          ),
                          child: Text(
                            "Mostra task corrente",
                            style: GoogleFonts.encodeSans(
                              color: widget.robot.status == "Working"
                                  ? colorsModel.coloreSecondario
                                  : colorsModel.coloreSecondario.withOpacity(.5),
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
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

// ignore_for_file: must_be_immutable, prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:fleet_manager/models/Project.dart';
import 'package:fleet_manager/models/Task.dart';
import 'package:fleet_manager/providers/ColorsProvider.dart';
import 'package:fleet_manager/providers/ProjectProvider.dart';
import 'package:fleet_manager/utils/ConfermaDialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

class TaskTile extends StatefulWidget {
  
  final Project project;
  final Task task;
  bool isHighlighted;

  TaskTile({
    super.key,
    required this.project,
    required this.task,
    required this.isHighlighted,
  });

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> with SingleTickerProviderStateMixin {
  bool isExpanded = false;

  Color coloreDaStato(String state) {
    final colorsProvider = Provider.of<ColorsProvider>(context, listen: false);

    switch (state) {
      case "Active":
        return colorsProvider.coloreSecondario;
      case "Completed":
        return Colors.green;
      case "Queued":
      case "Suspended":
        return Colors.yellow.shade700;
      case "Aborted":
        return Colors.red;
      default:
        return colorsProvider.coloreSecondario;
    }
  }

  Future showConfermaDialog(BuildContext context, String domanda) {
    return showDialog(
      context: context,
      builder: (context) => ConfermaDialog(domanda: domanda,),
    );
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
          child: AnimatedContainer(
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(17),
              border: Border.all(
                color: (widget.isHighlighted && widget.task.state == "Active") ? colorsModel.coloreSecondario : Colors.transparent,
                width: 2.0,
              ),
            ),
            child: AnimatedSize(
              duration: Duration(milliseconds: 300),
              curve: Curves.fastOutSlowIn,
              child: Container(
                padding: EdgeInsets.all(12),
                width: 300,
                decoration: BoxDecoration(
                  color: (widget.isHighlighted && widget.task.state == "Active") ? colorsModel.coloreHighlight : colorsModel.tileBackGroudColor,
                  // color: colorsModel.tileBackGroudColor,
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
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Spacer(),
                          Text(
                            "${widget.task.completionPerc.round()}%",
                            style: GoogleFonts.encodeSans(
                              color: colorsModel.coloreSecondario,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Spacer(),
                          SizedBox(
                            width: 175,
                            child: LinearPercentIndicator(
                              barRadius: Radius.circular(15),
                              lineHeight: 10,
                              percent: widget.task.completionPerc / 100,
                              progressColor: colorsModel.coloreSecondario,
                              animationDuration: 700,
                              animation: true,
                              animateFromLastPercent: true,
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
            
                    // Indicatore di stato
                    Center(
                      child: Container(
                        height: 24,
                        width: 140,
                        decoration: BoxDecoration(
                          color: coloreDaStato(widget.task.state),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: Text(
                            widget.task.state.toUpperCase(),
                            style: GoogleFonts.encodeSans(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
            
                    // Informazioni task
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                      child: Row(
                        children: [
                          Text(
                            "TaskID",
                            style: GoogleFonts.encodeSans(
                              color: Colors.grey,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Spacer(),
                          Text(
                            widget.task.id.toString(),
                            style: GoogleFonts.encodeSans(
                              color: colorsModel.textColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                      child: Row(
                        children: [
                          Text(
                            "Robot",
                            style: GoogleFonts.encodeSans(
                              color: Colors.grey,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Spacer(),
                          Text(
                            widget.task.robot.name,
                            style: GoogleFonts.encodeSans(
                              color: colorsModel.textColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                      child: Row(
                        children: [
                          Text(
                            "Type",
                            style: GoogleFonts.encodeSans(
                              color: Colors.grey,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Spacer(),
                          Text(
                            widget.task.type,
                            style: GoogleFonts.encodeSans(
                              color: colorsModel.textColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                      child: Row(
                        children: [
                          Text(
                            "Destination",
                            style: GoogleFonts.encodeSans(
                              color: Colors.grey,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Spacer(),
                          Text(
                            widget.task.destination,
                            style: GoogleFonts.encodeSans(
                              color: colorsModel.textColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                      child: Row(
                        children: [
                          Text(
                            "Start",
                            style: GoogleFonts.encodeSans(
                              color: Colors.grey,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Spacer(),
                          Text(
                            "${widget.task.start.hour}:${widget.task.start.minute}:${widget.task.start.second}",
                            style: GoogleFonts.encodeSans(
                              color: colorsModel.textColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Spacer(),
                          Text(
                            "End",
                            style: GoogleFonts.encodeSans(
                              color: Colors.grey,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Spacer(),
                          Text(
                            "${widget.task.end.hour}:${widget.task.end.minute}:${widget.task.end.second}",
                            style: GoogleFonts.encodeSans(
                              color: colorsModel.textColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
            
                    // Tasto elimina (visibile solo se isExpanded è true)
                    if (isExpanded)
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: ElevatedButton(
                                onPressed: () async {
                                  // Azione per eliminare il task
                                  bool conferma = await showConfermaDialog(context, "Sicuro di voler eliminare il task?");
                                  if (conferma) {
                                    projectsModel.removeTask(widget.project, widget.task);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: colorsModel.tileBackGroudColor,
                                ),
                                child: Text(
                                  "Elimina",
                                  style: GoogleFonts.encodeSans(
                                    color: Colors.red,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

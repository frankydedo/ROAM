// ignore_for_file: must_be_immutable, prefer_const_constructors, prefer_const_constructors_in_immutables

import 'dart:convert';

import 'package:fleet_manager/models/Project.dart';
import 'package:fleet_manager/models/Task.dart';
import 'package:fleet_manager/providers/AddressProvider.dart';
import 'package:fleet_manager/providers/ColorsProvider.dart';
import 'package:fleet_manager/providers/ProjectProvider.dart';
import 'package:fleet_manager/utils/ConfermaDialog.dart';
import 'package:fleet_manager/utils/MySnackBar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;


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

  Future showConfermaDialog(BuildContext context, String domanda) {
    return showDialog(
      context: context,
      builder: (context) => ConfermaDialog(domanda: domanda,),
    );
  }

  String millisecToHoursMinsSecs(int milliseconds) {

    double seconds = milliseconds / 1000;

    int sec = seconds.round() % 60;
    seconds -= sec;

    int mins = (seconds / 60).round() % 60;
    seconds -= mins * 60;

    int hours = (seconds / 3600).round();

    return "$hours : $mins : $sec";
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<ColorsProvider, ProjectProvider, AddressProvider>(
      builder: (context, colorsModel, projectsModel, addressModel, _) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(12,12,0,12),
          child: GestureDetector(
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
                  color: (widget.isHighlighted && (widget.task.state.toLowerCase() == "underway" || widget.task.state.toLowerCase() == "standby")) ? colorsModel.coloreSecondario : Colors.transparent,
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
                    color: (widget.isHighlighted && (widget.task.state.toLowerCase() == "underway" || widget.task.state.toLowerCase() == "standby")) ? colorsModel.coloreHighlight : colorsModel.tileBackGroudColor,
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
                              "${double.parse(widget.task.completionPerc).round()}%",
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
                                percent: double.parse(widget.task.completionPerc) / 100,
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
                              widget.task.getIdSecondHalf(),
                              style: GoogleFonts.encodeSans(
                                color: colorsModel.textColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            )
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
                              widget.task.robotName == null ? "Null" : widget.task.robotName!,
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
                              "Category",
                              style: GoogleFonts.encodeSans(
                                color: Colors.grey,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Spacer(),
                            Text(
                              widget.task.category,
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
                              millisecToHoursMinsSecs(int.parse(widget.task.startTime)),
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
                                    
                                    //se il task è in corso
                                    if(widget.task.state.toLowerCase() == "underway" || widget.task.state.toLowerCase() == "standby" || widget.task.state.toLowerCase() == "queued"){
                                      // Azione per eliminare il task
                                      bool conferma = await showConfermaDialog(context, "Sicuro di voler eliminare il planning?");
                                      if (conferma) {
                                        try {
                                          final response = await http.post(
                                            // Uri.parse('$apiServerAddress/cancel_task'),
                                            Uri.parse(addressModel.apiServerAddress_tasks + '/tasks/cancel_task'),
                                            headers: {
                                              "Content-Type": "application/json; charset=UTF-8",
                                            },
                                            body: jsonEncode({"type":"cancel_task_request","task_id": widget.task.id.toString()}),
                                          );
                                          if (response.statusCode == 200) {
                                            MySnackBar(text: "Planning cancelled", isError: false).show(context);
                                          } else {
                                            throw Exception('Failed to cancel task: '+response.statusCode.toString());
                                          }
                                        } catch (err) {
                                          print(err);
                                        }
                                      }
                                    }else{
                                      // se non è in corso
                                      MySnackBar(text: "Questo planning non è in corso", isError: false).show(context);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: colorsModel.tileBackGroudColor,
                                  ),
                                  child: Text(
                                    "Interrompi",
                                    style: GoogleFonts.encodeSans(
                                      color: 
                                        widget.task.state.toLowerCase() == "underway" ||
                                        widget.task.state.toLowerCase() == "standby" ||
                                        widget.task.state.toLowerCase() == "queued" ?
                                        Colors.red
                                        :
                                        Colors.red.withOpacity(.5),
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
          ),
        );
      },
    );
  }
}

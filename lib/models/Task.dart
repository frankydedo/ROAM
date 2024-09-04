import 'package:fleet_manager/models/Robot.dart';

class Task{

  String id;
  String destination;
  Robot robot;
  String type;
  String state;
  DateTime date;
  DateTime start;
  DateTime end;
  double completionPerc;

  Task({
    required this.id,
    required this.destination,
    required this.robot,
    required this.type,
    required this.state,
    required this.date,
    required this.start,
    required this.end,
    required this.completionPerc
  });

  void setCompletionPerc (double newCompletionperc){
    completionPerc = newCompletionperc;
  }

}
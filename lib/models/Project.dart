import 'package:fleet_manager/models/Robot.dart';
import 'package:fleet_manager/models/Task.dart';

class Project {

  String name;
  int liveTime; // duration in seconds
  List<Robot>? robots;
  List<Task>? tasks;

  Project ({
    required this.name,
    required this.liveTime,
    this.robots,
    this.tasks
  });

  void setName (String newName){
    name = newName;
  }

  void addRobot (Robot r){
    robots!.add(r);
  }

  void removeRobot (Robot r){
    robots!.remove(r);
  }

  void addTask(Task t){
    tasks!.add(t);
  }

  void removeTask (Task t){
    tasks!.remove(t);
  }

  void refreshLiveTime (int sec){
    liveTime = sec;
  }



}
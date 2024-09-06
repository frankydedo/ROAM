import 'package:fleet_manager/models/Robot.dart';
import 'package:fleet_manager/models/Task.dart';

class Project {

  String name;
  int liveTime = 0; // duration in seconds
  List<Robot> robots = [];
  List<Task> tasks = [];

  Project({
    required this.name,
    this.liveTime = 0, 
    List<Robot>? robots, 
    List<Task>? tasks,   
  })  : robots = robots ?? [], // Assign empty list if null
        tasks = tasks ?? [];    // Assign empty list if null

  void setName (String newName){
    name = newName;
  }

  void addRobot (Robot r){
    robots.add(r);
  }

  void removeRobot (Robot r){
    robots.remove(r);
  }

  void addTask(Task t){
    tasks.add(t);
  }

  void removeTask (Task t){
    tasks.remove(t);
  }

  void refreshLiveTime (int sec){
    liveTime = sec;
  }

  void refreshRobotList(List<Robot> newList){
    robots
      ..clear()
      ..addAll(newList);
  }

  void refreshTaskList(List<Task> newList){
    tasks
      ..clear()
      ..addAll(newList)
      ..sort((a, b) => (a.startTime.compareTo(b.startTime)));
  }



}
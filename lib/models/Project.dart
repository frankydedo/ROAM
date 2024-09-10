import 'package:fleet_manager/models/Robot.dart';
import 'package:fleet_manager/models/Task.dart';

class Project {

  String name;
  int liveTime = 0; // duration in seconds
  List<Robot> _robots = [];
  List<Task> _tasks = [];

  Project({
    required this.name,
    this.liveTime = 0, 
    List<Robot>? robots, 
    List<Task>? tasks,   
  })  : _robots = robots ?? [],
        _tasks = tasks ?? [];

  List <Robot> get robots => _robots;

  List <Task> get tasks{
    List<Task> tasks = _tasks;
    tasks.sort((a,b) => int.parse(b.startTime).compareTo(int.parse(a.startTime)));
    return tasks;
  }

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
      ..addAll(newList);
      // ..sort((a, b) => (a.startTime.compareTo(b.startTime)));
  }



}
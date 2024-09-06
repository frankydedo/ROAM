import 'package:fleet_manager/models/Project.dart';
import 'package:fleet_manager/models/Robot.dart';
import 'package:fleet_manager/models/Task.dart';
import 'package:flutter/material.dart';

class ProjectProvider extends ChangeNotifier {

  List<Project> projects = [Project(name: "test1")];

  void refreshRobotList (Project p, List<Robot> newList){
    p.refreshRobotList(newList);
    notifyListeners();
  }

  void refreshTaskList (Project p, List<Task> newList){
    p.refreshTaskList(newList);
    notifyListeners();
  }
}
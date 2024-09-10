import 'package:fleet_manager/models/Project.dart';
import 'package:fleet_manager/models/Robot.dart';
import 'package:fleet_manager/models/Task.dart';
import 'package:flutter/material.dart';

class ProjectProvider extends ChangeNotifier {

  List<Project> projects = [Project(name: "-")];

  void refreshRobotList (Project p, List<Robot> newList){
    p.refreshRobotList(newList);
    notifyListeners();
  }

  void refreshTaskList (Project p, List<Task> newList){
    p.refreshTaskList(newList);
    notifyListeners();
  }

  void refreshProjectName (Project p, String newName){
    p.setName(newName);
    notifyListeners();
  }

  List<Task> getProjectTask (Project p){
    return p.tasks;
  }
}
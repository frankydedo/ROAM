// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison

import 'dart:async';
import 'dart:convert';

import 'package:fleet_manager/api/WebSocketService.dart';
import 'package:fleet_manager/models/Robot.dart';
import 'package:fleet_manager/models/Task.dart';
import 'package:fleet_manager/providers/ColorsProvider.dart';
import 'package:fleet_manager/providers/ProjectProvider.dart';
import 'package:fleet_manager/utils/NewTaskDialog.dart';
import 'package:fleet_manager/utils/RealTimeStatusWidget.dart';
import 'package:fleet_manager/utils/RobotTile.dart';
import 'package:fleet_manager/utils/SelettoreTemaDialog.dart';
import 'package:fleet_manager/utils/TaskTile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class FirstPage extends StatefulWidget {
  FirstPage({super.key});

  // final int initMillisecondsSinceEpoch = DateTime.now().millisecondsSinceEpoch;

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> with SingleTickerProviderStateMixin {

  late TabController _tabController;
  int _selectedTabIndex = 0;
  String? highlightedTaskRobotName;
  final String apiServerAddress = "http://localhost:8083";
  final webSocketService = WebSocketService('ws://localhost:8000/_internal');

  @override
  void initState() {
    super.initState();

    startFetching();

    final projectProvider = context.read<ProjectProvider>();
    _tabController = TabController(length: projectProvider.projects.length, vsync: this);

    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });
  }

  void highlightTask(String robotName) {
    setState(() {
      highlightedTaskRobotName = robotName;
    });

    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        highlightedTaskRobotName = null;
      });
    });
  }

  String secToHoursMinsSecs(int seconds) {
    int sec = seconds % 60;
    seconds -= sec;

    int mins = (seconds / 60).round() % 60;
    seconds -= mins * 60;

    int hours = (seconds / 3600).round();

    return "$hours : $mins : $sec";
  }

  Future showSelettoreTemaDialog(BuildContext context) {
    final colorsModel = Provider.of<ColorsProvider>(context, listen: false);
    return showDialog(
      context: context,
      builder: (context) => SelettoreTemaDialog(selezione: colorsModel.temaAttuale),
    );
  }

  Future showNewTaskDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => NewTaskDialog(),
    );
  }

  ////////////////////////// METODI  HTTP /////////////////////////

  void startFetching(){

    final projectProvider = Provider.of<ProjectProvider>(context, listen: false);

    Timer.periodic(Duration(seconds: 1), (timer) async {

      // projectProvider.projects.elementAt(_selectedTabIndex).robots = await getRobots();
      // projectProvider.projects.elementAt(_selectedTabIndex).tasks = await getTasks();

      projectProvider.refreshRobotList(projectProvider.projects.elementAt(_selectedTabIndex), await getRobots());
      projectProvider.refreshTaskList(projectProvider.projects.elementAt(_selectedTabIndex), await getTasks());

      // getDashboardConfig();
    });
  }
  
  Future<List<Robot>> getRobots() async {
    try {
      // final response = await http.get(Uri.parse('http://localhost:8000/robot'));
      final response = await http.get(Uri.parse('$apiServerAddress/robot_list'));
      if (response.statusCode == 200) {
        return parseRobots(response.body);
      } else {
        throw Exception('Failed to load robots');
      }
    } catch (e) {
      throw Exception('Error: ${e.toString()}');
    }
  }

  Future<List<Task>> getTasks() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:8000/tasks'));
      // final response = await http.get(Uri.parse('$apiServerAddress/task_list'));
      if (response.statusCode == 200) {
        return parseTasks(response.body);
      } else {
        throw Exception('Failed to load tasks');
      }
    } catch (e) {
      throw Exception('Error: ${e.toString()}');
    }
  }


  //TODO provare questo metodo
  Future<List<dynamic>> getDashboardConfig() async {
    try {
      // final response = await http.get(Uri.parse('http://localhost:8000/robot'));
      final response = await http.get(Uri.parse('$apiServerAddress/dashboard_config'));
      if (response.statusCode == 200) {
        dynamic json = jsonDecode(response.body);
        print(json);
        return json;
      } else {
        throw Exception('Failed to load dashboard config');
      }
    } catch (e) {
      throw Exception('Error: ${e.toString()}');
    }
  }

  ////////////////////////// METODI DI PARSING /////////////////////////

  // Metodo per convertire JSON in lista di Robot

  List<Robot> parseRobots(String jsonStr) {

    final List<dynamic> jsonList = json.decode(jsonStr);

    return jsonList.map((jsonItem) {
      return Robot(
        name: jsonItem['robot_name'],
        fleet: jsonItem['fleet_name'],
        status: jsonItem['mode'],
        location: jsonItem['level_name'],
        batteryLevel: jsonItem['battery_percent'],
      );
    }).toList();
  }


  // Metodo per convertire JSON in lista di oggetti Task

  List<Task> parseTasks(String jsonStr) {

    final List<dynamic> jsonList = json.decode(jsonStr);

    return jsonList.map((jsonItem) {
      return Task(
        id: jsonItem['booking']['id'],
        category: jsonItem['category'],
        robotName: jsonItem['assigned_to'] == null ? null :  jsonItem['assigned_to']['name'],
        fleetName: jsonItem['assigned_to'] == null ? null :  jsonItem['assigned_to']['group'],
        state: jsonItem['status'],
        startTime: jsonItem['unix_millis_start_time'].toString(),
        // startTime: DateTime.fromMillisecondsSinceEpoch(jsonItem['unix_millis_start_time'] + widget.initMillisecondsSinceEpoch).toString(),
        estimatedDuration: jsonItem['estimate_millis'] == null ? null : '${(jsonItem['estimate_millis'] / 1000).toString()}',
      );
    }).toList();
  }

  ///////////////////////////////////////////////////////////////////


  @override
  Widget build(BuildContext context) {
    return Consumer2<ColorsProvider, ProjectProvider>(
      builder: (context, colorsModel, projectsModel, _) {

        // Project currentProject = projectsModel.projects[_selectedTabIndex];

        return Scaffold(

          // app bar

          appBar: AppBar(
            backgroundColor: colorsModel.backgroudColor,
            title: Stack(
              children: [

                //logo youbiquo 

                Row(
                  children: [
                    Spacer(),
                    SizedBox(
                        height: 65,
                        child: Image.asset('assets/youbiquo_logos/youbiquo_logo_esteso.png')),
                    Spacer()
                  ],
                ),

                Row(
                  children: [

                    //tempo sim

                    Icon(CupertinoIcons.clock, color: colorsModel.coloreSecondario, size: 30),
                    SizedBox(width: 8),
                    Text(
                      // secToHoursMinsSecs(currentProject.liveTime),
                      "time",
                      style: GoogleFonts.encodeSans(
                          color: colorsModel.coloreTitoli,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),

                    SizedBox(width: 24),

                    RealTimeStatusWidget(url: "ws://localhost:8000/_internal"),

                    Spacer(),

                    // new task button

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          onPressed: () async {
                            dynamic task = await showNewTaskDialog(context);
                            print(task.toString());
                            webSocketService.sendMessage(task.toString());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorsModel.tileBackGroudColor
                          ),
                          child: Text(
                            "New Task +",
                            style: GoogleFonts.encodeSans(
                                color: colorsModel.coloreSecondario,
                                fontSize: 20,
                                fontWeight: FontWeight.w700),
                          )),
                    ),

                    // tema button

                    ElevatedButton(
                      onPressed: () async{
                        String? tema = await showSelettoreTemaDialog(context);
                        if(tema == null){
                          return;
                        }
                        if (tema == "Sistema Operativo"){
                          colorsModel.setTemaAttualeSistemaOperativo(context);
                          setState(() {});
                        }else{
                          colorsModel.setTemaAttualeChiaroScuro(context, tema);
                          setState(() {});
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorsModel.tileBackGroudColor
                      ),
                      child: Icon(CupertinoIcons.settings_solid, color: colorsModel.coloreSecondario, size: 30)
                    )
                  ],
                ),
              ],
            ),
          ),

          body: Scaffold(
            backgroundColor: colorsModel.backgroudColor,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  DefaultTabController(
                    length: projectsModel.projects.length,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // Selettore di tab per i progetti
                          TabBar(
                            controller: _tabController,
                            onTap: (index) {
                              setState(() {
                                _selectedTabIndex = index;
                              });
                            },
                            isScrollable: true,
                            indicatorColor: colorsModel.coloreSecondario,
                            tabs: projectsModel.projects.map((project) {
                              return Tab(
                                child: Text(
                                  project.name.toString(),
                                  style: GoogleFonts.encodeSans(
                                    color: colorsModel.textColor,
                                    fontSize: 24,
                                    fontWeight: project.name == projectsModel.projects.elementAt(_selectedTabIndex).name ? FontWeight.w700 : FontWeight.w500,
                                  ),
                                ),
                              );
                            }).toList(),
                          //   tabs: [
                          //     Tab(
                          //       child: Text(
                          //         projectsList[0].name,
                          //         style: GoogleFonts.encodeSans(
                          //           color: colorsModel.textColor,
                          //           fontSize: 24,
                          //           fontWeight: FontWeight.w700,
                          //         ),
                          //       ),
                          //     )
                          //   ],
                          ),
                      
                          // Vista di task e robot per ogni progetto
                          Container(
                            height: 860,
                            child: TabBarView(
                              controller: _tabController,
                              children: projectsModel.projects.map((project) {
                                return Column(
                                  children: [

                                    // Task

                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Text(
                                          "Planning Commander",
                                          style: GoogleFonts.encodeSans(
                                              color: colorsModel.coloreTitoli,
                                              fontSize: 24,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                    ),

                                    projectsModel.projects.elementAt(_selectedTabIndex).tasks.isEmpty ? 

                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Column(
                                          children: [
                                            Icon(Icons.check_circle_rounded, color: Colors.grey, size: 40),
                                            Text(
                                              "Non ci sono task per questo progetto.\nAggiungine cliccando sul tasto in alto a destra!",
                                              style: GoogleFonts.encodeSans(
                                                color: Colors.grey,
                                                fontSize: 22,
                                                fontWeight: FontWeight.w500
                                              ),
                                              textAlign: TextAlign.center,
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                    :
                                    Container(
                                      alignment: Alignment.topLeft,
                                      height: 370,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Wrap(
                                          children: project.tasks.map((task) {
                                            return Padding(
                                              padding: const EdgeInsets.fromLTRB(14, 14, 0, 12),
                                              child: TaskTile(
                                                project: projectsModel.projects.elementAt(_selectedTabIndex),
                                                task: task,
                                                isHighlighted: highlightedTaskRobotName == task.robotName, 
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),

                                    // Robot
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Center(
                                        child: Text(
                                          "Skill Manager",
                                          style: GoogleFonts.encodeSans(
                                              color: colorsModel.coloreTitoli,
                                              fontSize: 24,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                    ),
                                    project.robots.isEmpty ?
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Center(
                                        child: Column(
                                          children: [
                                            Icon(Icons.smart_toy_outlined, color: Colors.grey, size: 40),
                                            Text(
                                              "Non ci sono robot per questo progetto.",
                                              style: GoogleFonts.encodeSans(
                                                color: Colors.grey,
                                                fontSize: 22,
                                                fontWeight: FontWeight.w500
                                              ),
                                              textAlign: TextAlign.center,
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                    :
                                    Container(
                                      alignment: Alignment.topLeft,
                                      height: 370,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Wrap(
                                          children: project.robots.map((robot) {
                                            return Padding(
                                              padding: const EdgeInsets.fromLTRB(14, 14, 0, 12),
                                              child: RobotTile(
                                                project: project,
                                                robot: robot,
                                                onHighlightTask: () => highlightTask(robot.name),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ],
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

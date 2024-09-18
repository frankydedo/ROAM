// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison

import 'dart:async';
import 'dart:convert';
import 'dart:math';

// import 'package:fleet_manager/api/WebSocketService.dart';
import 'package:fleet_manager/models/Robot.dart';
import 'package:fleet_manager/models/Task.dart';
import 'package:fleet_manager/providers/ColorsProvider.dart';
import 'package:fleet_manager/providers/ProjectProvider.dart';
import 'package:fleet_manager/utils/MySnackBar.dart';
import 'package:fleet_manager/utils/NewTaskDialog.dart';
import 'package:fleet_manager/utils/RealTimeStatusWidget.dart';
import 'package:fleet_manager/utils/RobotTile.dart';
import 'package:fleet_manager/utils/SelettoreTemaDialog.dart';
import 'package:fleet_manager/utils/TaskFiltersDialog.dart';
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
  // final webSocketService = WebSocketService('ws://localhost:8000/_internal');
  int? millisecondsSinceStart = null;
  late List<String> validTask;

  bool showUnderway = true;
  bool showCompleted = true;
  bool showStandby = true;
  bool showQueued = true;
  bool showCanceled = true;
  bool showFailed = true;

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

  bool mustBeVisible (Task t){
    switch (t.state.toLowerCase()){
      case "underway": 
        return showUnderway;
      case "completed":
        return showCompleted;
      case "queued":
        return showQueued;
      case "standby":
        return showStandby;
      case "canceled":
        return showCanceled;
      case "failed":
        return showFailed;
      default:
        return true;
    }
  }

  String secToHoursMinsSecs(int seconds) {
    int sec = seconds % 60;
    seconds -= sec;

    int mins = (seconds / 60).round() % 60;
    seconds -= mins * 60;

    int hours = (seconds / 3600).round();

    return "$hours : $mins : $sec";
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

  Future showTaskFiltersDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => TaskFiltersDialog(
        showCanceled: showCanceled,
        showCompleted: showCompleted,
        showFailed: showFailed,
        showQueued: showQueued,
        showStandby: showStandby,
        showUnderway: showUnderway,
      ),
    );
  }

  ////////////////////////// METODI  HTTP /////////////////////////

  void startFetching(){

    final projectProvider = Provider.of<ProjectProvider>(context, listen: false);

    Timer.periodic(Duration(seconds: 1), (timer) async {

      projectProvider.refreshRobotList(projectProvider.projects.elementAt(_selectedTabIndex), await getRobots());
      projectProvider.refreshTaskList(projectProvider.projects.elementAt(_selectedTabIndex), await getTasks());
      projectProvider.refreshProjectName(projectProvider.projects.elementAt(_selectedTabIndex), await getProjectName());

      if (millisecondsSinceStart == null){
        if(projectProvider.projects.elementAt(_selectedTabIndex).tasks.isEmpty){
          millisecondsSinceStart = 0;
        }else{
          List<int> starts = [];
          for(Task t in projectProvider.projects.elementAt(_selectedTabIndex).tasks){
            if(t.state.toLowerCase() != "queued"){
              starts.add(int.parse(t.startTime));
            }
          }
          if (starts.isNotEmpty){
            starts.sort((a,b) => b.compareTo(a));
            millisecondsSinceStart = starts[0];
          }
        }
      }else{
        if(projectProvider.projects.elementAt(_selectedTabIndex).tasks.isEmpty){
          millisecondsSinceStart = 0;
        }else{
          millisecondsSinceStart = millisecondsSinceStart! + 906;   //TODO: fix live timing
          List<int> starts = [];
          for(Task t in projectProvider.projects.elementAt(_selectedTabIndex).tasks){
            if(t.state.toLowerCase() != "queued"){
              starts.add(int.parse(t.startTime));
            }
          }
          starts.sort((a,b) => b.compareTo(a));
          if(starts[0]>millisecondsSinceStart!){
            millisecondsSinceStart = starts[0];
          }
        }
      }
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


  Future<String> getProjectName() async {
    try {
      final response = await http.get(Uri.parse('$apiServerAddress/dashboard_config'));
      
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonMap = json.decode(response.body);
        validTask = List<String>.from(jsonMap['valid_task']);
        return jsonMap['world_name'] as String;
      } else {
        throw Exception('Failed to load dashboard config');
      }
    } catch (e) {
      throw Exception('Error: ${e.toString()}');
    }
  }


  Future<dynamic> submitRequest(Map<String, dynamic> request) async {
    final url = Uri.parse('$apiServerAddress/submit_task');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(request),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to submit task: ${response.statusCode}');
      }
    } catch (e) {
      return e;
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
        status: jsonItem['fleet_name'] == "Charging-1" ? "Charging" : defineStatus(jsonItem['robot_name']),
        location: jsonItem['level_name'],
        batteryLevel: jsonItem['battery_percent'],
      );
    }).toList();
  }

  String defineStatus (String robotName){

    final projectProvider = Provider.of<ProjectProvider>(context, listen: false);

    for (Task t in projectProvider.getProjectTask(projectProvider.projects.elementAt(_selectedTabIndex))){
      if (t.robotName == robotName && t.state.toLowerCase() != "completed" && t.state.toLowerCase() != "failed" && t.state.toLowerCase() != "canceled"){
        return "Working";
      }
    }
    return "Idle";
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
        // startTime: millisecToHoursMinsSecs(jsonItem['unix_millis_start_time']).toString(),
        estimatedDuration: jsonItem['estimate_millis'] == null ? null : '${(jsonItem['estimate_millis']).toString()}',
        completionPerc: defineCompletionPerc(
          jsonItem['status'],
          jsonItem['unix_millis_start_time'].toString(),
          jsonItem['estimate_millis'] == null ? "" : '${(jsonItem['estimate_millis']).toString()}',
        )
      );
    }).toList();
  }

  String defineCompletionPerc(String status, String startTime, String estDuration){
    if (status.toLowerCase() == "completed"){
      return "100";
    }if (status.toLowerCase() == "canceled"){
      return "0";
    }else{
      if (estDuration.toLowerCase() == ""){
        return "0";
      }else{
        if (millisecondsSinceStart == null) {
          return "10";
        }else{
          double perc = max(0, min(99, (millisecondsSinceStart! - int.parse(startTime)) / int.parse(estDuration) * 20));
          return perc.round().toString();
        }
      }
    }
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

                    RealTimeStatusWidget(),

                    SizedBox(width: 24),

                    //tempo sim

                    Icon(CupertinoIcons.clock, color: colorsModel.coloreSecondario, size: 30),
                    SizedBox(width: 8),
                    Text(
                      millisecondsSinceStart != null ?
                      secToHoursMinsSecs((millisecondsSinceStart! / 1000).round())
                      :
                      DateTime.now().hour.toString()+" : "+ DateTime.now().minute.toString()+" : "+ DateTime.now().second.toString(),
                      style: GoogleFonts.encodeSans(
                          color: colorsModel.coloreTitoli,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),

                    Spacer(),

                    // new task button

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(

                          onPressed: () async {
                            dynamic taskJson = await showNewTaskDialog(context);

                            if (taskJson != null){
                              try {
                                Map<String, dynamic> task = jsonDecode(taskJson);
                                final response = await submitRequest(task);

                                // Gestione della risposta
                                if (response != null) {
                                  if (response['task_id'] != null && response['task_id'] != "") {
                                    MySnackBar(text: "Request submitted successfully!", isError: false).show(context);
                                  } else {
                                    MySnackBar(text: "Delivery Request failed! ${response["error_msg"]}", isError: true).show(context);
                                  }
                                } else {
                                  MySnackBar(text: 'No response received from server', isError: true,).show(context);
                                }
                              } catch (e) {
                                print('An error occurred: $e');
                                MySnackBar(text: "Delivery Request failed!", isError: true).show(context);
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorsModel.tileBackGroudColor
                          ),
                          child: Text(
                            "New Planning +",
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

                                    Stack(
                                      children:[ 
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

                                        Row(
                                          children: [
                                            Spacer(),

                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(0,8,24,8),
                                              child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: colorsModel.coloreSecondario
                                              ),
                                              onPressed: () async {
                                                List<bool>? vals = await showTaskFiltersDialog(context);
                                                if (vals != null){

                                                  setState(() {
                                                    showUnderway = vals[0];
                                                    showCompleted = vals[1];
                                                    showQueued = vals[2];
                                                    showStandby = vals[3];
                                                    showCanceled = vals[4];
                                                    showFailed = vals[5];
                                                  });

                                                }
                                              }, 
                                              child: Row(
                                                children: [
                                                  Text(
                                                  "Filtri  ",
                                                    style: GoogleFonts.encodeSans(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.w500
                                                    ),
                                                  ),
                                                  Icon(Icons.filter_alt_rounded, color: Colors.white,)
                                              ],
                                              )
                                              ),
                                            )
                                          ],
                                        )
                                      ]
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
                                          children: projectsModel.getProjectTask(projectsModel.projects.elementAt(_selectedTabIndex)).map((task) {
                                            return Padding(
                                              padding: const EdgeInsets.all(0),
                                              child: 
                                              mustBeVisible(task) ?
                                              TaskTile(
                                                project: projectsModel.projects.elementAt(_selectedTabIndex),
                                                task: task,
                                                isHighlighted: highlightedTaskRobotName == task.robotName, 
                                              )
                                              : 
                                              null
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
                                              padding: const EdgeInsets.all(0),
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

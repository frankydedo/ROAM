// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison

import 'package:fleet_manager/models/Project.dart';
import 'package:fleet_manager/providers/ColorsProvider.dart';
import 'package:fleet_manager/providers/ProjectProvider.dart';
import 'package:fleet_manager/utils/NewTaskDialog.dart';
import 'package:fleet_manager/utils/RobotTile.dart';
import 'package:fleet_manager/utils/SelettoreTemaDialog.dart';
import 'package:fleet_manager/utils/TaskTile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> with SingleTickerProviderStateMixin {

  late TabController _tabController;
  int _selectedTabIndex = 0;
  String? highlightedTaskRobotName;

  @override
  void initState() {
    super.initState();

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

  @override
  Widget build(BuildContext context) {
    return Consumer2<ColorsProvider, ProjectProvider>(
      builder: (context, colorsModel, projectsModel, _) {
        Project currentProject = projectsModel.projects[_selectedTabIndex];

        return Scaffold(
          appBar: AppBar(
            backgroundColor: colorsModel.backgroudColor,
            title: Stack(
              children: [
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
                    Icon(CupertinoIcons.clock, color: colorsModel.coloreSecondario, size: 30),
                    SizedBox(width: 8),
                    Text(
                      secToHoursMinsSecs(currentProject.liveTime),
                      style: GoogleFonts.encodeSans(
                          color: colorsModel.coloreTitoli,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          onPressed: () {
                            showNewTaskDialog(context);
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
                    ElevatedButton(
                      onPressed: () async{
                        // Navigator.pushNamed(context, '/settingspage');
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
                                    fontWeight: project == currentProject ? FontWeight.w700 : FontWeight.w500,
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
                                    currentProject.tasks!.isEmpty ? 
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
                                          children: project.tasks!.map((task) {
                                            return Padding(
                                              padding: const EdgeInsets.fromLTRB(14, 14, 0, 12),
                                              child: TaskTile(
                                                project: currentProject,
                                                task: task,
                                                isHighlighted: highlightedTaskRobotName == task.robot.name, 
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
                                    currentProject.robots!.isEmpty ?
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
                                          children: project.robots!.map((robot) {
                                            return Padding(
                                              padding: const EdgeInsets.fromLTRB(14, 14, 0, 12),
                                              child: RobotTile(
                                                project: currentProject,
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

// ignore_for_file: deprecated_member_use

import 'package:fleet_manager/providers/ColorsProvider.dart';
import 'package:fleet_manager/providers/ProjectProvider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class NewTaskDialog extends StatefulWidget {

  NewTaskDialog({super.key});

  @override
  State<NewTaskDialog> createState() => _NewTaskDialogState();
}

class _NewTaskDialogState extends State<NewTaskDialog> with SingleTickerProviderStateMixin {

  late TabController _tabController;
  int _selectedIndex = 0;

  String? json;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Consumer2<ColorsProvider, ProjectProvider>(
      builder: (context, colorsModel, projectsModel, _) {
        return WillPopScope(
          onWillPop: () async {
            Navigator.pop(context, null);
            return false;
          },
          child: AlertDialog(
            backgroundColor: colorsModel.dialogBackgroudColor,
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Text(
                      "Crea un nuovo task",
                      style: GoogleFonts.encodeSans(
                        color: colorsModel.coloreTitoli,
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  DefaultTabController(
                    length: 2,
                    child: Column(
                      children: [
                        TabBar(
                          controller: _tabController,
                          indicatorColor: colorsModel.coloreSecondario,
                          tabs: [
                            Tab(
                              child: Text(
                                "Form",
                                style: GoogleFonts.encodeSans(
                                  color: colorsModel.coloreTitoli,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Tab(
                              child: Text(
                                "JSON",
                                style: GoogleFonts.encodeSans(
                                  color: colorsModel.coloreTitoli,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: screenWidth * 0.7,
                          height: screenHeight * 0.6,
                          child: TabBarView(
                            controller: _tabController,
                            children: [
            
                              // vista per form
            
                              Center(
                                child: Text("Selected: Form"),
                              ),
            
                              // vista per json
            
                              SizedBox(
                                height: 300,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    cursorColor: colorsModel.coloreSecondario,
                                    textInputAction: TextInputAction.done,
                                    onFieldSubmitted: (_){},
                                    textAlign: TextAlign.start,
                                    textAlignVertical: TextAlignVertical.top,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Inserire task in formato JSON";
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      json = value;
                                    },
                                    style: TextStyle(
                                      color: colorsModel.textColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "JSON",
                                      hoverColor: colorsModel.coloreSecondario,
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15)
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide(color: colorsModel.coloreSecondario)
                                      ),
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
            
                  // tasti 
            
                  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
            
                    // tasto annulla
            
                    GestureDetector(
                      onTap: (){
                        Navigator.pop(context, null);
                      },
                      child: Text(
                        "Annulla",
                        style: TextStyle(
                          color: colorsModel.coloreSecondario,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
            
                    // tasto invia
                    ElevatedButton(
                      onPressed: () {
                        if(_selectedIndex == 0){
                          //TODO
                        }else{
                          // TODO validate form
                          Navigator.pop(context, json);
                        }
                      }, 
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, 
                        backgroundColor: colorsModel.coloreSecondario,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        elevation: 5,
                        shadowColor: Colors.black,
                      ),                          
                      child: Text(
                        "Invia",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    
                  ],
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

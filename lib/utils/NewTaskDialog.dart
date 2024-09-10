// ignore_for_file: deprecated_member_use, must_be_immutable

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fleet_manager/providers/ColorsProvider.dart';
import 'package:fleet_manager/providers/ProjectProvider.dart';

class NewTaskDialog extends StatefulWidget {

  List<String> validTask;

  NewTaskDialog({super.key, required this.validTask});

  @override
  State<NewTaskDialog> createState() => _NewTaskDialogState();
}

class _NewTaskDialogState extends State<NewTaskDialog> with SingleTickerProviderStateMixin {

  late TabController _tabController;
  int _selectedIndex = 0;
  
  // GlobalKey for the Form
  final _jsonFormKey = GlobalKey<FormState>();
  final _formFormKey = GlobalKey<FormState>();
  final TextEditingController _jsonController = TextEditingController();
  final TextEditingController _minutiController = TextEditingController();

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
    _jsonController.dispose();
    super.dispose();
  }

  void pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json', 'txt'],
      );

      if (result != null) {
        PlatformFile pickedFile = result.files.first;

        if (kIsWeb) {
          // Su Web, usa bytes per accedere al contenuto del file
          Uint8List? fileBytes = pickedFile.bytes;
          if (fileBytes != null) {
            String fileContent = String.fromCharCodes(fileBytes);
            _jsonController.text = fileContent;
          }
        } else {
          // Su Desktop/Mobile, usa il percorso del file
          String? filePath = pickedFile.path;
          if (filePath != null) {
            File file = File(filePath);
            String fileContent = await file.readAsString();
            _jsonController.text = fileContent;
          }
        }
      } else {
        print("No file selected.");
      }
    } catch (e) {
      print("Error picking file: $e");
    }
  }

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    String? _selectedTask;
    String? _selectedPriority;

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
                      "Crea un nuovo planning",
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
                              Form(
                                key: _formFormKey,
                                child: Column(
                                  children: [
                                
                                    SizedBox(
                                      width: screenWidth * 0.5,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: DropdownButtonFormField<String>(
                                          validator: (value) {
                                            if(value == null){
                                              return "Sceglere il task da eseguire";
                                            }
                                            return null;
                                          },
                                          value: _selectedTask,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                          ),
                                          decoration: InputDecoration(
                                            hintText: "seleziona un task",
                                            hintStyle: TextStyle(color: Colors.grey),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(15),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(15),
                                              borderSide: BorderSide(color: colorsModel.coloreSecondario),
                                            ),
                                          ),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              _selectedTask = newValue;
                                            });
                                          },
                                          items: widget.validTask.map((String task) {
                                            return DropdownMenuItem<String>(
                                              value: task,
                                              child: Text(task),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                
                                    SizedBox(
                                      width: screenWidth * 0.5,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextFormField(
                                          keyboardType: TextInputType.number,
                                          controller: _minutiController,
                                          cursorColor: colorsModel.coloreSecondario,
                                          textInputAction: TextInputAction.done,
                                          textAlign: TextAlign.start,
                                          textAlignVertical: TextAlignVertical.top,
                                          validator: (value) {
                                            //TODO
                                            return null;
                                          },
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                          ),
                                          decoration: InputDecoration(
                                            hintText: "minuti da ora",
                                            hintStyle: TextStyle(color: Colors.grey),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(15),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(15),
                                              borderSide: BorderSide(color: colorsModel.coloreSecondario),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    SizedBox(
                                      width: screenWidth * 0.5,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: DropdownButtonFormField<String>(
                                          validator: (value) {
                                            if(value == null){
                                              return "Sceglere la priorità";
                                            }
                                            return null;
                                          },
                                          value: _selectedPriority,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                          ),
                                          decoration: InputDecoration(
                                            hintText: "seleziona una priorità",
                                            hintStyle: TextStyle(color: Colors.grey),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(15),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(15),
                                              borderSide: BorderSide(color: colorsModel.coloreSecondario),
                                            ),
                                          ),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              _selectedTask = newValue;
                                            });
                                          },
                                          items: [
                                            DropdownMenuItem<String>(
                                              value: "High",
                                              child: Text("High")
                                            ),
                                            DropdownMenuItem(
                                              value: "Low",
                                              child: Text("Low")
                                            ),

                                          ],
                                        ),
                                      ),
                                    ),
                                
                                //TODO: temrinare il form
                                
                                
                                  ],
                                ),
                              ),

                              // vista per json
                              Form(
                                key: _jsonFormKey,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 300,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextFormField(
                                          controller: _jsonController,
                                          cursorColor: colorsModel.coloreSecondario,
                                          textInputAction: TextInputAction.done,
                                          textAlign: TextAlign.start,
                                          textAlignVertical: TextAlignVertical.top,
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return "Inserire task in formato JSON";
                                            }
                                            return null;
                                          },
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                          ),
                                          decoration: InputDecoration(
                                            hintText: "JSON",
                                            hintStyle: TextStyle(color: Colors.grey),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(15),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(15),
                                              borderSide: BorderSide(color: colorsModel.coloreSecondario),
                                            ),
                                          ),
                                          minLines: 10,
                                          maxLines: null,
                                        ),
                                      ),
                                    ),
                                    ElevatedButton.icon(
                                      onPressed: pickFile,
                                      icon: Icon(Icons.attach_file),
                                      label: Text("Scegli file"),
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: colorsModel.coloreSecondario,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                      ),
                                    ),
                                  ],
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
                        onTap: () {
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
                          if (_selectedIndex == 0) {
                            // TODO: Gestione della tab "Form"
                          } else {
                            if (_jsonFormKey.currentState?.validate() ?? false) {
                              Navigator.pop(context, _jsonController.text);
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: colorsModel.coloreSecondario,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 15,
                          ),
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

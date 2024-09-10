// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fleet_manager/providers/ColorsProvider.dart';
import 'package:fleet_manager/providers/ProjectProvider.dart';

class NewTaskDialog extends StatefulWidget {
  NewTaskDialog({super.key});

  @override
  State<NewTaskDialog> createState() => _NewTaskDialogState();
}

class _NewTaskDialogState extends State<NewTaskDialog> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;
  String? json;
  
  // GlobalKey for the Form
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _jsonController = TextEditingController();

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

  Future<void> _pickFile() async {
    print("File picker button pressed");
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json', 'txt'],
      );

      if (result != null) {
        File file = File(result.files.single.path!);
        String fileContent = await file.readAsString();
        setState(() {
          _jsonController.text = fileContent;
          json = fileContent;
        });
        print("File content loaded successfully");
      } else {
        print("No file selected");
      }
    } catch (e) {
      print("Error picking file: $e");
    }
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
                              Center(
                                child: Text("Selected: Form"),
                              ),

                              // vista per json
                              Form(
                                key: _formKey,  // Associating the form key
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 200,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextFormField(
                                          controller: _jsonController,
                                          cursorColor: colorsModel.coloreSecondario,
                                          textInputAction: TextInputAction.done,
                                          onFieldSubmitted: (_) {},
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
                                              borderRadius: BorderRadius.circular(15),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(15),
                                              borderSide: BorderSide(
                                                color: colorsModel.coloreSecondario,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    ElevatedButton.icon(
                                      onPressed: _pickFile,
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
                            if (_formKey.currentState?.validate() ?? false) {
                              Navigator.pop(context, json);
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

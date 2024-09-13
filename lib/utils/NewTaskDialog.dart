// ignore_for_file: deprecated_member_use, must_be_immutable

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fleet_manager/providers/ColorsProvider.dart';
import 'package:fleet_manager/providers/ProjectProvider.dart';
import 'package:http/http.dart' as http;


class NewTaskDialog extends StatefulWidget {

  NewTaskDialog({super.key});

  @override
  State<NewTaskDialog> createState() => _NewTaskDialogState();
}

class _NewTaskDialogState extends State<NewTaskDialog> with SingleTickerProviderStateMixin {

  late TabController _tabController;
  int _selectedIndex = 0;
  List<String> validTasks = [];
  List<String> places = [];

  String? _selectedTask;
  String? _selectedPriority;
  String? _selectedStartingSpot;
  String? _selectedEndingSpot;

  final String apiServerAddress = "http://localhost:8083";
  
  final _jsonFormKey = GlobalKey<FormState>();
  final _formFormKey = GlobalKey<FormState>();

  final TextEditingController _jsonController = TextEditingController();
  final TextEditingController _minutiController = TextEditingController();
  final TextEditingController _loopsController = TextEditingController();

  List<String> deliveryTemplate = [
    '{"task_type":"Delivery","start_time":',
    ',"priority":',
    ',"description":{"dropoff_ingestor":"coke_ingestor","dropoff_place_name":"hardware_2","pickup_dispenser":"coke_dispenser","pickup_place_name":"pantry"}}'
  ];

  List<String> loopTemplate = [
    '{"task_type":"Loop","start_time":',
    ',"priority":',
    ',"description":{"num_loops":',
    ',"start_name":',
    ',"finish_name":',
    '}}'
  ];

  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _initializeData();

    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });
  }

  Future<void> _initializeData() async {
    try {
      List<String> fetchedValidTasks = await getValidTasks();
      List<String> fetchedPlaces = await getPlaces();
      
      setState(() {
        validTasks = fetchedValidTasks;
        places = fetchedPlaces;
      });

    } catch (e) {
      print("Error initializing data: ${e.toString()}");
    }
  }

  Future<List<String>> getValidTasks() async {
    try {
      final response = await http.get(Uri.parse('$apiServerAddress/dashboard_config'));

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonMap = json.decode(response.body);
        return List<String>.from(jsonMap['valid_task']);
      } else {
        throw Exception('Failed to load valid tasks');
      }
    } catch (e) {
      throw Exception('Error: ${e.toString()}');
    }
  }

  Future<List<String>> getPlaces() async {
    try {
      final response = await http.get(Uri.parse('$apiServerAddress/dashboard_config'));

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonMap = json.decode(response.body);
        return List<String>.from(jsonMap['task']['Loop']['places']);
      } else {
        throw Exception('Failed to load places');
      }
    } catch (e) {
      throw Exception('Error: ${e.toString()}');
    }
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
                                            if (value == null) {
                                              return "Scegliere il task da eseguire";
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
                                            hintText: "Seleziona un task",
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
                                          items: validTasks.map((String task) {
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
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: screenWidth * 0.32,
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
                                                  if (value == null || value.isEmpty) {
                                                    return "Inserire i minuti";
                                                  }
                                                  if (int.tryParse(value) == null || int.parse(value) < 0) {
                                                    return "Inserire un valore positivo";
                                                  }
                                                  return null;
                                                },
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                decoration: InputDecoration(
                                                  hintText: "Minuti da ora",
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
                                          Spacer(),
                                          Text(
                                            "OPPURE",
                                            style: GoogleFonts.encodeSans(
                                              color: colorsModel.textColor,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Spacer(),
                                          SizedBox(
                                            width: screenWidth * 0.12,
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: ElevatedButton(
                                                onPressed: () async {
                                                  DateTime? pickedDate = await showDatePicker(
                                                    context: context,
                                                    initialDate: DateTime.now(),
                                                    firstDate: DateTime.now(),
                                                    lastDate: DateTime(2101),
                                                    builder: (BuildContext context, Widget? child) {
                                                      return Theme(
                                                        data: ThemeData(
                                                          colorScheme: ColorScheme.light(
                                                            primary: colorsModel.tileBackGroudColor,
                                                            onPrimary: colorsModel.coloreTitoli,
                                                            onSurface: colorsModel.textColor,
                                                            surface: colorsModel.tileBackGroudColor,
                                                          ),
                                                          textButtonTheme: TextButtonThemeData(
                                                            style: TextButton.styleFrom(
                                                              foregroundColor: colorsModel.coloreSecondario,
                                                            ),
                                                          ),
                                                          dialogBackgroundColor: colorsModel.tileBackGroudColor,
                                                        ),
                                                        child: child!,
                                                      );
                                                    },
                                                  );

                                                  if (pickedDate != null) {
                                                    TimeOfDay? pickedTime = await showTimePicker(
                                                      context: context,
                                                      initialTime: TimeOfDay.now(),
                                                      builder: (BuildContext context, Widget? child) {
                                                      return Theme(
                                                        data: ThemeData(
                                                          colorScheme: ColorScheme.light(
                                                            primary: colorsModel.tileBackGroudColor, 
                                                            onPrimary: colorsModel.coloreTitoli, 
                                                            onSurface: colorsModel.textColor, 
                                                            surface: colorsModel.tileBackGroudColor, 
                                                          ),
                                                          textButtonTheme: TextButtonThemeData(
                                                            style: TextButton.styleFrom(
                                                              foregroundColor: colorsModel.coloreSecondario,
                                                            ),
                                                          ),
                                                          dialogBackgroundColor: colorsModel.tileBackGroudColor,
                                                        ),
                                                        child: child!,
                                                      );
                                                    },
                                                    );

                                                    if (pickedTime != null) {
                                                      DateTime finalDateTime = DateTime(
                                                        pickedDate.year,
                                                        pickedDate.month,
                                                        pickedDate.day,
                                                        pickedTime.hour,
                                                        pickedTime.minute,
                                                      );

                                                      int diff = ((finalDateTime.millisecondsSinceEpoch - DateTime.now().millisecondsSinceEpoch) / 60000).round();
                                                      setState(() {
                                                        _minutiController.text = diff.toString();
                                                      });
                                                    }
                                                  }
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: colorsModel.coloreSecondario,
                                                  padding: EdgeInsets.symmetric(vertical: 15),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(15),
                                                  ),
                                                ),
                                                child: Text(
                                                  "Seleziona data e ora",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.normal,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
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
                                            hintText: "Seleziona una priorità",
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
                                              _selectedPriority = newValue;
                                            });
                                          },
                                          items: [
                                            DropdownMenuItem<String>(
                                              value: "1",
                                              child: Text("High")
                                            ),
                                            DropdownMenuItem(
                                              value: "0",
                                              child: Text("Low")
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    if (_selectedTask == "Loop")

                                      Column(
                                        children: [
                                          SizedBox(
                                            width: screenWidth * 0.5,
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: TextFormField(
                                                keyboardType: TextInputType.number,
                                                controller: _loopsController,
                                                cursorColor: colorsModel.coloreSecondario,
                                                textInputAction: TextInputAction.done,
                                                textAlign: TextAlign.start,
                                                textAlignVertical: TextAlignVertical.top,
                                                validator: (value) {
                                                  if (value == null || value.isEmpty) {
                                                    return "Inserire il numero di loop";
                                                  }
                                                  if (int.tryParse(value) == null || int.parse(value) < 0) {
                                                    return "Inserire un valore positivo";
                                                  }
                                                  return null;
                                                },
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                decoration: InputDecoration(
                                                  hintText: "Numero di loop",
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
                                                  if (value == null) {
                                                    return "Scegliere il punto di partenza";
                                                  }
                                                  return null;
                                                },
                                                value: _selectedStartingSpot,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                decoration: InputDecoration(
                                                  hintText: "Seleziona un punto di partenza",
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
                                                    _selectedStartingSpot = newValue;
                                                  });
                                                },
                                                items: places.map((String place) {
                                                  return DropdownMenuItem<String>(
                                                    value: place,
                                                    child: Text(place),
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                          ),
                                          
                                          SizedBox(
                                            width: screenWidth * 0.5,
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: DropdownButtonFormField<String>(
                                                validator: (value) {
                                                  if (value == null) {
                                                    return "Scegliere il punto di arrivo";
                                                  }
                                                  return null;
                                                },
                                                value: _selectedEndingSpot,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                decoration: InputDecoration(
                                                  hintText: "Seleziona un punto di arrivo",
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
                                                    _selectedEndingSpot = newValue;
                                                  });
                                                },
                                                items: places.map((String place) {
                                                  return DropdownMenuItem<String>(
                                                    value: place,
                                                    child: Text(place),
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
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

                            String t;

                            if (_formFormKey.currentState?.validate() ?? false) {
                              if(_selectedTask == "Loop"){
                                t = 
                                  loopTemplate[0]+_minutiController.text+
                                  loopTemplate[1]+_selectedPriority!+
                                  loopTemplate[2]+_loopsController.text+
                                  loopTemplate[3]+'"'+_selectedStartingSpot!+'"'+
                                  loopTemplate[4]+'"'+_selectedEndingSpot!+'"'+
                                  loopTemplate[5];
                              }else{
                                t = 
                                  deliveryTemplate[0]+_minutiController.text+
                                  deliveryTemplate[1]+_selectedPriority!+
                                  deliveryTemplate[2];
                              }

                              Navigator.pop(context, t);

                            }

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

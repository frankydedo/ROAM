// ignore_for_file: must_be_immutable, deprecated_member_use

import 'package:fleet_manager/providers/AddressProvider.dart';
import 'package:fleet_manager/providers/ColorsProvider.dart';
import 'package:fleet_manager/providers/ProjectProvider.dart';
import 'package:fleet_manager/utils/RealTimeStatusWidget2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ConnessioneDialog extends StatefulWidget {
  ConnessioneDialog({super.key});

  @override
  State<ConnessioneDialog> createState() => _ConnessioneDialogState();
}

class _ConnessioneDialogState extends State<ConnessioneDialog> {

  late bool switchValue;

  @override
  void initState() {
    super.initState();

    switchValue = context.read<AddressProvider>().useLocalhost;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Consumer3<ColorsProvider, ProjectProvider, AddressProvider>(
      builder: (context, colorsModel, ricetteModel, addressModel, _) {
        return WillPopScope(
          onWillPop: ()async{
            Navigator.pop(context , switchValue);
            return switchValue;
          },
          child: AlertDialog(
            backgroundColor: colorsModel.dialogBackgroudColor,
            content: SizedBox(
              width: screenWidth * 0.8,
              height: screenHeight * 0.8,
              child: Column(
                children: [
                  Icon(
                    CupertinoIcons.wifi,
                    color: colorsModel.coloreSecondario,
                    size: 50,
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: 480,
                    height: 50,
                    decoration: BoxDecoration(
                      color: colorsModel.isLightMode
                          ? colorsModel.tileBackGroudColor
                          : Colors.black,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            "Stato della connessione",
                            style: GoogleFonts.encodeSans(
                              color: colorsModel.textColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Spacer(),
                          RealTimeStatusWidget2(),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  Container(
                    width: 480,
                    height: 50,
                    decoration: BoxDecoration(
                      color: colorsModel.isLightMode
                          ? colorsModel.tileBackGroudColor
                          : Colors.black,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            "Usa localhost",
                            style: GoogleFonts.encodeSans(
                              color: colorsModel.textColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Spacer(),
                          CupertinoSwitch(
                            value: switchValue,
                            onChanged: (value) {
                              switchValue = value;
                              // print(switchValue.toString());
                            },
                            activeColor: Colors.green,
                          ),
                        ],
                      ),
                    ),
                  ),

                  Spacer(),

                  ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, switchValue);
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
                    "Fatto",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
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

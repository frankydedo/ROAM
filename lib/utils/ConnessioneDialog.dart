// ignore_for_file: must_be_immutable, deprecated_member_use

import 'package:fleet_manager/providers/AddressProvider.dart';
import 'package:fleet_manager/providers/ColorsProvider.dart';
import 'package:fleet_manager/providers/ProjectProvider.dart';
import 'package:fleet_manager/utils/RealTimeStatusWidget2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:validators/validators.dart';

class ConnessioneDialog extends StatefulWidget {
  ConnessioneDialog({super.key});

  @override
  State<ConnessioneDialog> createState() => _ConnessioneDialogState();
}

class _ConnessioneDialogState extends State<ConnessioneDialog> {

  late bool switchValue;
  late TextEditingController _ipController;
  String? _errorText;


  @override
  void initState() {
    super.initState();
    
    _ipController = TextEditingController(text:  Provider.of<AddressProvider>(context, listen: false).ipAddress);
    switchValue = context.read<AddressProvider>().useLocalhost;
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool _isValidIp(String ip) {
    return isIP(ip);  // Usa la libreria 'validators' per validare l'indirizzo IP
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
            content: SingleChildScrollView(
              child: SizedBox(
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
                              "IP locale del server",
                              style: GoogleFonts.encodeSans(
                                color: colorsModel.textColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Spacer(),
                            // Text(
                            //   addressModel.ipAddress+"   ",
                            //   style: GoogleFonts.encodeSans(
                            //     color: colorsModel.textColor,
                            //     fontSize: 20,
                            //     fontWeight: FontWeight.w600,
                            //   ),
                            // ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: 130,
                                child: TextField(
                                  textAlign: TextAlign.center,
                                  controller: _ipController,
                                  style: GoogleFonts.encodeSans(
                                    fontSize: 18,
                                    color: colorsModel.textColor,
                                  ),
                                  decoration: InputDecoration(
                                    errorText: _errorText,
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 10, 
                                    ),
                                    // border: OutlineInputBorder(
                                    //   borderRadius: BorderRadius.circular(15),
                                    // ),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      if (_isValidIp(value)) {
                                        _errorText = null;
                                        addressModel.changeIPaddress(value);
                                      } else {
                                        _errorText = 'IP non valido';
                                      }
                                    });
                                  },
                                ),
                              ),
                            )
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
          ),
        );
      },
    );
  }
}

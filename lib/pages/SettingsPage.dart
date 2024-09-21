// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison

import 'dart:async';
import 'package:fleet_manager/providers/AddressProvider.dart';
import 'package:fleet_manager/providers/ColorsProvider.dart';
import 'package:fleet_manager/providers/ProjectProvider.dart';
import 'package:fleet_manager/utils/ConnessioneDialog.dart';
import 'package:fleet_manager/utils/RealTimeStatusWidget.dart';
import 'package:fleet_manager/utils/SelettoreTemaDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({super.key});

  // final int initMillisecondsSinceEpoch = DateTime.now().millisecondsSinceEpoch;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  Future showSelettoreTemaDialog(BuildContext context) {
    final colorsModel = Provider.of<ColorsProvider>(context, listen: false);
    return showDialog(
      context: context,
      builder: (context) => SelettoreTemaDialog(selezione: colorsModel.temaAttuale),
    );
  }

  Future showConnessioneDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => ConnessioneDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    
    double screenWidth = MediaQuery.of(context).size.width;

    return Consumer3<ColorsProvider, ProjectProvider, AddressProvider>(
      builder: (context, colorsModel, projectsModel, addressModel, _) {

        return Scaffold(

          // app bar

          appBar: AppBar(
            backgroundColor: colorsModel.backgroudColor,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(CupertinoIcons.back, color: colorsModel.coloreSecondario, size: 30)
            ),
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    height: 65,
                    child: Image.asset('assets/youbiquo_logos/youbiquo_logo_esteso.png')),
              ],
            ),
          ),

          body: Scaffold(
            backgroundColor: colorsModel.backgroudColor,
            body: SingleChildScrollView(
              child: Column(
                children: [

                  // tile connessione

                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Row(
                      children: [
                        Spacer(),
                        GestureDetector(
                          onTap: () async {
                            bool useLocalhost = await showConnessioneDialog(context);
                            if (useLocalhost){
                              addressModel.setUseLocalhost();
                            }else{
                              addressModel.resetUseLocalhost();
                            }
                          },
                          child: Container(
                            width: screenWidth * 0.85,
                            height: 65,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: colorsModel.tileBackGroudColor,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 3,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                          
                                // icona
                          
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Container(
                                    width: 35,
                                    height: 35,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.blueAccent.shade700
                                    ),
                                    child: Icon(CupertinoIcons.wifi, color: Colors.white),
                                  ),
                                ),
                          
                                // testo
                          
                                SizedBox(width: 24),
                          
                                Text(
                                  "Connessione",
                                  style: GoogleFonts.encodeSans(
                                    color: colorsModel.textColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500
                                  ),
                                ),
                          
                                Spacer(),
                          
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: RealTimeStatusWidget(),
                                )
                              ],
                            ),
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                  ),

                  // tile tema

                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Row(
                      children: [
                        Spacer(),
                        GestureDetector(
                          onTap: () async {
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
                          child: Container(
                            width: screenWidth * 0.85,
                            height: 65,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: colorsModel.tileBackGroudColor,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 3,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                          
                            child: Row(
                              children: [
                          
                                // icona
                          
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Container(
                                    width: 35,
                                    height: 35,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.orange.shade700
                                    ),
                                    child: Icon(CupertinoIcons.device_phone_portrait, color: Colors.white),
                                  ),
                                ),
                          
                                // testo 
                          
                                SizedBox(width: 24),
                          
                                Text(
                                  "Tema",
                                  style: GoogleFonts.encodeSans(
                                    color: colorsModel.textColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Spacer()
                      ],
                    ),
                  )



                ],
              )
            ),
          ),
        );
      },
    );
  }
}

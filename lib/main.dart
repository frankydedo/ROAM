// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:fleet_manager/pages/FirstPage.dart';
import 'package:fleet_manager/providers/ColorsProvider.dart';
import 'package:fleet_manager/providers/ProjectProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ColorsProvider()),
        ChangeNotifierProvider(create: (_) => ProjectProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver{

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    Future.microtask(() async {
      final colorsProvider = Provider.of<ColorsProvider>(context, listen: false);
      await colorsProvider.initializationDone;  // aspetto che i dati siano in uno stato consistente 
      colorsProvider.initLightMode(context);
      print(colorsProvider.temaAttuale.toString());
    });
  }

  @override
  void didChangePlatformBrightness() {
    if(Provider.of<ColorsProvider>(context, listen: false).temaAttuale == "Sistema Operativo"){
      final colorsProvider = Provider.of<ColorsProvider>(context, listen: false);
      colorsProvider.updateLightMode(context);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.inactive:
        print('App is inactive');
        break;
      case AppLifecycleState.paused:
        print('App is paused');
        break;
      case AppLifecycleState.resumed:
        print('App is resumed');
        break;
      case AppLifecycleState.detached:
        print('App is detached');
        break;
      case AppLifecycleState.hidden:
        print('App is hidden');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fleet Manager',
      debugShowCheckedModeBanner: false,
      home: const FirstPage(),
      routes: {
          '/firstpage': (context) => FirstPage(),
      },
    );
  }
}

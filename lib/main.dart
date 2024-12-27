import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:iot/view/splash.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:iot/constant.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  try {
    await Supabase.initialize(
      url: 'https://dvardpoocedgbmhqtzqn.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImR2YXJkcG9vY2VkZ2JtaHF0enFuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzE4MDUyMzYsImV4cCI6MjA0NzM4MTIzNn0.sofSzSQC7BbDJL-a1XLJF_STPMS38-F6y1ZYSOrVDrQ',
    );
  } catch (e) {
    print("no enternet");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          appBarTheme: AppBarTheme(backgroundColor: Genral.grey2, elevation: 0),
          canvasColor: Genral.canvas,
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.grey),
          useMaterial3: true,
          fontFamily: "Cairo"),
      home: MyWidget(),
      debugShowCheckedModeBanner: false,
    );
  }
}

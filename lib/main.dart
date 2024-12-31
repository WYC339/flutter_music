import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'data/api/repositories/music_repository.dart';
import 'module/main/main_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return appBuilder();
  }

  Widget appBuilder() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => MusicRepository(), lazy: true),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 800),
        child: MaterialApp(
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: MainPage(),
          debugShowCheckedModeBanner: true,
        ),
      ),
    );
  }
}

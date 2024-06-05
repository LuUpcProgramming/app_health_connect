import 'package:app_health_connect/bindings/general_bindings.dart';
import 'package:app_health_connect/config/theme/app_theme.dart';
import 'package:app_health_connect/data/repositories/authentication/authentication_repository.dart';
import 'package:app_health_connect/firebase_options.dart';
import 'package:app_health_connect/utils/constants/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_storage/get_storage.dart';
Future<void> main() async{
  //Add Widgets Binding
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  //Getx Local Storage
  await GetStorage.init();

  await dotenv.load(fileName: '.env');

  // Await Splash until other items Load
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  
  // Initialize Firebase & Authentication Repository
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  ).then(
    (FirebaseApp value) => Get.put(AuthenticationRepository()),
    //(FirebaseApp value) => Get.off(const WelcomeScreen()),
  );

  //


  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    /*
    return MaterialApp.router(
      routerConfig: appRouter,
      title: 'Health Connect App',
      theme: AppTheme().getTheme(),
      debugShowCheckedModeBanner: false,
      //home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
    */
    return GetMaterialApp(
      title: 'Health Connect App',
      theme: AppTheme().getTheme(),
      debugShowCheckedModeBanner: false,
      initialBinding: GeneralBindings(),
      //home: const OnboardingScreen()
      //home: const MyHomePage(title: 'Flutter Demo Home Page'),
      home: const Scaffold(backgroundColor: TColors.primary,body: Center(child: CircularProgressIndicator(color: TColors.white),))
    );
  }
}




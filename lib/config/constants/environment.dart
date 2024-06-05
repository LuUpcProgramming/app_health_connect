import 'package:flutter_dotenv/flutter_dotenv.dart';


class Environment {

  static String openAiKey = dotenv.env['OPENAI_KEY'] ?? 'No hay openai api key';
  static String firebaseWebKey = dotenv.env['F_WEB_KEY'] ?? 'No hay firebase web key';
  static String firebaseAndroidKey = dotenv.env['F_ANDROID_KEY'] ?? 'No hay firebase android key';
  static String firebaseIOSKey = dotenv.env['F_IOS_KEY'] ?? 'No hay firebase IOS key';
  static String firebaseMacOSKey = dotenv.env['F_MACOS_KEY'] ?? 'No hay firebase MACOS key';
  static String firebaseWindowsKey = dotenv.env['F_WINDOWS_KEY'] ?? 'No hay firebase WINDOWS key';
  //static String openAiKey = 'No hay openai api key';


}
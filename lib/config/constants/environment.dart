import 'package:flutter_dotenv/flutter_dotenv.dart';


class Environment {

  static String openAiKey = dotenv.env['OPENAI_KEY'] ?? 'No hay openai api key';
  //static String openAiKey = 'No hay openai api key';


}
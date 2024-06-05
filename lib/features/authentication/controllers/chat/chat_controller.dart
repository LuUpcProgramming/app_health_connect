import 'package:app_health_connect/features/authentication/controllers/dashboard/dashboard_controller.dart';
import 'package:app_health_connect/features/authentication/models/user_model.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  static ChatController get instance => Get.find();

  //***************Variables***************/
  // final _user = UserModel(id: '',);

  //***************Métodos***************/
  @override
  void onInit() {
    super.onInit();
    cargaDatosChat();
  }

  void cargaDatosChat() {
    final dashboard = Get.put(DashboardController());
    var _user = dashboard.user;
  }
}

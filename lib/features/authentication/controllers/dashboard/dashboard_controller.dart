import 'package:app_health_connect/config/helper/logging.dart';
import 'package:app_health_connect/data/repositories/user/user_repository.dart';
import 'package:app_health_connect/features/authentication/models/user_model.dart';
import 'package:app_health_connect/utils/popups/loaders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  static DashboardController get instance => Get.find();

  //***************Variables***************/
  final log = logger(DashboardController);
  final _user = Rx<UserModel?>(null);
  UserModel? get user => _user.value;

  //***************Métodos***************/

  @override
  void onInit() {
    super.onInit();
    cargaDatosDashboard();
  }

  //Cargas Data
  Future<void> cargaDatosDashboard() async {
    try {
      //Show Dialog
      final currentUser = FirebaseAuth.instance.currentUser;
      log.i('currentUser: $currentUser');
      if (currentUser != null) {
        final userRepository = Get.put(UserRepository());
        UserModel user =
            await userRepository.getUserRecord(currentUser.uid.trim());
        _user.value = user;
        log.i('Welcome Screen: ${_user.value}');
      } else {
        throw Exception('Usuario no está logueado');
      }
    } catch (e) {
      //Show some generic error to user
      Loaders.errorSnackBar(
          title: 'Oh, sucedió un error', message: e.toString());
      throw Exception(e);
    }
  }
}

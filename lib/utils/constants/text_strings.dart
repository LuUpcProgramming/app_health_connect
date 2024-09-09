import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// This class contains all the App Text in String formats.
class TTexts {
  // -- GLOBAL Texts
  static const String and = "Y";
  static const String skip = "Saltar";
  static const String done = "Hecho";
  static const String submit = "Enviar";
  static const String appName = "Health Connect";
  static const String tContinue = "Continuar";
  static const String tNext = "Siguiente";
  static const String tStart = "Comenzar";

  // -- OnBoarding Texts
  static const String onBoardingTitle1 = "Encuentra la calma en cada día";
  static const String onBoardingTitle2 = "Juntos hacia una mente más saludable";
  static const String onBoardingTitle3 =
      "Empieza hoy mismo tu viaje hacia el equilibrio mental";

  static const String onBoardingSubTitle1 =
      "Bienvenido(a) a Health Connect - Tu Bienestar es nuestra prioridad!";
  static const String onBoardingSubTitle2 =
      "Ofrecemos herramientas personalizadas para cuidar de ti.!";
  static const String onBoardingSubTitle3 =
      "Explora nuestras funciones interactivas diseñadas para promover la serenidad y el autocuidado diario.!";

  // -- Authentication Forms
  static const String firstName = "Nombres";
  static const String lastName = "Apellidos";
  static const String email = "Correo Electrónico";
  static const String password = "Contraseña";
  static const String newPassword = "New Password";
  static const String username = "Username";
  static const String phoneNo = "Teléfono";
  static const String rememberMe = "Recuérdame";
  static const String forgetPassword = "¿Olvidó su contraseña?";
  static const String signIn = "Iniciar Sesión";
  static const String createAccount = "Crea una Cuenta";
  static const String registerAccount = "Registrarme";
  static const String orSignInWith = "o inicia sesión con";
  static const String orSignUpWith = "or sign up with";
  static const String iAgreeTo = "De acuerdo con ";
  static const String privacyPolicy = "Política de privacidad";
  static const String termsOfUse = "Términos de Uso";
  static const String verificationCode = "verificationCode";
  static const String resendEmail = "Reenviar Correo";
  static const String resendEmailIn = "Resend email in";

  // -- Authentication Headings
  static const String loginTitle = "Health Connect";
  static const String loginSubTitle = "''Tu bienestar donde sea que trabajes''";
  static const String signupTitle = "Creemos tu Cuenta";
  static const String forgetPasswordTitle = "Olvidé la Contraseña";
  static const String forgetPasswordSubTitle =
      "No te preocupes a veces las personas también puede olvidarla, ingresa tu correo electrónico y te enviaremos un enlace para restablecer tu contraseña.";
  static const String changeYourPasswordTitle =
      "Correo Electrónico de Restablecimiento de Contraseña Enviado.";
  static const String changeYourPasswordSubTitle =
      "¡La seguridad de su cuenta es nuestra prioridad! Le hemos enviado un enlace seguro para cambiar su contraseña de forma segura y mantener su cuenta protegida.";
  static const String confirmEmail = "Verifica tu Correo Electrónico!";
  static const String confirmEmailSubTitle =
      "Felicidades! Por favor, verifica tu correo electrónico para empezar tu viaje hacia un mejor bienestar mental con Health Connect. ¡Estamos aquí para apoyarte!";
  static const String emailNotReceivedMessage =
      "¿No recibiste el correo electrónico? Revisa tu correo no deseado/spam o reenvíalo.";
  static const String yourAccountCreatedTitle =
      "Tu Cuenta ha sido creada Exitosamente!";
  static const String yourAccountCreatedSubTitle =
      "Bienvenido a Health Connect, ya puedes comenzar tu viaje hacia un mejor bienestar mental. ¡Estamos aquí para apoyarte!";

  //Informacion Preliminar con Asistente
  static const String ipPresentationIATitle = 'Hola ';
  static const String ipPresentationIASubtitle =
      'Me llamo Coni y seré tu asistente virtual. Primero Conozcamonos!';
  static const String ipPersonalInfoTitle = 'Cuéntame sobre ti';
  static const String ipPersonalInfoGenero = 'Género';
  static const String ipPersonalInfoFechaNac = 'Fecha de Nacimiento';
  static const String ipPersonalInfoAltura = 'Altura(cm)';
  static const String ipPersonalInfoPeso = 'Peso(kg)';
  static const String ipWorkInfoTitle = 'Cuéntame sobre tu trabajo';
  static const String ipWorkInfoOcupacion = 'Ocupación';
  static const String ipWorkInfoModTrabajo = 'Modalidad de Trabajo';
  static const String ipWorkInfoHoraTrabajo = 'Horas de Trabajo';
  static const String ipWorkInfoTipoContrato = 'Tipo de Contrato';
  static const String ipHealthInfoTitle = 'Cuéntame sobre tu Salud';
  static const String ipHealthInfoSubtitle =
      'Elige las opciones que sientes que están afectando tu salud provocado por tu trabajo';
  static const String ipHealthInfoAnsiedad = 'Ansiedad';

  // -- Product
  static const String popularProducts = "Popular Products";

  // -- Home
  static const String homeAppbarTitle = "Good day for shopping";
  static const String homeAppbarSubTitle = "Taimoor Sikander";

  // -- Dashboard
  static const String avatarTitle = "Bienvenido(a)";

  // -- Chat
  static const String procesarConversacion = "Procesar";
  static const String eliminarConversacion = "Eliminar";

  //Estadisticas
  static const String sinRegistros = "";
  static const String diaria = "Diaria";
  static const String semanal = "Semanal";
  static const String mensual = "Mensual";
  // static const String eliminarConversacion = "Eliminar";

  //Actividades
  static const String activMeditacion = "Meditación";
  static const String actividadAlimentacion = "Alimentación";
  static const String actividadFisico = "Actividad Física";

  //Logros
  static const int logroGourmetSaludable = 1;
  static const int logroEquilibrioInterior = 2;
  static const int logroResilienciaFitness = 3;

  // -- Planes
/*   static const int logroCompletado = 1;
  static const int logroIncompleto = 0;
  static const int confirmado = 1;
  static const int noConfirmado = 0; */
  static const int estadoPendiente = 0;
  static const int estadoCompletado = 1;
  static const int estadoIncompleto = 2;
  static const int estadoAnulado = 3;
  static const int indicadorGenerarPlan = 1;
  static const int indicadorTerminarChat = 2;

  //Dias
  static const List<String> dias = [
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábado',
    'Domingo'
  ];

  static IconData obtenerIconoLogro(int tipoLogro) {
    if (tipoLogro == TTexts.logroGourmetSaludable) {
      return Icons.soup_kitchen;
    } else if (tipoLogro == TTexts.logroEquilibrioInterior) {
      return Icons.self_improvement;
    } else if (tipoLogro == TTexts.logroResilienciaFitness) {
      return Icons.directions_run;
    } else {
      return Icons.report_off;
    }
  }

  static IconData obtenerIconoPlan(int tipoLogro) {
    if (tipoLogro == TTexts.logroGourmetSaludable) {
      return Icons.local_dining;
    } else if (tipoLogro == TTexts.logroEquilibrioInterior) {
      return Icons.volunteer_activism;
    } else if (tipoLogro == TTexts.logroResilienciaFitness) {
      return Icons.fitness_center;
    } else {
      return Icons.report_off;
    }
  }

  static String obtenerNombreLogro(int tipoLogro) {
    if (tipoLogro == TTexts.logroGourmetSaludable) {
      return 'Gourmet Saludable';
    } else if (tipoLogro == TTexts.logroEquilibrioInterior) {
      return 'Equilibrio Interior';
    } else if (tipoLogro == TTexts.logroResilienciaFitness) {
      return 'Resiliencia Fitness';
    } else {
      return 'Desconocido';
    }
  }

  static Color obtenerColorLogro(int tipoLogro) {
    if (tipoLogro == TTexts.logroGourmetSaludable) {
      return const Color.fromARGB(255, 76, 175, 80);
    } else if (tipoLogro == TTexts.logroEquilibrioInterior) {
      return const Color.fromARGB(255, 33, 150, 243);
    } else if (tipoLogro == TTexts.logroResilienciaFitness) {
      return const Color.fromARGB(255, 255, 87, 34);
    } else {
      return Colors.grey;
    }
  }

  static int obtenerTipoLogro(String tipoActividad) {
    if (tipoActividad == activMeditacion) {
      return TTexts.logroEquilibrioInterior;
    } else if (tipoActividad == actividadAlimentacion) {
      return TTexts.logroGourmetSaludable;
    } else if (tipoActividad == actividadFisico) {
      return TTexts.logroResilienciaFitness;
    } else {
      return 0;
    }
  }

  static String convertirFecha(String fecha) {
    // Parsear el string de la fecha a un objeto DateTime
    DateTime fechaOriginal = DateTime.parse(fecha);

    // Crear el formato deseado
    DateFormat formatoDeseado = DateFormat('dd-MM-yyyy');

    // Formatear la fecha y retornarla
    return formatoDeseado.format(fechaOriginal);
  }

  static String obtenerFechaDeDia(String dia) {
    List<String> diasSemana = dias;

    // Formateador de fechas
    DateFormat formatoFecha = DateFormat('yyyy-MM-dd');
    // Obtener la fecha actual
    DateTime fechaActual = DateTime.now();
    // Obtener el número de día de la semana (1 = Lunes, 7 = Domingo)
    int diaActualSemana = fechaActual.weekday;
    // Determinar el primer día de la semana (Lunes)
    DateTime inicioSemana =
        fechaActual.subtract(Duration(days: diaActualSemana - 1));
    // Encontrar el índice del día dado en la lista
    int indiceDia = diasSemana.indexOf(dia);
    if (indiceDia == -1) {
      throw ArgumentError(
          "Día inválido. Debe ser un día de la semana válido en español.");
    }

    // Calcular la fecha del día dado sumando el índice del día a partir del inicio de la semana
    DateTime fechaResultado = inicioSemana.add(Duration(days: indiceDia));

    print(
        "La fecha correspondiente a $dia es: ${formatoFecha.format(fechaResultado)}");
    return formatoFecha.format(fechaResultado);
  }

  static bool validarRepeticionesRecomendaciones(String input) {
  // Expresión regular que busca la palabra "titulo" en el input (case insensitive)
    RegExp regExp = RegExp(r'titulo', caseSensitive: false);

    // Encuentra todas las coincidencias
    Iterable<RegExpMatch> matches = regExp.allMatches(input);

    // Verifica si se encuentra 2 o más veces
    return matches.length >= 2;
  }

  static String convertirListaEnStringConSaltosDeLinea(List<String> lista) {
    // Utiliza join para concatenar los elementos de la lista con un salto de línea entre ellos
    return lista.join('\n');
  }
}

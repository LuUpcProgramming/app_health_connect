import 'package:app_health_connect/features/authentication/controllers/plan/plan_controller.dart';
import 'package:app_health_connect/features/authentication/models/plan_diario.dart';
import 'package:app_health_connect/utils/constants/colors.dart';
import 'package:app_health_connect/utils/constants/image_strings.dart';
import 'package:app_health_connect/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showPlanDetailDragDetail(
    BuildContext context, PlanDiario plan, PlanController planController) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: const Color(0x00000000),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
    ),
    builder: (context) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: makeDismissible(
        context: context,
        child: DraggableScrollableSheet(
          initialChildSize: 0.75,
          minChildSize: 0.4,
          maxChildSize: 0.75,
          builder: (_, controller) => Container(
            decoration: const BoxDecoration(
              color: TColors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
              // border: Border(top: BorderSide(color: TColors.primary, style: BorderStyle.solid, width: 4)),
            ),
            child: ListView(
              controller: controller,
              padding: EdgeInsets.zero,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: TColors.primary,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(25.0)),
                    //border: Border(top: BorderSide(color: TColors.primary, style: BorderStyle.solid, width: 4)),
                  ),
                  //color: Colors.blue, // Fondo azul
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              plan.meta,
                              softWrap: true,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors
                                    .white, // Texto blanco para mejor contraste
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close,
                                color: Colors.white, size: 35),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 8, left: 32.0, right: 32.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        textAlign: TextAlign.justify,
                        plan.mensaje,
                        style: const TextStyle(
                            fontSize: 15, fontStyle: FontStyle.italic),
                      ),
                      const SizedBox(height: 15.0),
                      const Text(
                        'Recomendaciones',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        plan.recomendacion,
                        style: const TextStyle(
                            fontSize: 15, fontStyle: FontStyle.italic),
                      ),
                      const SizedBox(height: 2.0),
                      const Text(
                        'Logro',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        plan.estadoPlan == TTexts.estadoCompletado
                            ? "¡Felicidades! Has completado tu plan diario. Obtuviste el logro de '${TTexts.obtenerNombreLogro(plan.tipoLogro)}'. ¡Sigue así! Prioriza tu bienestar."
                            : " Si superas la meta, obtendrás el logro de '${TTexts.obtenerNombreLogro(plan.tipoLogro)}'. ¡Tú Puedes!'",
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                            fontSize: 15, fontStyle: FontStyle.italic),
                      ),
                      const SizedBox(height: 15.0),
                      Center(
                        child: Image(
                          width: 128,
                          height: 128,
                          image: plan.tipoLogro == TTexts.logroGourmetSaludable
                              ? const AssetImage(TImages.imgAlimento)
                              : plan.tipoLogro == TTexts.logroEquilibrioInterior
                                  ? const AssetImage(TImages.imgMeditacion)
                                  : const AssetImage(TImages.imgEjercicio),
                        ),
                      ),
                      const SizedBox(height: 25.0),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(
                                child: plan.estadoPlan ==
                                        TTexts.estadoCompletado
                                    ? const SizedBox.shrink()
                                    : ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          planController
                                              .showQuestionDialog(plan);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: TColors.primary,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12.0, horizontal: 30.0),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                          ),
                                        ),
                                        child: const Text(
                                          'Meta Cumplida',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white),
                                        ),
                                      ),
                              ),
                              Center(
                                child: plan.estadoPlan ==
                                        TTexts.estadoCompletado
                                    ? const SizedBox.shrink()
                                    : ElevatedButton(
                                        onPressed: () {
                                           Navigator.pop(context);
                                          planController.showQuestionDeleteDialog(plan);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red[400],
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12.0, horizontal: 30.0),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                          ),
                                        ),
                                        child: const Text(
                                          'Eliminar Plan',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white),
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 50.0),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

Widget makeDismissible(
        {required Widget child, required BuildContext context}) =>
    GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.of(context).pop(),
      child: GestureDetector(
        onTap: () {},
        child: child,
      ),
    );

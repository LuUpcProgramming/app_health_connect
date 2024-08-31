import 'package:app_health_connect/utils/constants/colors.dart';
import 'package:app_health_connect/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:app_health_connect/features/authentication/models/actividad.dart';

void showPlanDetailDragDetail(BuildContext context, Tarea actividad) {
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
                    borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
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
                              actividad.nombre,
                              softWrap: true,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            
                              style: const TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white, // Texto blanco para mejor contraste
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white,size: 35),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.only(top:8,left: 32.0,right: 32.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Text(textAlign: TextAlign.justify,
                       actividad.mensaje,
                        style: const TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
                      ),
                      const SizedBox(height: 15.0),
                      const Text(
                        'Recomendaciones',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      const SizedBox(height: 8.0),
                      const Text(
                        //actividad.nombre,
                        """- Mantén tus ensaladas interesantes probando diferentes combinaciones de vegetales, proteínas y aderezos.\n- Piensa en cómo te sientes después de comer algo fresco y saludable, y cómo esto contribuye a tu bienestar general.\n- Dedica un tiempo a preparar tus ingredientes con antelación para que sea fácil y rápido armar tu ensalada cada día.
                        """,
                        style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
                      ),
                      const SizedBox(height: 2.0),
                      const Text(
                       'Logro',
                       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                       const SizedBox(height: 8.0),
                      const Text(
                       //actividad.nombre,
                       """ Si superas la meta, obtendrás el logro de "Gourmet Saludable". ¡Tú Puedes!
                       """,
                       textAlign: TextAlign.justify,
                       style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
                      ),
                      const Center(
                        child: Image(
                          width: 128,
                          height: 128,
                          image:  AssetImage(TImages.imgAlimento)
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
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: TColors.primary,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12.0, horizontal: 30.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                    ),
                                  ),
                                  child: const Text(
                                    'Meta Cumplida',
                                    style: TextStyle(fontSize: 18, color: Colors.white),
                                  ),
                                ),
                              ),
                              Center(
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red[400],
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12.0, horizontal: 30.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                    ),
                                  ),
                                  child: const Text(
                                    'Eliminar Plan',
                                    style: TextStyle(fontSize: 18, color: Colors.white),
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

Widget makeDismissible({required Widget child,required BuildContext context}) => GestureDetector(
  behavior: HitTestBehavior.opaque,
  onTap: () => Navigator.of(context).pop(),
  child: GestureDetector(onTap: () {}, child: child,),
);
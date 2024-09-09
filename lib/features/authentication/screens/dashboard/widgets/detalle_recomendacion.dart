import 'package:app_health_connect/features/authentication/models/recomendacion.dart';
import 'package:app_health_connect/utils/constants/colors.dart';
import 'package:app_health_connect/utils/constants/image_strings.dart';
import 'package:app_health_connect/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';

void showRecomendacionDetail(BuildContext context, Recomendacion recomendacion) {
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
          initialChildSize: 0.70,
          minChildSize: 0.4,
          maxChildSize: 0.7,
          builder: (_, controller) => Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
            ),
            child: ListView(
              controller: controller,
              padding: EdgeInsets.zero,
              children: [
                // Encabezado
                Container(
                  decoration: const BoxDecoration(
                    color: TColors.primary,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
                  ),
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          recomendacion.titulo,
                          softWrap: true,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white, size: 35),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                
                // Detalle de la recomendación
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Descripción',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        TTexts.convertirListaEnStringConSaltosDeLinea(recomendacion.descripcion) ,
                        textAlign: TextAlign.justify,
                        style: const TextStyle(fontSize: 15),
                      ),
                      const SizedBox(height: 16.0),
                      
                      const Text(
                        'Beneficios',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                         TTexts.convertirListaEnStringConSaltosDeLinea(recomendacion.beneficios) ,
                        textAlign: TextAlign.justify,
                        style: const TextStyle(fontSize: 15),
                      ),
                      const SizedBox(height: 16.0),
                      const Center(child: Image(width: 250,height:250,image: AssetImage(TImages.imgMotivacion))),
                      
/*                       Center(
                        child: ElevatedButton(
                          onPressed: () {
                            // Acción para el botón, si fuera necesario
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 30.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                          ),
                          child: const Text(
                            'Aplicar Recomendación',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ), */
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

Widget makeDismissible({required Widget child, required BuildContext context}) =>
  GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: () => Navigator.of(context).pop(),
    child: GestureDetector(
      onTap: () {},
      child: child,
    ),
);

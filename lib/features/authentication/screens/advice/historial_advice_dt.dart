import 'package:app_health_connect/features/authentication/models/history_advice.dart';
import 'package:app_health_connect/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void showRecommendationDetail(BuildContext context, HistoryAdviceDetail advice) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
   
    builder: (context) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  advice.title,
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Estado de ánimo',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            const Row(
              children: [
                Icon(Icons.sentiment_satisfied, size: 32.0),
                SizedBox(width: 8.0),
                Text('Estresado'),
              ],
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Situación o Problema',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            const Text(
                '-Exceso de actividades de trabajo.\n-Horas extras sin pago.\n-Discusión con compañeros de trabajo'),
            const SizedBox(height: 16.0),
            const Text(
              'Recomendaciones',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(advice.description),
            const SizedBox(height: 16.0),
            /* Image.asset(
              'assets/path_to_image.jpg', // Ruta a tu imagen
              width: double.infinity,
              height: 200.0,
              fit: BoxFit.cover,
            ), */
          ],
        ),
      ),
    ),
  );
}

void showRecommendationDragDetail(BuildContext context, HistoryAdviceDetail advice) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
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
          initialChildSize: 0.7,
          minChildSize: 0.4,
          maxChildSize: 0.7,
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
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              advice.title,
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
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                               const Text(
                                'Estado de ánimo',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold, 
                                fontSize: 18, color: Colors.white),
                              ),
                              Row(
                                children: [
                                   const Icon(Icons.sentiment_dissatisfied, size: 64.0, color: Colors.white),
                                   const SizedBox(width: 8.0),
                                   Text(
                                      advice.estadoAnimo,
                                      style: const TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),

                            ],
                          ),
                        ],
                      ),
                      
                    ],
                  ),
                ),
                const Divider(color: Colors.grey, thickness: 0.3, indent: 1, endIndent: 1),
                Padding(
                  padding: const EdgeInsets.only(top:8,left: 16.0,right: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Situación o Problema',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      const SizedBox(height: 8.0),
                       Text(
                       // '-Exceso de actividades de trabajo.\n-Horas extras sin pago.\n-Discusión con compañeros de trabajo',
                       advice.problema,
                        style: const TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
                      ),
                      const SizedBox(height: 20.0),
                      const Text(
                        'Recomendaciones',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        advice.description,
                        style: const TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
                      ),
                      const SizedBox(height: 20.0),
                      Center(
                        child: Image.network(
                          'https://firebasestorage.googleapis.com/v0/b/tesisapp-bd1ec.appspot.com/o/img%2Fpazmental.png?alt=media&token=5347042a-ec0e-4073-a8fb-ef6ccd4406ba', // Ruta a tu imagen
                          width: 250,
                          height: 250,
                          fit: BoxFit.cover,
                        ),
                      ), 
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

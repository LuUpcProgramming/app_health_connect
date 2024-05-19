import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WorkInfoScreen extends StatelessWidget {
  static const name = 'work-info-screen';

  const WorkInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: _WorkInfoView()
        // bottomNavigationBar: CustomBottomNavigation(),
        );
  }
}

class _WorkInfoView extends StatelessWidget {
  const _WorkInfoView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cuéntame sobre ti',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF4157FF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Ocupación',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.16),
                      offset: const Offset(0, 2),
                      blurRadius: 8,
                    ),
                  ],
                  color: Colors.white,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Escribe tu ocupación',
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'Source Sans Pro',
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Modalidad de Trabajo',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.16),
                      offset: const Offset(0, 2),
                      blurRadius: 8,
                    ),
                  ],
                  color: Colors.white,
                ),
                child: DropdownButton<String>(
                  items: [
                    'Horario Diurno (Mañana y Tarde)           ',
                    'Horario Rotativo        '
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {},
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'Source Sans Pro',
                    color: Colors.black,
                  ),
                  dropdownColor: Colors.white,
                  underline: Container(),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Horas de Trabajo',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.16),
                            offset: const Offset(0, 2),
                            blurRadius: 8,
                          ),
                        ],
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Número de horas',
                          border: InputBorder.none,
                        ),
                        keyboardType: TextInputType.number,
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'Source Sans Pro',
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.16),
                          offset: const Offset(0, 2),
                          blurRadius: 8,
                        ),
                      ],
                      color: Colors.white,
                    ),
                    child: DropdownButton<String>(
                      items: ['hrs/día', 'hrs/semana'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {},
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'Source Sans Pro',
                        color: Colors.black,
                      ),
                      dropdownColor: Colors.white,
                      underline: Container(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Tipo de Contrato',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.16),
                      offset: const Offset(0, 2),
                      blurRadius: 8,
                    ),
                  ],
                  color: Colors.white,
                ),
                child: DropdownButton<String>(
                  items: ['Practicante', 'Tiempo completo'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {},
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'Source Sans Pro',
                    color: Colors.black,
                  ),
                  dropdownColor: Colors.white,
                  underline: Container(),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Turno de Trabajo',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.16),
                      offset: const Offset(0, 2),
                      blurRadius: 8,
                    ),
                  ],
                  color: Colors.white,
                ),
                child: DropdownButtonFormField<String>(
                  items: ['Horario Diurno (Mañana y tarde)', 'Horario Rotativo']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {},
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'Source Sans Pro',
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 50),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    context.push('/health');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4157FF),
                    minimumSize: const Size(104, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    elevation: 8,
                    padding: EdgeInsets.zero,
                  ),
                  child: Container(
                    width: 104,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4157FF),
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          offset: const Offset(0, 2),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(2),
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              /*
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 0, bottom: 0),
                  child: Image.asset('assets/images/logo.png'),
                ),
              )
              */
            ],
          ),
        ),
      ),
    );
  }
}

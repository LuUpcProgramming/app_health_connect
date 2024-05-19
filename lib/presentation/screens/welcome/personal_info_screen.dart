import 'package:app_health_connect/config/helper/logging.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class PersonalInfoScreen extends StatelessWidget {
  static const name = 'personal-info-screen';

  const PersonalInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: _PersonalInfoView()
        // bottomNavigationBar: CustomBottomNavigation(),
        );
  }
}

class _PersonalInfoView extends StatefulWidget {
  const _PersonalInfoView();

  @override
  _PersonalInfoState createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<_PersonalInfoView> {
  final _formKey = GlobalKey<FormState>();
  String _genero = 'Masculino';
  String _fechaNacimiento = '';
  String _altura = '';
  String _peso = '';
  final TextEditingController _dateController = TextEditingController();
  final _log = logger(_PersonalInfoView);

  String _gender = 'Masculino';
  String _birthDate = '';
  double _height = 0.0;
  double _weight = 0.0;

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime now = DateTime.now();
    DateTime lastDate = now.subtract(
        const Duration(days: 365 * 18)); // Allow only users 18 years or older
    DateTime initialDate = now.isAfter(lastDate) ? lastDate : now;

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: lastDate,
    );

    if (pickedDate != null) {
      setState(() {
        _dateController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
        _fechaNacimiento = DateFormat('dd/MM/yyyy').format(pickedDate);
      });
    }
  }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cuéntame sobre ti',style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF4157FF),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,color: Colors.white),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
              Flexible(
                fit: FlexFit.loose,
                child:  Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildDropdownField(),
                        const SizedBox(height: 30.0),
                        _buildDateField(context),
                        const SizedBox(height: 30.0),
                        _buildTextField(
                          labelText: 'Altura (cm)',
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Por favor ingresa tu altura';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _altura = value!;
                          },
                        ),
                        const SizedBox(height: 30.0),
                        _buildTextField(
                          labelText: 'Peso (kg)',
                          keyboardType: const TextInputType.numberWithOptions(
                              signed: true, decimal: true),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Por favor ingresa tu peso';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _peso = value!;
                          },
                        ),
                        const SizedBox(height: 40.0),
                        ElevatedButton(
                            //Boton de siguiente y guardar
                            onPressed: () {
                              context.push('/work');
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Datos guardados')),
                                );

                                _log.i('Género: $_genero');
                                _log.i('Fecha de Nacimiento: $_fechaNacimiento');
                                _log.i('Altura: $_altura');
                                _log.i('Peso: $_peso');
                                _log.i('Género: $_genero');
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4157FF),
                              minimumSize: const Size(104, 48),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              shadowColor: Colors.black.withOpacity(0.12),
                              elevation: 8,
                              padding: const EdgeInsets.all(
                                  0), // Eliminar padding predeterminado
                            ),
                            child: const Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 22,
                            ),
                        ),
                        const Spacer(),
                        /*
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Image.asset('assets/images/logo.png',width: 150,height: 150),
                        ),
                        */
                      ],
                    ),
                  ),
                ),
              )
            ]
            )
            
          ) 
        ) ,

         
      
    );
  }

  Widget _buildDropdownField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.16),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: DropdownButtonFormField<String>(
        decoration: const InputDecoration(
          labelText: 'Género',
          border: InputBorder.none,
        ),
        value: _genero,
        items: ['Masculino', 'Femenino'].map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            _genero = newValue!;
          });
        },
      ),
    );
  }

  Widget _buildTextField({
    required String labelText,
    String? hintText,
    required TextInputType keyboardType,
    required FormFieldValidator<String> validator,
    required FormFieldSetter<String> onSaved,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.16),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          border: InputBorder.none,
        ),
        keyboardType: keyboardType,
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }

  Widget _buildDateField(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.16),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TextFormField(
        controller: _dateController,
        decoration: const InputDecoration(
          labelText: 'Fecha de Nacimiento',
          hintText: 'dd/mm/yyyy',
          border: InputBorder.none,
        ),
        readOnly: true,
        onTap: () {
          _selectDate(context);
        },
        validator: (value) {
          if (value!.isEmpty) {
            return 'Por favor ingresa tu fecha de nacimiento';
          }
          return null;
        },
        onSaved: (value) {
          _fechaNacimiento = value!;
        },
      ),
    );
  }
}

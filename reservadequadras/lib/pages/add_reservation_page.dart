import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:reservadequadras/models/enums/status_enum.dart';
import 'package:reservadequadras/models/reservation.dart';
import 'package:http/http.dart' as http;

class AddReservationPage extends StatefulWidget {
  final Reservation? initialReservation;

  AddReservationPage({this.initialReservation});

  @override
  _AddReservationPageState createState() => _AddReservationPageState();
}

class _AddReservationPageState extends State<AddReservationPage> {
  final _formKey = GlobalKey<FormState>();
  final _courtNameController = TextEditingController();
  final _timeController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  final _locationController = TextEditingController();

  bool isHovered = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialReservation != null) {
      _courtNameController.text = widget.initialReservation!.courtName;
      _timeController.text = widget.initialReservation!.time;
      _selectedDate = DateTime.parse(widget.initialReservation!.date);
      _locationController.text = widget.initialReservation!.location;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = DateTime(picked.year, picked.month, picked.day);
      });
    }
  }

  Future<void> postReservation(Reservation reservation) async {
    const String apiUrl = 'http://localhost:3000/reservations';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(reservation.toMap()),
    );
    if (response.statusCode == 201) {
      print('Reserva adicionada com sucesso');
    } else {
      print(
          'Falha ao adicionar a reserva. Código de status: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulário de Reserva',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromARGB(255, 19, 141, 115),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _courtNameController,
                decoration: InputDecoration(labelText: 'Nome da Quadra'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome da quadra';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _timeController,
                decoration: InputDecoration(labelText: 'Horário'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o horário';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(labelText: 'Local'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o local';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Center(
                child: MouseRegion(
                  onEnter: (_) => setState(() => isHovered = true),
                  onExit: (_) => setState(() => isHovered = false),
                  child: InkWell(
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        final newReservation = Reservation(
                          courtName: _courtNameController.text,
                          time: _timeController.text,
                          date: _selectedDate.toIso8601String(),
                          location: _locationController.text,
                          status: Status.Reserved,
                          id: 0,
                        );
                        await postReservation(newReservation);
                        context.pushReplacement("/reservations");
                      }
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isHovered
                            ? Colors.blueAccent // Cor quando hover
                            : Color.fromARGB(255, 19, 141, 115), // Cor padrão
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Reservar Quadra',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

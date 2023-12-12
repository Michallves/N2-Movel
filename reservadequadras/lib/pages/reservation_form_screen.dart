import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reservadequadras/models/reservation.dart';


class ReservationFormScreen extends StatefulWidget {
  final Reservation? initialReservation;

  ReservationFormScreen({this.initialReservation});

  @override
  _ReservationFormScreenState createState() => _ReservationFormScreenState();
}

class _ReservationFormScreenState extends State<ReservationFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _courtNameController = TextEditingController();
  final _timeController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  final _locationController = TextEditingController();
  Status _selectedStatus = Status.Livre;

  bool isHovered = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialReservation != null) {
      _courtNameController.text = widget.initialReservation!.courtName;
      _timeController.text = widget.initialReservation!.time;
      _selectedDate = widget.initialReservation!.date;
      _locationController.text = widget.initialReservation!.location;
      _selectedStatus = widget.initialReservation!.status;
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
              DropdownButtonFormField<Status>(
                value: _selectedStatus,
                onChanged: (Status? value) {
                  if (value != null) {
                    setState(() {
                      _selectedStatus = value;
                    });
                  }
                },
                items: Status.values.map((status) {
                  return DropdownMenuItem<Status>(
                    value: status,
                    child: Text(status.toString().split('.').last),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: 'Status'),
              ),
              Row(
                children: [
                  Text(
                      'Data: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}'),
                  IconButton(
                    onPressed: () => _selectDate(context),
                    icon: Icon(Icons.calendar_today),
                    iconSize: 20.0,
                  ),
                ],
              ),
              SizedBox(height: 16),
              Center(
                child: MouseRegion(
                  onEnter: (_) => setState(() => isHovered = true),
                  onExit: (_) => setState(() => isHovered = false),
                  child: InkWell(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        final newReservation = Reservation(
                          courtName: _courtNameController.text,
                          time: _timeController.text,
                          date: _selectedDate,
                          location: _locationController.text,
                          status: _selectedStatus,
                        );
                        Navigator.pop(context, newReservation);
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

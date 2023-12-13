import 'dart:convert';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reservadequadras/models/enums/status_enum.dart';
import 'package:reservadequadras/models/reservation.dart';

class EditReservationPage extends StatefulWidget {
  final int id;

  const EditReservationPage({super.key, required this.id});

  @override
  _EditReservationPageState createState() => _EditReservationPageState();
}

class _EditReservationPageState extends State<EditReservationPage> {
  late TextEditingController courtNameController;
  late TextEditingController timeController;
  DateTime selectedDate = DateTime.now();
  late TextEditingController locationController;
  late Status selectedStatus;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    courtNameController = TextEditingController();
    timeController = TextEditingController();
    locationController = TextEditingController();
    selectedStatus = Status.Reserved;
    getReservation();
  }

  Future<void> getReservation() async {
    try {
      final String apiUrl = 'http://localhost:3000/reservations/${widget.id}';

      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        setState(() {
          isLoading = false;
          Reservation reservation = Reservation.fromMap(jsonData);

          courtNameController.text = reservation.courtName;
          timeController.text = reservation.time;
          selectedDate = DateTime.parse(reservation.date);
          locationController.text = reservation.location;
          selectedStatus = reservation.status;
        });
      } else {
        throw Exception(
            'Falha ao obter a reserva. Código de status: ${response.statusCode}');
      }
    } catch (error) {
      print('Erro ao obter a reserva: $error');
    }
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = DateTime(picked.year, picked.month, picked.day);
      });
    }
  }

  Future<void> saveChanges() async {
    String apiUrl = 'http://localhost:3000/reservations/${widget.id}';
    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "name": courtNameController.text,
          "date": selectedDate.toString(),
          "location": locationController.text,
          "status": selectedStatus.name,
          "time": timeController.text
        }),
      );
      if (response.statusCode == 200) {
        print('Reserva adicionada com sucesso');
        context.pushReplacement("/reservations");
      } else {
        print(
            'Falha ao adicionar a reserva. Código de status: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro: $e');

      showDialog(
          context: context,
          builder: (context) => Dialog(
                child: Container(
                    height: 100,
                    alignment: Alignment.center,
                    child: Text(
                      "Error",
                    )),
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Reserva', style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromARGB(255, 19, 141, 115),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () => saveChanges(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: courtNameController,
                    decoration: InputDecoration(labelText: 'Nome da Quadra'),
                  ),
                  TextFormField(
                    controller: timeController,
                    decoration: InputDecoration(labelText: 'Horário'),
                  ),
                  TextFormField(
                    controller: locationController,
                    decoration: InputDecoration(labelText: 'Local'),
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<Status>(
                    value: selectedStatus,
                    onChanged: (Status? value) {
                      if (value != null) {
                        setState(() {
                          selectedStatus = value;
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
                          'Data: ${DateFormat('yyyy-MM-dd').format(selectedDate)}'),
                      IconButton(
                        onPressed: () => selectDate(context),
                        icon: const Icon(Icons.calendar_today),
                        iconSize: 20.0,
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}

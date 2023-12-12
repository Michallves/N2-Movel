import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reservadequadras/models/reservation.dart';

class ReservationDetailsScreen extends StatelessWidget {
  final Reservation reservation;

  ReservationDetailsScreen({required this.reservation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Detalhes da Reserva', style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromARGB(255, 19, 141, 115),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nome da Quadra: ${reservation.courtName}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Horário: ${reservation.time}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Data: ${DateFormat('yyyy-MM-dd').format(reservation.date)}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Local: ${reservation.location}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Status: ${getStatusText(reservation.status)}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  String getStatusText(Status status) {
    switch (status) {
      case Status.Reservada:
        return 'Reservada';
      case Status.Livre:
        return 'Livre';
      case Status.Ocupada:
        return 'Ocupada';
      default:
        return '';
    }
  }
}

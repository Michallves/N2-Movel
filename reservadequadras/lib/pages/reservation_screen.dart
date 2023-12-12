import 'package:flutter/material.dart';
import 'package:reservadequadras/models/reservation.dart';
import 'package:reservadequadras/pages/reservation_details_screen.dart';
import 'package:reservadequadras/pages/reservation_form_screen.dart';
import 'package:intl/intl.dart';

class ReservationScreen extends StatefulWidget {
  @override
  _ReservationScreenState createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  List<Reservation> reservations = [];

  void _navigateToReservationForm() async {
    final newReservation = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ReservationFormScreen()),
    );

    if (newReservation != null) {
      setState(() {
        reservations.add(newReservation);
      });
    }
  }

  void _navigateToReservationDetails(Reservation reservation) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ReservationDetailsScreen(reservation: reservation),
      ),
    );
  }

  void _deleteReservation(int index) {
    setState(() {
      reservations.removeAt(index);
    });
  }

  void _editReservation(Reservation reservation, int index) async {
    final editedReservation = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              ReservationFormScreen(initialReservation: reservation)),
    );

    if (editedReservation != null) {
      setState(() {
        reservations[index] = editedReservation;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Quadras Reservadas', style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromARGB(255, 19, 141, 115),
      ),
      body: ListView.builder(
        itemCount: reservations.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(reservations[index].courtName),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Status: ${getStatusText(reservations[index].status)}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '${DateFormat('yyyy-MM-dd').format(reservations[index].date)} ${reservations[index].time}',
                ),
              ],
            ),
            onTap: () => _navigateToReservationDetails(reservations[index]),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit_note_outlined),
                  onPressed: () => _editReservation(reservations[index], index),
                ),
                IconButton(
                  icon: Icon(Icons.delete_forever),
                  onPressed: () => _deleteReservation(index),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton(
              onPressed: _navigateToReservationForm,
              tooltip: 'Reservar Quadra',
              backgroundColor: Color.fromARGB(255, 19, 141, 115),
              hoverColor: Colors.blueAccent,
              child: const Icon(
                Icons.sports_volleyball_sharp,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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

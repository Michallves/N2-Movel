import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:reservadequadras/models/reservation.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;
  List<Reservation> reservations = [];

  @override
  void initState() {
    getAll();
    super.initState();
  }

  getAll() async {
    try {
      final response =
          await http.get(Uri.parse('http://localhost:3000/reservations'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        final List<Reservation> reservationsData =
            jsonList.map((map) => Reservation.fromMap(map)).toList();
        setState(() {
          reservations = reservationsData;
          isLoading = false;
        });
      } else {
        throw Exception('Falha ao obter reservas');
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

  Future<void> deleteReservation(int reservationId) async {
    try {
      final response = await http.delete(
        Uri.parse('http://localhost:3000/reservations/$reservationId'),
      );

      if (response.statusCode == 200) {
        // Atualizar a lista após a exclusão
        getAll();
      } else {
        throw Exception('Falha ao excluir reserva');
      }
    } catch (e) {
      print('Erro ao excluir reserva: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    } else {
      return Scaffold(
        appBar: AppBar(
          leading: Container(),
          title:
              Text('Quadras Reservadas', style: TextStyle(color: Colors.white)),
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 19, 141, 115),
        ),
        body: ListView.separated(
          padding: const EdgeInsets.all(8),
          itemCount: reservations.length,
          separatorBuilder: (context, index) => Container(
            height: 8,
          ),
          itemBuilder: (context, index) {
            final Reservation reservation = reservations[index];
            return Container(
              decoration: BoxDecoration(
                  color: reservation.getStatusColors.background,
                  borderRadius: BorderRadius.circular(8)),
              child: ListTile(
                title: Text(
                  reservation.courtName!,
                  style:
                      TextStyle(color: reservation.getStatusColors.foreground),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Status: ${reservation.getStatus}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: reservation.getStatusColors.foreground,
                      ),
                    ),
                    Text(
                      "Data:${reservation.getDate}\nHora: ${reservation.time}",
                      style: TextStyle(
                          color: reservation.getStatusColors.foreground),
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit_note_outlined,
                          color: reservation.getStatusColors.foreground),
                      onPressed: () => context.push(
                          "/reservations/${reservation.id}/edit",
                          extra: reservation.id),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete_forever,
                          color: reservation.getStatusColors.foreground),
                      onPressed: () {
                        deleteReservation(reservation.id);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        floatingActionButton: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton(
                onPressed: () => context.push("/reservations/add"),
                tooltip: 'Reservar Quadra',
                backgroundColor: const Color.fromARGB(255, 19, 141, 115),
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
  }
}

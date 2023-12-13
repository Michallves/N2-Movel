import 'package:flutter/material.dart';
import 'package:reservadequadras/models/enums/status_enum.dart';
import 'package:intl/intl.dart';
import 'package:reservadequadras/models/reservation_color.dart';

class Reservation {
  int id;
  String courtName;
  String time;
  String date;
  String location;
  Status status;

  Reservation({
    required this.id,
    required this.courtName,
    required this.time,
    required this.date,
    required this.location,
    required this.status,
  });

  factory Reservation.fromMap(Map<String, dynamic> map) {
    return Reservation(
      id: map['id'],
      courtName: map['name'],
      time: map['time'],
      date: map['date'],
      location: map['location'],
      status: getStatusEnum(map['status']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': courtName,
      'time': time,
      'date': date,
      'location': location,
      'status': status.name,
    };
  }

  String get getDate {
    final formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.parse(date));
    return formattedDate;
  }

  String get getStatus {
    switch (status) {
      case Status.Reserved:
        return 'Reservada';
      case Status.Free:
        return 'Livre';
      case Status.Occupied:
        return 'Ocupada';
      default:
        return '';
    }
  }

  ReservationColor get getStatusColors {
    switch (status) {
      case Status.Reserved:
        return ReservationColor(
            background: Colors.orange, foreground: Colors.black);
      case Status.Free:
        return ReservationColor(
            background: Colors.green, foreground: Colors.black);
      case Status.Occupied:
        return ReservationColor(
            background: Colors.red, foreground: Colors.white);
      default:
        return ReservationColor(
            background: Colors.black, foreground: Colors.white);
    }
  }

  static Status getStatusEnum(String statusString) {
    switch (statusString) {
      case 'Reserved':
        return Status.Reserved;
      case 'Free':
        return Status.Free;
      case 'Occupied':
        return Status.Occupied;
      default:
        return Status.Reserved;
    }
  }
}

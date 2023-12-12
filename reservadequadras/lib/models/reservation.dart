enum Status { Reservada, Livre, Ocupada }

class Reservation {
  String courtName;
  String time;
  DateTime date;
  String location;
  Status status;

  Reservation({
    required this.courtName,
    required this.time,
    required this.date,
    required this.location,
    required this.status,
  });
}

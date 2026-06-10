// Freezed model — run: dart run build_runner build
class Booking {
  const Booking({
    required this.bookingId,
    required this.slotId,
    required this.date,
    required this.status,
    required this.startTime,
    required this.endTime,
    required this.venueId,
    required this.venueName,
    required this.sport,
    required this.address,
  });
  final int bookingId;
  final int slotId;
  final String date;
  final String status;
  final String startTime;
  final String endTime;
  final int venueId;
  final String venueName;
  final String sport;
  final String address;

  bool get isActive => status == 'active';
}

// Freezed model — run: dart run build_runner build
class Slot {
  const Slot({
    required this.id,
    required this.venueId,
    required this.startTime,
    required this.endTime,
    required this.status,
    this.bookedByUserId,
  });
  final int id;
  final int venueId;
  final String startTime;
  final String endTime;
  final String status;
  final int? bookedByUserId;

  bool get isAvailable => status == 'available';
}

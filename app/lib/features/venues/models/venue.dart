// Freezed model — run: dart run build_runner build
class Venue {
  const Venue({
    required this.id,
    required this.name,
    required this.sport,
    required this.address,
  });
  final int id;
  final String name;
  final String sport;
  final String address;
}

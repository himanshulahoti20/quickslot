class ApiEndpoints {
  static const String base = 'http://10.0.2.2:3000'; // Android emulator

  static const String venues   = '/venues';
  static const String bookings = '/bookings';

  static String venueSlots(int id)       => '/venues/$id/slots';
  static String cancelBooking(int id)    => '/bookings/$id';

  // Backend serves this at /bookings/users/:id/bookings (router mounted at /bookings).
  static String userBookings(int userId) => '/bookings/users/$userId/bookings';
}

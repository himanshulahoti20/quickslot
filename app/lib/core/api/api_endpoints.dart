class ApiEndpoints {
  static const String base = 'https://quickslot-production-a43d.up.railway.app';

  static const String venues   = '/venues';
  static const String bookings = '/bookings';

  static String venueSlots(int id)       => '/venues/$id/slots';
  static String cancelBooking(int id)    => '/bookings/$id';

  // Backend serves this at /bookings/users/:id/bookings (router mounted at /bookings).
  static String userBookings(int userId) => '/bookings/users/$userId/bookings';
}

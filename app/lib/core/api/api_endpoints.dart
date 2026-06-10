class ApiEndpoints {
  static const String health    = '/health';
  static const String venues    = '/venues';
  static const String bookings  = '/bookings';

  static String venueSlots(int venueId) => '/venues/$venueId/slots';
  static String userBookings(int userId) => '/bookings/users/$userId/bookings';
  static String cancelBooking(int bookingId) => '/bookings/$bookingId';
}

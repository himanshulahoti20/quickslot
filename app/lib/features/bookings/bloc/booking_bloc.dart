import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/core/api/api_client.dart';
import 'package:app/core/api/exceptions.dart';
import 'package:app/features/bookings/models/booking.dart';

part 'booking_event.dart';
part 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  BookingBloc(this._apiClient) : super(BookingIdle()) {
    on<BookSlot>(_onBookSlot);
    on<ResetBooking>((_, emit) => emit(BookingIdle()));
  }

  final ApiClient _apiClient;

  Future<void> _onBookSlot(BookSlot event, Emitter<BookingState> emit) async {
    emit(BookingLoading());
    try {
      final booking = await _apiClient.createBooking(event.slotId, event.date);
      emit(BookingSuccess(booking));
    } on SlotTakenException {
      emit(BookingConflict());
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/core/api/api_client.dart';
import 'package:app/core/api/exceptions.dart';

part 'booking_event.dart';
part 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  BookingBloc(this._apiClient) : super(BookingInitial()) {
    on<BookSlot>(_onBookSlot);
  }

  final ApiClient _apiClient;

  Future<void> _onBookSlot(BookSlot event, Emitter<BookingState> emit) async {
    emit(BookingLoading());
    try {
      final booking = await _apiClient.createBooking(event.slotId, event.date);
      emit(BookingSuccess(booking.id));
    } on SlotTakenException {
      emit(BookingConflict());
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }
}

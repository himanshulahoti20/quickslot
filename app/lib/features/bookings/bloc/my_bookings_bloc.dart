import 'package:flutter_bloc/flutter_bloc.dart';

part 'my_bookings_event.dart';
part 'my_bookings_state.dart';

class MyBookingsBloc extends Bloc<MyBookingsEvent, MyBookingsState> {
  MyBookingsBloc() : super(MyBookingsInitial());
}

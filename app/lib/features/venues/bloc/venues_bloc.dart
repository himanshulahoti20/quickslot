import 'package:flutter_bloc/flutter_bloc.dart';

part 'venues_event.dart';
part 'venues_state.dart';

class VenuesBloc extends Bloc<VenuesEvent, VenuesState> {
  VenuesBloc() : super(VenuesInitial());
}

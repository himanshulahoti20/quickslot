import 'package:flutter_bloc/flutter_bloc.dart';

part 'slots_event.dart';
part 'slots_state.dart';

class SlotsBloc extends Bloc<SlotsEvent, SlotsState> {
  SlotsBloc() : super(SlotsInitial());
}

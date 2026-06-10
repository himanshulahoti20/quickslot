import 'package:freezed_annotation/freezed_annotation.dart';

part 'slot.freezed.dart';
part 'slot.g.dart';

@freezed
class Slot with _$Slot {
  const Slot._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Slot({
    required int id,
    required int venueId,
    required String startTime,
    required String endTime,
    required String status,
    int? bookedByUserId,
  }) = _Slot;

  factory Slot.fromJson(Map<String, dynamic> json) => _$SlotFromJson(json);

  bool get isAvailable => status == 'available';
}

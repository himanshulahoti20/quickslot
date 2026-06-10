// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'slot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Slot _$SlotFromJson(Map<String, dynamic> json) => _Slot(
  id: (json['id'] as num).toInt(),
  venueId: (json['venue_id'] as num).toInt(),
  startTime: json['start_time'] as String,
  endTime: json['end_time'] as String,
  status: json['status'] as String,
  bookedByUserId: (json['booked_by_user_id'] as num?)?.toInt(),
);

Map<String, dynamic> _$SlotToJson(_Slot instance) => <String, dynamic>{
  'id': instance.id,
  'venue_id': instance.venueId,
  'start_time': instance.startTime,
  'end_time': instance.endTime,
  'status': instance.status,
  'booked_by_user_id': instance.bookedByUserId,
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'venue.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Venue _$VenueFromJson(Map<String, dynamic> json) => _Venue(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  sport: json['sport'] as String,
  address: json['address'] as String,
);

Map<String, dynamic> _$VenueToJson(_Venue instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'sport': instance.sport,
  'address': instance.address,
};

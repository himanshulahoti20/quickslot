import 'package:freezed_annotation/freezed_annotation.dart';

part 'venue.freezed.dart';
part 'venue.g.dart';

@freezed
class Venue with _$Venue {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Venue({
    required int id,
    required String name,
    required String sport,
    required String address,
  }) = _Venue;

  factory Venue.fromJson(Map<String, dynamic> json) => _$VenueFromJson(json);
}

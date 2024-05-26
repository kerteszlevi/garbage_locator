import 'package:json_annotation/json_annotation.dart';

part 'garbage.g.dart';

//@Entity(tableName: 'garbage')
@JsonSerializable()
class Garbage {
//  @PrimaryKey(autoGenerate: true)
  final String? id;
  final String imagePath;
  final String author;
  final double? latitude;
  final double? longitude;
  final String comment;
  final String location;

  Garbage({
    this.id,
    required this.author,
    required this.imagePath,
    required this.location,
    this.latitude,
    this.longitude,
    required this.comment,
  });

  Garbage copyWith({
    String? id,
    String? author,
    String? imagePath,
    double? latitude,
    double? longitude,
    String? comment,
    String? location,
  }) {
    return Garbage(
      id: id ?? this.id,
      author: author ?? this.author,
      imagePath: imagePath ?? this.imagePath,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      comment: comment ?? this.comment,
    );
  }

  factory Garbage.fromJson(Map<String, dynamic> json) =>
      _$GarbageFromJson(json);

  Map<String, dynamic> toJson() => _$GarbageToJson(this);
}

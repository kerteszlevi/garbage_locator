import 'package:floor/floor.dart';

@Entity(tableName: 'garbage')
class Garbage {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String imagePath;
  final double? latitude;
  final double? longitude;
  final String comment;
  final String location;

  Garbage({
    this.id,
    required this.imagePath,
    required this.location,
    this.latitude,
    this.longitude,
    required this.comment,
  });
}

import 'package:floor/floor.dart';

@Entity(tableName: 'garbage')
class Garbage {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String imagePath;
  final String latitude;
  final String longitude;
  final String comment;
  final String location;

  Garbage({
    this.id,
    required this.imagePath,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.comment,
  });
}

import 'package:floor/floor.dart';

@Entity(tableName: 'garbage')
class Garbage {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String imagePath;
  final String location;
  final String comment;

  Garbage({
    this.id,
    required this.imagePath,
    required this.location,
    required this.comment,
  });
}

import 'package:floor/floor.dart';
import 'package:garbage_locator/models/garbage.dart';

@dao
abstract class GarbageDao {
  @Query('SELECT * FROM garbage')
  Future<List<Garbage>> getAllGarbage();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertGarbage(Garbage photo);

  @Query('DELETE FROM garbage WHERE id = :id')
  Future<void> deleteGarbage(int id);

  @Query('SELECT * FROM garbage WHERE id = :id')
  Future<Garbage?> getGarbage(int id);
}

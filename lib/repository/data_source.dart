import 'package:garbage_locator/models/garbage.dart';
import 'package:garbage_locator/repository/garbage_repository.dart';

class DataSource {
  final GarbageRepository<Garbage> database;

  DataSource(this.database);

  Future<void> init() async {
    await database.init();
  }

  Future<List<Garbage>> getAllGarbage() async {
    final garbages = await database.getAllGarbage();
    return garbages.map((floorGarbage) => floorGarbage).toList();
  }

  Future<Garbage> getGarbage(int id) async {
    final floorTodo = await database.getGarbage(id);
    return floorTodo;
  }

  Future<void> insertGarbage(Garbage garbage) async {
    return database.insertGarbage(garbage);
  }

  Future<void> deleteGarbage(Garbage garbage) async {
    return database.deleteGarbage(garbage);
  }
}

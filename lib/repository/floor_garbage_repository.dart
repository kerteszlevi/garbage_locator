import 'package:garbage_locator/data/database/floor/floor_garbage_dao.dart';
import 'package:garbage_locator/data/database/floor/floor_garbage_database.dart';
import 'package:garbage_locator/models/garbage.dart';
import 'package:garbage_locator/repository/garbage_repository.dart';

class FloorGarbageRepository implements GarbageRepository<Garbage> {
  late GarbageDao garbageDao;

  @override
  Future<void> init() async {
    final database = await $FloorFloorGarbageDatabase
        .databaseBuilder("floor_garbage.db")
        .build();
    garbageDao = database.garbageDao;
  }

  @override
  Future<void> deleteGarbage(Garbage garbage) {
    return garbageDao.deleteGarbage(garbage.id ?? -1);
  }

  @override
  Future<List<Garbage>> getAllGarbage() {
    return garbageDao.getAllGarbage();
  }

  @override
  Future<Garbage> getGarbage(int id) async {
    final garbage = await garbageDao.getGarbage(id);
    if (garbage == null) {
      throw Exception("Invalid GARBAGE ID");
    } else {
      return garbage;
    }
  }

  @override
  Future<void> insertGarbage(Garbage garbage) {
    return garbageDao.insertGarbage(garbage);
  }

  // @override
  // Future<List<GarbagePhoto>> getAll() {
  //   return garbagePhotoDao.getAllTodos();
  // }

  // @override
  // Future<GarbagePhoto> getGarbagePhoto(int id) async {
  //   final todo = await garbagePhotoDao.getGarbagePhoto(id);
  //   if(todo == null) {
  //     throw Exception("Invalid TODO ID");
  //   } else {
  //     return todo;
  //   }
  // }

  // @override
  // Future<void> deleteTodo(FloorTodo todo) {
  //   return todoDao.deleteTodo(todo.id ?? -1);
  // }

  // @override
  // Future<void> upsertTodo(FloorTodo todo) {
  //   return todoDao.upsertTodo(todo);
  // }
}
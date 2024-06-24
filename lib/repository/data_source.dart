import 'package:garbage_locator/models/garbage.dart';
import 'package:garbage_locator/repository/garbage_repository.dart';
import 'package:logger/logger.dart';

class DataSource {
  final GarbageRepository<Garbage> database;
  final Logger _logger;
  DataSource(this.database) : _logger = Logger();

  Future<void> init() async {
    _logger.i('Initializing data source');
    try {
      await database.init();
      _logger.i('Database initialized successfully');
    } catch (e) {
      _logger.e('Error initializing database', error: e);
    }
  }

  Future<List<Garbage>> getAllGarbage() async {
    final garbages = await database.getAllGarbage();
    return garbages.map((garbageSource) => garbageSource).toList();
  }

  Stream<List<Garbage>> get allGarbageStream {
    return _getAllGarbageStream().asBroadcastStream();
  }

  Stream<List<Garbage>> _getAllGarbageStream() async* {
    while (true) {
      yield await getAllGarbage();
    }
  }

  Future<Garbage> getGarbage(String id) async {
    final garbage = await database.getGarbage(id);
    return garbage;
  }

  Future<void> insertGarbage(Garbage garbage) async {
    return database.insertGarbage(garbage);
  }

  Future<void> deleteGarbage(Garbage garbage) async {
    return database.deleteGarbage(garbage);
  }

  Future<List<Garbage>> getAllAuthorGarbage(String author) async {
    return database.getAllAuthorGarbage(author);
  }

  Stream<List<Garbage>> getAllAuthorGarbageStream(String author) {
    return database.getAllAuthorGarbageStream(author);
  }

  Future<void> likeGarbage(String garbageId, String userId) async {
    return database.likeGarbage(garbageId, userId);
  }

  Future<void> dislikeGarbage(String garbageId, String userId) async {
    return database.dislikeGarbage(garbageId, userId);
  }
}

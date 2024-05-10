// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'floor_garbage_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $FloorGarbageDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $FloorGarbageDatabaseBuilderContract addMigrations(
      List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $FloorGarbageDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<FloorGarbageDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorFloorGarbageDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $FloorGarbageDatabaseBuilderContract databaseBuilder(String name) =>
      _$FloorGarbageDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $FloorGarbageDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$FloorGarbageDatabaseBuilder(null);
}

class _$FloorGarbageDatabaseBuilder
    implements $FloorGarbageDatabaseBuilderContract {
  _$FloorGarbageDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $FloorGarbageDatabaseBuilderContract addMigrations(
      List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $FloorGarbageDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<FloorGarbageDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$FloorGarbageDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$FloorGarbageDatabase extends FloorGarbageDatabase {
  _$FloorGarbageDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  GarbageDao? _garbageDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `garbage` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `imagePath` TEXT NOT NULL, `latitude` TEXT NOT NULL, `longitude` TEXT NOT NULL, `comment` TEXT NOT NULL, `location` TEXT NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  GarbageDao get garbageDao {
    return _garbageDaoInstance ??= _$GarbageDao(database, changeListener);
  }
}

class _$GarbageDao extends GarbageDao {
  _$GarbageDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _garbageInsertionAdapter = InsertionAdapter(
            database,
            'garbage',
            (Garbage item) => <String, Object?>{
                  'id': item.id,
                  'imagePath': item.imagePath,
                  'latitude': item.latitude,
                  'longitude': item.longitude,
                  'comment': item.comment,
                  'location': item.location
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Garbage> _garbageInsertionAdapter;

  @override
  Future<List<Garbage>> getAllGarbage() async {
    return _queryAdapter.queryList('SELECT * FROM garbage',
        mapper: (Map<String, Object?> row) => Garbage(
            id: row['id'] as int?,
            imagePath: row['imagePath'] as String,
            location: row['location'] as String,
            latitude: row['latitude'] as String,
            longitude: row['longitude'] as String,
            comment: row['comment'] as String));
  }

  @override
  Future<void> deleteGarbage(int id) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM garbage WHERE id = ?1', arguments: [id]);
  }

  @override
  Future<Garbage?> getGarbage(int id) async {
    return _queryAdapter.query('SELECT * FROM garbage WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Garbage(
            id: row['id'] as int?,
            imagePath: row['imagePath'] as String,
            location: row['location'] as String,
            latitude: row['latitude'] as String,
            longitude: row['longitude'] as String,
            comment: row['comment'] as String),
        arguments: [id]);
  }

  @override
  Future<void> insertGarbage(Garbage photo) async {
    await _garbageInsertionAdapter.insert(photo, OnConflictStrategy.replace);
  }
}

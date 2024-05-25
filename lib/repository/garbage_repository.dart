abstract class GarbageRepository<T> {
  Future<void> init();

  Future<List<T>> getAllGarbage();

  Future<T> getGarbage(String id);

  Future<void> deleteGarbage(T garbage);

  Future<void> insertGarbage(T garbage);
}

abstract class GarbageRepository<T> {
  Future<void> init();

  Future<List<T>> getAllGarbage();

  Future<T> getGarbage(String id);

  Future<void> deleteGarbage(T garbage);

  Future<void> insertGarbage(T garbage);

  Future<List<T>> getAllAuthorGarbage(String author);

  Stream<List<T>> getAllAuthorGarbageStream(String author);

  Future<void> likeGarbage(String garbageId, String userId) async {}

  Future<void> dislikeGarbage(String garbageId, String userId) async {}
}

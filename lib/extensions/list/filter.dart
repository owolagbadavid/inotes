extension Filter<T> on Stream<List<T>> {
  Stream<List<T>> filter(bool Function(T) predicate) {
    return map((list) => list.where(predicate).toList());
  }
}

import 'dart:core';

// https://stackoverflow.com/questions/54990716/flutter-get-iteration-index-from-list-map/54995553
extension IndexedIterable<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T f(E e, int i)) {
    var i = 0;
    return this.map((e) => f(e, i++));
  }
}

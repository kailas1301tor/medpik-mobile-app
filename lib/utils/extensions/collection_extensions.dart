// lib/utils/extensions/collection_extensions.dart
import 'dart:math';

extension ListExtension<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
  T? get lastOrNull => isEmpty ? null : last;

  T? firstWhereOrNull(bool Function(T) test) {
    for (final e in this) {
      if (test(e)) return e;
    }
    return null;
  }

  List<List<T>> chunk(int size) {
    final chunks = <List<T>>[];
    for (var i = 0; i < length; i += size) {
      chunks.add(sublist(i, min(i + size, length)));
    }
    return chunks;
  }

  List<T> get shuffled => [...this]..shuffle();

  List<T> joinWith(T separator) {
    if (isEmpty) return this;
    return [
      for (var i = 0; i < length; i++) ...[
        this[i],
        if (i != length - 1) separator,
      ],
    ];
  }
}

extension IterableExtension<T> on Iterable<T> {
  Map<K, List<T>> groupBy<K>(K Function(T) key) {
    final map = <K, List<T>>{};
    for (final item in this) {
      (map[key(item)] ??= []).add(item);
    }
    return map;
  }

  double sumBy(double Function(T) value) =>
      fold(0.0, (sum, item) => sum + value(item));

  int countWhere(bool Function(T) test) => where(test).length;

  Iterable<(int, T)> get indexed sync* {
    var i = 0;
    for (final item in this) {
      yield (i++, item);
    }
  }

  T? get randomItem {
    if (isEmpty) return null;
    final list = toList();
    return list[Random().nextInt(list.length)];
  }
}

extension MapExtension<K, V> on Map<K, V> {
  V getOrDefault(K key, V defaultValue) =>
      containsKey(key) ? this[key]! : defaultValue;

  Map<K, V> get withoutNulls =>
      Map.fromEntries(entries.where((e) => e.value != null));

  Map<V, K> get inverted =>
      Map.fromEntries(entries.map((e) => MapEntry(e.value, e.key)));

  bool get isNullOrEmpty => isEmpty;
}

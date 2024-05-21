/// Utility class for storing fixed number of selected color choices
class FixedSizeList<T> {
  final int maxSize;
  final List<T> _items = [];

  FixedSizeList(this.maxSize);

  int get length => _items.length;

  bool get isFull => length == maxSize;

  /// Return an unmodifiable view of the list
  List<T> get items => List.unmodifiable(_items);

  void add(T item) {
    if (_items.contains(item)) {
      return;
    }

    if (isFull) {
      _items.removeAt(0); // Remove the oldest item
    }
    _items.add(item);
  }

  T get(int index) {
    if (index < 0 || index >= length) {
      throw RangeError('Index ($index) is out of bounds.');
    }
    return _items[index];
  }
}

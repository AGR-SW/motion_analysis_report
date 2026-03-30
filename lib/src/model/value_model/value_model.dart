class ValueModel<T> {
  T current;
  T prev;
  T diff;

  ValueModel({required this.current, required this.prev, required this.diff});
}

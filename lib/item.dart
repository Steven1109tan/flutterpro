class MyItem {
  final String name;
  final String description;
  ItemStatus status;

  MyItem(this.name, this.description, this.status);
}

enum ItemStatus {
  all,
  pending,
  approved,
  rejected,
}

import 'item.dart';

class ShoppingList {
  int? id;
  String name;
  List<Item> items;

  ShoppingList({this.id, required this.name, this.items = const []});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory ShoppingList.fromMap(Map<String, dynamic> map) {
    return ShoppingList(
      id: map['id'],
      name: map['name'],
      items: [],
    );
  }
}

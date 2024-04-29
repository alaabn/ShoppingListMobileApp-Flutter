import 'package:mylists/db/SQLHelper.dart';

class Item {
  int? id;
  String name;
  bool isFinished;
  int? shoppingListId;

  Item({
    this.id,
    required this.name,
    this.isFinished = false,
    required this.shoppingListId,
  });

  Map<String, dynamic> toMap() {
    return {
      SQLHelper.colId: id,
      SQLHelper.colName: name,
      SQLHelper.colIsFinished: isFinished ? 1 : 0,
      SQLHelper.colShoppingListId: shoppingListId,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map[SQLHelper.colId],
      name: map[SQLHelper.colName],
      isFinished: map[SQLHelper.colIsFinished] == 1,
      shoppingListId: map[SQLHelper.colShoppingListId],
    );
  }
}

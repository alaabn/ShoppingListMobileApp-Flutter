import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'item.dart';
import 'shoplist.dart';

class SQLHelper {
  static final SQLHelper instance = SQLHelper._instance();
  static Database? _db;

  SQLHelper._instance();

  static String itemsTable = 'items';
  static String listTable = 'lists';
  static String colShoppingListId = 'shopping_list_id';
  static String colId = 'id';
  static String colName = 'name';
  static String colIsFinished = 'isFinished';

  Future<Database?> get db async {
    _db ??= await _initDb();
    return _db;
  }

  Future<Database> _initDb() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'mylist.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
  }

  Future _createDb(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $itemsTable ($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colName TEXT NOT NULL, $colIsFinished INTEGER NOT NULL, $colShoppingListId INTEGER NOT NULL)');
    await db.execute(
        'CREATE TABLE $listTable ($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colName TEXT NOT NULL)');
  }

  Future<int> insertShoppingList(ShoppingList shoppingList) async {
    final db = await instance.db;
    return await db!.insert(listTable, shoppingList.toMap());
  }

  Future<List<ShoppingList>> getAllShoppingLists() async {
    final db = await instance.db;
    final maps = await db!.query(listTable);
    return maps.isNotEmpty
        ? maps.map((map) => ShoppingList.fromMap(map)).toList()
        : [];
  }

  Future<ShoppingList> getShoppingList(int id) async {
    final db = await instance.db;
    final list =
        await db!.query(listTable, where: '$colId = ?', whereArgs: [id]);
    return ShoppingList.fromMap(list.first);
  }

  Future<int> updateList(ShoppingList shoppingList) async {
    final db = await instance.db;
    return await db!.update(listTable, shoppingList.toMap(),
        where: '$colId = ?', whereArgs: [shoppingList.id]);
  }

  Future<int> deleteList(int id) async {
    final db = await instance.db;
    await db!
        .delete(itemsTable, where: '$colShoppingListId = ?', whereArgs: [id]);
    return await db!.delete(listTable, where: '$colId = ?', whereArgs: [id]);
  }

  Future<int> insertItem(Item item) async {
    final db = await instance.db;
    return await db!.insert(itemsTable, item.toMap());
  }

  Future<int> updateItem(Item item) async {
    final db = await instance.db;
    return await db!.update(itemsTable, item.toMap(),
        where: '$colId = ?', whereArgs: [item.id]);
  }

  Future<int> deleteItem(int id) async {
    final db = await instance.db;
    return await db!.delete(itemsTable, where: '$colId = ?', whereArgs: [id]);
  }

  Future<List<Item>> getAllItems(int? listId) async {
    final db = await instance.db;
    final maps = await db!.query(itemsTable,
        where: '$colShoppingListId = ?', whereArgs: [listId]);
    return maps.isNotEmpty ? maps.map((map) => Item.fromMap(map)).toList() : [];
  }

  Future<List<Item>> getAllItemsIn() async {
    final db = await instance.db;
    final maps = await db!.query(itemsTable);
    return maps.isNotEmpty ? maps.map((map) => Item.fromMap(map)).toList() : [];
  }

  Future close() async {
    final db = await instance.db;
    db!.close();
  }
}

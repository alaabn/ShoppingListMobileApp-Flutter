import 'package:flutter/material.dart';
import 'package:mylists/db/SQLHelper.dart';
import 'package:mylists/db/item.dart';
import 'package:mylists/db/shoplist.dart';

import '../widgets/exit.dart';

class ShoppingListPage extends StatefulWidget {
  final ShoppingList shoppingList;
  const ShoppingListPage({Key? key, required this.shoppingList})
      : super(key: key);

  @override
  _ShoppingListPageState createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  final SQLHelper _db = SQLHelper.instance;
  late List<Item> _items;
  String listname = "";
  final TextEditingController _textFieldController = TextEditingController();
  int? _editingIndex;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    listname = widget.shoppingList.name;
    final items = await _db.getAllItems(widget.shoppingList.id);
    setState(() {
      _items = items;
      _editingIndex = null;
    });
  }

  Future<void> _addItem(String itemName) async {
    if (itemName.isNotEmpty) {
      final newItem =
          Item(name: itemName, shoppingListId: widget.shoppingList.id);
      await _db.insertItem(newItem);
      _loadItems();
    }
  }

  Future<void> _toggleFinished(Item item) async {
    item.isFinished = !item.isFinished;
    await _db.updateItem(item);
    _loadItems();
  }

  Future<void> _deleteItem(int id) async {
    await _db.deleteItem(id);
    _loadItems();
  }

  void _startEditing(int index) {
    setState(() {
      _editingIndex = index;
      _textFieldController.text = _items[index].name;
    });
  }

  Future<void> _saveEditing(int index) async {
    final newName = _textFieldController.text;
    if (newName.isNotEmpty) {
      final item = _items[index];
      item.name = newName;
      await _db.updateItem(item);
      _loadItems();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$listname\'s Items',
            style: const TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app, color: Colors.white),
            onPressed: () {
              showExitDialog(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                if (index == _editingIndex) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _textFieldController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.check),
                          onPressed: () {
                            _saveEditing(index);
                            _textFieldController.clear();
                            setState(() {
                              _editingIndex = null;
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.cancel),
                          onPressed: () {
                            _textFieldController.clear();
                            setState(() {
                              _editingIndex = null;
                            });
                          },
                        )
                      ],
                    ),
                  );
                } else {
                  return Dismissible(
                    key: Key(item.id.toString()),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (direction) {
                      _deleteItem(item.id!);
                    },
                    child: ListTile(
                      title: Text(
                        item.name,
                        style: TextStyle(
                          decoration: item.isFinished
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      leading: Checkbox(
                        value: item.isFinished,
                        onChanged: (value) {
                          setState(() {
                            _toggleFinished(item);
                          });
                        },
                      ),
                      onTap: () {
                        _startEditing(index);
                      },
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              _startEditing(index);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          ),
          if (_editingIndex == null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textFieldController,
                      decoration: const InputDecoration(
                        hintText: 'Add Item',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        _addItem(_textFieldController.text);
                        _textFieldController.clear();
                        FocusScope.of(context).unfocus();
                      });
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

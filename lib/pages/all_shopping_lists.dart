import 'package:flutter/material.dart';
import 'package:mylists/db/SQLHelper.dart';
import 'package:mylists/db/shoplist.dart';
import 'package:mylists/pages/shopping_list.dart';

import '../widgets/exit.dart';

class AllShoppingLists extends StatefulWidget {
  const AllShoppingLists({Key? key}) : super(key: key);

  @override
  _AllShoppingListsState createState() => _AllShoppingListsState();
}

class _AllShoppingListsState extends State<AllShoppingLists> {
  final SQLHelper _databaseHelper = SQLHelper.instance;
  final TextEditingController _textFieldController = TextEditingController();
  List<ShoppingList> _shoppingLists = [];
  int? _editingIndex;

  @override
  void initState() {
    super.initState();
    _loadShoppingLists();
  }

  Future<void> _loadShoppingLists() async {
    final shoppingLists = await _databaseHelper.getAllShoppingLists();
    setState(() {
      _shoppingLists = shoppingLists;
      _editingIndex = null;
    });
  }

  Future<void> _addShoppingList(String name) async {
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please Write a valid name"),
      ));
    } else {
      final newShoppingList = ShoppingList(name: name);
      await _databaseHelper.insertShoppingList(newShoppingList);
      _loadShoppingLists();
    }
  }

  Future<void> _deleteShoppingList(int id) async {
    await _databaseHelper.deleteList(id);
    _loadShoppingLists();
  }

  void _startEditing(int index) {
    setState(() {
      _editingIndex = index;
      _textFieldController.text = _shoppingLists[index].name;
    });
  }

  Future<void> _saveEditing(int index) async {
    final newName = _textFieldController.text;
    if (newName.isNotEmpty) {
      final shoppingList = _shoppingLists[index];
      shoppingList.name = newName;
      await _databaseHelper.updateList(shoppingList);
      _loadShoppingLists();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Shopping Lists',
          style: TextStyle(color: Colors.white),
        ),
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
              itemCount: _shoppingLists.length,
              itemBuilder: (context, index) {
                final shoppingList = _shoppingLists[index];
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
                    key: Key(shoppingList.id.toString()),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (direction) {
                      _deleteShoppingList(shoppingList.id!);
                    },
                    child: ListTile(
                      title: Text(shoppingList.name),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ShoppingListPage(shoppingList: shoppingList),
                          ),
                        );
                      },
                      onLongPress: () {
                        _startEditing(index);
                      },
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _startEditing(index);
                        },
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
                        hintText: 'Add List',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        _addShoppingList(_textFieldController.text);
                        _textFieldController.clear();
                        FocusScope.of(context).unfocus();
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: () {
                      _textFieldController.clear();
                      FocusScope.of(context).unfocus();
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

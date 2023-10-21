import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TodoApp(),
    );
  }
}

class TodoApp extends StatefulWidget {
  @override
  _TodoAppState createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  List<TodoItem> _todoList = [];
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [
          Icon(
            Icons.search,
            color: Colors.blue,
          )
        ],
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    hintText: 'Add Title',
                    enabledBorder: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(),
                      hintText: 'Add description'),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                  ),
                  onPressed: () {
                    setState(() {
                      final title = _titleController.text;
                      final description = _descriptionController.text;
                      if (title.isNotEmpty && description.isNotEmpty) {
                        _todoList.add(TodoItem(title, description));
                        _titleController.clear();
                        _descriptionController.clear();
                      }
                    });
                  },
                  child: const Text(
                    'Add',
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _todoList.length,
              itemBuilder: (context, index) {
                final todoItem = _todoList[index];
                return ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.red,
                  ),
                  title: Text(todoItem.title),
                  subtitle: Text(todoItem.description),
                  onTap: () {
                    _showEditDialog(index);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alert'),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showUpdateDialog(index);
                },
                child: const Text('Edit'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _todoList.removeAt(index);
                  });
                  Navigator.pop(context);
                },
                child: const Text('Delete'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showUpdateDialog(int index) {
    final TextEditingController updateTitleController = TextEditingController();
    final TextEditingController updateDescriptionController =
        TextEditingController();
    updateTitleController.text = _todoList[index].title;
    updateDescriptionController.text = _todoList[index].description;

    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextFormField(
                  controller: updateTitleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: updateDescriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                TextButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red)),
                  onPressed: () {
                    setState(() {
                      _todoList[index].title = updateTitleController.text;
                      _todoList[index].description =
                          updateDescriptionController.text;
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Edit Done'),
                ),
              ],
            ),
          );
        });
  }
}

class TodoItem {
  String title;
  String description;

  TodoItem(this.title, this.description);
}

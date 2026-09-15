import 'package:flutter/material.dart';

class _TodoItem {
  _TodoItem(this.title);

  final String title;
  bool done = false;
}

/// Basic local to-do list, no backend involved yet.
class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final _items = [
    _TodoItem('Probar la app en el móvil'),
    _TodoItem('Conectar el backend'),
  ];
  final _textController = TextEditingController();

  void _addItem() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _items.add(_TodoItem(text));
      _textController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _textController,
            onSubmitted: (_) => _addItem(),
            decoration: InputDecoration(
              hintText: 'Nueva tarea',
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                onPressed: _addItem,
                icon: const Icon(Icons.add),
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _items.length,
            itemBuilder: (context, index) {
              final item = _items[index];
              return CheckboxListTile(
                value: item.done,
                title: Text(
                  item.title,
                  style: item.done
                      ? const TextStyle(decoration: TextDecoration.lineThrough)
                      : null,
                ),
                onChanged: (value) =>
                    setState(() => item.done = value ?? false),
              );
            },
          ),
        ),
      ],
    );
  }
}

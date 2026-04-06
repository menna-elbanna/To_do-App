import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/util/todoProvider.dart';
import 'package:todo_app/util/ToDoTile.dart';
import 'TaskHeader.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isTextFieldVisible = false;
  void _toggleTextField() {
    setState(() {
      _isTextFieldVisible = !_isTextFieldVisible;
    });
  }

  @override
  void initState() {
    super.initState();
    Provider.of<TodoProvider>(context, listen: false).fetchAndSetTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          Taskheader(onAddPressed: _toggleTextField, isExpanded: _isTextFieldVisible),
        if (_isTextFieldVisible)
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      hintText: "Add a new task",
                      filled: true,
                      fillColor: Colors.transparent,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add_box, size: 40, 
                  color: Theme.of(context).brightness == Brightness.dark 
                  ? const Color(0xFF311B92) 
                  : const Color(0xFF9161E0),),
                  onPressed: () {
                    context.read<TodoProvider>().addTask(_controller.text);
                    _controller.clear();
                  },
                )
              ],
            ),
          ),
          Expanded(
            child: Consumer<TodoProvider>(
              builder: (context, provider, child) {
                return ListView.builder(
                  itemCount: provider.ToDoList.length,
                  itemBuilder: (context, index) {
                    final task = provider.ToDoList[index];
                    return ToDoTile(
                      id: task['id'],
                      taskName: task['taskName'],
                      isDone: task['isDone'] == 1,
                      onChanged: (val) {
                        provider.toggleTask(task['id'], task['isDone']);
                      },
                      onDelete: () {
                        provider.deleteTask(task['id']);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
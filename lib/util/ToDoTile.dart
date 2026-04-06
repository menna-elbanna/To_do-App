import 'package:flutter/material.dart';

class ToDoTile extends StatelessWidget {
  final int id;
  final String taskName;
  final bool isDone;
  final Function(bool?)? onChanged;
  final Function()? onDelete;

  const ToDoTile({
    super.key,
    required this.id,
    required this.taskName,
    required this.isDone,
    required this.onChanged,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25, top: 25),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFEDE4FC),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Checkbox(
              value: isDone,
              onChanged: onChanged,
              activeColor: Color(0xFF9161E0),
              side: BorderSide(color: isDark ? Colors.white54 : Colors.black54),
            ),
            Expanded(
              child: Text(
                taskName,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  decoration: isDone ? TextDecoration.lineThrough : null,
                  decorationColor: isDark ? Colors.white70 : Colors.black54,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: onDelete,
            )
          ],
        ),
      ),
    );
  }
}
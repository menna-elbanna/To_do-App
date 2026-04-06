import 'package:flutter/material.dart';
import 'package:todo_app/sqlsafe.dart';

class TodoProvider extends ChangeNotifier {
  final sqlsafe1 _dbHelper = sqlsafe1();
  List<Map<String, dynamic>> _toDoList = [];

  List<Map<String, dynamic>> get ToDoList => _toDoList;

  Future<void> fetchAndSetTodos() async {
    _toDoList = await _dbHelper.readData();
    notifyListeners();
  }

  Future<void> addTask(String taskName) async {
    if (taskName.isEmpty) return;
    await _dbHelper.insertData(taskName);
    await fetchAndSetTodos();
  }

  Future<void> toggleTask(int id, int currentStatus) async {
    int newStatus = currentStatus == 1 ? 0 : 1;
    await _dbHelper.updateStatus(id, newStatus);
    await fetchAndSetTodos();
  }

  Future<void> deleteTask(int id) async {
    await _dbHelper.deleteData(id);
    await fetchAndSetTodos();
  }
}
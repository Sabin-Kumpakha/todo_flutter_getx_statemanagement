import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/app/data/models/todo/todo.dart';

import '../../../data/models/todo/todo_request.dart';
import '../../../services/remote/todo_api_service.dart';
import '../../../utils/helper.dart';
import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  final editTitleController = TextEditingController();
  final editDescriptionController = TextEditingController();

  var todos = <Todo>[].obs;

  getAllTodos() async {
    try {
      http.Response response = await TodoApiService().getAllTodos();
      var decodedResponse = jsonDecode(response.body);
      if (response.statusCode == 200) {
        todos.value = Todo.todoFromJson(jsonEncode(decodedResponse["content"]));
        // show todos
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        // show error message
        Helper.showToastMessage(message: "Something went wrong.");
      } else {
        throw Exception();
      }
    } catch (e) {
      log(e.toString());
      Helper.showToastMessage(message: "Something went wrong.");
    }
    return todos;
  }

  createTodo() async {
    try {
      TodoRequest todoRequest = TodoRequest(
        title: titleController.text,
        description: descriptionController.text,
      );

      http.Response response = await TodoApiService().createTodo(todoRequest);
      var decodedResponse = jsonDecode(response.body);
      if (response.statusCode == 200) {
        Todo todo = Todo.fromJson(decodedResponse);
        todos.add(todo);

        titleController.clear();
        descriptionController.clear();

        todos.refresh();
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        Helper.showToastMessage(message: decodedResponse["message"]);
      } else {
        throw Exception();
      }
    } catch (e) {
      log(e.toString());
      Helper.showToastMessage(message: "Something went wrong.");
    }
  }

  deleteTodo(int index) async {
    try {
      int id = todos[index].id;

      http.Response response = await TodoApiService().deleteTodo(id);
      var decodedResponse = jsonDecode(response.body);
      if (response.statusCode == 200) {
        todos.removeAt(index);
        todos.refresh();
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        Helper.showToastMessage(message: decodedResponse["message"]);
      } else {
        throw Exception();
      }
    } catch (e) {
      log(e.toString());
      Helper.showToastMessage(message: "Something went wrong.");
    }
  }

//markTodoAsCompleted is used to mark todo as completed or not completed
  markTodoAsCompleted(int index, bool? value) async {
    try {
      Todo todo = Todo(
        id: todos[index].id,
        title: todos[index].title,
        description: todos[index].description,
        // if value is null then set completed as false
        completed: value ?? false,
        createdAt: todos[index].createdAt,
        updatedAt: todos[index].updatedAt,
      );

      http.Response response = await TodoApiService().updateTodo(
        todo,
      );
      var decodedResponse = jsonDecode(response.body);
      if (response.statusCode == 200) {
        // if (value == true) then mark todo as completed else mark todo as not completed
        todos[index].completed = value ?? false;
        todos.refresh();
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        Helper.showToastMessage(message: decodedResponse["message"]);
      } else {
        throw Exception();
      }
    } catch (e) {
      log(e.toString());
      Helper.showToastMessage(message: "Something went wrong.");
    }
  }

//updateTodo is used to update todo after editing it in the edit todo dialog
  updateTodo(int index) async {
    try {
      Todo todo = Todo(
        id: todos[index].id,
        title: editTitleController.text,
        description: editDescriptionController.text,
        completed: todos[index].completed,
        createdAt: todos[index].createdAt,
        updatedAt: todos[index].updatedAt,
      );

      http.Response response = await TodoApiService().updateTodo(
        todo,
      );

      if (response.statusCode == 200) {
        Todo updatedTodo = Todo.singleTodoFromJson(response.body);
        // update todo in todos list
        todos[index] = updatedTodo;
        todos.refresh();
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        var decodedResponse = jsonDecode(response.body);
        Helper.showToastMessage(message: decodedResponse["message"]);
      } else {
        throw Exception();
      }
    } catch (e) {
      log(e.toString());
      Helper.showToastMessage(message: "Something went wrong.");
    }
  }
}

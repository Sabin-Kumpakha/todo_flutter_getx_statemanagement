import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../consts/text_form_field.dart';
import '../../../data/models/todo/todo.dart';
import '../../../services/local/auth_service.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({Key? key}) : super(key: key);

  final addTodoFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              Get.showOverlay(
                asyncFunction: () async {
                  AuthService authService = Get.put(AuthService());
                  await authService.logout();
                },
                loadingWidget: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: Get.height * 0.1,
            color: Colors.red,
            child: SafeArea(
              child: Center(
                child: Text(
                  "Todos",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: FutureBuilder(
                  future: controller.getAllTodos(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Obx(
                        () => ListView.builder(
                          itemCount: controller.todos.length,
                          padding: EdgeInsets.zero,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            Todo todo = controller.todos[index];

                            return ListTile(
                              title: Text(todo.title),
                              subtitle: Text(todo.description),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  //edit button
                                  IconButton(
                                    onPressed: () {
                                      _showEditTodoBottomModalSheet(
                                        context,
                                        todo,
                                        index,
                                      );
                                    },
                                    icon: const Icon(Icons.edit),
                                  ),

                                  //delete button
                                  IconButton(
                                    onPressed: () async {
                                      Get.showOverlay(
                                        asyncFunction: () async {
                                          await controller.deleteTodo(index);
                                        },
                                        loadingWidget: const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.delete),
                                  ),
                                ],
                              ),

                              //checkbox
                              leading: Checkbox(
                                value: todo.completed,
                                onChanged: (value) async {
                                  Get.showOverlay(
                                    asyncFunction: () async {
                                      await controller.markTodoAsCompleted(
                                        index,
                                        value,
                                      );
                                    },
                                    loadingWidget: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                },
                              ),
                              onLongPress: () {},
                            );
                          },
                        ),
                      );
                    }
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text("Something went wrong."),
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }),
            ),
          ),
        ],
      ),
      //Add todo button at bottom //floatingActionButton
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTodoBottomModalSheet(context);
        },
        backgroundColor: Colors.red,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  _showAddTodoBottomModalSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (cx) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Container(
                height: 5,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Form(
                    key: addTodoFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Create new todo",
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          decoration: TextFormFieldStyles
                              .kRoundedInputDecorationNoBorder(
                            radius: 6,
                          ).copyWith(
                            hintText: "Title",
                            filled: true,
                            fillColor: Colors.red.withOpacity(0.2),
                          ),
                          controller: controller.titleController,
                          validator: (description) {
                            if (description!.trim().length <= 3) {
                              return "Please Enter valid title";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          maxLines: 5,
                          decoration: TextFormFieldStyles
                              .kRoundedInputDecorationNoBorder(
                            radius: 6,
                          ).copyWith(
                            hintText: "Description",
                            filled: true,
                            fillColor: Colors.red.withOpacity(0.2),
                          ),
                          controller: controller.descriptionController,
                          validator: (description) {
                            if (description!.trim().length <= 6) {
                              return "Please Enter valid description";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (addTodoFormKey.currentState!.validate()) {
                                Get.showOverlay(
                                  asyncFunction: () async {
                                    await controller.createTodo();
                                    Get.back();
                                  },
                                  loadingWidget: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                "Create",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12.0),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  _showEditTodoBottomModalSheet(
    BuildContext context,
    Todo todo,
    int index,
  ) {
    controller.editTitleController.text = todo.title;
    controller.editDescriptionController.text = todo.description;
    showModalBottomSheet(
      context: context,
      builder: (cx) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Container(
                height: 5,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Form(
                    key: addTodoFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Edit todo",
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          decoration: TextFormFieldStyles
                              .kRoundedInputDecorationNoBorder(
                            radius: 6,
                          ).copyWith(
                            hintText: "Title",
                            filled: true,
                            fillColor: Colors.red.withOpacity(0.2),
                          ),
                          controller: controller.editTitleController,
                          validator: (description) {
                            if (description!.trim().length <= 3) {
                              return "Please Enter valid title";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          maxLines: 5,
                          decoration: TextFormFieldStyles
                              .kRoundedInputDecorationNoBorder(
                            radius: 6,
                          ).copyWith(
                            hintText: "Description",
                            filled: true,
                            fillColor: Colors.red.withOpacity(0.2),
                          ),
                          controller: controller.editDescriptionController,
                          validator: (description) {
                            if (description!.trim().length <= 6) {
                              return "Please Enter valid description";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (addTodoFormKey.currentState!.validate()) {
                                Get.showOverlay(
                                  asyncFunction: () async {
                                    await controller.updateTodo(index);
                                    Get.back();
                                  },
                                  loadingWidget: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                "Update Todo",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12.0),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

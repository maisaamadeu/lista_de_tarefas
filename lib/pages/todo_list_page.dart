import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/models/todo.dart';
import 'package:lista_de_tarefas/widgets/todo_list_item.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final TextEditingController todoController = TextEditingController();
  final List<Todo> todoList = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //ADD AREA
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: todoController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          hintText: 'Ex: Ir ao mercado',
                          labelText: 'Adicione uma tarefa',
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        String text = todoController.text;

                        if (text != '') {
                          setState(() {
                            Todo newTodo = Todo(
                              title: text,
                              dateTime: DateTime.now(),
                            );
                            todoList.add(newTodo);
                            todoController.clear();
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(14),
                        shape: const CircleBorder(),
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 30,
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 16,
                ),

                //'TODO' LIST AREA
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (Todo todo in todoList) TodoListItem(todo: todo),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 16,
                ),

                //CLEAR AREA
                Row(
                  children: [
                    Expanded(
                      child: Text(
                          'Você possui ${todoList.length} tarefas pendentes'),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    ElevatedButton(
                      onPressed: () => {
                        if (todoList != [])
                          {
                            setState(() {
                              todoList.clear();
                            })
                          }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(14),
                        shape: const StadiumBorder(),
                      ),
                      child: const Text('Limpar tudo'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

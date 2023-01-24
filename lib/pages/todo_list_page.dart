import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/models/todo.dart';
import 'package:lista_de_tarefas/repository/todo_repository.dart';
import 'package:lista_de_tarefas/widgets/todo_list_item.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final TextEditingController todoController = TextEditingController();
  final TodoRepository todoRepository = TodoRepository();

  List<Todo> todos = [];

  @override
  void initState() {
    super.initState();

    todoRepository.getTodoList().then((value) {
      setState(() {
        todos = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey,
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
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
                            todos.add(newTodo);
                            todoController.clear();
                            todoRepository.saveTodoList(todos);
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
                      for (Todo todo in todos)
                        TodoListItem(
                          todo: todo,
                          onDelete: onDelete,
                        ),
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
                      child:
                          Text('Você possui ${todos.length} tarefas pendentes'),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    ElevatedButton(
                      onPressed: () => showDeleteTodoConfirmationDialog(),
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

  void onDelete(Todo todo) {
    Todo lastTodo = todo;
    int index = todos.indexOf(todo);

    setState(() {
      todos.remove(todo);
      todoRepository.saveTodoList(todos);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.white,
        content: Text(
          'Tarefa "${todo.title}" foi removida com sucesso! Deseja desfazer essa ação?',
          style: const TextStyle(color: Colors.black),
        ),
        action: SnackBarAction(
            label: 'Desfazer',
            onPressed: () => {
                  setState(() {
                    todos.insert(index, lastTodo);
                    todoRepository.saveTodoList(todos);
                  })
                }),
      ),
    );
  }

  void showDeleteTodoConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text("Limpar tudo?"),
        content: const Text(
          "Você tem certeza que deseja apagar todas as tarefas? Essa ação não pode ser desfeita!",
        ),
        actions: [
          TextButton(
            onPressed: () => {
              setState(
                () => {
                  todos.clear(),
                  todoRepository.saveTodoList(todos),
                  Navigator.of(context).pop(),
                },
              ),
            },
            child: const Text(
              'Sim',
              style: TextStyle(color: Colors.red),
            ),
          ),
          TextButton(
            onPressed: () => {
              setState(
                () => {
                  Navigator.of(context).pop(),
                },
              ),
            },
            child: const Text(
              'Cancelar',
            ),
          ),
        ],
      ),
    );
  }
}

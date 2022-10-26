import 'package:flutter/material.dart';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/repositories/todo_repository.dart';

import '../widgets/todo_list_item.dart';

class TodoListPage extends StatefulWidget {
  TodoListPage({Key? key}) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final TextEditingController todoControler = TextEditingController();
  final TodoRepository todoRepository = TodoRepository();

  List<Todo> todos = [];

  Todo? deletedTodo;
  int? deletedTodoPosition;

  String? errorText;

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
          body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: todoControler,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Adicione uma tarefa',
                          hintText: 'Ex.: Estudar Flutter',
                          errorText: errorText,
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.purple, width: 2)),
                          labelStyle: TextStyle(color: Colors.purple)),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      String text = todoControler.text;

                      if (text.isEmpty) {
                        setState(() {
                          errorText = 'O título não pode ser vazio';
                        });
                        return;
                      }

                      setState(() {
                        Todo newTodo = Todo(title: text, date: DateTime.now());
                        todos.add(newTodo);
                        errorText = null;
                      });
                      todoControler.clear();
                      todoRepository.saveTodoList(todos);
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Colors.purple, padding: EdgeInsets.all(21)),
                    child: Icon(Icons.add),
                  )
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Flexible(
                child: ListView(shrinkWrap: true, children: [
                  for (Todo todo in todos)
                    TodoListItem(
                      todo: todo,
                      onDelete: onDelete,
                    ),
                ]),
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  Expanded(
                      child: Text(
                          'Você possui ${todos.length} tarefas pendentes')),
                  ElevatedButton(
                      onPressed: showDeleteTodosConfirmationDialog,
                      style: ElevatedButton.styleFrom(
                          primary: Colors.purple, padding: EdgeInsets.all(21)),
                      child: Text('Limpar tudo'))
                ],
              )
            ],
          ),
        ),
      )),
    );
  }

  void onDelete(Todo todo) {
    deletedTodo = todo;
    deletedTodoPosition = todos.indexOf(todo);

    setState(() {
      todos.remove(todo);
    });
    todoRepository.saveTodoList(todos);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Tarefa "${todo.title}" foi removida com sucesso'),
      action: SnackBarAction(
        label: 'Desfazer',
        textColor: Colors.purple[600],
        onPressed: () {
          setState(() {
            todos.insert(deletedTodoPosition!, deletedTodo!);
          });
          todoRepository.saveTodoList(todos);
        },
      ),
    ));
  }

  void showDeleteTodosConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Limpar tudo?"),
        content: Text("Você tem certeza que deseja apagar todas as tarefas?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Cancelar"),
            style: TextButton.styleFrom(primary: Colors.purple[600]),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              deleteAllTodos();
            },
            child: Text("Limpar tudo"),
            style: TextButton.styleFrom(primary: Colors.red),
          )
        ],
      ),
    );
  }

  void deleteAllTodos() {
    setState(() {
      todos.clear();
    });
    todoRepository.saveTodoList(todos);
  }
}

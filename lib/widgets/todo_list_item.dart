import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/models/todo.dart';

class TodoListItem extends StatelessWidget {
  const TodoListItem({Key? key, required this.todo, required this.onDelete})
      : super(key: key);

  final Todo todo;
  final Function(Todo) onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Slidable(
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4), color: Colors.grey[200]),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                    DateFormat('dd/MM/yyyy - HH:mm - EE', 'pt_BR')
                        .format(todo.date),
                    style: TextStyle(fontSize: 12)),
                Text(todo.title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
              ],
            ),
          ),
        ),
        actionExtentRatio: 0.25,
        actionPane: SlidableDrawerActionPane(),
        secondaryActions: [
          IconSlideAction(
            color: Colors.red,
            icon: Icons.delete,
            caption: 'Deletar',
            foregroundColor: Colors.white,
            onTap: () {
              onDelete(todo);
            },
          )
        ],
      ),
    );
  }
}

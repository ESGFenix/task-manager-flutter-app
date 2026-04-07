import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_final_domestika/app/view/components/h1.dart';
import 'package:proyecto_final_domestika/app/view/components/shape.dart';
import 'package:proyecto_final_domestika/app/view/task_list/task_provider.dart';

class TaskListPage extends StatelessWidget {
  const TaskListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TaskProvider()..fetchTasks(),
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _Header(),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Theme.of(context).colorScheme.primary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 129, //Tamaño del Shape
            child: Stack(
              children: const [
                Align(
                  alignment: Alignment.topLeft,
                  child: Shape(),
                ),
                Align(
                  alignment: Alignment.center,
                  child: H1(
                    'Completa tus tareas',
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10,),
        ],
      )
    );
  }
}

import 'package:accordion/accordion.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_final_domestika/app/view/components/h1.dart';
import 'package:proyecto_final_domestika/app/view/components/shape.dart';
import 'package:proyecto_final_domestika/app/view/task_list/task_provider.dart';

import '../../model/task.dart';
import '../../model/task_category.dart';

class TaskListPage extends StatelessWidget {
  const TaskListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TaskProvider()..initialize(),
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _Header(),
            Expanded(child: _TaskCategoriesAccordion()),
          ],
        ),
      ),
    );
  }
}

class _TaskCategoriesAccordion extends StatelessWidget {
  const _TaskCategoriesAccordion();

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, provider, _) {
        final categories = provider.categories;
        final tasks = provider.taskList;
        if (categories.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Accordion(
            headerBackgroundColorOpened: Theme.of(context).colorScheme.primary,
            headerPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            contentBorderColor: Colors.transparent,
            scaleWhenAnimating: false,
            openAndCloseAnimation: true,
            children: categories
                .map(
                  (category) => AccordionSection(
                    isOpen: category.id == 'mock-category',
                    leftIcon: const Icon(Icons.folder_open_outlined),
                    header: Text(
                      category.name,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    contentBackgroundColor: Colors.white,
                    headerBackgroundColor: Colors.white,
                    headerBackgroundColorOpened: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.15),
                    content: _CategoryTasksList(
                      category: category,
                      tasks: tasks
                          .where((task) => task.categoryId == category.id)
                          .toList(),
                    ),
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }
}

class _CategoryTasksList extends StatelessWidget {
  const _CategoryTasksList({required this.category, required this.tasks});

  final TaskCategory category;
  final List<Task> tasks;

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 6),
        child: Text('No hay tareas en esta categoría.'),
      );
    }

    return Column(
      children: tasks.map((task) => _TaskListTile(task: task)).toList(),
    );
  }
}

class _TaskListTile extends StatefulWidget {
  const _TaskListTile({required this.task});

  final Task task;

  @override
  State<_TaskListTile> createState() => _TaskListTileState();
}

class _TaskListTileState extends State<_TaskListTile> {
  double _swipeProgress = 0;

  @override
  Widget build(BuildContext context) {
    final task = widget.task;

    return Dismissible(
      key: ValueKey('${task.title}-${task.description}-${task.hashCode}'),
      direction: DismissDirection.startToEnd,
      background: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsetsGeometry.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.green.withValues(
            alpha: (0.12 + (_swipeProgress * 0.88)).clamp(0.12, 1.0),
          ),
          borderRadius: BorderRadiusGeometry.circular(14),
        ),
        alignment: Alignment.centerLeft,
        child: Icon(
          Icons.check,
          color: Colors.white.withValues(alpha: 0.6 + (_swipeProgress * 0.4)),
        ),
      ),
      onUpdate: (details) {
        final progress = details.progress.clamp(0.0, 1.0);
        if ((_swipeProgress - progress).abs() > 0.01) {
          setState(() => _swipeProgress = progress);
        }
      },
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          await context.read<TaskProvider>().onTaskDoneChange(task);
        }
        if (mounted) {
          setState(() => _swipeProgress = 0);
        }
        return false;
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        margin: const EdgeInsets.only(bottom: 8),
        child: ListTile(
          onTap: () => _showTaskModal(context, widget.task),
          title: Text(widget.task.title),
          subtitle: Text(
            widget.task.dueDate == null
                ? 'Sin fecha límite'
                : 'Fecha límite: ${_formatDate(widget.task.dueDate!)}',
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _StateBadge(taskState: widget.task.taskState),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () =>
                    context.read<TaskProvider>().deleteTask(widget.task),
                icon: const Icon(Icons.delete_outline),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StateBadge extends StatelessWidget {
  const _StateBadge({required this.taskState});

  final TaskState taskState;

  @override
  Widget build(BuildContext context) {
    final color = switch (taskState) {
      TaskState.DONE => Colors.green,
      TaskState.LATE => Colors.red,
      TaskState.PENDING => Colors.orange,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        taskState.name.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

Future<void> _showTaskModal(BuildContext context, Task task) async {
  final provider = context.read<TaskProvider>();
  final titleController = TextEditingController(text: task.title);
  final descriptionController = TextEditingController(text: task.description);
  var selectedDueDate = task.dueDate;
  var selectedCategoryId = task.categoryId;

  await showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Añadir tarea',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre de la tarea',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: descriptionController,
                    minLines: 3,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Descripción',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () async {
                            final now = DateTime.now();
                            final result = await showDatePicker(
                              context: context,
                              initialDate: selectedDueDate ?? now,
                              firstDate: DateTime(now.year - 2),
                              lastDate: DateTime(now.year + 5),
                            );
                            if (result != null) {
                              setState(() => selectedDueDate = result);
                            }
                          },
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              selectedDueDate == null
                                  ? 'Fecha límite'
                                  : _formatDate(selectedDueDate!),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          isExpanded: true,
                          initialValue: selectedCategoryId,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Categoría',
                          ),
                          items: [
                            const DropdownMenuItem<String>(
                              value: '__new_category__',
                              child: Text(
                                '+ Crear categoría',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            ...provider.categories.map(
                              (category) => DropdownMenuItem<String>(
                                value: category.id,
                                child: Text(category.name),
                              ),
                            ),
                          ],
                          onChanged: (value) async {
                            if (value == '__new_category__') {
                              final newCategoryName =
                                  await _showCreateCategoryDialog(context);
                              if (newCategoryName == null ||
                                  newCategoryName.isEmpty) {
                                return;
                              }
                              final category = TaskCategory(
                                id: 'cat-${DateTime.now().millisecondsSinceEpoch}',
                                name: newCategoryName,
                              );
                              await provider.addNewCategory(category);
                              setState(() => selectedCategoryId = category.id);
                              return;
                            }
                            if (value != null) {
                              setState(() => selectedCategoryId = value);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      final updatedTask = Task(
                        titleController.text.trim(),
                        descriptionController.text.trim(),
                        dueDate: selectedDueDate,
                        done: task.done,
                        taskState: task.taskState,
                        categoryId: selectedCategoryId,
                      );
                      await provider.updateTask(task, updatedTask);
                      if (context.mounted) Navigator.of(context).pop();
                    },
                    child: const Text('Guardar cambios'),
                  ),
                  const SizedBox(height: 8),
                  OverflowBar(
                    alignment: MainAxisAlignment.center,
                    spacing: 8,
                    overflowAlignment: OverflowBarAlignment.center,
                    overflowDirection: VerticalDirection.down,
                    overflowSpacing: 4,
                    children: [
                      TextButton.icon(
                        onPressed: () async {
                          await provider.onTaskDoneChange(task);
                          if (context.mounted) Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.check),
                        label: Text( task.done ? 'Marcar como pendiente' : 'Marcar como hecho'),
                      ),
                      const SizedBox(width: 8),
                      TextButton.icon(
                        onPressed: () async {
                          await provider.deleteTask(task);
                          if (context.mounted) Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.delete_outline),
                        label: const Text('Borrar tarea'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

Future<String?> _showCreateCategoryDialog(BuildContext context) {
  final controller = TextEditingController();
  return showDialog<String>(
    context: context,
    builder: (_) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Nueva categoría'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Nombre de la categoría',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: const Text('Crear'),
          ),
        ],
      );
    },
  );
}

String _formatDate(DateTime date) =>
    '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';

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
                Align(alignment: Alignment.topLeft, child: Shape()),
                Align(
                  alignment: Alignment.center,
                  child: H1('Completa tus tareas', color: Colors.white),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}

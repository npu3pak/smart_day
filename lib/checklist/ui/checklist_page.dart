import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_day/checklist/logic/cubit/checklist_cubit.dart';
import 'package:smart_day/checklist/logic/cubit/checklist_state.dart';
import 'package:smart_day/checklist/logic/entities/checklist_task.dart';

class ChecklistPage extends StatefulWidget {
  const ChecklistPage({super.key});

  @override
  State<ChecklistPage> createState() => _ChecklistPageState();
}

class _ChecklistPageState extends State<ChecklistPage> {
  final _newTaskTitleController = TextEditingController();
  late final ChecklistCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<ChecklistCubit>();
    _cubit.loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ChecklistCubit, ChecklistState>(
        builder: (context, state) {
          if (state is ChecklistLoading) {
            return _buildLoading();
          } else if (state is ChecklistLoaded) {
            return _buildList(state.tasks);
          } else if (state is ChecklistSaving) {
            return _buildSaving();
          } else {
            return _buildError();
          }
        },
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildList(List<ChecklistTask> tasks) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return _buildListItem(task);
            },
          ),
        ),
        _buildAddTaskWidget(),
      ],
    );
  }

  Widget _buildListItem(ChecklistTask task) {
    return Dismissible(
      key: Key(task.id.toString()),
      onDismissed: (_) => _removeTask(task.id!),
      child: ListTile(
        title: Text(task.title),
        trailing: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => _removeTask(task.id!),
        ),
      ),
    );
  }

  Widget _buildAddTaskWidget() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: TextField(
              controller: _newTaskTitleController,
              maxLines: null,
              decoration: const InputDecoration(
                hintText: 'Add new task',
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              final title = _newTaskTitleController.text.trim();
              if (title.isNotEmpty) {
                _cubit.addTask(title);
                _newTaskTitleController.clear();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSaving() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildError() {
    return const Center(
      child: Text('Failed to load tasks'),
    );
  }

  void _removeTask(int id) {
    _cubit.removeTask(id);
  }
}

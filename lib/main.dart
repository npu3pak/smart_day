import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_day/checklist/logic/dao/checklist_dao.dart';
import 'package:smart_day/checklist/logic/repository/checklist_repository.dart';
import 'package:smart_day/checklist/ui/checklist_page.dart';

import 'checklist/logic/cubit/checklist_cubit.dart';

late final ChecklistDao _checklistDao;
late final ChecklistRepository _checklistRepository;

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  _checklistDao = ChecklistDao();
  _checklistRepository = ChecklistRepository(_checklistDao);
  _checklistDao.initDatabase().then((value) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 0,
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.list_alt), text: 'Задачи'),
                Tab(icon: Icon(Icons.schedule), text: 'Расписание'),
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              // Вставьте сюда виджеты для первой вкладки
              _getTasksPage(),
              // Вставьте сюда виджеты для второй вкладки
              const Text('Settings'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getTasksPage() {
    return BlocProvider(
      create: (_) => ChecklistCubit(_checklistRepository),
      child: const ChecklistPage(),
    );
  }
}

import 'package:flutter/material.dart';

import '../../core/sync/sync_controller.dart';
import '../fields/fields_screen.dart';
import '../more/more_screen.dart';
import '../records/records_screen.dart';
import '../tasks/tasks_screen.dart';
import 'home_screen.dart';

/// 底部導覽：首頁／田區／工作／紀錄／更多（DESIGN_SYSTEM §9）。
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  void _go(int index) => setState(() => _index = index);

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(onOpenTab: _go),
      const FieldsScreen(),
      const TasksScreen(),
      const RecordsScreen(),
      const MoreScreen(),
    ];
    return Scaffold(
      body: AutoSync(
        child: IndexedStack(index: _index, children: pages),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: _go,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: '首頁',
          ),
          NavigationDestination(
            icon: Icon(Icons.grass_outlined),
            selectedIcon: Icon(Icons.grass),
            label: '田區',
          ),
          NavigationDestination(
            icon: Icon(Icons.assignment_outlined),
            selectedIcon: Icon(Icons.assignment),
            label: '工作',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: '紀錄',
          ),
          NavigationDestination(icon: Icon(Icons.more_horiz), label: '更多'),
        ],
      ),
    );
  }
}

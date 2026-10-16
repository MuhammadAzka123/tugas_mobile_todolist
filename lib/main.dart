import 'package:flutter/material.dart';

void main() {
  runApp(const TodoApp());
}

const Color background = Color(0xFFF5F6F2);
const Color navy = Color(0xFF253B46);
const Color teal = Color(0xFF5A9E91);
const Color orange = Color(0xFFF1A276);
const Color lightTeal = Color(0xFFE1EFE9);
const Color muted = Color(0xFF82908D);
const Color borderColor = Color(0xFFE5E9E4);

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To Do List',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: navy,
          primary: navy,
          secondary: teal,
        ),
      ),
      home: const TodoPage(),
    );
  }
}

class MyApp extends TodoApp {
  const MyApp({super.key});
}

class TodoItem {
  String title;
  bool isDone;

  TodoItem({
    required this.title,
    this.isDone = false,
  });
}

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final TextEditingController _controller = TextEditingController();

  final List<TodoItem> _tasks = [
    TodoItem(title: 'Makan'),
    TodoItem(title: 'Minum'),
    TodoItem(title: 'Tidur'),
  ];

  int _selectedPage = 0;

  List<TodoItem> get _activeTasks =>
      _tasks.where((task) => !task.isDone).toList();

  List<TodoItem> get _completedTasks =>
      _tasks.where((task) => task.isDone).toList();

  void _addTask() {
    final title = _controller.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Masukkan nama tugas terlebih dahulu.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      _tasks.insert(0, TodoItem(title: title));
      _controller.clear();
    });

    FocusScope.of(context).unfocus();
  }

  void _toggleTask(TodoItem task, bool value) {
    setState(() {
      task.isDone = value;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _selectedPage == 0
                  ? _buildTaskPage()
                  : _buildCompletedPage(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        indicatorColor: lightTeal,
        selectedIndex: _selectedPage,
        onDestinationSelected: (index) {
          FocusScope.of(context).unfocus();

          setState(() {
            _selectedPage = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.checklist_rounded),
            label: 'Daftar Tugas',
          ),
          NavigationDestination(
            icon: Icon(Icons.task_alt_rounded),
            label: 'Selesai',
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(22, 20, 20, 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'To Do List',
          style: TextStyle(
            color: navy,
            fontSize: 25,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildTaskPage() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 18, 20, 12),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Daftar Tugas',
              style: TextStyle(
                color: navy,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  maxLength: 100,
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _addTask(),
                  decoration: InputDecoration(
                    hintText: 'Tulis tugas baru...',
                    counterText: '',
                    hintStyle: const TextStyle(
                      color: muted,
                      fontSize: 12,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: borderColor,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: borderColor,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: teal,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 9),
              SizedBox(
                height: 49,
                width: 49,
                child: FilledButton(
                  onPressed: _addTask,
                  style: FilledButton.styleFrom(
                    backgroundColor: orange,
                    foregroundColor: navy,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Icon(
                    Icons.add_rounded,
                    size: 26,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: _activeTasks.isEmpty
              ? _buildEmptyState(
                  'Semua tugas selesai!',
                  'Kamu bisa menambahkan tugas baru.',
                  Icons.celebration_rounded,
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 2, 20, 15),
                  itemCount: _activeTasks.length,
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 10);
                  },
                  itemBuilder: (context, index) {
                    return _buildTaskCard(_activeTasks[index]);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildCompletedPage() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 18, 20, 14),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Tugas Selesai',
              style: TextStyle(
                color: navy,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
        Expanded(
          child: _completedTasks.isEmpty
              ? _buildEmptyState(
                  'Belum ada tugas selesai',
                  'Centang tugas untuk memindahkannya ke sini.',
                  Icons.task_alt_rounded,
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
                  itemCount: _completedTasks.length,
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 10);
                  },
                  itemBuilder: (context, index) {
                    return _buildTaskCard(_completedTasks[index]);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildTaskCard(TodoItem task) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: borderColor),
        boxShadow: const [
          BoxShadow(
            color: Color(0x07000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Checkbox(
            value: task.isDone,
            activeColor: teal,
            checkColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            onChanged: (value) {
              if (value != null) {
                _toggleTask(task, value);
              }
            },
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              task.title,
              style: TextStyle(
                color: task.isDone ? muted : navy,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                decoration: task.isDone
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            task.isDone
                ? Icons.check_circle_rounded
                : Icons.radio_button_unchecked_rounded,
            color: task.isDone ? teal : const Color(0xFFD4DDD8),
            size: 19,
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildEmptyState(
    String title,
    String subtitle,
    IconData icon,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 74,
              height: 74,
              decoration: BoxDecoration(
                color: lightTeal,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(
                icon,
                color: teal,
                size: 36,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: navy,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: muted,
                fontSize: 12,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
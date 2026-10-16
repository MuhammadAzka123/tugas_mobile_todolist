import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const TodoPage(),
    );
  }
}

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final TextEditingController controller = TextEditingController();

  List<String> tasks = [];

  void tambahTugas() {
    if (controller.text.trim().isNotEmpty) {
      setState(() {
        tasks.add(controller.text.trim());
        controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5FF),
      appBar: AppBar(
        title: const Text('Todo List', style: TextStyle(fontSize: 18)),
        centerTitle: true,
        backgroundColor: const Color(0xFFDCC8F5),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: 'Nama tugas',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(10),
                    ),
                    onSubmitted: (_) => tambahTugas(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: tambahTugas,
                  child: const Text('Tambah'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    dense: true,
                    leading: Text('${index + 1}'),
                    title: Text(
                      tasks[index],
                      style: const TextStyle(fontSize: 14),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

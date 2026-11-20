import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'lab6.dart' as lab6;
import 'lab7.dart' as lab7;
import 'lab8.dart' as lab8;

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => lab8.TodoModel()),
        ChangeNotifierProvider(create: (_) => lab8.ThemeModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Lắng nghe trạng thái Sáng/Tối từ ThemeModel của Lab 8
    final isDark = context.watch<lab8.ThemeModel>().isDark;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tong Hop Thuc Hanh Flutter',
      theme: isDark
          ? ThemeData.dark(useMaterial3: true)
          : ThemeData(primarySwatch: Colors.indigo, useMaterial3: true),
      home: const MenuChinh(),
    );
  }
}

class MenuChinh extends StatelessWidget {
  const MenuChinh({super.key});

  @override
  Widget build(BuildContext context) {
    final themeModel = context.watch<lab8.ThemeModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh Sach Bai Lab Flutter'),
        actions: [
          IconButton(
            tooltip: 'Doi giao dien Sang/Toi',
            icon: Icon(
              themeModel.isDark ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () => context.read<lab8.ThemeModel>().toggleTheme(),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const lab6.TrangHoSo()),
                ),
                child: const Text('Mo Lab 6: Ho So Sinh Vien'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const lab7.TrangTodo()),
                ),
                child: const Text('Mo Lab 7: Todo List (setState)'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const lab8.TrangDanhSach()),
                ),
                child: const Text('Mo Lab 8: Todo List (Provider)'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
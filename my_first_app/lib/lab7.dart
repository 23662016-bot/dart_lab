import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Danh Sach Cong Viec',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const TrangTodo(),
    );
  }
}

// Bước 1: Mô hình dữ liệu công việc
class CongViec {
  String tieuDe;
  bool hoanThanh;
  CongViec(this.tieuDe, {this.hoanThanh = false});
}

// Bước 2: StatefulWidget và danh sách công việc
class TrangTodo extends StatefulWidget {
  const TrangTodo({super.key});

  @override
  State<TrangTodo> createState() => _TrangTodoState();
}

class _TrangTodoState extends State<TrangTodo> {
  final List<CongViec> _dsCongViec = [
    CongViec('Hoc Dart co ban'),
    CongViec('Hoc Flutter widget'),
  ];
  final TextEditingController _controller = TextEditingController();

  void _themCongViec() {
    if (_controller.text.trim().isEmpty) return;
    setState(() {
      _dsCongViec.add(CongViec(_controller.text.trim()));
      _controller.clear();
    });
  }

  void _toggleHoanThanh(int index) {
    setState(() {
      _dsCongViec[index].hoanThanh = !_dsCongViec[index].hoanThanh;
    });
  }

  void _xoaCongViec(int index) {
    setState(() => _dsCongViec.removeAt(index));
  }

  // Bài tập 2: Xóa tất cả công việc đã hoàn thành
  void _xoaTatCaDaHoanThanh() {
    setState(() {
      _dsCongViec.removeWhere((cv) => cv.hoanThanh);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Bài tập 1: Tính số công việc chưa hoàn thành (X) và tổng số việc (Y)
    final int chuaHoanThanh = _dsCongViec.where((cv) => !cv.hoanThanh).length;
    final int tongCongViec = _dsCongViec.length;

    return Scaffold(
      appBar: AppBar(title: const Text('Danh sach cong viec')),
      body: Column(
        children: [
          // Ô nhập công việc mới
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onSubmitted: (_) => _themCongViec(),
                    decoration: const InputDecoration(
                      hintText: 'Nhap cong viec moi...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _themCongViec,
                  child: const Text('Them'),
                ),
              ],
            ),
          ),

          // Bài tập 1 & Bài tập 2: Thanh thống kê và nút xóa các việc đã hoàn thành
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Con lai: $chuaHoanThanh / $tongCongViec cong viec',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                TextButton.icon(
                  onPressed: _xoaTatCaDaHoanThanh,
                  icon: const Icon(Icons.delete_sweep, color: Colors.red),
                  label: const Text(
                    'Xoa da hoan thanh',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Danh sách công việc
          Expanded(
            child: ListView.builder(
              itemCount: _dsCongViec.length,
              itemBuilder: (context, index) {
                final cv = _dsCongViec[index];

                // Bài tập 3: Bọc bằng Dismissible để vuốt trái/phải xóa công việc
                return Dismissible(
                  key: ObjectKey(cv),
                  direction: DismissDirection.horizontal,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  secondaryBackground: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    _xoaCongViec(index);
                  },
                  child: ListTile(
                    leading: Checkbox(
                      value: cv.hoanThanh,
                      onChanged: (_) => _toggleHoanThanh(index),
                    ),
                    // Bước 3: Style gạch ngang và đổi màu xám khi hoàn thành
                    title: Text(
                      cv.tieuDe,
                      style: TextStyle(
                        decoration: cv.hoanThanh
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        color: cv.hoanThanh ? Colors.grey : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
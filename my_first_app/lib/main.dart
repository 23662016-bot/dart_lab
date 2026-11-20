import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ho So Ca Nhan',
      // Bài tập 3: Thử đổi Colors.indigo sang Colors.teal hoặc Colors.orange rồi bấm 'r' ở Terminal
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const TrangHoSo(),
    );
  }
}

class TrangHoSo extends StatelessWidget {
  const TrangHoSo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ho So Sinh Vien')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // BÀI TẬP 2: Đổi CircleAvatar thành hiển thị ảnh mạng bằng NetworkImage
            const CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                'https://avatars.githubusercontent.com/u/14101776?s=200&v=4',
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Nguyen Van A',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text('Lop: CNTT-K20'),
            const SizedBox(height: 16),

            // BÀI TẬP 1: Thêm Row chứa Icon email, phone và Text hiển thị thông tin
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.email, color: Colors.indigo, size: 20),
                SizedBox(width: 6),
                Text('nguyenvana@gmail.com'),
                SizedBox(width: 16),
                Icon(Icons.phone, color: Colors.green, size: 20),
                SizedBox(width: 6),
                Text('0901234567'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
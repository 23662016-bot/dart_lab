import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CongViec {
  String tieuDe;
  bool hoanThanh;
  CongViec(this.tieuDe, {this.hoanThanh = false});
}

class TodoModel extends ChangeNotifier {
  final List<CongViec> _ds = [
    CongViec('Hoc Dart co ban'),
    CongViec('Hoc Flutter widget'),
  ];

  List<CongViec> get danhSach => List.unmodifiable(_ds);

  void them(String tieuDe) {
    if (tieuDe.trim().isEmpty) return;
    _ds.add(CongViec(tieuDe.trim()));
    notifyListeners();
  }

  void toggle(int index) {
    _ds[index].hoanThanh = !_ds[index].hoanThanh;
    notifyListeners();
  }

  void xoa(int index) {
    _ds.removeAt(index);
    notifyListeners();
  }

  void suaTieuDe(int index, String tieuDeMoi) {
    if (tieuDeMoi.trim().isEmpty) return;
    _ds[index].tieuDe = tieuDeMoi.trim();
    notifyListeners();
  }

  int get soConLai => _ds.where((cv) => !cv.hoanThanh).length;
}

class ThemeModel extends ChangeNotifier {
  bool _isDark = false;
  bool get isDark => _isDark;

  void toggleTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }
}

class TrangDanhSach extends StatelessWidget {
  const TrangDanhSach({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<TodoModel>();
    final themeModel = context.watch<ThemeModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Con lai: ${model.soConLai} viec'),
        actions: [
          IconButton(
            tooltip: 'Doi giao dien Sang/Toi',
            icon: Icon(
              themeModel.isDark ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () => context.read<ThemeModel>().toggleTheme(),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: model.danhSach.length,
        itemBuilder: (context, index) {
          final cv = model.danhSach[index];
          return ListTile(
            leading: Checkbox(
              value: cv.hoanThanh,
              onChanged: (_) => context.read<TodoModel>().toggle(index),
            ),
            title: Text(
              cv.tieuDe,
              style: TextStyle(
                decoration: cv.hoanThanh
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => context.read<TodoModel>().xoa(index),
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => TrangChiTiet(index: index),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _hienHopThoaiThem(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _hienHopThoaiThem(BuildContext context) {
    final ctl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Cong viec moi'),
        content: TextField(controller: ctl, autofocus: true),
        actions: [
          TextButton(
            onPressed: () {
              context.read<TodoModel>().them(ctl.text);
              Navigator.pop(context);
            },
            child: const Text('Them'),
          ),
        ],
      ),
    );
  }
}

class TrangChiTiet extends StatelessWidget {
  final int index;
  const TrangChiTiet({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final ds = context.watch<TodoModel>().danhSach;
    if (index >= ds.length) {
      return const Scaffold(body: Center(child: Text('Cong viec khong ton tai')));
    }
    final cv = ds[index];

    return Scaffold(
      appBar: AppBar(title: const Text('Chi tiet cong viec')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tieu de: ${cv.tieuDe}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Trang thai: ${cv.hoanThanh ? "Da xong" : "Chua xong"}'),
            const SizedBox(height: 24),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () => _hienHopThoaiSua(context, cv.tieuDe),
                  icon: const Icon(Icons.edit),
                  label: const Text('Sua'),
                ),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Quay lai'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _hienHopThoaiSua(BuildContext context, String tenHienTai) {
    final ctl = TextEditingController(text: tenHienTai);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Sua ten cong viec'),
        content: TextField(controller: ctl, autofocus: true),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Huy'),
          ),
          TextButton(
            onPressed: () {
              context.read<TodoModel>().suaTieuDe(index, ctl.text);
              Navigator.pop(context);
            },
            child: const Text('Luu'),
          ),
        ],
      ),
    );
  }
}
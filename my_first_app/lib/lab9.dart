import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// =========================================================================
// BƯỚC 1: LỚP MODEL ÁNH XẠ DỮ LIỆU JSON (BaiViet & NguoiDung)
// =========================================================================
class BaiViet {
  final int id;
  final String tieuDe;
  final String noiDung;

  BaiViet({required this.id, required this.tieuDe, required this.noiDung});

  factory BaiViet.fromJson(Map<String, dynamic> json) {
    return BaiViet(
      id: json['id'] as int,
      tieuDe: json['title'] as String,
      noiDung: json['body'] as String,
    );
  }
}

// Bài tập 4: Model NguoiDung ánh xạ JSON từ /users
class NguoiDung {
  final int id;
  final String ten;
  final String email;
  final String dienThoai;

  NguoiDung({
    required this.id,
    required this.ten,
    required this.email,
    required this.dienThoai,
  });

  factory NguoiDung.fromJson(Map<String, dynamic> json) {
    return NguoiDung(
      id: json['id'] as int,
      ten: json['name'] as String,
      email: json['email'] as String,
      dienThoai: json['phone'] as String,
    );
  }
}

// =========================================================================
// BƯỚC 2 & BÀI TẬP 3, 4: HÀM GỌI API CÓ TIMEOUT & BẮT LỖI
// =========================================================================
Future<List<BaiViet>> taiDanhSachBaiViet() async {
  try {
    final response = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/posts?_limit=15'))
        .timeout(const Duration(seconds: 5)); // Bài tập 3: Timeout 5 giây

    if (response.statusCode != 200) {
      throw Exception('Loi tai du lieu: ma HTTP ${response.statusCode}');
    }

    final List<dynamic> duLieuJson = jsonDecode(response.body);
    return duLieuJson.map((item) => BaiViet.fromJson(item)).toList();
  } on TimeoutException {
    throw Exception('Qua thoi gian cho (5 giay). Vui long kiem tra mang!');
  } catch (e) {
    throw Exception('Khong the ket noi may chu: $e');
  }
}

Future<List<NguoiDung>> taiDanhSachNguoiDung() async {
  try {
    final response = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/users'))
        .timeout(const Duration(seconds: 5));

    if (response.statusCode != 200) {
      throw Exception('Loi tai du lieu: ma HTTP ${response.statusCode}');
    }

    final List<dynamic> duLieuJson = jsonDecode(response.body);
    return duLieuJson.map((item) => NguoiDung.fromJson(item)).toList();
  } on TimeoutException {
    throw Exception('Qua thoi gian cho (5 giay). Vui long kiem tra mang!');
  } catch (e) {
    throw Exception('Khong the ket noi may chu: $e');
  }
}

// =========================================================================
// BƯỚC 3 & BÀI TẬP 1, 2, 4: GIAO DIỆN HIỂN THỊ DỮ LIỆU VỚI FutureBuilder
// =========================================================================
class TrangLab9 extends StatefulWidget {
  const TrangLab9({super.key});

  @override
  State<TrangLab9> createState() => _TrangLab9State();
}

class _TrangLab9State extends State<TrangLab9> {
  late Future<List<BaiViet>> _futureBaiViet;
  late Future<List<NguoiDung>> _futureNguoiDung;
  int _tabHienTai = 0; // 0: Bai viet, 1: Nguoi dung

  @override
  void initState() {
    super.initState();
    _futureBaiViet = taiDanhSachBaiViet();
    _futureNguoiDung = taiDanhSachNguoiDung();
  }

  // Bài tập 1: Hàm làm mới dữ liệu khi bấm nút Tải lại
  void _taiLaiDuLieu() {
    setState(() {
      if (_tabHienTai == 0) {
        _futureBaiViet = taiDanhSachBaiViet();
      } else {
        _futureNguoiDung = taiDanhSachNguoiDung();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_tabHienTai == 0 ? 'Danh sach bai viet' : 'Danh sach nguoi dung'),
        actions: [
          // Bài tập 1: Nút Tải lại trên AppBar
          IconButton(
            tooltip: 'Tai lai',
            icon: const Icon(Icons.refresh),
            onPressed: _taiLaiDuLieu,
          ),
        ],
      ),
      body: _tabHienTai == 0 ? _xayDungTabBaiViet() : _xayDungTabNguoiDung(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tabHienTai,
        onTap: (index) => setState(() => _tabHienTai = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'Bai viet (Posts)',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Nguoi dung (Users)',
          ),
        ],
      ),
    );
  }

  Widget _xayDungTabBaiViet() {
    return FutureBuilder<List<BaiViet>>(
      future: _futureBaiViet,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Da co loi: ${snapshot.error}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: _taiLaiDuLieu,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Thu lai'),
                  ),
                ],
              ),
            ),
          );
        }

        final ds = snapshot.data!;
        return ListView.builder(
          itemCount: ds.length,
          itemBuilder: (context, index) {
            final bv = ds[index];
            return ListTile(
              leading: CircleAvatar(child: Text('${bv.id}')),
              title: Text(bv.tieuDe, maxLines: 1, overflow: TextOverflow.ellipsis),
              subtitle: Text(
                bv.noiDung,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              // Bài tập 2: Bấm vào mở màn hình chi tiết bài viết
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TrangChiTietBaiViet(baiViet: bv),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _xayDungTabNguoiDung() {
    return FutureBuilder<List<NguoiDung>>(
      future: _futureNguoiDung,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Da co loi: ${snapshot.error}', style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 12),
                ElevatedButton(onPressed: _taiLaiDuLieu, child: const Text('Thu lai')),
              ],
            ),
          );
        }

        final ds = snapshot.data!;
        return ListView.builder(
          itemCount: ds.length,
          itemBuilder: (context, index) {
            final nd = ds[index];
            return ListTile(
              leading: CircleAvatar(child: Text('${nd.id}')),
              title: Text(nd.ten),
              subtitle: Text('${nd.email} • ${nd.dienThoai}'),
            );
          },
        );
      },
    );
  }
}

// =========================================================================
// BÀI TẬP 2: MÀN HÌNH CHI TIẾT BÀI VIẾT
// =========================================================================
class TrangChiTietBaiViet extends StatelessWidget {
  final BaiViet baiViet;
  const TrangChiTietBaiViet({super.key, required this.baiViet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bai viet #${baiViet.id}')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              baiViet.tieuDe,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 24),
            Text(
              baiViet.noiDung,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
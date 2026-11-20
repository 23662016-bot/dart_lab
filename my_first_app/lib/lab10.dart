import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// =========================================================================
// BƯỚC 1: MÔ HÌNH DỮ LIỆU (GiaoDich & LoaiGiaoDich)
// =========================================================================
enum LoaiGiaoDich { thu, chi }

class GiaoDich {
  final String moTa;
  final double soTien;
  final LoaiGiaoDich loai;
  final DateTime ngay;

  GiaoDich({
    required this.moTa,
    required this.soTien,
    required this.loai,
    DateTime? ngay,
  }) : ngay = ngay ?? DateTime.now();

  // Bài tập mở rộng 2: Chuyển đổi sang JSON để lưu vào SharedPreferences
  Map<String, dynamic> toJson() => {
        'moTa': moTa,
        'soTien': soTien,
        'loai': loai == LoaiGiaoDich.thu ? 'thu' : 'chi',
        'ngay': ngay.toIso8601String(),
      };

  factory GiaoDich.fromJson(Map<String, dynamic> json) => GiaoDich(
        moTa: json['moTa'] as String,
        soTien: (json['soTien'] as num).toDouble(),
        loai: json['loai'] == 'thu' ? LoaiGiaoDich.thu : LoaiGiaoDich.chi,
        ngay: DateTime.parse(json['ngay'] as String),
      );
}

// =========================================================================
// BƯỚC 2: QUẢN LÝ TRẠNG THÁI (ChiTieuModel) + LƯU TRỮ LOCAL
// =========================================================================
class ChiTieuModel extends ChangeNotifier {
  final List<GiaoDich> _ds = [];

  ChiTieuModel() {
    _taiDuLieuTuMay();
  }

  List<GiaoDich> get danhSach => List.unmodifiable(_ds.reversed);

  double get tongThu => _ds
      .where((g) => g.loai == LoaiGiaoDich.thu)
      .fold(0.0, (tong, g) => tong + g.soTien);

  double get tongChi => _ds
      .where((g) => g.loai == LoaiGiaoDich.chi)
      .fold(0.0, (tong, g) => tong + g.soTien);

  double get soDu => tongThu - tongChi;

  void them(GiaoDich gd) {
    _ds.add(gd);
    _luuDuLieuVaoMay();
    notifyListeners();
  }

  void xoa(GiaoDich gd) {
    _ds.remove(gd);
    _luuDuLieuVaoMay();
    notifyListeners();
  }

  // Lưu danh sách dưới dạng chuỗi JSON vào SharedPreferences
  Future<void> _luuDuLieuVaoMay() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(_ds.map((e) => e.toJson()).toList());
    await prefs.setString('ds_giao_dich_lab10', jsonString);
  }

  Future<void> _taiDuLieuTuMay() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('ds_giao_dich_lab10');
    if (jsonString != null) {
      final List<dynamic> decoded = jsonDecode(jsonString);
      _ds.clear();
      _ds.addAll(decoded.map((item) => GiaoDich.fromJson(item)));
      notifyListeners();
    }
  }
}

// Hàm định dạng số tiền VNĐ dễ đọc (ví dụ: 150000 -> 150,000 đ)
String dinhDangTien(double tien) {
  final str = tien.toStringAsFixed(0);
  final reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  return '${str.replaceAllMapped(reg, (m) => '${m[1]},')} đ';
}

// =========================================================================
// BƯỚC 3 & BÀI TẬP MỞ RỘNG 1: MÀN HÌNH DANH SÁCH + SỐ DƯ + BỘ LỌC
// =========================================================================
class TrangDanhSach extends StatefulWidget {
  const TrangDanhSach({super.key});

  @override
  State<TrangDanhSach> createState() => _TrangDanhSachState();
}

class _TrangDanhSachState extends State<TrangDanhSach> {
  String _boLoc = 'tat_ca'; // 'tat_ca', 'thu', 'chi'

  @override
  Widget build(BuildContext context) {
    final model = context.watch<ChiTieuModel>();

    // Lọc danh sách theo ChoiceChip
    final dsHienThi = model.danhSach.where((gd) {
      if (_boLoc == 'thu') return gd.loai == LoaiGiaoDich.thu;
      if (_boLoc == 'chi') return gd.loai == LoaiGiaoDich.chi;
      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('So du: ${dinhDangTien(model.soDu)}'),
        actions: [
          IconButton(
            tooltip: 'Xem thong ke',
            icon: const Icon(Icons.pie_chart),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TrangThongKe()),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Bài tập mở rộng 1: Bộ lọc Thu / Chi / Tất cả bằng ChoiceChip
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChoiceChip(
                  label: const Text('Tat ca'),
                  selected: _boLoc == 'tat_ca',
                  onSelected: (_) => setState(() => _boLoc = 'tat_ca'),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Khoan Thu'),
                  selected: _boLoc == 'thu',
                  onSelected: (_) => setState(() => _boLoc = 'thu'),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Khoan Chi'),
                  selected: _boLoc == 'chi',
                  onSelected: (_) => setState(() => _boLoc = 'chi'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: dsHienThi.isEmpty
                ? const Center(child: Text('Chua co giao dich nao.'))
                : ListView.builder(
                    itemCount: dsHienThi.length,
                    itemBuilder: (context, index) {
                      final gd = dsHienThi[index];
                      final laThu = gd.loai == LoaiGiaoDich.thu;
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: laThu ? Colors.green.shade100 : Colors.red.shade100,
                          child: Icon(
                            laThu ? Icons.arrow_downward : Icons.arrow_upward,
                            color: laThu ? Colors.green : Colors.red,
                          ),
                        ),
                        title: Text(gd.moTa, style: const TextStyle(fontWeight: FontWeight.w500)),
                        subtitle: Text(
                          '${gd.ngay.day}/${gd.ngay.month}/${gd.ngay.year}',
                          style: const TextStyle(fontSize: 12),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${laThu ? "+" : "-"}${dinhDangTien(gd.soTien)}',
                              style: TextStyle(
                                color: laThu ? Colors.green : Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.grey),
                              onPressed: () => context.read<ChiTieuModel>().xoa(gd),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const TrangThemGiaoDich()),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Them moi'),
      ),
    );
  }
}

// =========================================================================
// BƯỚC 4: MÀN HÌNH THÊM GIAO DỊCH (FORM + VALIDATION)
// =========================================================================
class TrangThemGiaoDich extends StatefulWidget {
  const TrangThemGiaoDich({super.key});

  @override
  State<TrangThemGiaoDich> createState() => _TrangThemGiaoDichState();
}

class _TrangThemGiaoDichState extends State<TrangThemGiaoDich> {
  final _ctlMoTa = TextEditingController();
  final _ctlSoTien = TextEditingController();
  LoaiGiaoDich _loaiChon = LoaiGiaoDich.chi;
  String? _loi;

  void _luuGiaoDich() {
    final moTa = _ctlMoTa.text.trim();
    final soTien = double.tryParse(_ctlSoTien.text.trim());

    if (moTa.isEmpty) {
      setState(() => _loi = 'Vui long nhap mo ta giao dich!');
      return;
    }
    if (soTien == null || soTien <= 0) {
      setState(() => _loi = 'So tien phai la mot so duong hop le!');
      return;
    }

    context.read<ChiTieuModel>().them(
          GiaoDich(moTa: moTa, soTien: soTien, loai: _loaiChon),
        );
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _ctlMoTa.dispose();
    _ctlSoTien.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Them Giao Dich Moi')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChoiceChip(
                  label: const Text('Khoan Chi (-)'),
                  selected: _loaiChon == LoaiGiaoDich.chi,
                  selectedColor: Colors.red.shade100,
                  onSelected: (_) => setState(() => _loaiChon = LoaiGiaoDich.chi),
                ),
                const SizedBox(width: 16),
                ChoiceChip(
                  label: const Text('Khoan Thu (+)'),
                  selected: _loaiChon == LoaiGiaoDich.thu,
                  selectedColor: Colors.green.shade100,
                  onSelected: (_) => setState(() => _loaiChon = LoaiGiaoDich.thu),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _ctlMoTa,
              decoration: const InputDecoration(
                labelText: 'Mo ta (vi du: An trua, Luong thang)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _ctlSoTien,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'So tien (VND)',
                border: OutlineInputBorder(),
              ),
            ),
            if (_loi != null) ...[
              const SizedBox(height: 12),
              Text(_loi!, style: const TextStyle(color: Colors.red)),
            ],
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _luuGiaoDich,
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
              child: const Text('Luu Giao Dich', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}

// =========================================================================
// BƯỚC 5 & BÀI TẬP MỞ RỘNG 3: MÀN HÌNH THỐNG KÊ + API TỈ GIÁ VND <-> USD
// =========================================================================
class TrangThongKe extends StatefulWidget {
  const TrangThongKe({super.key});

  @override
  State<TrangThongKe> createState() => _TrangThongKeState();
}

class _TrangThongKeState extends State<TrangThongKe> {
  late Future<double> _futureTiGiaUSD;

  @override
  void initState() {
    super.initState();
    _futureTiGiaUSD = _layTiGiaVndSangUsd();
  }

  // Gọi API tỉ giá công khai miễn phí để lấy tỉ giá 1 VND = ? USD
  Future<double> _layTiGiaVndSangUsd() async {
    final response = await http
        .get(Uri.parse('https://open.er-api.com/v6/latest/VND'))
        .timeout(const Duration(seconds: 5));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['rates']['USD'] as num).toDouble();
    }
    throw Exception('Khong lay duoc ti gia');
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<ChiTieuModel>();
    final tongCong = model.tongThu + model.tongChi;
    final tyLeThu = tongCong == 0 ? 0.0 : model.tongThu / tongCong;
    final tyLeChi = tongCong == 0 ? 0.0 : model.tongChi / tongCong;

    return Scaffold(
      appBar: AppBar(title: const Text('Thong Ke Thu Chi')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text('SO DU HIEN TAI', style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 4),
                    Text(
                      dinhDangTien(model.soDu),
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: model.soDu >= 0 ? Colors.indigo : Colors.red,
                      ),
                    ),
                    const Divider(height: 24),
                    // Bài tập mở rộng 3: Hiển thị số dư quy đổi sang USD qua API
                    FutureBuilder<double>(
                      future: _futureTiGiaUSD,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Text('Dang tai ti gia USD...');
                        }
                        if (snapshot.hasError) {
                          return const Text('Khong tai duoc ti gia USD', style: TextStyle(fontSize: 12, color: Colors.grey));
                        }
                        final soDuUsd = model.soDu * snapshot.data!;
                        return Text(
                          'Quy doi: ~ \$${soDuUsd.toStringAsFixed(2)} USD',
                          style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.teal),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text('Tong Thu: ${dinhDangTien(model.tongThu)} (${(tyLeThu * 100).toStringAsFixed(1)}%)',
                style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: tyLeThu,
              minHeight: 12,
              color: Colors.green,
              backgroundColor: Colors.green.shade100,
            ),
            const SizedBox(height: 24),
            Text('Tong Chi: ${dinhDangTien(model.tongChi)} (${(tyLeChi * 100).toStringAsFixed(1)}%)',
                style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: tyLeChi,
              minHeight: 12,
              color: Colors.red,
              backgroundColor: Colors.red.shade100,
            ),
          ],
        ),
      ),
    );
  }
}
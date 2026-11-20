import 'dart:async';

// =========================================================================
// PHẦN 1: CÁC HÀM MẪU TRONG BƯỚC 1 - BƯỚC 4
// =========================================================================

// Bước 1 & 2: Hàm giả lập tải dữ liệu người dùng (trễ 2 giây)
Future<String> taiDuLieuNguoiDung(int id) async {
  print('Dang tai du lieu nguoi dung $id...');
  await Future.delayed(Duration(seconds: 2)); // giả lập độ trễ mạng[cite: 3]
  return 'Nguoi dung #$id: Nguyen Van A';
}

// Bước 3: Hàm giả lập tải dữ liệu có khả năng ném lỗi[cite: 5]
Future<String> taiDuLieuCoTheLoi(int id) async {
  await Future.delayed(Duration(seconds: 1));
  if (id <= 0) {
    throw Exception('ID khong hop le: $id');
  }
  return 'Du lieu cho ID $id';
}

// Bước 4: Stream đếm ngược[cite: 5]
Stream<int> demNguoc(int tu) async* {
  for (var i = tu; i >= 0; i--) {
    await Future.delayed(Duration(seconds: 1));
    yield i;
  }
}

// =========================================================================
// PHẦN 2: BÀI TẬP CUỐI LAB
// =========================================================================

// Bài 1: Hàm mô phỏng đăng nhập
Future<bool> moPhongDangNhap(String user, String pass) async {
  print('Dang kiem tra dang nhap cho $user...');
  await Future.delayed(Duration(seconds: 1)); // giả lập trễ 1 giây
  if (pass == '123456') {
    return true;
  } else {
    throw Exception('Sai mat khau cho tai khoan $user!');
  }
}

// Hàm phụ trợ kiểm tra số nguyên tố cho Bài 3
bool laSoNguyenTo(int n) {
  if (n < 2) return false;
  for (int i = 2; i * i <= n; i++) {
    if (n % i == 0) return false;
  }
  return true;
}

// Bài 3: Stream phát ra các số nguyên tố lần lượt (mỗi 500ms) tới giới hạn
Stream<int> streamSoNguyenTo(int gioiHan) async* {
  for (int i = 2; i <= gioiHan; i++) {
    if (laSoNguyenTo(i)) {
      await Future.delayed(Duration(milliseconds: 500));
      yield i;
    }
  }
}

// =========================================================================
// HÀM MAIN CHẠY KIỂM THỬ TOÀN BỘ LAB 5
// =========================================================================
void main() async {
  // --- CHẠY THỬ BƯỚC 1: Future cơ bản[cite: 3] ---
  print('=== BUOC 1: FUTURE CO BAN ===');
  print('Bat dau chuong trinh');
  final ketQuaB1 = await taiDuLieuNguoiDung(7);
  print(ketQuaB1);
  print('Ket thuc chuong trinh\n');

  // --- CHẠY THỬ BƯỚC 2: Gọi nhiều Future song song với Future.wait[cite: 3] ---
  print('=== BUOC 2: FUTURE.WAIT ===');
  final batDauB2 = DateTime.now();
  final ketQuaB2 = await Future.wait([
    taiDuLieuNguoiDung(1),
    taiDuLieuNguoiDung(2),
    taiDuLieuNguoiDung(3),
  ]);
  print(ketQuaB2);
  print('Tong thoi gian: ${DateTime.now().difference(batDauB2).inSeconds} giay\n');

  // --- CHẠY THỬ BƯỚC 3: Xử lý lỗi với try/catch[cite: 4, 5] ---
  print('=== BUOC 3: TRY / CATCH ===');
  try {
    final r = await taiDuLieuCoTheLoi(-1);
    print(r);
  } catch (e) {
    print('Da bat duoc loi: $e\n');
  }

  // --- CHẠY THỬ BƯỚC 4: Stream đếm ngược[cite: 5] ---
  print('=== BUOC 4: STREAM DEM NGUOC ===');
  await for (final giaTri in demNguoc(3)) {
    print('Con lai: $giaTri');
  }
  print('Het gio!\n');

  // =======================================================================
  // CHẠY BÀI TẬP CUỐI LAB[cite: 7]
  // =======================================================================

  // --- BÀI TẬP 1: Mô phỏng đăng nhập[cite: 7] ---
  print('=== BAI TAP 1: MO PHONG DANG NHAP ===');
  try {
    // Trường hợp đúng mật khẩu
    bool kq1 = await moPhongDangNhap('admin', '123456');
    print('Dang nhap thanh cong: $kq1');

    // Trường hợp sai mật khẩu (sẽ nhảy xuống catch)
    bool kq2 = await moPhongDangNhap('admin', '000000');
    print('Dang nhap thanh cong: $kq2');
  } catch (e) {
    print('Loi dang nhap: $e');
  }
  print('');

  // --- BÀI TẬP 2: So sánh Future.wait (song song) và vòng lặp for (tuần tự)[cite: 7] ---
  print('=== BAI TAP 2: SO SANH SONG SONG VS TUAN TU ===');
  
  // Cách 1: Tải đồng thời 5 người dùng bằng Future.wait (~2 giây)
  final startSongSong = DateTime.now();
  final dsSongSong = await Future.wait([
    for (int id = 1; id <= 5; id++) taiDuLieuNguoiDung(id),
  ]);
  print('Ket qua song song: ${dsSongSong.length} nguoi dung');
  print('-> Thoi gian chay SONG SONG: ${DateTime.now().difference(startSongSong).inSeconds} giay\n');

  // Cách 2: Tải tuần tự bằng vòng lặp for kèm await (~10 giây)
  final startTuanTu = DateTime.now();
  final dsTuanTu = <String>[];
  for (int id = 1; id <= 5; id++) {
    final user = await taiDuLieuNguoiDung(id);
    dsTuanTu.add(user);
  }
  print('Ket qua tuan tu: ${dsTuanTu.length} nguoi dung');
  print('-> Thoi gian chay TUAN TU: ${DateTime.now().difference(startTuanTu).inSeconds} giay\n');

  // --- BÀI TẬP 3: Stream số nguyên tố[cite: 7] ---
  print('=== BAI TAP 3: STREAM SO NGUYEN TO (<= 15) ===');
  await for (final snt in streamSoNguyenTo(15)) {
    print('So nguyen to nhan duoc: $snt');
  }
  print('Hoan thanh Stream so nguyen to!');
}
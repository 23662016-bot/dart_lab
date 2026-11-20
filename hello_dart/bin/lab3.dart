
// =========================================================================
// PHẦN 1: CÁC HÀM & LỚP NGOẠI LỆ CỦA BƯỚC 1 - BƯỚC 4
// =========================================================================

// BƯỚC 1: Hàm và tham số

String gioiThieu(String ten, [String? biDanh]) {
  if (biDanh == null) {
    return 'Toi la $ten';
  }
  return 'Toi la $ten, biet danh $biDanh';
}

double tinhDiemTB({
  required double giuaKy,
  required double cuoiKy,
  double heSoCK = 0.6,
}) {
  return giuaKy * (1 - heSoCK) + cuoiKy * heSoCK;
}

// BƯỚC 2: Đếm tần suất ký tự

void demTanSuatChu(String cauVan) {
  final Map<String, int> tanSuat = {};

  for (final ky in cauVan.toLowerCase().split('')) {
    if (ky == ' ') continue;

    tanSuat[ky] = (tanSuat[ky] ?? 0) + 1;
  }

  tanSuat.forEach((k, v) {
    print("'$k' xuat hien $v lan");
  });
}

// BƯỚC 3: Xử lý ngoại lệ

class DiemKhongHopLeException implements Exception {
  final String message;

  DiemKhongHopLeException(this.message);
}

String xepLoaiAnToan(double diem) {
  try {
    if (diem < 0 || diem > 10) {
      throw DiemKhongHopLeException(
        'Diem $diem nam ngoai [0, 10]',
      );
    }

    return diem >= 5 ? 'Dat' : 'Khong dat';
  } on DiemKhongHopLeException catch (e) {
    return 'Loi: ${e.message}';
  } finally {
    print('Da kiem tra xong diem $diem');
  }
}

// =========================================================================
// PHẦN 2: CÁC HÀM & LỚP NGOẠI LỆ CỦA BÀI TẬP CUỐI LAB 3
// =========================================================================

// Câu 1, 2: Xếp loại sinh viên

String xepLoai(double diem) {
  if (diem >= 9.0) return 'Xuat sac';
  if (diem >= 8.0) return 'Gioi';
  if (diem >= 6.5) return 'Kha';
  if (diem >= 5.0) return 'Trung binh';

  return 'Yeu';
}

// Câu 1: Tính tổng danh sách

num tinhTongList(List<num> ds) {
  num tong = 0;

  for (final so in ds) {
    tong += so;
  }

  return tong;
}

// Câu 3: Ngoại lệ danh sách rỗng

class DanhSachRongException implements Exception {
  final String message;

  DanhSachRongException([
    this.message = 'Danh sach sinh vien dang rong!',
  ]);

  @override
  String toString() {
    return 'DanhSachRongException: $message';
  }
}

// Câu 3: Tìm điểm cao nhất

double timDiemCaoNhat(List<Map<String, dynamic>> ds) {
  if (ds.isEmpty) {
    throw DanhSachRongException(
      'Khong the tim diem cao nhat vi danh sach rong.',
    );
  }

  return ds
      .map((sv) => sv['diem'] as double)
      .reduce((a, b) => a > b ? a : b);
}

// Câu 4: Sắp xếp điểm giảm dần

void sapXepGiamDan(List<Map<String, dynamic>> ds) {
  ds.sort(
    (a, b) => (b['diem'] as double)
        .compareTo(a['diem'] as double),
  );
}

// =========================================================================
// HÀM CHẠY BÀI TẬP CUỐI LAB 3
// =========================================================================

void baiTapCuoiLab3() {
  print('\n================ BAI TAP CUOI LAB 3 ================');

  // CÂU 1: So sánh vòng lặp for và .fold()

  print('\n--- CAU 1: Tinh tong List ---');

  final List<num> numbers = [10, 20.5, 5, 14.5];

  final tongFor = tinhTongList(numbers);
  final tongFold = numbers.fold<num>(0, (a, b) => a + b);

  print('Dung vong lap for: $tongFor');
  print('Dung .fold()     : $tongFold');
  print('Ket qua bang nhau: ${tongFor == tongFold}');

  // CÂU 2: Lấy các mức xếp loại không trùng lặp bằng Set

  print('\n--- CAU 2: Cac muc xep loai (Set) ---');

  final List<Map<String, dynamic>> sinhVien = [
    {'ten': 'An', 'diem': 8.5},
    {'ten': 'Binh', 'diem': 6.0},
    {'ten': 'Chi', 'diem': 9.2},
    {'ten': 'Dung', 'diem': 8.8},
  ];

  final Set<String> cacXepLoai = {};

  for (final sv in sinhVien) {
    cacXepLoai.add(
      xepLoai(sv['diem'] as double),
    );
  }

  print('Cac muc xep loai khong trung lap: $cacXepLoai');

  // CÂU 3: Bắt ngoại lệ DanhSachRongException

  print('\n--- CAU 3: Bat loi DanhSachRongException ---');

  try {
    final List<Map<String, dynamic>> dsRong = [];

    print('Diem cao nhat: ${timDiemCaoNhat(dsRong)}');
  } on DanhSachRongException catch (e) {
    print('Da bat duoc loi an toan -> ${e.message}');
  }

  // CÂU 4: Sắp xếp điểm giảm dần

  print('\n--- CAU 4: Sap xep diem giam dan ---');

  sapXepGiamDan(sinhVien);

  for (final sv in sinhVien) {
    print('${sv['ten']}: ${sv['diem']}');
  }
}

// =========================================================================
// PHẦN 3: HÀM MAIN CHÍNH CHẠY TOÀN BỘ LAB 3
// =========================================================================

void main() {

  // BƯỚC 1: Hàm và tham số

  print('--- BUOC 1: Ham & Tham so ---');

  print(gioiThieu('An'));
  print(gioiThieu('Binh', 'Beo'));

  print(
    'Diem TB (mac dinh heSoCK 0.6): '
    '${tinhDiemTB(giuaKy: 7.0, cuoiKy: 8.5)}',
  );

  print(
    'Diem TB (heSoCK 0.7): '
    '${tinhDiemTB(giuaKy: 7.0, cuoiKy: 8.5, heSoCK: 0.7)}',
  );

  // BƯỚC 2: Danh sách sinh viên

  print('\n--- BUOC 2: Danh sach sinh vien ---');

  final List<Map<String, dynamic>> sinhVien = [
    {'ten': 'An', 'diem': 8.5},
    {'ten': 'Binh', 'diem': 6.0},
    {'ten': 'Chi', 'diem': 9.2},
  ];

  for (final sv in sinhVien) {
    print('${sv['ten']}: ${sv['diem']}');
  }

  final diemCaoNhat = sinhVien
      .map((sv) => sv['diem'] as double)
      .reduce((a, b) => a > b ? a : b);

  print('Diem cao nhat: $diemCaoNhat');

  final svGioi = sinhVien.where(
    (sv) => (sv['diem'] as double) >= 8.0,
  );

  print('Danh sach sinh vien gioi (>= 8.0):');

  for (final sv in svGioi) {
    print('- ${sv['ten']} (${sv['diem']})');
  }

  // BƯỚC 3: Đếm tần suất ký tự

  print('\n--- BUOC 3: Dem tan suat ky tu ---');

  demTanSuatChu('lap trinh dart va flutter');

  // BƯỚC 4: Xử lý ngoại lệ

  print('\n--- BUOC 4: Xu ly ngoai le ---');

  print('Ket qua (7.5): ${xepLoaiAnToan(7.5)}');
  print('Ket qua (-2): ${xepLoaiAnToan(-2)}');
  print('Ket qua (15): ${xepLoaiAnToan(15)}');

  // BÀI TẬP CUỐI LAB 3

  baiTapCuoiLab3();
}

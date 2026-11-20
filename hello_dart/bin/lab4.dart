
// =========================================================================
// PHẦN 1: CÁC LỚP & MIXIN TỪ BƯỚC 1 ĐẾN BƯỚC 4
// =========================================================================

// BƯỚC 1: Lớp cơ bản và Constructor rút gọn

class TaiKhoan {
  final String chuTaiKhoan;
  double soDu;

  TaiKhoan(this.chuTaiKhoan, {this.soDu = 0});

  void napTien(double soTien) {
    soDu += soTien;
    print('$chuTaiKhoan nap $soTien, so du moi: $soDu');
  }

  bool rutTien(double soTien) {
    if (soTien > soDu) {
      print('$chuTaiKhoan rut that bai: khong du so du');
      return false;
    }

    soDu -= soTien;
    return true;
  }

  @override
  String toString() {
    return 'TaiKhoan($chuTaiKhoan, so du: $soDu)';
  }
}

// BƯỚC 2: Kế thừa và đa hình

class TaiKhoanTietKiem extends TaiKhoan {
  final double laiSuatNam;

  TaiKhoanTietKiem(
    super.chuTaiKhoan,
    this.laiSuatNam, {
    super.soDu,
  });

  void congLaiThang() {
    final tien = soDu * laiSuatNam / 12;
    napTien(tien);
  }

  @override
  bool rutTien(double soTien) {
    print(
      'Luu y: rut tu tai khoan tiet kiem co the mat lai suat.',
    );

    return super.rutTien(soTien);
  }

  @override
  String toString() {
    return 'TaiKhoanTietKiem($chuTaiKhoan, so du: $soDu, '
        'lai suat: ${(laiSuatNam * 100).toStringAsFixed(1)}%/nam)';
  }
}

// BƯỚC 3: Lớp trừu tượng và Interface

abstract class CoTheInSaoKe {
  String inSaoKe();
}

class TaiKhoanThanhToan extends TaiKhoan
    implements CoTheInSaoKe {
  TaiKhoanThanhToan(
    super.chuTaiKhoan, {
    super.soDu,
  });

  @override
  String inSaoKe() {
    return 'Sao ke: $chuTaiKhoan - So du hien tai: $soDu';
  }

  @override
  String toString() {
    return 'TaiKhoanThanhToan($chuTaiKhoan, so du: $soDu)';
  }
}

// BƯỚC 4: Mixin Ghi nhật ký

mixin GhiNhatKy {
  final List<String> nhatKy = [];

  void ghi(String noiDung) {
    nhatKy.add(noiDung);
    print('[LOG] $noiDung');
  }
}

// =========================================================================
// PHẦN 2: CÁC LỚP & MIXIN CHO BÀI TẬP CUỐI LAB 4
// =========================================================================

// BÀI TẬP 4: Mixin kiểm tra gian lận

mixin KiemTraGianLan {
  void canhBao(double soTien) {
    if (soTien > 50000000) {
      print(
        '[CANH BAO GIAN LAN] Giao dich rut so tien lon: '
        '$soTien VND (> 50 trieu)!',
      );
    }
  }
}

// Lớp TaiKhoanVIP sử dụng hai Mixin

class TaiKhoanVIP extends TaiKhoan
    with GhiNhatKy, KiemTraGianLan {
  TaiKhoanVIP(
    super.chuTaiKhoan, {
    super.soDu,
  });

  @override
  void napTien(double soTien) {
    super.napTien(soTien);
    ghi('Nap $soTien vao tai khoan VIP');
  }

  @override
  bool rutTien(double soTien) {
    canhBao(soTien);

    final ketQua = super.rutTien(soTien);

    if (ketQua) {
      ghi('Rut $soTien tu tai khoan VIP');
    } else {
      ghi('Rut that bai $soTien tu tai khoan VIP');
    }

    return ketQua;
  }

  @override
  String toString() {
    return 'TaiKhoanVIP($chuTaiKhoan, so du: $soDu)';
  }
}

// BÀI TẬP 1: Lớp TaiKhoanTraGop kế thừa TaiKhoan

class TaiKhoanTraGop extends TaiKhoan {
  double soNoConLai;

  TaiKhoanTraGop(
    super.chuTaiKhoan, {
    super.soDu,
    required this.soNoConLai,
  });

  @override
  bool rutTien(double soTien) {
    final thanhCong = super.rutTien(soTien);

    if (thanhCong && soNoConLai > 0) {
      final truNo = soTien >= soNoConLai
          ? soNoConLai
          : soTien;

      soNoConLai -= truNo;

      print(
        '-> Da tu dong tru $truNo vao du no tra gop. '
        'No con lai: $soNoConLai',
      );
    }

    return thanhCong;
  }

  @override
  String toString() {
    return 'TaiKhoanTraGop($chuTaiKhoan, so du: $soDu, '
        'no con lai: $soNoConLai)';
  }
}

// BÀI TẬP 2: Hàm in tổng kết đa hình

void inTongKet(List<TaiKhoan> danhSach) {
  print('\n--- BAO CAO TONG KET CAC TAI KHOAN ---');

  for (final tk in danhSach) {
    print(tk.toString());
  }
}

// =========================================================================
// PHẦN 3: HÀM MAIN KIỂM THỬ TOÀN BỘ LAB 4
// =========================================================================

void main() {

  // 1. BƯỚC 1: Lớp cơ bản và Constructor rút gọn

  print('=== BUOC 1: Lop co ban & Constructor rut gon ===');

  final tk1 = TaiKhoan(
    'Nguyen Van A',
    soDu: 1000000,
  );

  print(tk1);

  tk1.napTien(500000);
  tk1.rutTien(200000);
  tk1.rutTien(2000000);

  print(tk1);

  // 2. BƯỚC 2: Kế thừa và đa hình

  print('\n=== BUOC 2: Ke thua & Da hinh ===');

  final tkTietKiem = TaiKhoanTietKiem(
    'Tran Thi B',
    0.06,
    soDu: 12000000,
  );

  print(tkTietKiem);

  tkTietKiem.congLaiThang();
  tkTietKiem.rutTien(1000000);

  print(tkTietKiem);

  // 3. BƯỚC 3: Lớp trừu tượng và Interface

  print('\n=== BUOC 3: Lop truu tuong & Interface ===');

  final tkThanhToan = TaiKhoanThanhToan(
    'Le Van C',
    soDu: 3500000,
  );

  tkThanhToan.napTien(1500000);

  print(tkThanhToan.inSaoKe());

  // 4. BƯỚC 4: Mixin GhiNhatKy và KiemTraGianLan

  print('\n=== BUOC 4 & BAI TAP 4: Mixin ===');

  final tkVip = TaiKhoanVIP(
    'Pham Thi D',
    soDu: 100000000,
  );

  tkVip.napTien(20000000);

  tkVip.rutTien(10000000);

  tkVip.rutTien(60000000);

  print('Lich su nhat ky VIP: ${tkVip.nhatKy}');

  // 5. BÀI TẬP 1: TaiKhoanTraGop

  print('\n=== BAI TAP 1: TaiKhoanTraGop ===');

  final tkTraGop = TaiKhoanTraGop(
    'Hoang Van E',
    soDu: 5000000,
    soNoConLai: 3000000,
  );

  print(tkTraGop);

  tkTraGop.rutTien(2000000);
  tkTraGop.rutTien(1500000);

  print(tkTraGop);

  // 6. BÀI TẬP 2: Báo cáo đa hình

  print('\n=== BAI TAP 2: Bao cao da hinh ===');

  final danhSachTaiKhoan = <TaiKhoan>[
    tk1,
    tkTietKiem,
    tkThanhToan,
    tkVip,
    tkTraGop,
  ];

  inTongKet(danhSachTaiKhoan);
}

import 'dart:io';

// Câu 1: Kiểm tra năm nhuận
bool kiemTraNamNhuan(int nam) {
  return (nam % 4 == 0 && nam % 100 != 0) || (nam % 400 == 0);
}

// Câu 2: Phân loại ký tự bằng switch pattern kết hợp mệnh đề when
String phanLoaiKyTu(String kyTu) {
  if (kyTu.isEmpty) return 'Rong';
  final c = kyTu[0].toLowerCase();
  final code = c.codeUnitAt(0);

  return switch (c) {
    'a' || 'e' || 'i' || 'o' || 'u' => 'Nguyen am',
    _ when code >= 48 && code <= 57 => 'Chu so',
    _ when code >= 97 && code <= 122 => 'Phu am',
    _ => 'Ky tu dac biet',
  };
}

// Câu 4: In tam giác cân bằng dấu * với chiều cao h
void inTamGiacCan(int chieuCao) {
  for (int i = 1; i <= chieuCao; i++) {
    String khoangTrang = ' ' * (chieuCao - i);
    String dauSao = '*' * (2 * i - 1);
    print('$khoangTrang$dauSao');
  }
}

void main() {
  // --- Kiểm thử Câu 1 ---
  print('--- Cau 1: Kiem tra nam nhuan ---');
  print('Nam 2024: ${kiemTraNamNhuan(2024)}');
  print('Nam 1900: ${kiemTraNamNhuan(1900)}');
  print('Nam 2000: ${kiemTraNamNhuan(2000)}');

  // --- Kiểm thử Câu 2 ---
  print('\n--- Cau 2: Phan loai ky tu ---');
  print('Ky tu "A": ${phanLoaiKyTu('A')}');
  print('Ky tu "b": ${phanLoaiKyTu('b')}');
  print('Ky tu "7": ${phanLoaiKyTu('7')}');

  // --- Kiểm thử Câu 4 ---
  print('\n--- Cau 4: In tam giac can ---');
  stdout.write('Nhap chieu cao tam giac: ');
  String? input = stdin.readLineSync();
  int? h = int.tryParse(input ?? '');

  if (h != null && h > 0) {
    inTamGiacCan(h);
  } else {
    print('Vui long nhap mot so nguyen duong hop le!');
  }
}
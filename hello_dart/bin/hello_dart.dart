void main() {
  final ten = 'Minh tri';
  int tuoi = 20; // Câu 1: Khai báo sẵn biến tuổi dạng int

  print('Xin chao, $ten! Day la chuong trinh Dart dau tien.');
  print('Nam sau ban se ${tuoi + 1} tuoi'); // Câu 1: Tự tính tuổi + 1

  for (var i = 1; i <= 5; i++) {
    print('Dem: $i');
  }

  // Câu 2: Vòng lặp while in ra bảng cửu chương của số 5 (5x1 đến 5x10)
  int j = 1;
  while (j <= 10) {
    print('5 x $j = ${5 * j}');
    j++;
  }
}
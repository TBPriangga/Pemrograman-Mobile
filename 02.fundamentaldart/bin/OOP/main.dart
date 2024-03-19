import 'Meong.dart';

void main() {
  var kucing = Meong('Ketty', 2, 4.5, 'Hitam');
  kucing.makan();
  kucing.tidur();
  kucing.jalan();
  print(kucing.berat);
  print(kucing.warnaBulu);
}

import 'burung.dart';

void main() {
  var burung = Burung('Merpati', 1, 0.5, 'Putih');
  burung.makan();
  burung.tidur();
  burung.fly();
  print(burung.berat);
}

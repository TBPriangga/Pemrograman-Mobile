import 'flyable.dart';
import 'hewan.dart';

class Burung extends Animal implements Flyable {
  String warna;

  Burung(String nama, int umur, double berat, this.warna)
      : super(nama, umur, berat);

  @override
  void fly() {
    print('$nama sedang terbang');
  }
}

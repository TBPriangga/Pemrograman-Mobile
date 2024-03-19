import 'hewan.dart';

class Meong extends Animal {
  String warnaBulu;

  Meong(String nama, int umur, double berat, this.warnaBulu)
      : super(nama, umur, berat);

  void jalan() {
    print('${super.nama} berjalan');
  }
}

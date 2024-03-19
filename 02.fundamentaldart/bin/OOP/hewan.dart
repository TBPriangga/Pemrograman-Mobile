class Animal {
  String nama = '';
  int umur = 0;
  double berat = 0;

  Animal(this.nama, this.umur, this.berat);

  //setter
  set _nama(String value) {
    nama = value;
  }

  //Getter
  double get _berat => berat;

  void makan() {
    print('$nama sedang makan');
    berat = berat + 0.2;
  }

  void tidur() {
    print('$nama sedang tidur');
  }

  void poop() {
    print('$nama sedang buang air besar');
    berat = berat - 0.1;
  }
}

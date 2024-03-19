void main() {
  var contohClosure = penjumlahan(2);
  contohClosure();
  contohClosure();
}

Function penjumlahan(base) {
  var a = 1;
  return () => print("Nilainya adalah ${base + a++}");
} //Outputnya Nilainya adalah 3 Nilainya adalah 4
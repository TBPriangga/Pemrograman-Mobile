void main() {
  // Deklarasi Set dengan literal
  var angkaSet = {1, 3, 5};

  // Deklarasi Set dengan konstruktor Set.from()
  Set<int> bilanganSet = Set.from([1, 3, 5, 4, 2, 1]);

  // Mencetak isi Set
  print(bilanganSet);

  // Menambahkan elemen ke Set
  bilanganSet.add(6);

  // Menghapus elemen dari Set
  bilanganSet.remove(2);

  // Mengecek apakah elemen ada di Set
  print(bilanganSet.contains(5)); // true

  // Mengecek apakah Set kosong
  print(bilanganSet.isEmpty); // false

  // Menjumlahkan elemen Set
  var total = bilanganSet.fold(0, (sum, element) => sum + element);
  print(total); // 21

  // Menggabungkan dua Set
  var gabunganSet = angkaSet.union(bilanganSet);
  print(gabunganSet); // {1, 2, 3, 4, 5, 6}

  // Mengambil irisan dua Set
  var irisanSet = angkaSet.intersection(bilanganSet);
  print(irisanSet); // {1, 3, 5}

  // Mengurutkan elemen Set
  var listUrut = bilanganSet.toList()..sort();
  print(listUrut); // [1, 3, 4, 5, 6]
}

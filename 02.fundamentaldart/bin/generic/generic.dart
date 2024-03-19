void main() {
  // Mendefinisikan list dengan generic type int
  List<int> bilangan = [1, 2, 3, 4, 5];

// Mencetak isi list bilangan
  print(bilangan); // Output: [1, 2, 3, 4, 5]

// Mendefinisikan list dengan generic type String
  List<String> kata = ['Informatika', 'Flutter', 'Pemrograman'];

// Mencetak isi list kata
  print(kata); // Output: [Informatika, Flutter, Pemrograman]

// Mendefinisikan list dynamic yang dapat menampung berbagai jenis data
  List dynamicList = [1, 2, 3, 'empat'];

// Mencetak isi list dynamicList
  print(dynamicList); // Output: [1, 2, 3, empat]

// Menambahkan elemen baru ke list dynamicList
  dynamicList.add(true);

// Mencetak isi list dynamicList setelah menambahkan elemen baru
  print(dynamicList); // Output: [1, 2, 3, empat, true]

// Mengakses elemen list dengan generic type
  var firstNumber =
      bilangan[0]; // Mendapatkan elemen pertama dari list bilangan
  var firstWord = kata[0]; // Mendapatkan elemen pertama dari list kata

// Mencetak elemen yang diakses
  print(firstNumber); // Output: 1
  print(firstWord); // Output: Informatika
}

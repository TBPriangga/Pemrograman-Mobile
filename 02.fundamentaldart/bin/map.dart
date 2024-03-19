void main() {
  // Deklarasi map dengan literal
  var kota = {
    'Semarang': 'Jawa Tengah',
    'Bandung': 'Jawa Barat',
    'Surabaya': 'Jawa Timur',
  };

  // Mengakses nilai dari map
  print(kota['Semarang']); // Jawa Tengah

  // Menambahkan elemen ke map
  kota['Yogyakarta'] = 'Daerah Istimewa Yogyakarta';

  // Menghapus elemen dari map
  kota.remove('Bandung');

  // Mengecek apakah elemen ada di map
  print(kota.containsKey('Surabaya')); // true

  // Mengecek apakah map kosong
  print(kota.isEmpty); // false

  // Menjumlahkan nilai map
  var totalPopulasi = kota.length;
  print(totalPopulasi); // 3

  // Mengurutkan map berdasarkan key
  var listKota = kota.keys.toList()..sort();
  print(listKota); // ['Semarang', 'Surabaya', 'Yogyakarta']

  // Mengubah map menjadi list
  var listKeyValue = kota.entries.toList();
  print(
      listKeyValue); // [('Semarang', 'Jawa Tengah'), ('Surabaya', 'Jawa Timur'), ('Yogyakarta', 'Daerah Istimewa Yogyakarta')]
}

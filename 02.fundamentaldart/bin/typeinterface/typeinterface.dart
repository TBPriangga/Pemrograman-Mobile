void main() {
  // List dengan type inference
  var dataMahasiswa = [
    {
      'nama': 'Budi',
      'nim': '123456789',
      'jurusan': 'Informatika',
    },
    {
      'nama': 'Ani',
      'nim': '987654321',
      'jurusan': 'Teknik Industri',
    },
  ];

// Mencetak isi list
  print(dataMahasiswa);

// Mengakses elemen list
  var namaMahasiswaPertama = dataMahasiswa[0]['nama'];

// Mencetak elemen yang diakses
  print(namaMahasiswaPertama); // Output: Budi

// Menambahkan elemen baru ke list
  dataMahasiswa.add({
    'nama': 'Cici',
    'nim': '0123456789',
    'jurusan': 'Teknik Elektro',
  });

// Mencetak isi list setelah menambahkan elemen baru
  print(dataMahasiswa);
}

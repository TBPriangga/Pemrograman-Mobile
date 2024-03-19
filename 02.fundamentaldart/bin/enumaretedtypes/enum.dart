enum Pelangi { merah, jingga, kuning, hijau, biru, nila, ungu }

enum Status { Todo, In_Progress, In_Review, Done }

void main() {
  // Mencetak semua nilai enum Pelangi
  print(Pelangi.values);

  // Mencetak nilai enum Pelangi dengan nama "kuning"
  print(Pelangi.kuning);

  // Mencetak index dari nilai enum Pelangi "biru"
  print(Pelangi.biru.index);
}

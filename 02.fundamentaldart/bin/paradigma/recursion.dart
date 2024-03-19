// Fungsi rekursif untuk menghitung deret Fibonacci
int fibonacci(int n) {
  if (n <= 0) {
    return 0;
  } else if (n == 1) {
    return 1;
  } else {
    return fibonacci(n - 1) + fibonacci(n - 2);
  }
}

void main() {
  // Menghitung deret Fibonacci ke-10
  var hasil = fibonacci(10);

  // Mencetak hasil
  print(hasil);
}

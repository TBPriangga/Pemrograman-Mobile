void main() {
  var sum = (int angka1, int angka2) {
    return angka1 + angka2;
  };
  Function printLambda = () {
    print('Ini adalah fungsi lambda');
  };
  printLambda();
  print(sum(3, 4));
}

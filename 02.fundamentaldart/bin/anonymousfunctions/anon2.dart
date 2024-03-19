void main() {
  var sum = (int angka1, int angka2) => angka1 + angka2;
  Function printLambda = () => print('This is lambda function');
  printLambda();
  print(sum(3, 4));
}

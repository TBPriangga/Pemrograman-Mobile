import 'package:flutter/material.dart';

class SecondPage extends StatelessWidget {
  final String? data;
  const SecondPage({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    final data2 = ModalRoute.of(context)!.settings.arguments ?? "";
    // untuk memberikan nilai default jika nilai sebelumnya adalah null.
    //Dalam hal ini, jika tidak ada argumen yang dilewatkan ke route (artinya .arguments adalah null),
    //maka data2 akan diinisialisasi dengan string kosong ("").
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              data ?? '',
              style: const TextStyle(fontSize: 20.0),
            ),
            Text(
              data2.toString(),
              style: const TextStyle(fontSize: 20.0),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Kembali'),
            ),
          ],
        ),
      ),
    );
  }
}

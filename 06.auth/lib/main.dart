import 'package:auth/bloc/login/login_cubit.dart';
import 'package:auth/bloc/register/register_cubit.dart';
import 'package:auth/ui/home_screen.dart';
import 'package:auth/ui/login.dart';
import 'package:auth/ui/splash.dart';
import 'package:auth/utils/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => LoginCubit()),
          BlocProvider(create: (context) => RegisterCubit())
        ],
        child: MaterialApp(
          title: "Praktikum Auth",
          debugShowCheckedModeBanner: false,
          navigatorKey: NAV_KEY,
          onGenerateRoute: generateRoute,
          home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasData) {
                return HomeScreen();
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text('Something went wrong'),
                );
              } else {
                return LoginScreen();
              }
            },
          ),
        ));
  }
}

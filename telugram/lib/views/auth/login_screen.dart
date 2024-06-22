import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:telugram/services/firebase_service/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback show;
  const LoginScreen({super.key, required this.show});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController();
  FocusNode email_F = FocusNode();
  final password = TextEditingController();
  FocusNode password_F = FocusNode();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Image.asset('assets/logo/telugram.png'),
              ),
              textField(
                email,
                email_F,
                'Email',
              ),
              SizedBox(height: 15.h),
              passwordField(
                password,
                password_F,
                'Password',
                _obscurePassword,
                () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
              SizedBox(height: 10.h),
              forget(),
              const SizedBox(height: 10.0),
              loginButton(),
              const SizedBox(height: 10.0),
              signup()
            ],
          ),
        ),
      ),
    );
  }

  Widget signup() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Don\'t have an account? ',
            style: TextStyle(
              color: Colors.black,
              fontSize: 13.sp,
            ),
          ),
          GestureDetector(
            onTap: widget.show,
            child: Text(
              'Sign up',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 15.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget loginButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: InkWell(
        onTap: () async {
          try {
            await Authentication()
                .Login(email: email.text, password: password.text);
            // Tampilkan Snackbar "Berhasil Login"
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Berhasil Login'),
                backgroundColor: Colors.green,
              ),
            );
          } catch (e) {
            // Tampilkan Snackbar kesalahan
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Email atau Password salah'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: 60.h,
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Text(
            'LOG IN',
            style: TextStyle(
              fontSize: 23.sp,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget forget() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () {},
            child: Text(
              'Forget Password?',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 13.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget textField(
    TextEditingController controller,
    FocusNode focusNode,
    String hintText,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Container(
        height: 44.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.r),
        ),
        child: TextField(
          style: TextStyle(fontSize: 18.sp, color: Colors.black),
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(
            hintText: hintText,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.r),
              borderSide: BorderSide(
                width: 2.w,
                color: Colors.grey,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.r),
              borderSide: BorderSide(
                width: 2.w,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget passwordField(
    TextEditingController controller,
    FocusNode focusNode,
    String hintText,
    bool obscureText,
    VoidCallback toggleObscureText,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Container(
        height: 44.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.r),
        ),
        child: TextField(
          style: TextStyle(fontSize: 18.sp, color: Colors.black),
          controller: controller,
          focusNode: focusNode,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hintText,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.r),
              borderSide: BorderSide(
                width: 2.w,
                color: Colors.grey,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.r),
              borderSide: BorderSide(
                width: 2.w,
                color: Colors.black,
              ),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                obscureText ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey,
              ),
              onPressed: toggleObscureText,
            ),
          ),
        ),
      ),
    );
  }
}

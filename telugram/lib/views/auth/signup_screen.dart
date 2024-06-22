import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:telugram/viewModels/imagepicker.dart';
import '../../services/firebase_service/firebase_auth.dart';
import '../../viewModels/dialog.dart';
import '../../viewModels/exception.dart';

class SignupScreen extends StatefulWidget {
  final VoidCallback show;
  const SignupScreen({super.key, required this.show});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final email = TextEditingController();
  FocusNode email_F = FocusNode();
  final password = TextEditingController();
  FocusNode password_F = FocusNode();
  final username = TextEditingController();
  FocusNode username_F = FocusNode();
  final bio = TextEditingController();
  FocusNode bio_F = FocusNode();
  final passwordConfirm = TextEditingController();
  FocusNode passwordConfirm_F = FocusNode();
  File? _imageFile;
  bool _obscurePassword = true;
  bool _obscurePasswordConfirm = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Image.asset('assets/logo/miniLogo3.png'),
              ),
              InkWell(
                onTap: () async {
                  File? _imagefilee =
                      await ImagePickerr().uploadImage('gallery');
                  setState(() {
                    _imageFile = _imagefilee;
                  });
                },
                child: CircleAvatar(
                  radius: 36.r,
                  backgroundColor: Colors.grey,
                  child: _imageFile == null
                      ? CircleAvatar(
                          radius: 34.r,
                          backgroundColor: Colors.grey.shade200,
                          child: Icon(Icons.person, size: 50.r),
                        )
                      : CircleAvatar(
                          radius: 34.r,
                          backgroundImage: Image.file(
                            _imageFile!,
                            fit: BoxFit.cover,
                          ).image,
                        ),
                ),
              ),
              SizedBox(height: 15.h),
              textField(username, username_F, 'Username'),
              SizedBox(height: 15.h),
              textField(email, email_F, 'Email'),
              SizedBox(height: 15.h),
              textField(bio, bio_F, 'Bio'),
              SizedBox(height: 15.h),
              passwordField(password, password_F, 'Password', _obscurePassword,
                  () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              }),
              SizedBox(height: 15.h),
              passwordField(passwordConfirm, passwordConfirm_F,
                  'Password Confirm', _obscurePasswordConfirm, () {
                setState(() {
                  _obscurePasswordConfirm = !_obscurePasswordConfirm;
                });
              }),
              SizedBox(height: 20.h),
              const SizedBox(height: 10.0),
              signupButton(),
              const SizedBox(height: 10.0),
              login(),
            ],
          ),
        ),
      ),
    );
  }

  Widget signupButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: InkWell(
        onTap: () async {
          if (username.text.isEmpty ||
              email.text.isEmpty ||
              bio.text.isEmpty ||
              password.text.isEmpty ||
              passwordConfirm.text.isEmpty) {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Semua form harus diisi!'),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }

          if (password.text != passwordConfirm.text) {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Password dan konfirmasi password tidak cocok!'),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }

          try {
            await Authentication().Signup(
              email: email.text,
              password: password.text,
              passwordConfirm: passwordConfirm.text,
              username: username.text,
              bio: bio.text,
              profile: _imageFile ?? File(''),
            );
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Registrasi berhasil!'),
                backgroundColor: Colors.green,
              ),
            );
          } on exceptions catch (e) {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(e.message),
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
            'Sign up',
            style: TextStyle(
              fontSize: 23.sp,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget login() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Already have an account? ',
            style: TextStyle(
              color: Colors.black,
              fontSize: 13.sp,
            ),
          ),
          GestureDetector(
            onTap: widget.show,
            child: Text(
              'LOGIN',
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

  Widget textField(
      TextEditingController controller, FocusNode focusNode, String hint) {
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
            hintText: hint,
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

  Widget passwordField(TextEditingController controller, FocusNode focusNode,
      String hint, bool obscureText, VoidCallback toggleObscureText) {
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
            hintText: hint,
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

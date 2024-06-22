import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:telugram/viewModels/imagepicker.dart';
import '../services/firebase_service/firebase_auth.dart';
import '../viewModels/exception.dart';

class EditProfileScreen extends StatefulWidget {
  final VoidCallback onSave;
  const EditProfileScreen({super.key, required this.onSave});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final bioController = TextEditingController();
  FocusNode bioFocusNode = FocusNode();
  final newPasswordController = TextEditingController();
  FocusNode newPasswordFocusNode = FocusNode();
  final confirmPasswordController = TextEditingController();
  FocusNode confirmPasswordFocusNode = FocusNode();
  File? _imageFile;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoadingImage = false;
  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: InkWell(
                  onTap: () async {
                    setState(() {
                      _isLoadingImage = true;
                    });
                    File? _imagefilee =
                        await ImagePickerr().uploadImage('gallery');
                    setState(() {
                      _imageFile = _imagefilee;
                      _isLoadingImage = false;
                    });
                  },
                  child: CircleAvatar(
                    radius: 36.r,
                    backgroundColor: Colors.grey,
                    child: _isLoadingImage
                        ? CircleAvatar(
                            radius: 34.r,
                            backgroundColor: Colors.grey.shade200,
                            child: const CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.grey),
                            ),
                          )
                        : _imageFile == null
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
              ),
              SizedBox(height: 15.h),
              textField(bioController, bioFocusNode, 'Bio'),
              SizedBox(height: 15.h),
              passwordField(newPasswordController, newPasswordFocusNode,
                  'New Password', _obscureNewPassword, () {
                setState(() {
                  _obscureNewPassword = !_obscureNewPassword;
                });
              }),
              SizedBox(height: 15.h),
              passwordField(confirmPasswordController, confirmPasswordFocusNode,
                  'Confirm Password', _obscureConfirmPassword, () {
                setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                });
              }),
              SizedBox(height: 20.h),
              saveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveProfile() async {
    setState(() {
      _isSaving =
          true; // Set _isSaving menjadi true ketika proses penyimpanan dimulai
    });

    String bio = bioController.text;
    String newPassword = newPasswordController.text;
    String confirmPassword = confirmPasswordController.text;

    if (newPassword.isNotEmpty && newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match!'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        _isSaving =
            false; // Set _isSaving kembali menjadi false jika terjadi error
      });
      return;
    }

    try {
      await Authentication().updateProfile(
        bio: bio,
        newPassword: newPassword,
        profile: _imageFile,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      widget.onSave();
      Navigator.of(context).pop();
    } on exceptions catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isSaving =
            false; // Set _isSaving kembali menjadi false setelah proses penyimpanan selesai
      });
    }
  }

  Widget saveButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: InkWell(
        onTap: _saveProfile,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _isSaving
              ? Container(
                  key: ValueKey<bool>(_isSaving),
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: 60.h,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: SizedBox(
                    width: 24.w,
                    height: 24.w,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2.0,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                )
              : Container(
                  key: ValueKey<bool>(_isSaving),
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: 60.h,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text(
                    'Save',
                    style: TextStyle(
                      fontSize: 23.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
        ),
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

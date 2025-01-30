import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:simawi_mobile/models/user_model.dart';
import 'package:simawi_mobile/providers/user_provider.dart';
import 'package:simawi_mobile/services/database_service.dart';
import 'package:simawi_mobile/services/icd_api_service.dart';
import 'package:simawi_mobile/views/dashboard_view.dart';
import 'package:simawi_mobile/views/register_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _loginFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: FractionallySizedBox(
        heightFactor: 1.0,
        widthFactor: 1.0,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'SAMAWI',
              style: TextStyle(
                fontSize: 38.sp,
                fontWeight: FontWeight.w700,
                color: Colors.teal,
              ),
            ),
            SizedBox(
              height: 40.h,
            ),
            SizedBox(
              width: 300.w,
              child: Consumer<UserProvider>(
                builder: (context, userProvider, child) {
                  return Form(
                    key: _loginFormKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Masukan email';
                            }
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                .hasMatch(value)) {
                              return 'Email tidak valid';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            if (value != null) {
                              userProvider.user.email = value;
                            }
                          },
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Masukan password';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            if (value != null) {
                              userProvider.user.password = value;
                            }
                          },
                        ),
                        SizedBox(height: 20.h),
                        ElevatedButton(
                          onPressed: () async {
                            try {
                              if (_loginFormKey.currentState!.validate()) {
                                _loginFormKey.currentState!.save();
                                userProvider.setState(() {});
                                final userMap = await DatabaseService
                                    .getUserByEmailAndPassword(
                                        email: userProvider.user.email,
                                        password: userProvider.user.password);
                                userProvider.user = UserModel.fromMap(userMap);
                                final icdToken =
                                    await IcdApiService().initIcdApi();
                                userProvider.accessToken = icdToken;
                                userProvider.setState(() {});
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text('Login berhasil'),
                                  ));
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const DashboardView()));
                                }
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text('Login gagal'),
                                ));
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            foregroundColor: Colors.white,
                            fixedSize: Size(150.w, 50.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                          ),
                          child: Text(
                            'Masuk',
                            style: TextStyle(fontSize: 18.sp),
                          ),
                        ),
                        SizedBox(height: 15.h),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const RegisterView()));
                          },
                          child: Text(
                            'Buat akun',
                            style: TextStyle(
                              fontSize: 18.sp,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

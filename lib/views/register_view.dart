import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:simawi_mobile/providers/user_provider.dart';
import 'package:simawi_mobile/services/database_service.dart';
import 'package:simawi_mobile/utils/enums.dart';
import 'package:simawi_mobile/views/login_view.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _registerFormKey = GlobalKey<FormState>();

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
              'SIMAWI',
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
                    key: _registerFormKey,
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
                            labelText: 'Nama',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Masukan nama';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            if (value != null) {
                              userProvider.user.name = value;
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
                        SizedBox(
                          height: 10.h,
                        ),
                        DropdownButtonFormField<Role>(
                          value: Role.admin,
                          items: Role.values.map((Role role) {
                            return DropdownMenuItem<Role>(
                              value: role,
                              child: Text(
                                role.name.toUpperCase(),
                              ),
                            );
                          }).toList(),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                          ),
                          onChanged: (value) {},
                          onSaved: (value) {
                            if (value != null) {
                              userProvider.user.role = value;
                            }
                          },
                        ),
                        SizedBox(height: 20.h),
                        ElevatedButton(
                          onPressed: () async {
                            try {
                              if (_registerFormKey.currentState!.validate()) {
                                _registerFormKey.currentState!.save();
                                final registerTimestamp =
                                    DateTime.now().millisecondsSinceEpoch;
                                userProvider.user.createdAt = registerTimestamp;
                                userProvider.user.updatedAt = registerTimestamp;
                                userProvider.setState(() {});
                                final id = await DatabaseService.putUser(
                                    userProvider.user.toMap());
                                userProvider.user.id = id;
                                userProvider.setState(() {});
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text('Pendaftaran berhasil'),
                                  ));
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginView()));
                                }
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text('Daftar gagal'),
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
                            'Daftar',
                            style: TextStyle(fontSize: 18.sp),
                          ),
                        ),
                        SizedBox(height: 15.h),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const LoginView()));
                          },
                          child: Text(
                            'Sudah punya akun',
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

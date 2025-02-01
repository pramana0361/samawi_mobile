import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:simawi_mobile/models/user_model.dart';
import 'package:simawi_mobile/providers/user_provider.dart';
import 'package:simawi_mobile/services/database_service.dart';
import 'package:simawi_mobile/utils/enums.dart';
import 'package:simawi_mobile/utils/functions.dart';

class ManageUserView extends StatefulWidget {
  const ManageUserView({super.key});

  @override
  State<ManageUserView> createState() => _ManageUserViewState();
}

class _ManageUserViewState extends State<ManageUserView> {
  Future<void> manageUserDialog({UserModel? data}) {
    final userFormKey = GlobalKey<FormState>();
    UserModel userModel = UserModel(
        id: 0,
        email: '',
        password: '',
        name: '',
        role: Role.admin,
        createdAt: 0,
        updatedAt: 0);
    if (data != null) {
      userModel = data;
    }
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog.fullscreen(
          child: Scaffold(
            appBar: AppBar(
              title: const Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'USER DATA',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
            body: FractionallySizedBox(
              widthFactor: 1.0,
              heightFactor: 1.0,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 300.w,
                    child: Form(
                      key: userFormKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextFormField(
                            initialValue: data == null ? null : userModel.email,
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
                                userModel.email = value;
                              }
                            },
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          TextFormField(
                            initialValue: data == null ? null : userModel.name,
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
                                userModel.name = value;
                              }
                            },
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          TextFormField(
                            initialValue:
                                data == null ? null : userModel.password,
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
                                userModel.password = value;
                              }
                            },
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          DropdownButtonFormField<Role>(
                            value: data == null ? Role.admin : userModel.role,
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
                            onChanged: data == null ? (value) {} : null,
                            onSaved: (value) {
                              if (value != null) {
                                userModel.role = value;
                              }
                            },
                          ),
                          SizedBox(height: 20.h),
                          ElevatedButton(
                            onPressed: () async {
                              try {
                                if (userFormKey.currentState!.validate()) {
                                  userFormKey.currentState!.save();
                                  final timestamp =
                                      DateTime.now().millisecondsSinceEpoch;
                                  userModel.updatedAt = timestamp;
                                  if (data == null) {
                                    userModel.createdAt = timestamp;
                                    await DatabaseService.putUser(
                                        userModel.toMap());
                                  } else {
                                    await DatabaseService.updateUser(
                                        userModel.toMap());
                                  }
                                  if (context.mounted) {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text('Simpan berhasil'),
                                    ));
                                  }
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text('Simpan gagal'),
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
                              'Simpan',
                              style: TextStyle(fontSize: 18.sp),
                            ),
                          ),
                          SizedBox(height: 55.h),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Colors.grey[200],
            title: const Align(
              alignment: Alignment.centerRight,
              child: Text(
                'SIMAWI',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.teal,
                ),
              ),
            ),
          ),
          body: FractionallySizedBox(
            heightFactor: 1.0,
            widthFactor: 1.0,
            child: FutureBuilder(
              future: DatabaseService.getUserAll(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData && snapshot.data != null) {
                    final listUserFromDb = snapshot.data!;
                    List<UserModel> userListModel = [];
                    int selectedIndex = -1;
                    for (var element in listUserFromDb) {
                      userListModel.add(UserModel.fromMap(element));
                    }
                    return StatefulBuilder(
                      builder: (context, setState) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      await manageUserDialog();
                                      userProvider.setState(() {});
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      backgroundColor: Colors.blue,
                                      foregroundColor: Colors.white,
                                      fixedSize: Size(70.w, 30.h),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.r),
                                      ),
                                    ),
                                    child: Text(
                                      'Tambah',
                                      style: TextStyle(fontSize: 12.sp),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  ElevatedButton(
                                    onPressed: selectedIndex < 0
                                        ? null
                                        : () async {
                                            await manageUserDialog(
                                                data: userListModel[
                                                    selectedIndex]);
                                            userProvider.setState(() {});
                                          },
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      backgroundColor: Colors.yellow[800],
                                      foregroundColor: Colors.white,
                                      fixedSize: Size(70.w, 30.h),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.r),
                                      ),
                                    ),
                                    child: Text(
                                      'Ubah',
                                      style: TextStyle(fontSize: 12.sp),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  ElevatedButton(
                                    onPressed: selectedIndex < 0 ||
                                            userListModel[selectedIndex].id ==
                                                userProvider.user.id
                                        ? null
                                        : () async {
                                            try {
                                              await DatabaseService.deleteUser(
                                                  userListModel[selectedIndex]
                                                      .id);
                                              if (context.mounted) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                        const SnackBar(
                                                  content:
                                                      Text('Hapus berhasil'),
                                                ));
                                              }
                                            } catch (e) {
                                              if (context.mounted) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                        const SnackBar(
                                                  backgroundColor: Colors.red,
                                                  content: Text('Hapus gagal'),
                                                ));
                                              }
                                            }
                                            userProvider.setState(() {});
                                          },
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                      fixedSize: Size(70.w, 30.h),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.r),
                                      ),
                                    ),
                                    child: Text(
                                      'Hapus',
                                      style: TextStyle(fontSize: 12.sp),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: InteractiveViewer(
                                panAxis: PanAxis.aligned,
                                boundaryMargin:
                                    EdgeInsets.symmetric(vertical: 20.h),
                                constrained: false,
                                scaleEnabled: false,
                                child: DataTable(
                                  showCheckboxColumn: false,
                                  columns: const [
                                    DataColumn(
                                      label: Text('ID'),
                                    ),
                                    DataColumn(
                                      label: Text('Name'),
                                    ),
                                    DataColumn(
                                      label: Text('Email'),
                                    ),
                                    DataColumn(
                                      label: Text('Role'),
                                    ),
                                    DataColumn(
                                      label: Text('Registered'),
                                    ),
                                  ],
                                  rows: List.generate(
                                    userListModel.length,
                                    (index) => DataRow(
                                      selected:
                                          selectedIndex == index ? true : false,
                                      onLongPress: () {
                                        setState(() {
                                          if (selectedIndex == index) {
                                            selectedIndex = -1;
                                          } else {
                                            selectedIndex = index;
                                          }
                                        });
                                      },
                                      color: WidgetStateProperty.resolveWith<
                                          Color?>(
                                        (states) {
                                          if (states
                                              .contains(WidgetState.selected)) {
                                            return Colors.teal[200];
                                          }
                                          return null;
                                        },
                                      ),
                                      cells: [
                                        DataCell(
                                            Text('${userListModel[index].id}')),
                                        DataCell(
                                            Text(userListModel[index].name)),
                                        DataCell(
                                            Text(userListModel[index].email)),
                                        DataCell(Text(userListModel[index]
                                            .role
                                            .name
                                            .toUpperCase())),
                                        DataCell(Text(milisecondsToDateString(
                                            userListModel[index].createdAt))),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: Text('Error'),
                    );
                  }
                } else {
                  return SizedBox.square(
                    dimension: 50.sp,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Colors.teal,
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }
}

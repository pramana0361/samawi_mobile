import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:simawi_mobile/providers/user_provider.dart';
import 'package:simawi_mobile/services/database_service.dart';
import 'package:simawi_mobile/utils/enums.dart';
import 'package:simawi_mobile/views/login_view.dart';
import 'package:simawi_mobile/views/manage_user_view.dart';
import 'package:simawi_mobile/views/registrasi_pasien_view.dart';
import 'package:simawi_mobile/views/rekam_medis_view.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
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
          drawer: Drawer(
            child: ListView(
              children: [
                SizedBox(
                  height: 60.h,
                  child: DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.account_circle,
                          color: Colors.grey[700],
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 5.w,
                            ),
                            child: Text(
                              userProvider.user.name,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => const LoginView(),
                              ),
                              (Route<dynamic> route) => false,
                            );
                          },
                          child: const Icon(
                            Icons.door_back_door_rounded,
                            color: Colors.black54,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                if (userProvider.user.role == Role.admin) ...[
                  ListTile(
                    leading: const Icon(
                      Icons.supervised_user_circle,
                      color: Colors.red,
                    ),
                    title: const Text('Manajemen User'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const ManageUserView()));
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.local_hospital,
                      color: Colors.green,
                    ),
                    title: const Text('Registrasi Pasien'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const RegistrasiPasienView()));
                    },
                  ),
                ],
                if (userProvider.user.role == Role.doctor) ...[
                  ListTile(
                    leading: const Icon(
                      Icons.document_scanner_rounded,
                      color: Colors.green,
                    ),
                    title: const Text('Rekam Medis'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const RekamMedisView()));
                    },
                  ),
                ],
              ],
            ),
          ),
          body: FractionallySizedBox(
            heightFactor: 1.0,
            widthFactor: 1.0,
            child: FutureBuilder(
              future: DatabaseService.countPatientAll(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData && snapshot.data != null) {
                    final patientCount = snapshot.data!;
                    return Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 0.7.sw,
                          height: 0.25.sh,
                          margin: EdgeInsets.symmetric(vertical: 20.h),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'JUMLAH PASIEN',
                                style: TextStyle(
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey[300],
                                ),
                              ),
                              Text(
                                '$patientCount',
                                style: TextStyle(
                                  fontSize: 62.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey[300],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Text(
                      'ERROR',
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey[300],
                      ),
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

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:simawi_mobile/providers/user_provider.dart';
import 'package:simawi_mobile/utils/enums.dart';
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
                'SAMAWI',
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
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 15.sp,
                      children: [
                        Icon(
                          Icons.account_circle,
                          color: Colors.grey[700],
                        ),
                        Text(userProvider.user.name),
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
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'DASHBOARD',
                  style: TextStyle(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey[300],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

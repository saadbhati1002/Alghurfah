import 'package:eshop_multivendor/Helper/Color.dart';
import 'package:eshop_multivendor/Screen/Dashboard/Dashboard.dart';
import 'package:eshop_multivendor/ServiceApp/screens/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';

class AppTabbbarScreen extends StatefulWidget {
  const AppTabbbarScreen({Key? key}) : super(key: key);

  @override
  State<AppTabbbarScreen> createState() => _AppTabbbarScreenState();
}

class _AppTabbbarScreenState extends State<AppTabbbarScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        body: DefaultTabController(
          length: 2,
          child: Column(children: [
            Theme(
              data: ThemeData(
                brightness: Brightness.light,
                primaryColor: Colors.white,
              ),
              child: const TabBar(
                labelColor: colors.primary,
                unselectedLabelColor: Colors.grey,
                indicatorColor: colors.primary,
                tabs: [
                  Tab(
                    text: 'E-Commerce',
                  ),
                  Tab(
                    text: 'Service',
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(children: [
                Dashboard(),
                DashboardScreen(),
              ]),
            )
          ]),
        ),
      ),
    );
  }
}

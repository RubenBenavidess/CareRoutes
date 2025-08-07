import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screen_pages.dart';
import 'side_menu.dart';
import '../viewmodels/navigation_viewmodel.dart';

class HomeState extends StatelessWidget {
  const HomeState({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 800;

        return Consumer<NavigationViewModel>(
          builder: (context, navigationVM, child) {
            // Map each index to the screen you want to show
            final List<Widget> pages = [
              const FileUploadView(), // Tu nueva vista con Provider
              const ConsultVehicles(),
              const RouteManagementScreen(),
              const RoutesOverviewScreen(),
              const MaintenanceCrudView(),
              const ReportsView(),
              const RouteManagementScreen(),
              //const ConsultRoutes(),
              //const ConsultDriversWidget(),
              //const RegisterMaintenance(),
              //const ConsultMaintenance(),
              //const GenerateReports(),
              //const SettingsScreen(),
            ];

            return Scaffold(
              backgroundColor: const Color(0xFFF2F2F2),
              appBar: isDesktop
                  ? null
                  : AppBar(
                      backgroundColor: const Color(0xFFF2F2F2),
                      elevation: 0,
                      title: Text(navigationVM.currentPageName),
                    ),
              drawer: isDesktop
                  ? null
                  : SideMenu(), // Ya no necesita parámetros
              body: Row(
                children: [
                  // Sidebar permanente en desktop
                  if (isDesktop)
                    const SizedBox(
                      width: 240,
                      child: SideMenu(),
                    ),

                  // Contenido principal
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      switchInCurve: Curves.easeInOut,
                      switchOutCurve: Curves.easeInOut,
                      child: Container(
                        key: ValueKey(navigationVM.selectedIndex),
                        child: pages[navigationVM.selectedIndex],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
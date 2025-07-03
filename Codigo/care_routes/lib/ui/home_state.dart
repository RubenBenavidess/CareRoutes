import 'screen_pages.dart';
import 'side_menu.dart';
import 'package:flutter/material.dart';

class HomeState extends StatefulWidget {
  const HomeState({super.key});
  @override
  _HomeStateState createState() => _HomeStateState();
}

class _HomeStateState extends State<HomeState> {
  int _selectedIndex = 2;

  /// Map each index to the screen you want to show.
  /// Add your other screens (AssignCustodians, ConsultVehicles, etc.) here.
  final List<Widget> _pages = [
    DropZoneWidget(),
    AssignCustodians(),
    ConsultVehicles(),
    AssignRoutes(),
    ConsultRoutes(),
    ConsultDriversWidget(),
    RegisterMaintenance(),
    ConsultMaintenance(),
    GenerateReports(),
    SettingsScreen(),
  ];

  void _onIndexChanged(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // adjust this breakpoint as you like
        final isDesktop = constraints.maxWidth >= 800;

        return Scaffold(
          appBar:
              isDesktop
                  ? null
                  : AppBar(
                    backgroundColor: const Color(0xFFF2F2F2),
                    actions: [
                      // on desktop, show the menu in the app bar
                      if (isDesktop)
                        IconButton(
                          icon: const Icon(Icons.menu),
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
                        ),
                    ],
                  ),
          // only show the “hamburger drawer” on mobile
          drawer:
              isDesktop
                  ? null
                  : SideMenu(
                    selectedIndex: _selectedIndex,
                    onIndexChanged: (i) {
                      _onIndexChanged(i);
                      Navigator.of(context).pop(); // close drawer
                    },
                  ),

          body: Row(
            children: [
              // on desktop, show the menu permanently
              if (isDesktop)
                SizedBox(
                  width: 240,
                  child: SideMenu(
                    selectedIndex: _selectedIndex,
                    onIndexChanged: _onIndexChanged,
                  ),
                ),

              // your main content
              Expanded(child: _pages[_selectedIndex]),
            ],
          ),
        );
      },
    );
  }
}

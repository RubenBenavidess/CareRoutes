import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/navigation_viewmodel.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: const Color(0xFFF2F2F2),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // — Header fijo —
              SizedBox(
                height: 72,
                child: DrawerHeader(
                  margin: EdgeInsets.zero,
                  padding: EdgeInsets.zero,
                  decoration: const BoxDecoration(color: Color(0xFFF2F2F2)),
                  child: const Center(
                    child: Text(
                      'CareRoutes',
                      style: TextStyle(
                        color: Color(0xFFFF8989),
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              // — Menú scrollable —
              Expanded(
                child: Consumer<NavigationViewModel>(
                  builder: (context, navigationVM, child) {
                    return ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        // — Sección Vehículos —
                        const _SectionHeader('Vehículos'),
                        SideMenuItem(
                          icon: Icons.upload_file,
                          label: 'Importar Datos',
                          isSelected: navigationVM.selectedIndex == 0,
                          onTap: () => navigationVM.setSelectedIndex(0),
                        ),
                        SideMenuItem(
                          icon: Icons.search,
                          label: 'Gestionar Vehículos y Custodios',
                          isSelected: navigationVM.selectedIndex == 1,
                          onTap: () => navigationVM.setSelectedIndex(1),
                        ),

                        const Divider(color: Color(0xFF76777C)),

                        // — Sección Rutas —
                        const _SectionHeader('Rutas'),
                        SideMenuItem(
                          icon: Icons.map,
                          label: 'Asignar Rutas',
                          isSelected: navigationVM.selectedIndex == 2,
                          onTap: () => navigationVM.setSelectedIndex(2),
                        ),
                        SideMenuItem(
                          icon: Icons.visibility,
                          label: 'Ver Rutas',
                          isSelected: navigationVM.selectedIndex == 3,
                          onTap: () => navigationVM.setSelectedIndex(3),
                        ),

                        const Divider(color: Color(0xFF76777C)),


                        // — Sección Mantenimientos —
                        const _SectionHeader('Mantenimientos'),
                        SideMenuItem(
                          icon: Icons.build,
                          label: 'Gestionar Mantenimientos',
                          isSelected: navigationVM.selectedIndex == 4,
                          onTap: () => navigationVM.setSelectedIndex(4),
                        ),
                        const Divider(color: Color(0xFF76777C)),

                        // — Sección Reportes —
                        const _SectionHeader('Reportes'),
                        SideMenuItem(
                          icon: Icons.pie_chart,
                          label: 'Generar Reportes',
                          isSelected: navigationVM.selectedIndex == 5,
                          onTap: () => navigationVM.setSelectedIndex(5),
                        ),
                      ],
                    );
                  },
                ),
              ),


              Padding(
                padding: const EdgeInsets.all(16),
                child: Image.asset(
                  'assets/images/footer_logo.png', 
                  height: 64,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 64,
                      color: Colors.grey[300],
                      child: const Icon(Icons.car_rental),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String text;
  const _SectionHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF76777C),
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );
  }
}

class SideMenuItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const SideMenuItem({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<SideMenuItem> createState() => _SideMenuItemState();
}

class _SideMenuItemState extends State<SideMenuItem>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Colores base
    const bgSelected = Color(0xFF0973AD);
    const fgSelected = Color(0xFFF2F2F2);
    const fgDefault = Color(0xFF76777C);
    const bgHover = Color(0xFFE0E0E0);

    final bgColor = widget.isSelected
        ? bgSelected
        : (_isHovered ? bgHover : Colors.transparent);
    final fgColor = widget.isSelected ? fgSelected : fgDefault;

    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        if (!widget.isSelected) _animationController.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _animationController.reverse();
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(8),
                boxShadow: widget.isSelected
                    ? [
                        BoxShadow(
                          color: bgSelected.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: widget.onTap,
                  child: ListTile(
                    leading: Icon(widget.icon, color: fgColor),
                    title: Text(
                      widget.label,
                      style: TextStyle(
                        color: fgColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
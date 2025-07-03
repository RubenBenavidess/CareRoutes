import 'package:flutter/material.dart';

class SideMenu extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onIndexChanged;

  const SideMenu({
    super.key,
    required this.selectedIndex,
    required this.onIndexChanged,
  });

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
                  child: Center(
                    child: const Text(
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
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    // — Sección Vehículos —
                    const _SectionHeader('Vehículos'),
                    SideMenuItem(
                      icon: Icons.upload_file,
                      label: 'Importar Datos',
                      isSelected: selectedIndex == 0,
                      onTap: () => onIndexChanged(0),
                    ),
                    SideMenuItem(
                      icon: Icons.person_add,
                      label: 'Asignar Custodios',
                      isSelected: selectedIndex == 1,
                      onTap: () => onIndexChanged(1),
                    ),
                    SideMenuItem(
                      icon: Icons.search,
                      label: 'Consultar Vehículos',
                      isSelected: selectedIndex == 2,
                      onTap: () => onIndexChanged(2),
                    ),

                    const Divider(color: Color(0xFF76777C)),

                    // — Sección Rutas —
                    const _SectionHeader('Rutas'),

                    SideMenuItem(
                      icon: Icons.map,
                      label: 'Asignar Rutas',
                      isSelected: selectedIndex == 3,
                      onTap: () => onIndexChanged(3),
                    ),
                    SideMenuItem(
                      icon: Icons.visibility,
                      label: 'Ver Rutas',
                      isSelected: selectedIndex == 4,
                      onTap: () => onIndexChanged(4),
                    ),

                    const Divider(color: Color(0xFF76777C)),

                    // — Sección Conductores —
                    const _SectionHeader('Conductores'),
                    SideMenuItem(
                      icon: Icons.delivery_dining,
                      label: 'Consultar Conductores',
                      isSelected: selectedIndex == 5,
                      onTap: () => onIndexChanged(5),
                    ),

                    const Divider(color: Color(0xFF76777C)),

                    // — Sección Mantenimientos —
                    const _SectionHeader('Mantenimientos'),
                    SideMenuItem(
                      icon: Icons.build,
                      label: 'Registrar Mantenimientos',
                      isSelected: selectedIndex == 6,
                      onTap: () => onIndexChanged(6),
                    ),
                    SideMenuItem(
                      icon: Icons.history,
                      label: 'Ver Mantenimientos',
                      isSelected: selectedIndex == 7,
                      onTap: () => onIndexChanged(7),
                    ),

                    const Divider(color: Color(0xFF76777C)),

                    // — Sección Reportes —
                    const _SectionHeader('Reportes'),
                    SideMenuItem(
                      icon: Icons.pie_chart,
                      label: 'Generar Reportes',
                      isSelected: selectedIndex == 8,
                      onTap: () => onIndexChanged(8),
                    ),
                  ],
                ),
              ),

              // — Footer fijo —
              const Divider(color: Color(0xFF76777C)),
              SideMenuItem(
                icon: Icons.settings,
                label: 'Configuración',
                isSelected: selectedIndex == 9,
                onTap: () => onIndexChanged(9),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Image.asset('assets/images/footer_logo.png', height: 64),
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
  _SideMenuItemState createState() => _SideMenuItemState();
}

class _SideMenuItemState extends State<SideMenuItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    // Colores base
    const bgSelected = Color(0xFF0973AD);
    const fgSelected = Color(0xFFF2F2F2);
    const fgDefault = Color(0xFF76777C);
    const bgHover = Color(0xFFE0E0E0);

    final bgColor =
        widget.isSelected
            ? bgSelected
            : (_isHovered ? bgHover : Colors.transparent);
    final fgColor = widget.isSelected ? fgSelected : fgDefault;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
        ),
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
          onTap: widget.onTap,
        ),
      ),
    );
  }
}

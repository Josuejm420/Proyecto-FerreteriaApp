import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_colors.dart';
import '../../../data/models/user_role.dart';
import '../profile/profile_screen.dart';
import 'widgets/home_dashboard.dart';
import 'widgets/section_placeholder_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    this.userName = 'Don Antonio Ruiz',
    this.role = UserRole.administrador,
  });

  static const routeName = '/home';

  final String userName;
  final UserRole role;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  void _onTabSelected(int index) => setState(() => _currentIndex = index);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: DarkColors.fondo,
        body: IndexedStack(
          index: _currentIndex,
          children: [
            HomeDashboard(
              userName: widget.userName,
              role: widget.role,
              onOpenTab: _onTabSelected,
            ),
            const SectionPlaceholderScreen(title: 'Ventas', emoji: '🧾'),
            const SectionPlaceholderScreen(title: 'Productos', emoji: '📦'),
            ProfileScreen(userName: widget.userName, role: widget.role),
          ],
        ),
        bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
            backgroundColor: DarkColors.tarjeta,
            surfaceTintColor: Colors.transparent,
            indicatorColor: DarkColors.indicador,
            height: 72,
            labelTextStyle: WidgetStateProperty.resolveWith((states) {
              final selected = states.contains(WidgetState.selected);
              return TextStyle(
                fontSize: 12,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected ? DarkColors.naranja : DarkColors.textoSuave,
              );
            }),
          ),
          child: NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: _onTabSelected,
            destinations: const [
              NavigationDestination(
                icon: Text('🏠', style: TextStyle(fontSize: 22)),
                label: 'Inicio',
              ),
              NavigationDestination(
                icon: Text('🧾', style: TextStyle(fontSize: 22)),
                label: 'Ventas',
              ),
              NavigationDestination(
                icon: Text('📦', style: TextStyle(fontSize: 22)),
                label: 'Productos',
              ),
              NavigationDestination(
                icon: Text('👤', style: TextStyle(fontSize: 22)),
                label: 'Perfil',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

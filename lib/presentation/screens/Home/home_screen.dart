import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_icons.dart';
import '../../../data/models/user_role.dart';
import '../profile/profile_screen.dart';
import '../Ventas/sales_screen.dart';
import 'widgets/home_dashboard.dart';
import '../products/products_screen.dart';

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
            SalesScreen(role: widget.role),
            const ProductsScreen(),
            ProfileScreen(userName: widget.userName, role: widget.role),
          ],
        ),
        bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
            backgroundColor: DarkColors.tarjeta,
            surfaceTintColor: Colors.transparent,
            indicatorColor: DarkColors.indicador,
            height: 72,
            iconTheme: WidgetStateProperty.resolveWith((states) {
              final selected = states.contains(WidgetState.selected);
              return IconThemeData(
                size: 26,
                color: selected ? DarkColors.naranja : DarkColors.textoSuave,
              );
            }),
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
                icon: Icon(AppIcons.inicio),
                label: 'Inicio',
              ),
              NavigationDestination(
                icon: Icon(AppIcons.ventas),
                label: 'Ventas',
              ),
              NavigationDestination(
                icon: Icon(AppIcons.productos),
                label: 'Productos',
              ),
              NavigationDestination(
                icon: Icon(AppIcons.perfil),
                label: 'Perfil',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
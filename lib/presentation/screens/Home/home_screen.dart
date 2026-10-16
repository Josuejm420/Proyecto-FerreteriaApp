import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../data/models/user_role.dart';
import 'widgets/main_scaffold.dart';
import 'widgets/metric_card.dart';
import 'widgets/search_form_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    this.userName = 'Don Antonio Ruiz',
    this.role = UserRole.administrador,
  });

  static const routeName = '/home';

  final String userName;
  final UserRole role;

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      titulo: 'Don Toño - ${role.label}',
      currentIndex: 0,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hola, $userName',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.texto,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Aquí puedes administrar tu ferretería',
              style: TextStyle(color: AppColors.gris),
            ),
            const SizedBox(height: 16),
            const SearchFormWidget(),
            const SizedBox(height: 24),
            const Text(
              'Métricas del sistema',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.texto,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                children: const [
                  MetricCard(
                    icono: Icons.inventory_2,
                    valor: '128',
                    etiqueta: 'Productos en inventario',
                  ),
                  MetricCard(
                    icono: Icons.warning_amber,
                    valor: '5',
                    etiqueta: 'Productos con poco stock',
                    color: AppColors.naranja,
                  ),
                  MetricCard(
                    icono: Icons.people_alt,
                    valor: '32',
                    etiqueta: 'Clientes registrados',
                  ),
                  MetricCard(
                    icono: Icons.local_shipping,
                    valor: '7',
                    etiqueta: 'Proveedores activos',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

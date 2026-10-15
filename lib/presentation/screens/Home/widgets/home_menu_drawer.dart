<<<<<<< HEAD    
import 'package:flutter/material.dart';
=======
﻿import 'package:flutter/material.dart';
>>>>>>> 1655f88 (Actualiza login e implementa pantalla Home)

class HomeMenuDrawer extends StatelessWidget {
  const HomeMenuDrawer({
    required this.selectedIndex,
    required this.onSectionSelected,
    super.key,
  });

  final int selectedIndex;
  final ValueChanged<int> onSectionSelected;

  static const _sections = [
    (label: 'Inicio y todos los KPI', icon: Icons.home_outlined),
    (label: 'Clientes', icon: Icons.people_outline),
    (label: 'Productos', icon: Icons.inventory_2_outlined),
    (label: 'Descuentos y vendedores', icon: Icons.sell_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Icon(
                    Icons.handyman_outlined,
                    color: Colors.white,
                    size: 40,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Ferretería',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Menú principal',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            for (var index = 0; index < _sections.length; index++)
              ListTile(
                leading: Icon(_sections[index].icon),
                title: Text(_sections[index].label),
                selected: selectedIndex == index,
                onTap: () => onSectionSelected(index),
              ),
          ],
        ),
      ),
    );
  }
}

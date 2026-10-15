<<<<<<< HEAD
import 'package:flutter/material.dart';

class HomeKpiCard extends StatelessWidget {
  const HomeKpiCard({
    required this.number,
    required this.title,
    required this.question,
    required this.formula,
    required this.diagnosis,
    required this.decision,
    super.key,
  });

  final int number;
  final String title;
  final String question;
  final String formula;
  final String diagnosis;
  final String decision;
=======
﻿import 'package:flutter/material.dart';

class HomeKpiCard extends StatelessWidget {
  const HomeKpiCard({
    required this.icon,
    required this.title,
    super.key,
  });

  final IconData icon;
  final String title;
>>>>>>> 1655f88 (Actualiza login e implementa pantalla Home)

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 1,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
<<<<<<< HEAD
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: colors.primary,
                  foregroundColor: colors.onPrimary,
                  child: Text(
                    '$number',
                    style: textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
=======
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 30,
                  color: colors.primary,
                ),
                const SizedBox(width: 14),
>>>>>>> 1655f88 (Actualiza login e implementa pantalla Home)
                Expanded(
                  child: Text(
                    title,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
<<<<<<< HEAD
            const SizedBox(height: 16),
            _KpiDetail(label: 'Pregunta', value: question),
            const SizedBox(height: 10),
            _KpiDetail(label: 'Fórmula', value: formula),
            const SizedBox(height: 10),
            _KpiDetail(label: 'Diagnóstico', value: diagnosis),
            const SizedBox(height: 10),
            _KpiDetail(label: 'Decisión', value: decision),
=======
>>>>>>> 1655f88 (Actualiza login e implementa pantalla Home)
          ],
        ),
      ),
    );
  }
}
<<<<<<< HEAD

class _KpiDetail extends StatelessWidget {
  const _KpiDetail({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(value, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
=======
>>>>>>> 1655f88 (Actualiza login e implementa pantalla Home)

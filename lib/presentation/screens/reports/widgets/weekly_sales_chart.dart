import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../data/models/report_models.dart';

/// Gráfico de barras: una barra por semana. La mejor semana va en naranja.
class WeeklySalesChart extends StatelessWidget {
  const WeeklySalesChart({super.key, required this.weeks});

  final List<WeekSalesStat> weeks;

  static const double _barAreaHeight = 140;
  static const double _minColumnWidth = 64;

  String _shortDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month';
  }

  /// 1500 -> "1.5k"
  String _compact(double value) {
    if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}k';
    return value.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    final maxTotal = weeks.fold<double>(
      0,
      (max, week) => week.total > max ? week.total : max,
    );
    final best = weeks.reduce((a, b) => b.total > a.total ? b : a);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: DarkColors.tarjeta,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: DarkColors.borde),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final fit = constraints.maxWidth / weeks.length;
              final columnWidth = fit < _minColumnWidth ? _minColumnWidth : fit;

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (final week in weeks)
                      SizedBox(
                        width: columnWidth,
                        child: _WeekBar(
                          valueText: _compact(week.total),
                          dateText: _shortDate(week.inicio),
                          invoicesText: week.facturas == 1
                              ? '1 fact.'
                              : '${week.facturas} fact.',
                          fraction: maxTotal == 0 ? 0 : week.total / maxTotal,
                          highlighted: week == best && best.total > 0,
                          barAreaHeight: _barAreaHeight,
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Icon(AppIcons.trofeo, size: 18, color: DarkColors.naranja),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Mejor semana: ${_shortDate(best.inicio)} - '
                  '${_shortDate(best.fin)} · ${formatMoney(best.total)}',
                  style: const TextStyle(
                    color: DarkColors.textoSuave,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WeekBar extends StatelessWidget {
  const _WeekBar({
    required this.valueText,
    required this.dateText,
    required this.invoicesText,
    required this.fraction,
    required this.highlighted,
    required this.barAreaHeight,
  });

  final String valueText;
  final String dateText;
  final String invoicesText;
  final double fraction;
  final bool highlighted;
  final double barAreaHeight;

  @override
  Widget build(BuildContext context) {
    final color = highlighted
        ? DarkColors.naranjaBoton
        : DarkColors.acentosProducto[1];
    final barHeight = fraction <= 0 ? 4.0 : (barAreaHeight * fraction);

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          valueText,
          style: TextStyle(
            color: highlighted ? DarkColors.naranjaBoton : Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          height: barAreaHeight,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: 28,
              height: barHeight < 4 ? 4 : barHeight,
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(8),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          dateText,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          invoicesText,
          style: const TextStyle(color: DarkColors.textoSuave, fontSize: 11),
        ),
      ],
    );
  }
}
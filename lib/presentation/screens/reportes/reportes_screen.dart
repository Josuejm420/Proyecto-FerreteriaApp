import 'package:flutter/material.dart';
import 'historial_screen.dart';
class Reportesscreen extends StatefulWidget {
  const Reportesscreen({super.key});

  @override
  State<Reportesscreen> createState() => _ReportesscreenState();
}

class _ReportesscreenState extends State<Reportesscreen> {
  int reporteSeleccionado = 0;

  final Color azulOscuro = const Color(0xFF102A43);
  final Color amarillo = const Color(0xFFF4B942);
  final Color fondo = const Color(0xFFF5F6FA);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondo,

      appBar: AppBar(
        backgroundColor: azulOscuro,
        foregroundColor: Colors.white,
        title: const Text(
          'Reportes',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [
         
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('No hay nuevas notificaciones'),
                ),
              );
            },
          ),

          
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Historial',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HistorialScreen(),
                ),
              );
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              'Resumen general',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              'Información de ferreteria Don Toño',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 20),

            // TARJETAS
            LayoutBuilder(
              builder: (context, constraints) {
                double ancho = constraints.maxWidth;

                return Wrap(
                  spacing: 15,
                  runSpacing: 15,
                  children: [
                    _tarjetaResumen(
                      'Ventas del día',
                      'C\$ 25,450',
                      Icons.point_of_sale,
                      amarillo,
                      ancho,
                    ),

                    _tarjetaResumen(
                      'Ganancias del día',
                      'C\$ 18,500',
                      Icons.trending_up,
                      Colors.white,
                      ancho,
                    ),

                    _tarjetaResumen(
                      'Productos vendidos',
                      '125',
                      Icons.inventory_2,
                      amarillo,
                      ancho,
                    ),

                    _tarjetaResumen(
                      'Stock bajo',
                      '8',
                      Icons.warning_amber,
                      Colors.white,
                      ancho,
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 30),

            // GRÁFICA
            const Text(
              'Ganancias de la semana',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            Container(
              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 8,
                  ),
                ],
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  const Text(
                    'Ganancias semanales',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    height: 220,

                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,

                      children: [
                        _barraGrafica('Lun', 100),
                        _barraGrafica('Mar', 140),
                        _barraGrafica('Mié', 80),
                        _barraGrafica('Jue', 170),
                        _barraGrafica('Vie', 120),
                        _barraGrafica('Sáb', 190),
                        _barraGrafica('Dom', 90),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Center(
                    child: Text(
                      'Datos demostrativos',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // REPORTES
            const Text(
              'Reportes disponibles',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            _opcionReporte(
              0,
              Icons.bar_chart,
              'Reporte de ventas',
              'Consultar las ventas realizadas',
            ),

            _opcionReporte(
              1,
              Icons.inventory_2,
              'Reporte de inventario',
              'Consultar existencias de productos',
            ),

            _opcionReporte(
              2,
              Icons.trending_up,
              'Productos más vendidos',
              'Visualizar productos con mayor demanda',
            ),

            const SizedBox(height: 25),

            // PANEL
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: double.infinity,
              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: azulOscuro,
                borderRadius: BorderRadius.circular(18),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  const Text(
                    'Resumen de actividad',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    reporteSeleccionado == 0
                        ? 'Consulta las ventas y el estado general del negocio.'
                        : reporteSeleccionado == 1
                            ? 'Revisa las existencias y los productos con stock bajo.'
                            : 'Visualiza los productos que más se venden.',
                    style: const TextStyle(
                      color: Colors.white70,
                    ),
                  ),

                  const SizedBox(height: 18),

                  SizedBox(
                    width: double.infinity,

                    child: ElevatedButton.icon(
                      onPressed: _mostrarReporte,

                      icon: const Icon(Icons.visibility),

                      label: const Text('Ver reporte'),

                      style: ElevatedButton.styleFrom(
                        backgroundColor: amarillo,
                        foregroundColor: azulOscuro,
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _tarjetaResumen(
    String titulo,
    String valor,
    IconData icono,
    Color color,
    double ancho,
  ) {
    double anchoTarjeta = (ancho - 15) / 2;

    return Container(
      width: anchoTarjeta,
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 6,
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Icon(
            icono,
            color: azulOscuro,
            size: 28,
          ),

          const SizedBox(height: 12),

          Text(
            titulo,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black54,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            valor,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: azulOscuro,
            ),
          ),
        ],
      ),
    );
  }

  Widget _barraGrafica(
    String dia,
    double valor,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,

      children: [
        Container(
          width: 22,
          height: valor,

          decoration: BoxDecoration(
            color: amarillo,
            borderRadius: BorderRadius.circular(6),
          ),
        ),

        const SizedBox(height: 8),

        Text(
          dia,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _opcionReporte(
    int indice,
    IconData icono,
    String titulo,
    String descripcion,
  ) {
    bool seleccionado = reporteSeleccionado == indice;

    return GestureDetector(
      onTap: () {
        setState(() {
          reporteSeleccionado = indice;
        });
      },

      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),

        decoration: BoxDecoration(
          color: seleccionado
              ? amarillo.withValues(alpha: 0.25)
              : Colors.white,

          borderRadius: BorderRadius.circular(14),

          border: Border.all(
            color: seleccionado
                ? amarillo
                : Colors.transparent,
          ),
        ),

        child: Row(
          children: [
            CircleAvatar(
              backgroundColor:
                  seleccionado ? amarillo : azulOscuro,

              child: Icon(
                icono,
                color:
                    seleccionado ? azulOscuro : Colors.white,
              ),
            ),

            const SizedBox(width: 15),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  Text(
                    titulo,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    descripcion,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }

  void _mostrarReporte() {
    String titulo;

    if (reporteSeleccionado == 0) {
      titulo = 'Reporte de ventas';
    } else if (reporteSeleccionado == 1) {
      titulo = 'Reporte de inventario';
    } else {
      titulo = 'Productos más vendidos';
    }

    showDialog(
      context: context,

      builder: (context) {
        return AlertDialog(
          title: Text(titulo),

          content: const Text(
            'Este reporte mostrará información detallada '
            'cuando se conecte la base de datos.',
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },

              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }
}
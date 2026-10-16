enum UserRole {
  administrador('Administrador', 'Don Antonio Ruiz'),
  empleado('Empleado', 'Juan Pérez');

  const UserRole(this.label, this.demoName);

  final String label;
  final String demoName; // nombre de ejemplo hasta conectar la base de datos
}
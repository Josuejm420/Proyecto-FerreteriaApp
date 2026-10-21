enum UserRole {
  administrador('Administrador', 'Don Antonio Ruiz', 'antonio@dontono.com'),
  empleado('Empleado', 'Juan Pérez', 'juan@dontono.com');

  const UserRole(this.label, this.demoName, this.demoEmail);

  final String label;
  final String demoName; // nombre de ejemplo hasta conectar la base de datos
  final String demoEmail;
}
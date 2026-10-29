import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../data/models/role_model.dart';
import '../../../../data/models/user_model.dart';
import '../../products/widgets/status_chip.dart';

class UserListCard extends StatelessWidget {
  const UserListCard({
    super.key,
    required this.user,
    required this.role,
    required this.onTap,
  });

  final UserModel user;
  final RoleModel role;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // El color de la franja cambia según el rol.
    final index = (role.id - 1) % DarkColors.acentosProducto.length;
    final accent = DarkColors.acentosProducto[index];
    final iconBackground = DarkColors.fondosIconoProducto[index];
    final isAdmin = role.id == 1;

    return Material(
      color: DarkColors.tarjeta,
      borderRadius: BorderRadius.circular(22),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: 4, color: accent),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: iconBackground,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Icon(
                          isAdmin ? AppIcons.usuarios : AppIcons.perfil,
                          color: accent,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              user.nombre,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              user.correo,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: DarkColors.textoSuave,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(AppIcons.rol, size: 16, color: accent),
                                const SizedBox(width: 6),
                                Text(
                                  role.descripcion,
                                  style: TextStyle(
                                    color: accent,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      StatusChip(activo: user.activo),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
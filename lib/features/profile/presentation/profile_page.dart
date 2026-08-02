import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static const name = 'profile';
  static const route = '/profile';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Profilul meu',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.p20),
        child: Column(
          children: [
            // Card User Avatar & Info
            Container(
              padding: const EdgeInsets.all(AppSizes.p20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSizes.r20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                    child: const Text(
                      'LP',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSizes.p16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Lilian Pletosu',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: AppSizes.p4),
                        const Text(
                          'lilian.pletosu@digitalbeauty.ro',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: AppSizes.p8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.p10,
                            vertical: AppSizes.p4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.goldBackground,
                            borderRadius: BorderRadius.circular(AppSizes.r8),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.workspace_premium,
                                size: AppSizes.iconSm,
                                color: AppColors.goldText,
                              ),
                              SizedBox(width: AppSizes.p4),
                              Text(
                                'Membru Gold',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.goldText,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.p20),

            // Statisitici parcare
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.local_parking_rounded,
                    value: '18',
                    label: 'Parcări efectuate',
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: AppSizes.p12),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.access_time_rounded,
                    value: '24.5 h',
                    label: 'Timp economisit',
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.p20),

            // Vehiculul meu
            _buildSectionHeader('Vehicul salvat'),
            const SizedBox(height: AppSizes.p10),
            Container(
              padding: const EdgeInsets.all(AppSizes.p16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSizes.r16),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppSizes.r12),
                    ),
                    child: const Icon(
                      Icons.directions_car_rounded,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: AppSizes.p14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'BMW Seria 3 (2022)',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'CH 777 PRQ',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.success,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.p24),

            // Meniu setări
            _buildSectionHeader('Setări cont'),
            const SizedBox(height: AppSizes.p10),
            Material(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSizes.r16),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  _buildMenuItem(
                    icon: Icons.payment_rounded,
                    title: 'Metode de plată',
                    subtitle: 'Visa **** 4242',
                  ),
                  const Divider(
                    height: 1,
                    indent: 56,
                    color: AppColors.divider,
                  ),
                  _buildMenuItem(
                    icon: Icons.history_rounded,
                    title: 'Istoric parcări',
                    subtitle: 'Vezi ultimele sesiuni',
                  ),
                  const Divider(
                    height: 1,
                    indent: 56,
                    color: AppColors.divider,
                  ),
                  _buildMenuItem(
                    icon: Icons.notifications_none_rounded,
                    title: 'Notificări',
                    subtitle: 'Alerte expirare timp parcare',
                  ),
                  const Divider(
                    height: 1,
                    indent: 56,
                    color: AppColors.divider,
                  ),
                  _buildMenuItem(
                    icon: Icons.help_outline_rounded,
                    title: 'Suport & Asistență',
                    subtitle: 'Întrebări frecvente și contact',
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.p24),

            // Deconectare
            OutlinedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.logout_rounded, color: AppColors.danger),
              label: const Text(
                'Deconectare',
                style: TextStyle(
                  color: AppColors.danger,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                side: const BorderSide(color: AppColors.danger),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.r14),
                ),
              ),
            ),
            const SizedBox(height: AppSizes.p20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.p16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.r16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: AppSizes.iconXl),
          const SizedBox(height: AppSizes.p12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
      ),
      trailing: const Icon(Icons.chevron_right_rounded, size: 20),
      onTap: () {},
    );
  }
}

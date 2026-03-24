import 'package:flutter/material.dart';
import 'package:rajniti_sathi/main.dart';
import 'package:rajniti_sathi/utils/app_colors.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key, required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    final localization = controller.localizations;

    final items = [
      _DrawerItem(
        icon: Icons.home_rounded,
        label: localization.translate('home'),
      ),
      _DrawerItem(
        icon: Icons.workspace_premium_rounded,
        label: localization.translate('premium'),
      ),
      _DrawerItem(
        icon: Icons.collections_rounded,
        label: localization.translate('myPosters'),
      ),
      _DrawerItem(
        icon: Icons.settings_rounded,
        label: localization.translate('settings'),
      ),
      _DrawerItem(
        icon: Icons.info_rounded,
        label: localization.translate('about'),
      ),
    ];

    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.secondary],
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.campaign_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          localization.appTitle,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          localization.translate('drawerSubtitle'),
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.white.withValues(alpha: 0.9)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ...items.map(
              (item) => ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                leading: Icon(item.icon, color: AppColors.primary),
                title: Text(
                  item.label,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                onTap: () => Navigator.of(context).pop(),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              child: Text(
                localization.translate('futureFirebasePlaceholder'),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem {
  const _DrawerItem({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

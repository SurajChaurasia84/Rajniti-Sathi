import 'package:flutter/material.dart';
import 'package:rajniti_sathi/main.dart';
import 'package:rajniti_sathi/utils/app_colors.dart';
import 'package:rajniti_sathi/widgets/drawer_menu.dart';
import 'package:rajniti_sathi/widgets/poster_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.controller});

  static const String routeName = '/home';
  final AppController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final localization = controller.localizations;
        final theme = Theme.of(context);

        return Scaffold(
          drawer: DrawerMenu(controller: controller),
          appBar: AppBar(
            leading: Builder(
              builder: (context) {
                return IconButton(
                  icon: const Icon(Icons.menu_rounded),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                );
              },
            ),
            title: Text(
              localization.appTitle,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            actions: [
              PopupMenuButton<String>(
                tooltip: localization.translate('language'),
                icon: const Icon(Icons.language_rounded),
                onSelected: controller.updateLanguage,
                itemBuilder: (context) => [
                  PopupMenuItem<String>(
                    value: 'en',
                    child: Text(localization.translate('english')),
                  ),
                  PopupMenuItem<String>(
                    value: 'hi',
                    child: Text(localization.translate('hindi')),
                  ),
                ],
              ),
            ],
          ),
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(28),
                            gradient: const LinearGradient(
                              colors: [AppColors.primary, AppColors.secondary],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.22),
                                blurRadius: 28,
                                offset: const Offset(0, 16),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                localization.translate('headline'),
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                localization.translate('subHeadline'),
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          localization.translate('upcomingDates'),
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: List.generate(7, (index) {
                            final date =
                                DateTime.now().add(Duration(days: index));
                            final localeCode = controller.languageCode;
                            final isSelected =
                                controller.selectedDateIndex == index;
                            final label = _formatDate(date, localeCode);

                            return Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  right: index == 6 ? 0 : 6,
                                ),
                                child: _DateChip(
                                  label: label,
                                  dayLabel: _weekdayLabel(date, localeCode),
                                  isSelected: isSelected,
                                  onTap: () => controller.selectDateIndex(index),
                                ),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          _formatDate(
                            DateTime.now().add(
                              Duration(days: controller.selectedDateIndex),
                            ),
                            controller.languageCode,
                          ),
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  sliver: SliverList.separated(
                    itemCount: controller.posters.length,
                    itemBuilder: (context, index) {
                      final poster = controller.posters[index];
                      return PosterCard(
                        poster: poster,
                        controller: controller,
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 18),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DateChip extends StatelessWidget {
  const _DateChip({
    required this.label,
    required this.dayLabel,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final String dayLabel;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Ink(
          height: 64,
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.08)
                : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,
              width: isSelected ? 1.6 : 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  dayLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String _formatDate(DateTime date, String languageCode) {
  final months = languageCode == 'hi' ? _monthsHi : _monthsEn;
  return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]}';
}

String _weekdayLabel(DateTime date, String languageCode) {
  final weekdays = languageCode == 'hi' ? _weekdaysHi : _weekdaysEn;
  return weekdays[date.weekday - 1];
}

const List<String> _monthsEn = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

const List<String> _monthsHi = [
  'जन',
  'फ़र',
  'मार्च',
  'अप्रै',
  'मई',
  'जून',
  'जुल',
  'अग',
  'सितं',
  'अक्टू',
  'नवं',
  'दिसं',
];

const List<String> _weekdaysEn = [
  'Mon',
  'Tue',
  'Wed',
  'Thu',
  'Fri',
  'Sat',
  'Sun',
];

const List<String> _weekdaysHi = [
  'सोम',
  'मंगल',
  'बुध',
  'गुरु',
  'शुक्र',
  'शनि',
  'रवि',
];

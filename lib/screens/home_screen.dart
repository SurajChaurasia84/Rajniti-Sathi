import 'package:flutter/material.dart';
import 'package:rajniti_sathi/main.dart';
import 'package:rajniti_sathi/screens/language_screen.dart';
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
              IconButton(
                tooltip: localization.translate('language'),
                icon: const Icon(Icons.language_rounded),
                onPressed: () {
                  Navigator.of(context).pushNamed(LanguageScreen.routeName);
                },
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
                        LayoutBuilder(
                          builder: (context, constraints) {
                            const gap = 3.0;
                            final chipWidth =
                                (constraints.maxWidth - (gap * 6)) / 7;

                            return Row(
                              children: List.generate(7, (index) {
                                final date =
                                    DateTime.now().add(Duration(days: index));
                                final localeCode = controller.languageCode;
                                final isSelected =
                                    controller.selectedDateIndex == index;

                                return Padding(
                                  padding: EdgeInsets.only(
                                    right: index == 6 ? 0 : gap,
                                  ),
                                  child: SizedBox(
                                    width: chipWidth,
                                    child: _DateChip(
                                      label: date.day.toString().padLeft(2, '0'),
                                      subLabel: _weekdayShortLabel(
                                        date,
                                        localeCode,
                                      ),
                                      isSelected: isSelected,
                                      onTap: () => controller.selectDateIndex(
                                        index,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            );
                          },
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
                  padding: const EdgeInsets.only(bottom: 24),
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
                        const SizedBox(height: 16),
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
    required this.subLabel,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final String subLabel;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Ink(
          height: 50,
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.08)
                : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,
              width: isSelected ? 1.6 : 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1.5, vertical: 2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subLabel,
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                  softWrap: false,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
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

String _weekdayShortLabel(DateTime date, String languageCode) {
  final weekdays = languageCode == 'hi' ? _weekdaysHi : _weekdaysEn;
  return weekdays[date.weekday - 1];
}

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
  '\u0938\u094b\u092e',
  '\u092e\u0902\u0917',
  '\u092c\u0941\u0927',
  '\u0917\u0941\u0930\u0941',
  '\u0936\u0941\u0915\u094d\u0930',
  '\u0936\u0928\u093f',
  '\u0930\u0935\u093f',
];

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
  '\u091c\u0928',
  '\u092b\u093c\u0930',
  '\u092e\u093e\u0930\u094d\u091a',
  '\u0905\u092a\u094d\u0930\u0948',
  '\u092e\u0908',
  '\u091c\u0942\u0928',
  '\u091c\u0941\u0932',
  '\u0905\u0917',
  '\u0938\u093f\u0924\u0902',
  '\u0905\u0915\u094d\u091f\u0942',
  '\u0928\u0935\u0902',
  '\u0926\u093f\u0938\u0902',
];

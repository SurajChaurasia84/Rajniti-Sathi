import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
                        SizedBox(
                          height: 56,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: 7,
                            separatorBuilder: (context, index) =>
                                const SizedBox(width: 10),
                            itemBuilder: (context, index) {
                              final date = DateTime.now().add(Duration(days: index));
                              final localeCode = controller.languageCode == 'hi'
                                  ? 'hi_IN'
                                  : 'en_US';
                              final isToday = index == 0;
                              final label = isToday
                                  ? localization.translate('today')
                                  : DateFormat('dd MMM', localeCode).format(date);

                              return ChoiceChip(
                                selected: isToday,
                                label: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(label),
                                    Text(
                                      DateFormat('EEE', localeCode).format(date),
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: isToday
                                            ? Colors.white.withValues(alpha: 0.92)
                                            : AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                                onSelected: (_) {},
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          localization.translate('posterFeed'),
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

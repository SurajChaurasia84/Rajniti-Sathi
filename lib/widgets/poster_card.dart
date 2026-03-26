import 'package:flutter/material.dart';
import 'package:rajniti_sathi/main.dart';
import 'package:rajniti_sathi/utils/app_colors.dart';

class PosterCard extends StatelessWidget {
  const PosterCard({
    super.key,
    required this.poster,
    required this.controller,
  });

  final PosterItem poster;
  final AppController controller;

  static const double _avatarWidth = 158;
  static const double _avatarHeight = 214;

  @override
  Widget build(BuildContext context) {
    final localization = controller.localizations;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: double.infinity,
          child: AspectRatio(
            aspectRatio: poster.imageAspectRatio,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final canvasHeight = constraints.maxWidth / poster.imageAspectRatio;
                const double overlayHeight = 100.0;
                final maxX = constraints.maxWidth - _avatarWidth - 8;
                final maxY = canvasHeight - _avatarHeight - overlayHeight + 67;
                final clampedOffset = Offset(
                  poster.imageOffset.dx.clamp(0, maxX),
                  poster.imageOffset.dy.clamp(0, maxY),
                );
                final topThumbSize = constraints.maxWidth * 0.11;

                return Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        poster.assetPath,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Row(
                                children: List.generate(4, (index) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                      right: index == 3 ? 0 : 6,
                                    ),
                                    child: Container(
                                      width: topThumbSize,
                                      height: topThumbSize,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 2,
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(2),
                                        child: Image.asset(
                                          poster.userImagePath,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: topThumbSize * 1.55,
                              height: topThumbSize * 1.55,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(6),
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/posters/bjp.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        height: overlayHeight,
                        color: AppColors.primary,
                        padding: const EdgeInsets.fromLTRB(14, 10, 14, 6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              poster.userName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 26,
                                height: 1,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              localization.translate('defaultDesignation'),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.92),
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: double.infinity,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 6,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: _SocialItem(
                                          icon: Icons.facebook_rounded,
                                          label: 'Social Media Name',
                                        ),
                                      ),
                                      SizedBox(width: 6),
                                      Expanded(
                                        child: _SocialItem(
                                          icon: Icons.photo_camera_back_rounded,
                                          label: 'Social Media Name',
                                        ),
                                      ),
                                      SizedBox(width: 6),
                                      Expanded(
                                        child: _SocialItem(
                                          icon: Icons.message_rounded,
                                          label: 'Social Media Name',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: clampedOffset.dx,
                      top: clampedOffset.dy,
                      child: GestureDetector(
                        onLongPressMoveUpdate: (details) {
                          final renderBox =
                              context.findRenderObject() as RenderBox?;
                          if (renderBox == null) {
                            return;
                          }

                          final localPosition = renderBox.globalToLocal(
                            details.globalPosition,
                          );
                          controller.updatePoster(
                            posterId: poster.id,
                            imageOffset: Offset(
                              (localPosition.dx - (_avatarWidth / 2)).clamp(0, maxX),
                              (localPosition.dy - (_avatarHeight / 2)).clamp(0, maxY),
                            ),
                          );
                        },
                        child: SizedBox(
                          width: _avatarWidth,
                          height: _avatarHeight,
                          child: Image.asset(
                            poster.userImagePath,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
          child: Row(
            children: [
              Expanded(
                child: _ActionItem(
                  icon: Icons.download_rounded,
                  label: localization.translate('download'),
                ),
              ),
              Expanded(
                child: _ActionItem(
                  icon: Icons.edit_rounded,
                  label: localization.translate('edit'),
                  onTap: () => _openEditor(context),
                ),
              ),
              Expanded(
                child: _ActionItem(
                  icon: Icons.share_rounded,
                  label: localization.translate('share'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _openEditor(BuildContext context) async {
    final localization = controller.localizations;
    final nameController = TextEditingController(text: poster.userName);
    Color selectedColor = poster.textColor;
    bool showBackground = poster.showNameBackground;
    final colorOptions = <Color>[
      Colors.white,
      AppColors.primary,
      AppColors.textPrimary,
      const Color(0xFF00A86B),
    ];

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                top: 16,
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 42,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.border,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      localization.translate('editPoster'),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 18),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: localization.translate('changeName'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      localization.translate('textColor'),
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: colorOptions.map((color) {
                        final isSelected = selectedColor == color;
                        return GestureDetector(
                          onTap: () => setModalState(() => selectedColor = color),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.border,
                                width: isSelected ? 3 : 1.5,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 12),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(localization.translate('nameBackground')),
                      value: showBackground,
                      activeThumbColor: AppColors.primary,
                      onChanged: (value) =>
                          setModalState(() => showBackground = value),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        onPressed: () {
                          controller.updatePoster(
                            posterId: poster.id,
                            userName: nameController.text.trim().isEmpty
                                ? poster.userName
                                : nameController.text.trim(),
                            textColor: selectedColor,
                            showNameBackground: showBackground,
                          );
                          Navigator.of(context).pop();
                        },
                        child: Text(localization.translate('saveChanges')),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    nameController.dispose();
  }
}

class _ActionItem extends StatelessWidget {
  const _ActionItem({
    required this.icon,
    required this.label,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          decoration: BoxDecoration(
            // color: AppColors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.28),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: AppColors.primary, size: 18),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
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

class _SocialItem extends StatelessWidget {
  const _SocialItem({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Icon(icon, size: 12, color: AppColors.textPrimary),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 10,
            ),
          ),
        ),
      ],
    );
  }
}

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

  static const double _avatarSize = 76;

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
                final canvasHeight =
                    constraints.maxWidth / poster.imageAspectRatio;
                final maxX = constraints.maxWidth - _avatarSize;
                final maxY = canvasHeight - _avatarSize;
                final clampedOffset = Offset(
                  poster.imageOffset.dx.clamp(0, maxX),
                  poster.imageOffset.dy.clamp(0, maxY),
                );

                return Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        poster.assetPath,
                        fit: BoxFit.cover,
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
                              (localPosition.dx - (_avatarSize / 2))
                                  .clamp(0, maxX),
                              (localPosition.dy - (_avatarSize / 2))
                                  .clamp(0, maxY),
                            ),
                          );
                        },
                        child: Container(
                          width: _avatarSize,
                          height: _avatarSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.18),
                                blurRadius: 14,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              poster.userImagePath,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: clampedOffset.dx + _avatarSize + 10,
                      top: clampedOffset.dy + 24,
                      right: 18,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: poster.showNameBackground
                              ? Colors.black.withValues(alpha: 0.36)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: poster.showNameBackground ? 12 : 0,
                            vertical: poster.showNameBackground ? 8 : 0,
                          ),
                          child: Text(
                            poster.userName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: poster.textColor,
                              fontWeight: FontWeight.w800,
                              fontSize: 20,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withValues(alpha: 0.35),
                                  blurRadius: 12,
                                ),
                              ],
                            ),
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
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: AppColors.primary),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

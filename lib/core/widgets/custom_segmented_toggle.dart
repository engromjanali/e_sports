import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CustomSegmentedToggle extends StatefulWidget {
  final List<String> options;
  final int selectedIndex;
  final Function(int) onSelected;

  const CustomSegmentedToggle({
    super.key,
    required this.options,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  State<CustomSegmentedToggle> createState() => _CustomSegmentedToggleState();
}

class _CustomSegmentedToggleState extends State<CustomSegmentedToggle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.bgSurface.withOpacity(0.5),
        borderRadius: AppRadius.borderPill,
        border: Border.all(color: AppColors.white.withOpacity(0.1)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double segmentWidth = constraints.maxWidth / widget.options.length;
          
          // Calculate alignment based on selected index
          // -1 is far left, 1 is far right. 
          // For 2 options: index 0 -> -1, index 1 -> 1
          // For N options: ...
          final alignmentX = -1.0 + (widget.selectedIndex * (2.0 / (widget.options.length - 1)));

          return Stack(
            children: [
              // Animated Background Indicator
              AnimatedAlign(
                alignment: Alignment(alignmentX, 0),
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOutQuart,
                child: Container(
                  width: segmentWidth,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    gradient: AppColors.blueHeroGradient,
                    borderRadius: AppRadius.borderPill,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.neonBlue.withOpacity(0.3),
                        blurRadius: 10,
                        spreadRadius: -2,
                      )
                    ],
                  ),
                ),
              ),
              
              // Labels
              Row(
                children: List.generate(widget.options.length, (i) {
                  final isSelected = widget.selectedIndex == i;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => widget.onSelected(i),
                      behavior: HitTestBehavior.opaque,
                      child: Center(
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: TextStyle(
                            fontSize: AppTypography.sizeCaption,
                            fontWeight: isSelected ? AppTypography.black : AppTypography.bold,
                            color: isSelected ? AppColors.white : AppColors.textMuted,
                            letterSpacing: 1.2,
                          ),
                          child: Text(widget.options[i].toUpperCase()),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          );
        },
      ),
    );
  }
}

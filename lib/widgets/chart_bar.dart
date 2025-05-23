import 'dart:math';
import 'package:flutter/material.dart';

class ChartBar extends StatefulWidget {
  final double value;
  final double maxValue;
  final String label;
  final bool isCurrentUser;
  final bool showAnimation;
  final Color primaryColor;
  final Color secondaryColor;
  final double minDisplayThreshold;
  // Nuevos parámetros para la funcionalidad de edición
  final bool showEditButton;
  final VoidCallback? onEdit;
  final bool isLoading;

  const ChartBar({
    Key? key,
    required this.value,
    required this.maxValue,
    required this.label,
    this.isCurrentUser = false,
    this.showAnimation = true,
    required this.primaryColor,
    required this.secondaryColor,
    this.minDisplayThreshold = 0.001,
    this.showEditButton = false,
    this.onEdit,
    this.isLoading = false,
  }) : super(key: key);

  @override
  State<ChartBar> createState() => _ChartBarState();
}

class _ChartBarState extends State<ChartBar> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _widthAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _widthAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    
    if (widget.showAnimation) {
      _animationController.forward();
    } else {
      _animationController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final borderRadius = BorderRadius.circular(14);
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          // Label section
          SizedBox(
            width: 90,
            child: Text(
              widget.label,
              style: TextStyle(
                fontWeight: widget.isCurrentUser ? FontWeight.bold : null,
                color: widget.isCurrentUser ? colorScheme.primary : null,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          
          // Chart bar section
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final maxAvailableWidth = constraints.maxWidth;
                
                final bool valueIsSignificant = 
                    widget.value > 0 && 
                    widget.value / widget.maxValue >= widget.minDisplayThreshold;
                
                final double barWidth = valueIsSignificant
                    ? maxAvailableWidth * (widget.value / widget.maxValue)
                    : 0.0;
                
                final bool isSmallBar = barWidth < 50;

                return ClipRRect(
                  borderRadius: borderRadius,
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.centerLeft,
                    children: [
                      // Background container
                      Container(
                        height: 28,
                        width: maxAvailableWidth,
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceVariant.withOpacity(0.3),
                          borderRadius: borderRadius,
                        ),
                      ),
                      
                      // Animated bar - only shown if value is significant
                      if (valueIsSignificant)
                        AnimatedBuilder(
                          animation: _widthAnimation,
                          builder: (context, child) {
                            return Container(
                              width: barWidth * _widthAnimation.value,
                              height: 28,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: widget.isCurrentUser
                                      ? [
                                          widget.primaryColor,
                                          widget.primaryColor.withOpacity(0.7),
                                        ]
                                      : [
                                          widget.secondaryColor,
                                          widget.secondaryColor.withOpacity(0.7),
                                        ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                              ),
                            );
                          },
                        ),
                      
                      // Value text
                      Positioned(
                        left: 10,
                        child: Text(
                          widget.value.toStringAsFixed(0),
                          style: TextStyle(
                            color: valueIsSignificant && !isSmallBar
                              ? Colors.white 
                              : colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          
          // Edit button space - consistent width regardless of whether button is shown
          SizedBox(
            width: 48,
            child: widget.showEditButton
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: IconButton(
                    padding: const EdgeInsets.all(6),
                    constraints: const BoxConstraints(
                      minWidth: 36,
                      minHeight: 36,
                    ),
                    icon: widget.isLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(
                            Icons.edit,
                            size: 18,
                          ),
                    style: IconButton.styleFrom(
                      backgroundColor: colorScheme.primaryContainer,
                    ),
                    onPressed: widget.isLoading ? null : widget.onEdit,
                  ),
                )
              : null, // No widget here, but space is reserved
          ),
        ],
      ),
    );
  }
}
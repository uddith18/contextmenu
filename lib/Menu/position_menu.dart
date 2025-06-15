import 'package:contextmenu/Menu/context_menu.dart';
import 'package:flutter/material.dart';



class _PositionedMenu extends StatelessWidget {
  const _PositionedMenu({
    required this.screenSize,
    required this.calculatePosition,
    required this.menuItems,
  });

  final Size screenSize;
  final Offset Function(Size screenSize, Size menuSize) calculatePosition;
  final List<ContextMenuItem> menuItems;

  @override
  Widget build(BuildContext context) {
    
    const double itemHeight = 48.0;
    const double menuWidth = 160.0;
    final Size estimatedMenuSize = Size(
      menuWidth,
      (menuItems.length * itemHeight) + 16, 
    );

    final Offset menuPosition = calculatePosition(screenSize, estimatedMenuSize);

    return Positioned(
      left: menuPosition.dx,
      top: menuPosition.dy,
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: menuWidth,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              ...menuItems.map((item) => _MenuItemWidget(item: item)),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}


class _MenuItemWidget extends StatelessWidget {
  const _MenuItemWidget({required this.item});

  final ContextMenuItem item;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            if (item.icon != null) ...[
              Icon(
                item.icon,
                size: 18,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              const SizedBox(width: 12),
            ],
            Text(
              item.label,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


extension PointerEventExtension on PointerEvent {
  dynamic get original => null; 
  void preventDefault() {
  }
}
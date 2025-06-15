import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RectangleArea extends StatelessWidget {
  const RectangleArea({
    super.key,
    required this.label,
    required this.size,
    required this.color,
  });
  final String label;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black26, width: 1),
      ),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

//

class Interceptor extends StatelessWidget {
  const Interceptor({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Listener(
        onPointerDown: (PointerDownEvent event) {
          if (event.kind == PointerDeviceKind.mouse &&
              event.buttons == kSecondaryMouseButton) {
            event.original?.preventDefault();
          }
        },
        child: child,
      );
    } else {
      return child;
    }
  }
}

//

class ContextMenu extends StatefulWidget {
  const ContextMenu({
    super.key,
    required this.child,
    this.menuItems,
  });

  final Widget child;
  final List<ContextMenuItem>? menuItems;

  @override
  State<ContextMenu> createState() => _ContextMenuState();
}

//

class _ContextMenuState extends State<ContextMenu> {
  OverlayEntry? _overlayEntry;
  final GlobalKey _childKey = GlobalKey();

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _showContextMenu(BuildContext context, Offset globalPosition) {
    _removeOverlay(); 

    final RenderBox? renderBox = 
        _childKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final Size childSize = renderBox.size;
    final Offset childPosition = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => _ContextMenuOverlay(
        globalPosition: globalPosition,
        childPosition: childPosition,
        childSize: childSize,
        menuItems: widget.menuItems ?? _defaultMenuItems,
        onDismiss: _removeOverlay,
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  List<ContextMenuItem> get _defaultMenuItems => [
    ContextMenuItem(
      icon: Icons.add,
      label: 'Create',
      onTap: () {
        _removeOverlay();
        _showSnackBar('Create action triggered');
      },
    ),
    ContextMenuItem(
      icon: Icons.edit,
      label: 'Edit',
      onTap: () {
        _removeOverlay();
        _showSnackBar('Edit action triggered');
      },
    ),
    ContextMenuItem(
      icon: Icons.delete,
      label: 'Remove',
      onTap: () {
        _removeOverlay();
        _showSnackBar('Remove action triggered');
      },
    ),
  ];

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Interceptor(
      child: GestureDetector(
        key: _childKey,
        onSecondaryTapDown: (TapDownDetails details) {
          _showContextMenu(context, details.globalPosition);
        },
        child: widget.child,
      ),
    );
  }
}


class ContextMenuItem {
  const ContextMenuItem({
    required this.label,
    required this.onTap,
    this.icon,
  });

  final String label;
  final VoidCallback onTap;
  final IconData? icon;
}


class _ContextMenuOverlay extends StatefulWidget {
  const _ContextMenuOverlay({
    required this.globalPosition,
    required this.childPosition,
    required this.childSize,
    required this.menuItems,
    required this.onDismiss,
  });

  final Offset globalPosition;
  final Offset childPosition;
  final Size childSize;
  final List<ContextMenuItem> menuItems;
  final VoidCallback onDismiss;

  @override
  State<_ContextMenuOverlay> createState() => _ContextMenuOverlayState();
}

class _ContextMenuOverlayState extends State<_ContextMenuOverlay>
    with WidgetsBindingObserver {
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    setState(() {});
  }

  Offset _calculateMenuPosition(Size screenSize, Size menuSize) {
    double x = widget.globalPosition.dx;
    double y = widget.globalPosition.dy;

    if (x + menuSize.width > screenSize.width) {
      x = screenSize.width - menuSize.width - 8;
    }

    if (y + menuSize.height > screenSize.height) {
      y = screenSize.height - menuSize.height - 8;
    }

    if (x < 8) {
      x = 8;
    }
    if (y < 8) {
      y = 8;
    }

    final Rect menuRect = Rect.fromLTWH(x, y, menuSize.width, menuSize.height);
    final Rect childRect = Rect.fromLTWH(
      widget.childPosition.dx,
      widget.childPosition.dy,
      widget.childSize.width,
      widget.childSize.height,
    );

    if (menuRect.overlaps(childRect)) {
      double newX = widget.childPosition.dx + widget.childSize.width + 8;
      if (newX + menuSize.width <= screenSize.width) {
        x = newX;
        y = widget.childPosition.dy;
      } else {
        newX = widget.childPosition.dx - menuSize.width - 8;
        if (newX >= 0) {
          x = newX;
          y = widget.childPosition.dy;
        } else {
          double newY = widget.childPosition.dy - menuSize.height - 8;
          if (newY >= 0) {
            x = widget.globalPosition.dx;
            y = newY;
            
            if (x + menuSize.width > screenSize.width) {
              x = screenSize.width - menuSize.width - 8;
            }
          } else {
            newY = widget.childPosition.dy + widget.childSize.height + 8;
            if (newY + menuSize.height <= screenSize.height) {
              x = widget.globalPosition.dx;
              y = newY;
      
              if (x + menuSize.width > screenSize.width) {
                x = screenSize.width - menuSize.width - 8;
              }
            }
          }
        }
      }
    }

    return Offset(x, y);
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    
    return GestureDetector(
      onTap: widget.onDismiss,
      behavior: HitTestBehavior.translucent,
      child: SizedBox.expand(
        child: Stack(
          children: [
            const SizedBox.expand(),
            _PositionedMenu(
              screenSize: screenSize,
              calculatePosition: _calculateMenuPosition,
              menuItems: widget.menuItems,
            ),
          ],
        ),
      ),
    );
  }
}

//


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
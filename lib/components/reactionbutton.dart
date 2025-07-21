import 'package:flutter/material.dart';

class ReactionButton extends StatefulWidget {
  final int emojiTotal;
  final ValueChanged<int> onEmojiTotalChanged;

  const ReactionButton({
    super.key,
    required this.emojiTotal,
    required this.onEmojiTotalChanged,
  });

  @override
  _ReactionButtonState createState() => _ReactionButtonState();
}

class _ReactionButtonState extends State<ReactionButton> {
  late int emojiTotal;
  OverlayEntry? _overlayEntry;
  String defaultIcon = "⚫";
  late String currentIcon;
  bool _isHovering = false;
  final LayerLink _layerLink = LayerLink();

  List<String> emojis = ["👍", "👎", "😀", "😂", "😍", "😡", "😘", "💀", "💩"];
  @override
  void initState() {
    super.initState();

    currentIcon = defaultIcon;
    emojiTotal = widget.emojiTotal;
  }

  void _showOverlay() {
    if (_overlayEntry != null) return;
    _overlayEntry = _buildOverlay();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _buildOverlay() {
    int? hoveredIndex;

    return OverlayEntry(
      builder: (context) => Positioned.fill(
        child: CompositedTransformFollower(
          link: _layerLink,
          offset: const Offset(0, -60),
          showWhenUnlinked: false,
          child: Align(
            alignment: Alignment.topLeft,
            child: MouseRegion(
              onEnter: (_) {
                _isHovering = true;
              },
              onExit: (_) {
                _isHovering = false;
                Future.delayed(const Duration(milliseconds: 100), () {
                  if (!_isHovering) _removeOverlay();
                });
              },
              child: Material(
                elevation: 4,
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: StatefulBuilder(
                    builder: (context, setOverlayState) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: emojis.asMap().entries.map((entry) {
                          final index = entry.key;
                          final emoji = entry.value;
                          return MouseRegion(
                            onEnter: (_) =>
                                setOverlayState(() => hoveredIndex = index),
                            onExit: (_) =>
                                setOverlayState(() => hoveredIndex = null),
                            child: AnimatedScale(
                              scale: hoveredIndex == index ? 1.4 : 1.0,
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeOut,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (currentIcon == defaultIcon)
                                      emojiTotal++;
                                    currentIcon = emoji;
                                    widget.onEmojiTotalChanged(emojiTotal);
                                  });
                                  _removeOverlay();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Material(
                                    color: Colors.transparent,
                                    elevation: hoveredIndex == index ? 8 : 0,
                                    shadowColor: Colors.black45,
                                    shape: const CircleBorder(),
                                    child: Text(
                                      emoji,
                                      style: const TextStyle(fontSize: 24),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        _isHovering = true;
        _showOverlay();
      },
      onExit: (_) {
        _isHovering = false;
        Future.delayed(const Duration(milliseconds: 100), () {
          if (!_isHovering) _removeOverlay();
        });
      },
      child: CompositedTransformTarget(
        link: _layerLink,
        child: GestureDetector(
          onTap: () {
            setState(() {
              if (currentIcon != defaultIcon) emojiTotal--;
              currentIcon = defaultIcon;
              widget.onEmojiTotalChanged(emojiTotal);
            });
          },
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: Text(
              currentIcon,
              key: ValueKey<String>(currentIcon),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                color: currentIcon == defaultIcon
                    ? Colors.blueGrey
                    : Colors.amber,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

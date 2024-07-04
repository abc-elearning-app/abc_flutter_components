import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CurvedNavigationBar extends StatefulWidget {
  final List<Widget> icons;
  final List<Widget> selectedIcons;
  final List<String> titles;
  final int index;
  final Color color;
  final Color iconShadowColor;
  final Color? buttonBackgroundColor;
  final ValueChanged<int> onTap;
  final Curve animationCurve;
  final Duration animationDuration;
  final double height;
  final bool isDarkMode;

  CurvedNavigationBar({
    super.key,
    this.index = 0,
    required this.icons,
    required this.titles,
    required this.onTap,
    required this.color,
    required this.selectedIcons,
    this.iconShadowColor = const Color(0xFFC7B28E),
    this.buttonBackgroundColor,
    this.animationCurve = Curves.linear,
    this.animationDuration = const Duration(milliseconds: 600),
    this.height = 75.0,
    required this.isDarkMode,
  })  : assert(icons.isNotEmpty),
        assert(0 <= index && index < icons.length),
        assert(0 <= height && height <= 75.0);

  @override
  CurvedNavigationBarState createState() => CurvedNavigationBarState();
}

class CurvedNavigationBarState extends State<CurvedNavigationBar>
    with SingleTickerProviderStateMixin {
  late double _startingPos;
  int _endingIndex = 0;
  late double _pos;
  double _buttonHide = 0;
  late Widget _icon;
  late AnimationController _animationController;
  late int _length;
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _icon = widget.selectedIcons[widget.index];
    _length = widget.icons.length;
    _pos = widget.index / _length;
    _startingPos = widget.index / _length;
    _animationController = AnimationController(
      vsync: this,
      value: _pos,
      duration: widget.animationDuration,
    );
    _animationController.addListener(() {
      setState(() {
        _pos = _animationController.value;
        if (_animationController.value == _endingIndex / _length) {
          _icon = widget.selectedIcons[_endingIndex];
        }
      });
    });
  }

  @override
  void didUpdateWidget(CurvedNavigationBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.index != widget.index) {
      final newPosition = widget.index / _length;
      _startingPos = _pos;
      _endingIndex = widget.index;
      _animationController.animateTo(newPosition,
          duration: widget.animationDuration, curve: widget.animationCurve);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: widget.isDarkMode ? Colors.black : Colors.white,
            blurRadius: 10,
            spreadRadius: 20)
      ]),
      height: widget.height + 48,
      child: Stack(
        fit: StackFit.expand,
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          // Current button
          Positioned(
            bottom: -35 - (75.0 - widget.height),
            left: Directionality.of(context) == TextDirection.rtl
                ? null
                : _pos * size.width,
            right: Directionality.of(context) == TextDirection.rtl
                ? _pos * size.width
                : null,
            width: size.width / _length,
            child: Center(
              child: Transform.translate(
                offset: Offset(
                  0,
                  -10 - (1 - _buttonHide) * 80,
                ),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: widget.buttonBackgroundColor ?? widget.color),
                  padding: const EdgeInsets.all(18),
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          boxShadow: [
                            BoxShadow(
                                color: widget.iconShadowColor.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 20)
                          ]),
                      child: _icon),
                ),
              ),
            ),
          ),

          // Curved background
          Positioned(
            left: 0,
            right: 0,
            bottom: 0 - (75.0 - widget.height),
            child: CustomPaint(
              painter: NavCustomPainter(
                  _pos, _length, widget.color, Directionality.of(context)),
              child: Container(height: 95.0),
            ),
          ),

          // Icons
          Positioned(
            left: 0,
            right: 0,
            bottom: 15 - (75.0 - widget.height),
            child: SizedBox(
                height: 100.0,
                child: Row(
                    children: widget.icons.map((item) {
                  return NavButton(
                    onTap: _buttonTap,
                    position: _pos,
                    length: _length,
                    index: widget.icons.indexOf(item),
                    child: Center(child: item),
                  );
                }).toList())),
          ),

          // Titles
          Positioned(
            left: 0,
            right: 0,
            bottom: 20,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: widget.titles.asMap().entries.map((entry) {
                  return SizedBox(
                    width: size.width / widget.titles.length,
                    child: Center(
                      child: Text(
                        entry.value,
                        style: TextStyle(
                          color: Colors.white.withOpacity(
                              entry.key == _currentPageIndex ? 1 : 0.5),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  );
                }).toList()),
          ),
        ],
      ),
    );
  }

  void setPage(int index) {
    _buttonTap(index);
  }

  void _buttonTap(int index) {
    widget.onTap(index);
    final newPosition = index / _length;
    setState(() {
      _currentPageIndex = index;
      _startingPos = _pos;
      _endingIndex = index;
      _animationController.animateTo(
        newPosition,
        duration: widget.animationDuration,
        curve: widget.animationCurve,
      );
    });
  }
}

class NavButton extends StatelessWidget {
  final double position;
  final int length;
  final int index;
  final ValueChanged<int> onTap;
  final Widget child;

  const NavButton({
    super.key,
    required this.onTap,
    required this.position,
    required this.length,
    required this.index,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final desiredPosition = 1.0 / length * index;
    final difference = (position - desiredPosition).abs();
    final verticalAlignment = 1 - length * difference;
    final opacity = length * difference;
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          onTap(index);
        },
        child: SizedBox(
            height: 75.0,
            child: Transform.translate(
              offset: Offset(
                0,
                difference < 1.0 / length ? verticalAlignment * 40 : 0,
              ),
              child: Opacity(
                  opacity: difference < 1.0 / length * 0.99 ? opacity : 1.0,
                  child: child),
            )),
      ),
    );
  }
}

class NavCustomPainter extends CustomPainter {
  late double loc; // Location of the floating button
  late double s; // Span size for the curved effect
  Color color; // Color of the curved background
  TextDirection textDirection; // Text direction (RTL or LTR)

  // Constructor to initialize the custom painter
  NavCustomPainter(
    double startingLoc,
    // Initial location of the floating button
    int itemsLength, // Number of items in the navigation bar
    this.color, // Color of the curved background
    this.textDirection, // Text direction (RTL or LTR)
  ) {
    final span =
        1.0 / itemsLength; // Calculate span size based on the number of items
    s = 0.2; // Set the span size for the curve
    double l = startingLoc +
        (span - s) / 2; // Calculate the initial location of the curve

    // Adjust the location for RTL text direction
    loc = textDirection == TextDirection.rtl ? 0.8 - l : l;
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Define the paint properties
    final paint = Paint()
      ..color = color // Set the color of the paint
      ..style = PaintingStyle.fill; // Set the paint style to fill

    // Create the path for the curved background
    final path = Path()
      ..moveTo(0, 0) // Move to the starting point
      ..lineTo((loc - 0.1) * size.width,
          0) // Draw a line to the starting point of the curve
      ..cubicTo(
        (loc + s * 0.10) * size.width,
        // Adjusted control point 1 (x-coordinate) for less curve
        size.height * 0.10,
        // Adjusted control point 1 (y-coordinate) for less curve
        loc * size.width, // Control point 2 (x-coordinate)
        size.height * 0.50, // Control point 2 (y-coordinate)
        (loc + s * 0.50) * size.width, // End point of the curve (x-coordinate)
        size.height * 0.50, // End point of the curve (y-coordinate)
      )
      ..cubicTo(
        (loc + s) * size.width, // Control point 3 (x-coordinate)
        size.height * 0.50, // Control point 3 (y-coordinate)
        (loc + s - s * 0.10) * size.width,
        // Adjusted control point 4 (x-coordinate) for less curve
        size.height * 0.10,
        // Adjusted control point 4 (y-coordinate) for less curve
        (loc + s + 0.1) * size.width, // End point of the curve (x-coordinate)
        0, // End point of the curve (y-coordinate)
      )
      ..lineTo(size.width, 0) // Draw a line to the top-right corner
      ..lineTo(
          size.width, size.height) // Draw a line to the bottom-right corner
      ..lineTo(0, size.height) // Draw a line to the bottom-left corner
      ..close(); // Close the path

    // Draw the path on the canvas using the defined paint
    canvas.drawPath(path, paint);
  }

  // Determine whether the painter should repaint
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // Repaint only if this painter is different from the old delegate
    return this != oldDelegate;
  }
}

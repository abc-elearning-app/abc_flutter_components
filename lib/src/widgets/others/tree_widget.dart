import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_drawing/src/dash_path.dart';

import '../../../flutter_abc_jsc_components.dart';
import '../../../models/constraints.dart';
import '../../../models/test_info/test_info.dart';
import '../../../models/topic/topic.dart';

class TreeWidget extends StatefulWidget {
  final bool isSingleTest;
  final List<TreeItem>? treeItems;
  final Function(TreeItem treeItem, int index)? onClick;
  final Color? backgroundColor;
  final ScrollController? scrollController;
  final IconType iconType;
  final RotateType rotateType;
  final bool checkUnlockTopic;

  const TreeWidget({
    super.key,
    this.treeItems,
    this.onClick,
    this.backgroundColor,
    this.scrollController,
    this.iconType = IconType.CIRCLE_SHAPE,
    this.rotateType = RotateType.TOP_LEFT,
    required this.isSingleTest,
    required this.checkUnlockTopic,
  });

  @override
  State<TreeWidget> createState() => _TreeWidgetState();
}

class _TreeWidgetState extends State<TreeWidget>
    with SingleTickerProviderStateMixin {
  final Size sizeItem = const Size(60, 100);

  List<TreeItem>? get _treeItems => widget.treeItems;
  final List<GlobalKey> _treeItemKeys = [];
  final List<OffsetItem> _treeItemOffsets = [];
  final GlobalKey _keyOffsetWidget = GlobalKey();
  int currentPart = 0;
  bool _draw = false;
  AnimationController? _controller;
  Animation<double>? _animation;
  final double maxScale = 1.6;

  bool get darkMode =>
      Theme.of(context).colorScheme.brightness == Brightness.dark;

  Color get _treeItemColor => Theme.of(context).colorScheme.primary;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _animation = TweenSequence([
      TweenSequenceItem(tween: Tween<double>(begin: 1, end: 1.2), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 1.2, end: 1.3), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 1.3, end: 1.4), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 1.4, end: 1.5), weight: 1),
      TweenSequenceItem(
          tween: Tween<double>(begin: 1.5, end: maxScale), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 1, end: 1), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 1, end: 1), weight: 1),
    ]).animate(_controller!);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(
          Duration(milliseconds: _treeItems!.length < 12 ? 100 : 200),
          _calcOffset);
      _controller?.repeat(period: const Duration(seconds: 3));
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   ///ToDo làm sao để estimate được cái thời gian delay này.
  //   Future.delayed(Duration(milliseconds: _treeItems.length < 12 ? 300 : 500), _calcOffset);
  // }

  void _calcOffset() {
    final renderBoxRed =
        _keyOffsetWidget.currentContext?.findRenderObject() as RenderBox?;
    Offset? positionRed = renderBoxRed?.localToGlobal(Offset.zero);

    ///get position này chỉ get được start position và gốc O(0;0) tính từ
    ///đỉnh bên trái của màn hình.
    if (positionRed != null && !_draw) {
      setState(() {
        for (GlobalKey<State<StatefulWidget>> key in _treeItemKeys) {
          OffsetItem? item = _getPosition(key, positionRed);
          if (item != null) {
            _treeItemOffsets.add(item);
          }
        }

        ///sau vòng for này thì sẽ lưu được List các position của widget.
        _draw = true;
      });
    }
  }

  OffsetItem? _getPosition(GlobalKey key, Offset offset) {
    try {
      final RenderBox? renderBoxRed =
          key.currentContext?.findRenderObject() as RenderBox?;
      Offset? positionRed = renderBoxRed?.localToGlobal(Offset.zero);
      if (positionRed != null) {
        //ToDo: cần xác định con số này được dùng như thế nào
        return OffsetItem(positionRed.dx + sizeItem.width / 2 - offset.dx,
            positionRed.dy + sizeItem.width / 2 - offset.dy);
      }
      return null;
    } catch (e) {}
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.backgroundColor ?? Theme.of(context).colorScheme.background,
      child: SingleChildScrollView(
        controller: widget.scrollController,
        child: CustomPaint(
          key: _keyOffsetWidget,
          painter: _draw
              ? DrawDragon(
                  offsets: _treeItemOffsets,
                  activeIndex: currentPart,
                  color: darkMode ? Colors.grey : _treeItemColor)
              : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 24),
            child: Column(
              children: _makeTreeItem()
                ..add(SizedBox(height: widget.isSingleTest ? 50 : 0)),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _makeTreeItem() {
    var length = _treeItems?.length;
    List<Widget> widgets = [];

    ///biến temp này để lưu lại số hàng mà treeWidget tạo ra.
    ///Nó chỉ tăng khi kết thúc việc build 1 row trong treeWidget
    int temp = 0;
    Widget widget;
    List<Widget> childs = [];
    currentPart = 0;

    ///lấy currentPart để phục vụ cho việc show animation
    for (int index = 0; index < length!; index++) {
      if (!_treeItems![index].isLock) {
        currentPart = index;
      }
    }

    ///Thêm toàn bộ các Row vào trong TreeWidget
    for (int index = 0; index < length; index++) {
      TreeItem? treeItem = _treeItems?[index];
      if (temp % 2 == 0) {
        childs.add(_makeItem(treeItem!, index, _treeItemColor));

        /// length = 3 thì sẽ ngắt 1 Row và xoá list<widget> childs đi.
        if (childs.length == 3) {
          List<Widget> cs = [];
          cs.addAll(childs);
          widget = _makeRowItem(cs, MainAxisAlignment.spaceBetween);
          temp++;
          childs = [];
          widgets.add(widget);
        }
      } else {
        childs.insert(0, _makeItem(treeItem!, index, _treeItemColor));
        if (childs.length == 2) {
          List<Widget> cs = [];
          cs.addAll(childs);
          widget = _makeRowItem(cs, MainAxisAlignment.spaceEvenly);
          temp++;
          childs = [];
          widgets.add(widget);
        }
      }
    }

    ///với mỗi lần build ĐỦ HÀNG( hàng 3 item hoặc 2 item thì list<Widget>
    ///childs sẽ được clear. Còn nếu không đủ hàng sẽ vào hàm này.
    if (childs.isNotEmpty) {
      if (length == 1) {
        widget = _makeRowItem(childs, MainAxisAlignment.center);
        widgets.add(widget);
      } else if (length == 2) {
        //nếu list có length là 2 thì sẽ add thêm 1 phần tử có index trong list
        //là 1 vào giữa list đó.
        childs.insert(
            1, SizedBox(width: sizeItem.width * 1.5, height: sizeItem.height));
        widget = _makeRowItem(childs, MainAxisAlignment.center);
        widgets.add(widget);
      } else {
        int l = temp % 2 == 0 ? 3 : 2;
        //vòng for này chỉ có tác dụng tạo thêm cho các item SizedBox để đủ các
        //phần tử để có thể tạo Row.
        for (int index = 0; index < l - childs.length; index++) {
          if (temp % 2 == 0) {
            childs
                .add(SizedBox(width: sizeItem.width, height: sizeItem.height));
          } else {
            childs.insert(
                0, SizedBox(width: sizeItem.width, height: sizeItem.height));
          }
        }
        widget = _makeRowItem(
            childs,
            temp % 2 == 0
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment.spaceEvenly);
        widgets.add(widget);
      }
    }
    return widgets;
  }

  Widget _makeRowItem(
      List<Widget> children, MainAxisAlignment mainAxisAlignment) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: mainAxisAlignment,
      children: children,
    );
  }

  BorderRadius _shape(IconType iconType, RotateType rotateType, double size) {
    if (iconType == IconType.CIRCLE_SHAPE) {
      return BorderRadius.circular(size);
    }
    if (iconType == IconType.PARALLELOGRAM_SHAPE) {
      return BorderRadius.only(
          topLeft: const Radius.circular(0),
          bottomLeft: Radius.circular(size / 2),
          bottomRight: const Radius.circular(0),
          topRight: Radius.circular(size / 2));
    }
    if (iconType == IconType.TEARDROP_SHAPE) {
      switch (rotateType) {
        case RotateType.TOP_LEFT:
          return BorderRadius.only(
              topLeft: const Radius.circular(0),
              bottomLeft: Radius.circular(size),
              bottomRight: Radius.circular(size),
              topRight: Radius.circular(size));
        case RotateType.TOP_RIGHT:
          return BorderRadius.only(
              topLeft: Radius.circular(size),
              bottomLeft: Radius.circular(size),
              bottomRight: Radius.circular(size),
              topRight: const Radius.circular(0));
        case RotateType.BOTTOM_RIGHT:
          return BorderRadius.only(
              topLeft: Radius.circular(size),
              bottomLeft: Radius.circular(size),
              bottomRight: const Radius.circular(0),
              topRight: Radius.circular(size));
        case RotateType.BOTTOM_LEFT:
          return BorderRadius.only(
              topLeft: Radius.circular(size),
              bottomLeft: const Radius.circular(0),
              bottomRight: Radius.circular(size),
              topRight: Radius.circular(size));
        default:
          return BorderRadius.only(
              topLeft: const Radius.circular(0),
              bottomLeft: Radius.circular(size),
              bottomRight: Radius.circular(size),
              topRight: Radius.circular(size));
      }
    }
    return BorderRadius.circular(8);
  }

  Widget _getWidgetFromIconType(
      {required Widget child, required IconType iconType}) {
    if (iconType != IconType.POLYGON_SHAPE) {
      return child;
    }
    return Container(
      child: child,
    );
  }

  Widget _rotate({required Widget child, required RotateType rotateType}) {
    switch (rotateType) {
      case RotateType.TOP_CENTER:
        return Transform.rotate(
          angle: pi / 4,
          child: child,
        );
      case RotateType.CENTER_LEFT:
        return Transform.rotate(
          angle: pi * 3 / 4,
          child: child,
        );
      case RotateType.CENTER_RIGHT:
        return Transform.rotate(
          angle: -pi / 4,
          child: child,
        );
      case RotateType.BOTTOM_CENTER:
        return Transform.rotate(
          angle: pi * 5 / 4,
          child: child,
        );
      default:
        return child;
    }
  }

  Widget _rotateRollBack(
      {required Widget child, required RotateType rotateType}) {
    switch (rotateType) {
      case RotateType.TOP_CENTER:
        return Transform.rotate(
          angle: -pi / 4,
          child: child,
        );
      case RotateType.CENTER_LEFT:
        return Transform.rotate(
          angle: -pi * 3 / 4,
          child: child,
        );
      case RotateType.CENTER_RIGHT:
        return Transform.rotate(
          angle: pi / 4,
          child: child,
        );
      case RotateType.BOTTOM_CENTER:
        return Transform.rotate(
          angle: -pi * 5 / 4,
          child: child,
        );
      default:
        return child;
    }
  }

  Future<bool> get delay async {
    await Future.delayed(const Duration(milliseconds: 200));
    return Future.value(true);
  }

  bool isShowProTag(BuildContext context, TreeItem treeItem, int index) {
    var topic = treeItem.entity;
    if (topic is ITopic) {
      if (treeItem.isFreeToday) {
        return false;
      }
      return widget.checkUnlockTopic;
    }
    return false;
  }

  Widget _makeItem(TreeItem treeItem, int index, Color color) {
    GlobalKey key = GlobalKey();
    _treeItemKeys.add(key);
    // treeItem.isLock
    return Stack(
      children: <Widget>[
        if (index == currentPart && _draw == true)
          FutureBuilder(
              future: delay,
              builder: (context, snapshot) {
                if (snapshot.data == true) {
                  return AnimatedBuilder(
                    animation: _animation!,
                    builder: (context, child) {
                      return Opacity(
                        opacity: maxScale - _animation!.value,
                        child: Transform.scale(
                          scale: _animation!.value,
                          child: _makeItemContent(),
                        ),
                      );
                    },
                  );
                }
                return const SizedBox();
              }),
        Container(
          key: key,
          width: sizeItem.width,
          height: sizeItem.height,
          alignment: Alignment.center,
          child: _draw == true
              ? FadeScaleAnimation(
                  delay: 100 + index * 100,
                  child: Column(
                    children: <Widget>[
                      GestureDetector(
                          onTap: () => widget.onClick!(treeItem, index),
                          child: _makeIcon(treeItem)),
                      const SizedBox(height: 8),
                      Flexible(
                          child: Text(
                        treeItem.name(index),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: darkMode
                                ? Colors.white
                                : const Color(0xFF212121)),
                      ))
                    ],
                  ),
                )
              : const SizedBox(),
        ),
        if (treeItem.isFreeToday)
          Positioned(
              top: sizeItem.width - 10,
              left: sizeItem.width / 2 - 25,
              child: Container(
                  alignment: Alignment.center,
                  width: 50,
                  height: 20,
                  decoration: BoxDecoration(
                      color: const Color(0xFF212121),
                      borderRadius: BorderRadius.circular(4)),
                  child: const Text("Free today",
                      style: TextStyle(fontSize: 8, color: Colors.white))))
        else if (isShowProTag(context, treeItem, index))
          Positioned(
              top: sizeItem.width - 8,
              left: sizeItem.width / 2 - 18,
              child: SvgPicture.asset("assets/static/icons/pro_icon.svg",
                  width: 36)),
      ],
    );
  }

  double _getRotateDegrees(RotateType rotateType) {
    if (rotateType == RotateType.TOP_LEFT ||
        rotateType == RotateType.TOP_RIGHT ||
        rotateType == RotateType.BOTTOM_LEFT ||
        rotateType == RotateType.BOTTOM_RIGHT) {
      return 30;
    }
    return 0;
  }

  Widget _makeItemContent() {
    if (widget.iconType == IconType.POLYGON_SHAPE) {
      return SizedBox(
        width: sizeItem.width,
        height: sizeItem.width,
        child: ClipPolygon(
            sides: 6,
            borderRadius: 5.0,
            // Default 0.0 degrees
            rotate: _getRotateDegrees(widget.rotateType),
            // Default 0.0 degrees
            boxShadows: [
              PolygonBoxShadow(color: Colors.black, elevation: 1.0),
              PolygonBoxShadow(color: Colors.grey, elevation: 5.0)
            ],
            child: Container(
                color: darkMode ? const Color(0xFF212121) : _treeItemColor)),
      );
    }
    return _rotate(
        rotateType: widget.rotateType,
        child: Container(
          width: sizeItem.width,
          height: sizeItem.width,
          decoration: BoxDecoration(
              color: darkMode ? const Color(0xFF4D4D4D) : _treeItemColor,
              borderRadius:
                  _shape(widget.iconType, widget.rotateType, sizeItem.width)),
        ));
  }

  Widget _makeIconWithPolygonShape(TreeItem treeItem) {
    bool notDoYet = false;
    if (treeItem.entity is ITestInfo) {
      notDoYet = treeItem.testInfoTreeItemProperty!.isNotDoYet;
    }
    Color color = _treeItemColor;
    Widget child = Text(notDoYet ? "?" : "${treeItem.progress.round()}%",
        style: const TextStyle(
            color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600));
    if (treeItem.isFreeToday) {
      child = const Icon(Icons.lock_open, size: 24, color: Color(0xFFAEAEC0));
      color = const Color(0xFFEEF0F5);
    }
    if (treeItem.isLock) {
      child = const Icon(Icons.lock, size: 24, color: Color(0xFFAEAEC0));
      color = const Color(0xFFEEF0F5);
    }
    if (treeItem.isPassed) {
      child = const Icon(Icons.done, size: 24, color: Colors.white);
      color = Colors.green;
    }
    if (treeItem.isNotPassed) {
      child = const Icon(Icons.close, size: 24, color: Colors.white);
      color = Colors.red;
    }
    return Container(
      alignment: Alignment.center,
      width: sizeItem.width,
      height: sizeItem.width,
      child: ClipPolygon(
          sides: 6,
          borderRadius: 5.0,
          // Default 0.0 degrees
          rotate: _getRotateDegrees(widget.rotateType),
          // Default 0.0 degrees
          boxShadows: [
            PolygonBoxShadow(color: Colors.black, elevation: 1.0),
            PolygonBoxShadow(color: Colors.grey, elevation: 1.0)
          ],
          child: Container(
              width: sizeItem.width,
              height: sizeItem.width,
              color: color,
              alignment: Alignment.center,
              child: child)),
    );
  }

  Widget _makeIcon(TreeItem treeItem) {
    if (widget.iconType == IconType.POLYGON_SHAPE) {
      return _makeIconWithPolygonShape(treeItem);
    }
    if (treeItem.isFreeToday) {
      return MainIcon(
        icon: const Icon(Icons.lock_open, size: 24, color: Color(0xFFAEAEC0)),
        color: const Color(0xFFEEF0F5),
        size: sizeItem.width,
        useDefault: true,
        iconType: widget.iconType,
        rotateType: widget.rotateType,
      );
    }
    if (treeItem.isLock) {
      return _rotate(
        rotateType: widget.rotateType,
        child: Container(
          width: sizeItem.width,
          height: sizeItem.width,
          decoration: BoxDecoration(
            boxShadow: darkMode
                ? []
                : [
                    const BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0, 1),
                        blurRadius: 1,
                        spreadRadius: 0)
                  ],
            borderRadius:
                _shape(widget.iconType, widget.rotateType, sizeItem.width),
            color: darkMode ? const Color(0xFF383838) : const Color(0xFFEEF0F5),
          ),
          child: _rotateRollBack(
              rotateType: widget.rotateType,
              child:
                  const Icon(Icons.lock, size: 24, color: Color(0xFFAEAEC0))),
        ),
      );
    }
    if (treeItem.isPassed) {
      return MainIcon(
        icon: const Icon(Icons.done, size: 24, color: Colors.white),
        size: sizeItem.width,
        color: Colors.green,
        useDefault: true,
        iconType: widget.iconType,
        rotateType: widget.rotateType,
      );
    }
    if (treeItem.isNotPassed) {
      return MainIcon(
        icon: const Icon(Icons.close, size: 24, color: Colors.white),
        size: sizeItem.width,
        color: Colors.red,
        useDefault: true,
        iconType: widget.iconType,
        rotateType: widget.rotateType,
      );
    }
    bool showX = false;
    if (treeItem.entity is ITestInfo) {
      showX = treeItem.testInfoTreeItemProperty!.isNotDoYet;
    }
    return MainIcon(
      rotateType: widget.rotateType,
      icon: Text(showX ? "?" : "${treeItem.progress.round()}%",
          style: const TextStyle(
              color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
      size: sizeItem.width,
      useDefault: true,
      iconType: widget.iconType,
      color: _treeItemColor,
    );
  }
}

class DrawDragon extends CustomPainter {
  final List<OffsetItem> offsets;
  final int activeIndex;
  final Color? color;
  Paint? _paint;

  int get totalItem => offsets.length;

  DrawDragon({required this.offsets, this.activeIndex = 0, this.color}) {
    _paint = Paint();
    _paint?.color = color ?? Colors.blue;
    _paint?.style = PaintingStyle.stroke;
    _paint?.strokeWidth = 2;
    // debugLog("activeIndex = $activeIndex");
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (int index = 0; index < totalItem; index++) {
      if (index + 1 < totalItem) {
        if ((index - 2) % 5 == 0) {
          _drawHaftCircle(canvas, offsets[index], offsets[index + 1], "right",
              index < activeIndex);
        } else if ((index + 1) % 5 == 0) {
          _drawHaftCircle(canvas, offsets[index], offsets[index + 1], "left",
              index < activeIndex);
        } else {
          _drawLine(
              canvas, offsets[index], offsets[index + 1], index < activeIndex);
        }
      }
    }
  }

  void _drawLine(
      Canvas canvas, OffsetItem offsetFrom, OffsetItem offsetTo, bool active) {
    var path = Path();
    path.moveTo(offsetFrom.dx, offsetFrom.dy);
    path.lineTo(offsetFrom.dx + offsetTo.dx - offsetFrom.dx,
        offsetFrom.dy + offsetTo.dy - offsetFrom.dy);
    //ToDo:
    canvas.drawPath(
      dashPathWidthLimit(path,
          dashArray: CircularIntervalList<double>(<double>[5, 10]),
          limit: active == true ? 1000 : 0)!,
      _paint!,
    );
    path.close();
  }

  void _drawHaftCircle(Canvas canvas, OffsetItem offsetFrom,
      OffsetItem offsetTo, String rotate, bool active) {
    Path path = Path();
    double delta = offsetTo.dy - offsetFrom.dy;
    if (rotate == 'left') {
      path.moveTo(offsetFrom.dx, offsetFrom.dy);
      path.lineTo(offsetTo.dx, offsetFrom.dy);
      path.cubicTo(
          offsetTo.dx - delta * 2 / pi,
          offsetFrom.dy,
          offsetTo.dx - delta * 2 / pi,
          delta + offsetFrom.dy,
          offsetTo.dx,
          offsetTo.dy);
    } else {
      path.moveTo(offsetFrom.dx, offsetFrom.dy);
      path.cubicTo(
          delta * 2 / pi + offsetFrom.dx,
          offsetFrom.dy,
          delta * 2 / pi + offsetFrom.dx,
          delta + offsetFrom.dy,
          offsetFrom.dx,
          offsetTo.dy);
      path.lineTo(offsetTo.dx, offsetTo.dy);
    }
    canvas.drawPath(
      dashPathWidthLimit(path,
          dashArray: CircularIntervalList<double>(<double>[5, 10]),
          limit: active == true ? 1000 : 0)!,
      _paint!,
    );
    path.close();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class OffsetItem {
  double dx;
  double dy;

  OffsetItem(this.dx, this.dy);

  @override
  String toString() {
    return "{ dx: $dx, dy: $dy }";
  }
}

class TopicTreeItemProperty {
  final double flashCardComplete;
  final double percentComplete;
  final bool progressLock;

  TopicTreeItemProperty({
    required this.progressLock,
    required this.flashCardComplete,
    required this.percentComplete,
  });
}

class TestInfoTreeItemProperty {
  final bool lock;
  final bool isPassed;
  final bool isNotPassed;
  final double lastUserTestDataPassPercent;
  final bool isNotDoYet;
  final Function(int level) isLevelPassed;
  final Function(int level) isLevelNotPassed;
  final Function(int level) getPercentPassedByLevel;

  TestInfoTreeItemProperty({
    required this.lock,
    required this.isPassed,
    required this.isNotPassed,
    required this.lastUserTestDataPassPercent,
    required this.isNotDoYet,
    required this.isLevelPassed,
    required this.isLevelNotPassed,
    required this.getPercentPassedByLevel,
  });
}

class TreeItem {
  dynamic entity;
  bool checkFreeToday = false;
  bool flashCard = false;
  TopicTreeItemProperty? topicTreeItemProperty;
  TestInfoTreeItemProperty? testInfoTreeItemProperty;

  TreeItem.testInfo({this.entity, required this.testInfoTreeItemProperty});

  TreeItem.topic(
      {this.entity,
      this.checkFreeToday = false,
      required this.topicTreeItemProperty});

  TreeItem.flashCard({this.entity, required this.topicTreeItemProperty}) {
    flashCard = true;
  }

  String name(int index) => entity is ITopic
      ? ((entity as ITopic).name)
      : (entity is ITestInfo ? 'Test ${index + 1}' : '');

  bool get isLock {
    if (CONFIG_OPEN_ALL_PART_AND_TEST && CONFIG_TEST_MODE) {
      return false;
    }
    return entity is ITopic
        ? topicTreeItemProperty?.progressLock ?? true
        : (entity is ITestInfo
            ? (testInfoTreeItemProperty?.lock ?? true)
            : true);
  }

  bool get isFreeToday => checkFreeToday == true;

  bool get isPassed {
    if (entity is ITopic) {
      return flashCard
          ? topicTreeItemProperty!.flashCardComplete >= 100
          : topicTreeItemProperty!.percentComplete >= 100;
    } else if (entity is ITestInfo) {
      return testInfoTreeItemProperty?.isPassed ?? false;
    }
    return false;
  }

  bool get isNotPassed => (entity is ITestInfo
      ? (testInfoTreeItemProperty?.isNotPassed ?? false)
      : false);

  double get progress {
    if (entity is ITopic) {
      return flashCard
          ? (topicTreeItemProperty?.flashCardComplete ?? 0)
          : (topicTreeItemProperty?.percentComplete ?? 0);
    } else if (entity is ITestInfo) {
      return (testInfoTreeItemProperty?.lastUserTestDataPassPercent ?? 0);
    }
    return 0;
  }

  bool isLevelPassed(int level) {
    if (entity is ITopic) {
      return flashCard
          ? topicTreeItemProperty!.flashCardComplete >= 100
          : topicTreeItemProperty!.percentComplete >= 100;
    } else if (entity is ITestInfo) {
      return testInfoTreeItemProperty?.isLevelPassed(level) ?? false;
    }
    return false;
  }

  bool isLevelNotPassed(int level) => (entity is ITestInfo
      ? (testInfoTreeItemProperty?.isLevelNotPassed(level) ?? false)
      : false);

  double levelProgress(int level) {
    if (entity is ITopic) {
      return flashCard
          ? (topicTreeItemProperty?.flashCardComplete ?? 0)
          : (topicTreeItemProperty?.percentComplete ?? 0);
    } else if (entity is ITestInfo) {
      return (testInfoTreeItemProperty?.getPercentPassedByLevel(level) ?? 0);
    }
    return 0;
  }
}

void showConfirmResetProgress(BuildContext context,
    {String? title, required Function onConfirm, required Function onCancel}) {
  showDialog(
    context: context,
    builder: (context) {
      bool darkMode = Theme.of(context).brightness == Brightness.dark;
      return AlertDialog(
        backgroundColor: darkMode ? const Color(0xFF383838) : Colors.white,
        insetPadding: const EdgeInsets.all(20),
        title: Text(AppStrings.treeWidgetStrings.buttonTryAgain,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: darkMode ? Colors.white : const Color(0xFF272728),
                fontSize: 18,
                fontWeight: FontWeight.w600)),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Text(
              title ?? AppStrings.treeWidgetStrings.resetAllProgress,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: darkMode ? Colors.white : const Color(0xFF575758),
                  fontSize: 16,
                  fontWeight: FontWeight.normal),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                      flex: 1,
                      child: SizedBox(
                        child: MainButton(
                          title: AppStrings.treeWidgetStrings.notNow,
                          onPressed: () => Navigator.of(context).pop(),
                          backgroundColor:
                              darkMode ? Colors.transparent : Colors.white,
                          borderSize: BorderSide(color: Colors.grey.shade300),
                          textColor: darkMode ? Colors.white : Colors.black,
                        ),
                      )),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 1,
                    child: MainButton(
                      title: AppStrings.treeWidgetStrings.buttonReset,
                      onPressed: () => onConfirm.call(),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      );
    },
  );
}

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../flutter_abc_jsc_components.dart';

class TreeWidget extends StatefulWidget {
  final List<TreeItem>? treeItems;
  final Function(TreeItem treeItem, int index)? onClick;
  final Color? backgroundColor;
  final ScrollController? scrollController;
  final IconType iconType;
  final RotateType rotateType;

  const TreeWidget({
    super.key,
    this.treeItems,
    this.onClick,
    this.backgroundColor,
    this.scrollController,
    this.iconType = IconType.CIRCLE_SHAPE,
    this.rotateType = RotateType.TOP_LEFT,
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

  OffsetItem _getPosition(GlobalKey key, Offset offset) {
    try {
      final RenderBox renderBoxRed = key.currentContext.findRenderObject();
      Offset _positionRed = renderBoxRed.localToGlobal(Offset.zero);
      if (_positionRed != null) {
        //ToDo: cần xác định con số này được dùng như thế nào
        return OffsetItem(_positionRed.dx + sizeItem.width / 2 - offset.dx,
            _positionRed.dy + sizeItem.width / 2 - offset.dy);
      }
      return null;
    } catch (e) {}
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.backgroundColor ?? Theme.of(context).backgroundColor,
      child: SingleChildScrollView(
        controller: widget.scrollController,
        child: CustomPaint(
          key: _keyOffsetWidget,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 24),
            child: Column(
              children: _makeTreeItem()
                ..add(SizedBox(height: CheckAppUtils.isSingleTest ? 50 : 0)),
            ),
          ),
          painter: _draw
              ? DrawDragon(
                  offsets: _treeItemOffsets,
                  activeIndex: currentPart,
                  color: darkMode ? Colors.grey : _treeItemColor)
              : null,
        ),
      ),
    );
  }

  List<Widget> _makeTreeItem() {
    int length = _treeItems.length;
    List<Widget> widgets = [];

    ///biến temp này để lưu lại số hàng mà treeWidget tạo ra.
    ///Nó chỉ tăng khi kết thúc việc build 1 row trong treeWidget
    int temp = 0;
    Widget widget;
    List<Widget> childs = [];
    currentPart = 0;

    ///lấy currentPart để phục vụ cho việc show animation
    for (int index = 0; index < length; index++) {
      if (!_treeItems[index].isLock) {
        currentPart = index;
      }
    }

    ///Thêm toàn bộ các Row vào trong TreeWidget
    for (int index = 0; index < length; index++) {
      TreeItem treeItem = _treeItems[index];
      if (temp % 2 == 0) {
        childs.add(_makeItem(treeItem, index, _treeItemColor));

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
        childs.insert(0, _makeItem(treeItem, index, _treeItemColor));
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
        int _l = temp % 2 == 0 ? 3 : 2;
        //vòng for này chỉ có tác dụng tạo thêm cho các item SizedBox để đủ các
        //phần tử để có thể tạo Row.
        for (int index = 0; index < _l - childs.length; index++) {
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

  BorderRadius _shape(
      IconType _iconType, RotateType _rotateType, double _size) {
    if (_iconType == IconType.CIRCLE_SHAPE) {
      return BorderRadius.circular(_size);
    }
    if (_iconType == IconType.PARALLELOGRAM_SHAPE) {
      return BorderRadius.only(
          topLeft: Radius.circular(0),
          bottomLeft: Radius.circular(_size / 2),
          bottomRight: Radius.circular(0),
          topRight: Radius.circular(_size / 2));
    }
    if (_iconType == IconType.TEARDROP_SHAPE) {
      switch (_rotateType) {
        case RotateType.TOP_LEFT:
          return BorderRadius.only(
              topLeft: Radius.circular(0),
              bottomLeft: Radius.circular(_size),
              bottomRight: Radius.circular(_size),
              topRight: Radius.circular(_size));
        case RotateType.TOP_RIGHT:
          return BorderRadius.only(
              topLeft: Radius.circular(_size),
              bottomLeft: Radius.circular(_size),
              bottomRight: Radius.circular(_size),
              topRight: Radius.circular(0));
        case RotateType.BOTTOM_RIGHT:
          return BorderRadius.only(
              topLeft: Radius.circular(_size),
              bottomLeft: Radius.circular(_size),
              bottomRight: Radius.circular(0),
              topRight: Radius.circular(_size));
        case RotateType.BOTTOM_LEFT:
          return BorderRadius.only(
              topLeft: Radius.circular(_size),
              bottomLeft: Radius.circular(0),
              bottomRight: Radius.circular(_size),
              topRight: Radius.circular(_size));
        default:
          return BorderRadius.only(
              topLeft: Radius.circular(0),
              bottomLeft: Radius.circular(_size),
              bottomRight: Radius.circular(_size),
              topRight: Radius.circular(_size));
      }
    }
    return BorderRadius.circular(8);
  }

  Widget _getWidgetFromIconType({Widget child, IconType iconType}) {
    if (iconType != IconType.POLYGON_SHAPE) {
      return child;
    }
    return Container(
      child: child,
    );
  }

  Widget _rotate({Widget child, RotateType rotateType}) {
    switch (rotateType) {
      case RotateType.TOP_CENTER:
        return Transform.rotate(
          angle: pi / 4,
          child: child,
        );
        break;
      case RotateType.CENTER_LEFT:
        return Transform.rotate(
          angle: pi * 3 / 4,
          child: child,
        );
        break;
      case RotateType.CENTER_RIGHT:
        return Transform.rotate(
          angle: -pi / 4,
          child: child,
        );
        break;
      case RotateType.BOTTOM_CENTER:
        return Transform.rotate(
          angle: pi * 5 / 4,
          child: child,
        );
        break;
      default:
        return child;
    }
  }

  Widget _rotateRollBack({Widget child, RotateType rotateType}) {
    switch (rotateType) {
      case RotateType.TOP_CENTER:
        return Transform.rotate(
          angle: -pi / 4,
          child: child,
        );
        break;
      case RotateType.CENTER_LEFT:
        return Transform.rotate(
          angle: -pi * 3 / 4,
          child: child,
        );
        break;
      case RotateType.CENTER_RIGHT:
        return Transform.rotate(
          angle: pi / 4,
          child: child,
        );
        break;
      case RotateType.BOTTOM_CENTER:
        return Transform.rotate(
          angle: -pi * 5 / 4,
          child: child,
        );
        break;
      default:
        return child;
    }
  }

  Future<bool> get delay async {
    await Future.delayed(Duration(milliseconds: 200));
    return Future.value(true);
  }

  bool isShowProTag(BuildContext context, TreeItem treeItem, int index) {
    Topic topic = treeItem.entity;
    if (topic is Topic) {
      if (treeItem.isFreeToday) {
        return false;
      }
      InAppPurchaseModel _inAppPurchaseModel =
          Provider.of<InAppPurchaseModel>(context, listen: false);
      List<RewardAdProgress> rewardProgress =
          Provider.of<AdsModel>(context, listen: false).listRewardProgress;
      return _inAppPurchaseModel.checkUnlockTopic(topic, index, rewardProgress);
    }
    return false;
  }

  Widget _makeItem(TreeItem treeItem, int index, Color color) {
    GlobalKey _key = GlobalKey();
    _treeItemKeys.add(_key);
    // treeItem.isLock
    return Stack(
      children: <Widget>[
        if (index == currentPart && _draw == true)
          FutureBuilder(
              future: delay,
              builder: (context, snapshot) {
                if (snapshot.data == true) {
                  return AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Opacity(
                        opacity: maxScale - _animation.value,
                        child: Transform.scale(
                          scale: _animation.value,
                          child: _makeItemContent(),
                        ),
                      );
                    },
                  );
                }
                return SizedBox();
              }),
        Container(
          key: _key,
          width: sizeItem.width,
          height: sizeItem.height,
          alignment: Alignment.center,
          child: _draw == true
              ? FadeScaleAnimation(
                  delay: 100 + index * 100,
                  child: Column(
                    children: <Widget>[
                      GestureDetector(
                          onTap: () => widget.onClick(treeItem, index),
                          child: _makeIcon(treeItem)),
                      SizedBox(height: 8),
                      Flexible(
                          child: Text(
                        '${treeItem.name(index)}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: darkMode
                                ? Colors.white
                                : MyColors.colorBlackFull),
                      ))
                    ],
                  ),
                )
              : SizedBox(),
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
                      color: MyColors.colorBlackFull,
                      borderRadius: BorderRadius.circular(4)),
                  child: Text("Free today",
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

  double _getRotateDegrees(RotateType _rotateType) {
    if (_rotateType == RotateType.TOP_LEFT ||
        _rotateType == RotateType.TOP_RIGHT ||
        _rotateType == RotateType.BOTTOM_LEFT ||
        _rotateType == RotateType.BOTTOM_RIGHT) {
      return 30;
    }
    return 0;
  }

  Widget _makeItemContent() {
    if (widget.iconType == IconType.POLYGON_SHAPE) {
      return Container(
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
                color: darkMode ? MyColors.darkColorFull : _treeItemColor)),
      );
    }
    return _rotate(
        rotateType: widget.rotateType,
        child: Container(
          width: sizeItem.width,
          height: sizeItem.width,
          decoration: BoxDecoration(
              color: darkMode ? MyColors.darkColorMid : _treeItemColor,
              borderRadius:
                  _shape(widget.iconType, widget.rotateType, sizeItem.width)),
        ));
  }

  Widget _makeIconWithPolygonShape(TreeItem treeItem) {
    bool notDoYet = false;
    if (treeItem.entity is TestInfo) {
      notDoYet = (treeItem.entity as TestInfo).isNotDoYet;
    }
    Color _color = _treeItemColor;
    Widget child = Text(notDoYet ? "?" : "${treeItem.progress.round()}%",
        style: TextStyle(
            color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600));
    if (treeItem.isFreeToday) {
      child = Icon(Icons.lock_open, size: 24, color: Color(0xFFAEAEC0));
      _color = Color(0xFFEEF0F5);
    }
    if (treeItem.isLock) {
      child = Icon(Icons.lock, size: 24, color: Color(0xFFAEAEC0));
      _color = Color(0xFFEEF0F5);
    }
    if (treeItem.isPassed) {
      child = Icon(Icons.done, size: 24, color: Colors.white);
      _color = Colors.green;
    }
    if (treeItem.isNotPassed) {
      child = Icon(Icons.close, size: 24, color: Colors.white);
      _color = Colors.red;
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
              color: _color,
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
        icon: Icon(Icons.lock_open, size: 24, color: Color(0xFFAEAEC0)),
        size: sizeItem.width,
        color: Color(0xFFEEF0F5),
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
                    BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0, 1),
                        blurRadius: 1,
                        spreadRadius: 0)
                  ],
            borderRadius:
                _shape(widget.iconType, widget.rotateType, sizeItem.width),
            color: darkMode ? MyColors.darkColorFull : Color(0xFFEEF0F5),
          ),
          child: _rotateRollBack(
              rotateType: widget.rotateType,
              child: Icon(Icons.lock, size: 24, color: Color(0xFFAEAEC0))),
        ),
      );
    }
    if (treeItem.isPassed) {
      return MainIcon(
        icon: Icon(Icons.done, size: 24, color: Colors.white),
        size: sizeItem.width,
        color: Colors.green,
        useDefault: true,
        iconType: widget.iconType,
        rotateType: widget.rotateType,
      );
    }
    if (treeItem.isNotPassed) {
      return MainIcon(
        icon: Icon(Icons.close, size: 24, color: Colors.white),
        size: sizeItem.width,
        color: Colors.red,
        useDefault: true,
        iconType: widget.iconType,
        rotateType: widget.rotateType,
      );
    }
    bool _showX = false;
    if (treeItem.entity is TestInfo) {
      _showX = (treeItem.entity as TestInfo).isNotDoYet;
    }
    return MainIcon(
      rotateType: widget.rotateType,
      icon: Text(_showX ? "?" : "${treeItem.progress.round()}%",
          style: TextStyle(
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
  final Color color;
  Paint _paint;

  int get totalItem => offsets.length;

  DrawDragon({this.offsets, this.activeIndex = 0, this.color}) {
    _paint = new Paint();
    _paint.color = color ?? Colors.blue;
    _paint.style = PaintingStyle.stroke;
    _paint.strokeWidth = 2;
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
          limit: active == true ? 1000 : 0),
      _paint,
    );
    path.close();
  }

  void _drawHaftCircle(Canvas canvas, OffsetItem offsetFrom,
      OffsetItem offsetTo, String rotate, bool active) {
    Path _path = Path();
    double delta = offsetTo.dy - offsetFrom.dy;
    if (rotate == 'left') {
      _path.moveTo(offsetFrom.dx, offsetFrom.dy);
      _path.lineTo(offsetTo.dx, offsetFrom.dy);
      _path.cubicTo(
          offsetTo.dx - delta * 2 / pi,
          offsetFrom.dy,
          offsetTo.dx - delta * 2 / pi,
          delta + offsetFrom.dy,
          offsetTo.dx,
          offsetTo.dy);
    } else {
      _path.moveTo(offsetFrom.dx, offsetFrom.dy);
      _path.cubicTo(
          delta * 2 / pi + offsetFrom.dx,
          offsetFrom.dy,
          delta * 2 / pi + offsetFrom.dx,
          delta + offsetFrom.dy,
          offsetFrom.dx,
          offsetTo.dy);
      _path.lineTo(offsetTo.dx, offsetTo.dy);
    }
    canvas.drawPath(
      dashPathWidthLimit(_path,
          dashArray: CircularIntervalList<double>(<double>[5, 10]),
          limit: active == true ? 1000 : 0),
      _paint,
    );
    _path.close();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class OffsetItem {
  double dx;
  double dy;

  OffsetItem(double dx, double dy) {
    this.dx = dx;
    this.dy = dy;
  }

  @override
  String toString() {
    return "{ dx: $dx, dy: $dy }";
  }
}

class TreeItem {
  BaseEntity entity;
  bool checkFreeToday = false;
  bool flashCard = false;

  TreeItem.testInfo({this.entity});

  TreeItem.topic({this.entity, this.checkFreeToday});

  TreeItem.flashCard({this.entity}) {
    this.flashCard = true;
  }

  String name(int index) => entity is Topic
      ? ((entity as Topic).content ?? '')
      : (entity is TestInfo ? 'Test ${index + 1}' : '');

  bool get isLock {
    if (CONFIG_OPEN_ALL_PART_AND_TEST && CONFIG_TEST_MODE) {
      return false;
    }
    return entity is Topic
        ? ((entity as Topic).progress?.lock ?? true)
        : (entity is TestInfo ? ((entity as TestInfo).lock ?? true) : true);
  }

  bool get isFreeToday => checkFreeToday == true;

  bool get isPassed {
    if (entity is Topic) {
      Topic _t = entity as Topic;
      return flashCard
          ? _t.getFlashCardComplete() >= 100
          : _t.getPercentComplete() >= 100;
    } else if (entity is TestInfo) {
      return (entity as TestInfo).isPassed ?? false;
    }
    return false;
  }

  bool get isNotPassed => (entity is TestInfo
      ? ((entity as TestInfo).isNotPassed ?? false)
      : false);

  double get progress {
    if (entity is Topic) {
      Topic _t = entity as Topic;
      return flashCard
          ? (_t.getFlashCardComplete().toDouble() ?? 0)
          : (_t.getPercentComplete().toDouble() ?? 0);
    } else if (entity is TestInfo) {
      return ((entity as TestInfo).lastUserTestData?.passedPercent ?? 0);
    }
    return 0;
  }

  bool isLevelPassed(int level) {
    if (entity is Topic) {
      Topic _t = entity as Topic;
      return flashCard
          ? _t.getFlashCardComplete() >= 100
          : _t.getPercentComplete() >= 100;
    } else if (entity is TestInfo) {
      return (entity as TestInfo).isLevelPassed(level) ?? false;
    }
    return false;
  }

  bool isLevelNotPassed(int level) => (entity is TestInfo
      ? ((entity as TestInfo).isLevelNotPassed(level) ?? false)
      : false);

  double levelProgress(int level) {
    if (entity is Topic) {
      Topic _t = entity as Topic;
      return flashCard
          ? (_t.getFlashCardComplete().toDouble() ?? 0)
          : (_t.getPercentComplete().toDouble() ?? 0);
    } else if (entity is TestInfo) {
      return ((entity as TestInfo).mapUserTestData[level]?.passedPercent ?? 0);
    }
    return 0;
  }
}

void showConfirmResetProgress(BuildContext context,
    {String title, Function onConfirm, Function onCancel}) {
  showDialog(
    context: context,
    builder: (context) {
      bool _darkMode = ThemeUtils.getInstance().isDarkMode();
      return AlertDialog(
        backgroundColor: _darkMode ? MyColors.darkColorFull : Colors.white,
        insetPadding: EdgeInsets.all(20),
        title: Text(LocaleKeys.tryAgain.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
                color: _darkMode ? Colors.white : Color(0xFF272728),
                fontSize: 18,
                fontWeight: FontWeight.w600)),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 8),
            Text(
              title ?? LocaleKeys.resetAllProgress.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: _darkMode ? Colors.white : Color(0xFF575758),
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
                        child: NewMainButton(
                          title: LocaleKeys.notNow.tr(),
                          onPressed: () => NavigationService().pop(),
                          backgroundColor:
                              _darkMode ? Colors.transparent : Colors.white,
                          borderSize: BorderSide(color: Colors.grey[300]),
                          textColor: _darkMode ? Colors.white : Colors.black,
                        ),
                      )),
                  SizedBox(width: 8),
                  Expanded(
                    flex: 1,
                    child: NewMainButton(
                      title: LocaleKeys.reset.tr(),
                      onPressed: onConfirm,
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

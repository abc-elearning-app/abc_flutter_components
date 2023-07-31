import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';
import 'package:flutter_svg/svg.dart';

class InlineToaster extends StatefulWidget {
  final String msg;
  final ABCToasterType type;
  final Function onShowToastEnd;
  final String iconPath;

  const InlineToaster({
    super.key,
    required this.msg,
    required this.type,
    required this.onShowToastEnd,
    required this.iconPath,
  });

  @override
  State<InlineToaster> createState() => _InlineToasterState();
}

class _InlineToasterState extends State<InlineToaster> {
  var showToast = true;
  bool disposed = false;

  @override
  void initState() {
    disposed = false;
    Future.delayed(const Duration(seconds: 3)).whenComplete(() {
      if (!disposed) {
        setState(() => showToast = false);
        widget.onShowToastEnd.call();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    disposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (showToast) {
      try {
        Color textColor = Colors.black;
        Color backgroundColor = const Color(0xFFf6f6f6);
        switch (widget.type) {
          case ABCToasterType.failed:
            backgroundColor = const Color(0xFFFCE4E3);
            textColor = const Color(0xFFE31E18);
            break;
          case ABCToasterType.info:
            backgroundColor = const Color(0xFFE4F0FB);
            textColor = const Color(0xFF2183DF);
            break;
          case ABCToasterType.success:
            backgroundColor = const Color(0xFFEBFAF5);
            textColor = const Color(0xFF00C17C);
            break;
          case ABCToasterType.warning:
            backgroundColor = const Color(0xFFFDF8EF);
            textColor = const Color(0xFFEBAD34);
            break;
          default:
        }

        return OpacityAnimation(
          startValue: 0,
          endValue: 1,
          duration: 200,
          delay: 0,
          child: IntrinsicWidth(
            child: Container(
              constraints: const BoxConstraints(minWidth: 50, maxWidth: 250),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: backgroundColor,
                  boxShadow: const [
                    BoxShadow(
                        blurRadius: 2,
                        color: Color(0xFFE5E5E5),
                        spreadRadius: 0,
                        offset: Offset(0, 1))
                  ]),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(widget.iconPath,
                      width: 13, color: textColor),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(widget.msg,
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                            color: textColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500)),
                  ),
                ],
              ),
            ),
          ),
        );
      } catch (e) {
        switch (widget.type) {
          case ABCToasterType.failed:
            showToastError(widget.msg);
            break;
          case ABCToasterType.info:
            showToastInfo(widget.msg);
            break;
          case ABCToasterType.success:
            showToastSuccess(widget.msg);
            break;
          case ABCToasterType.warning:
            showToastWarning(widget.msg);
            break;
          default:
        }
      }
      return Container();
    } else {
      return Container();
    }
  }
}

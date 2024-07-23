import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/src/widgets/new_home_screen/widgets/study_tab_widgets/home_icon.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class SubjectData {
  final String id;
  final String icon;
  final String title;
  final double progress;

  SubjectData({
    required this.id,
    required this.icon,
    required this.title,
    required this.progress,
  });
}

class StudyTabSubjectTile extends StatefulWidget {
  final int index;
  final SubjectData subjectData;
  final Color tileColor;
  final Color tileSecondaryColor;
  final bool isDarkMode;
  final void Function(String id) onSelectSubject;

  const StudyTabSubjectTile({
    super.key,
    required this.index,
    required this.subjectData,
    required this.tileColor,
    required this.tileSecondaryColor,
    required this.isDarkMode,
    required this.onSelectSubject,
  });

  @override
  State<StudyTabSubjectTile> createState() => _StudyTabSubjectTileState();
}

class _StudyTabSubjectTileState extends State<StudyTabSubjectTile> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _translateAnimation;
  late Animation _fadeAnimation;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    _translateAnimation = Tween<double>(begin: 20, end: 0).animate(_animationController);
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_animationController);

    Future.delayed(Duration(milliseconds: 150 * widget.index), () {
      if (mounted) _animationController.forward();
    });
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (_, __) => Transform.translate(
        offset: Offset(0, _translateAnimation.value),
        child: Opacity(
          opacity: _fadeAnimation.value,
          child: GestureDetector(
            onTap: () => widget.onSelectSubject(widget.subjectData.id),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(widget.isDarkMode ? 0.16 : 1),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: !widget.isDarkMode ? [BoxShadow(color: Colors.grey.shade200, blurRadius: 5, spreadRadius: 1)] : null),
              child: Row(
                children: [
                  Container(
                      padding: const EdgeInsets.all(10),
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: widget.tileSecondaryColor,
                      ),
                      child: HomeIcon(icon: widget.subjectData.icon, tileColor: widget.tileColor)),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        widget.subjectData.title,
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: widget.isDarkMode ? Colors.white : Colors.black),
                      ),
                    ),
                  ),
                  CircularPercentIndicator(
                    animation: true,
                    radius: 35,
                    percent: widget.subjectData.progress / 100,
                    progressColor: widget.tileColor,
                    backgroundColor: widget.tileSecondaryColor,
                    circularStrokeCap: CircularStrokeCap.round,
                    lineWidth: 7,
                    center: Text(
                      '${widget.subjectData.progress.toInt()}%',
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: widget.isDarkMode ? Colors.white : Colors.black),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

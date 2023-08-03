import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../flutter_abc_jsc_components.dart';
import '../../../models/constraints.dart';
import '../../../models/enums.dart';
import '../../../models/question/question.dart';
import '../../../models/question/question_status.dart';

class CheckAppModel {
  final bool isPartner;
  final bool isAppFrance;
  final bool pushRankingApp;

  const CheckAppModel({
    required this.isPartner,
    required this.isAppFrance,
    required this.pushRankingApp,
  });
}

class ChoicePanelInAppPurchase {
  final ValueNotifier<bool> inAppPurchaseLock;
  final VoidCallback onInAppPurchaseLockClick;

  const ChoicePanelInAppPurchase({
    required this.inAppPurchaseLock,
    required this.onInAppPurchaseLockClick,
  });
}

class ChoicePanel extends StatefulWidget {
  final IQuestion question;
  final bool instanceFeedback; // show result after
  final bool showResult;
  final double fontSize;
  final Function(IAnswer)? onChoiceSelected;
  final bool review;
  final bool choiceAnimation;
  final bool showAllAnswer;
  final GameType gameType;
  final ModeExam modeExam;
  final String bucket;
  final QuestionStatus questionStatus;
  final bool isTester;
  final CheckAppModel choicePanelCheckApp;
  final ChoicePanelInAppPurchase choicePanelInAppPurchase;
  final List<String> choiceSelectedIds;

  const ChoicePanel({
    super.key,
    required this.question,
    this.instanceFeedback = false,
    this.fontSize = CONFIG_FONT_SIZE_DEFAULT,
    this.onChoiceSelected,
    this.showResult = false,
    this.review = false,
    this.choiceAnimation = true,
    required this.gameType,
    this.showAllAnswer = false,
    required this.modeExam,
    required this.bucket,
    required this.questionStatus,
    required this.isTester,
    required this.choicePanelCheckApp,
    required this.choicePanelInAppPurchase,
    required this.choiceSelectedIds,
  });

  @override
  State<ChoicePanel> createState() => _ChoicePanelState();
}

class _ChoicePanelState extends State<ChoicePanel> {
  bool testMode = (isInDebugMode || CONFIG_TEST_MODE);

  String get _bucket => widget.bucket;

  bool get isShowResult =>
      widget.showResult || (widget.questionStatus != QuestionStatus.notAnswerYet);

  Color get _inCorrectBackgroundColor => const Color(0xFFF08A86);

  Color get _correctBackgroundColor => const Color(0xFF00C17C);

  bool get _showAnswer => !widget.instanceFeedback && isShowResult;

  bool get _darkMode => Theme.of(context).brightness == Brightness.dark;

  bool get _hasMultipleAnswerExplanation {
    int count = 0;
    for (var element in widget.question.allAnswer) {
      if (element.explanation.isNotEmpty) {
        count++;
      }
    }
    return count > 1;
  }

  bool get showAnswerVersion2 => widget.choicePanelCheckApp
      .isPartner; // Hiện đáp tất cả đáp án đúng và sai sau khi trả lời và hiện đáp án có giải thích riêng
  bool get showAnswerVersion3 => widget.choicePanelCheckApp
      .pushRankingApp; // Hiện đáp tất cả đáp án đúng và sai sau khi trả lời

  bool get isTester => widget.isTester;

  @override
  Widget build(BuildContext context) {
    if (widget.question.choices.isEmpty) {
      return Container();
    }
    List<IAnswer> displayChoices = [];
    List<IAnswer> choices = widget.question.allAnswer;
    String firstAnswerCorrectId = "";
    for (int index = 0; index < choices.length; index++) {
      IAnswer choice = choices[index];
      if (choice.isCorrect && firstAnswerCorrectId.isNotEmpty) {
        firstAnswerCorrectId = choice.id;
        break;
      }
      if (showAnswerVersion2 ||
          showAnswerVersion3 ||
          widget.review ||
          widget.instanceFeedback ||
          !_showAnswer ||
          choice.isCorrect ||
          widget.choiceSelectedIds.contains(choice.id) ||
          widget.showAllAnswer) {
        displayChoices.add(choice);
      }
    }
    return Column(
      children: displayChoices
          .map((choice) => _makeChoice(
              firstAnswerCorrect: firstAnswerCorrectId == choice.id,
              fontSize: widget.fontSize,
              choice: choice,
              instanceFeedback: widget.instanceFeedback,
              isTester: isTester,
              questionExplanation: widget.question.explanation,
              showAnswer: _showAnswer,
              context: context,
              modeExam: widget.modeExam))
          .toList(),
    );
  }

  Widget _makeChoice(
      {required bool firstAnswerCorrect,
      required String? questionExplanation,
      IAnswer? choice,
      required bool instanceFeedback,
      required double fontSize,
      required BuildContext context,
      required bool isTester,
      required bool showAnswer,
      ModeExam? modeExam}) {
    String? explanation = choice?.explanation;
    bool showAnswerExplanation =
        explanation != null && explanation.isNotEmpty && showAnswer;
    if (questionExplanation != null &&
        questionExplanation.isNotEmpty &&
        firstAnswerCorrect &&
        showAnswer) {
      showAnswerExplanation = true;
      explanation = questionExplanation;
    }
    if (modeExam != null && modeExam == ModeExam.fast) {
      showAnswerExplanation = false;
      explanation = null;
    }
    bool isAnswered =
        widget.question.status == QuestionStatus.answeredIncorrect ||
            widget.question.status == QuestionStatus.answeredCorrect;

    return InkWell(
        onTap: () async {
          if (widget.onChoiceSelected != null && !showAnswer) {
            widget.onChoiceSelected!(choice);
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              width: double.infinity,
              decoration: ShapeDecoration(
                color:
                    !showAnswer && widget.choiceSelectedIds.contains(choice!.id)
                        ? (_darkMode
                            ? const Color(0xFF8c8c8c)
                            : const Color(0xFFe4e4e4))
                        : (_darkMode ? const Color(0xFF4D4D4D) : Colors.white),
                shape: SmoothRectangleBorder(
                    borderRadius: SmoothBorderRadius(
                        cornerRadius: 12, cornerSmoothing: 1),
                    side: _borderAnswer(choice!, showAnswer, isTester)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: _makeContent(choice, showAnswer),
              ),
            ),
            if (showAnswerExplanation)
              ValueListenableBuilder(
                  valueListenable:
                      widget.choicePanelInAppPurchase.inAppPurchaseLock,
                  builder: (_, locked, __) {
                    final showExplanation = widget.review ||
                        (showAnswerVersion2 && _hasMultipleAnswerExplanation
                            ? (!choice.isCorrect &&
                                widget.choiceSelectedIds.contains(choice.id) &&
                                isAnswered)
                            : isAnswered) ||
                        showAnswerVersion3;
                    return buildExplanation(
                      context,
                      fontSize: fontSize - 4,
                      locked: locked,
                      show: showExplanation,
                      explanation: explanation!,
                      onTap: () {
                        if (locked) {
                          widget
                              .choicePanelInAppPurchase.onInAppPurchaseLockClick
                              .call();
                          return;
                        }
                      },
                    );
                  })
          ],
        ));
  }

  BorderSide _borderAnswer(IAnswer choice, bool showAnswer, bool isTester) {
    bool showAnswerCorrect =
        choice.isCorrect && (testMode || isTester || showAnswer);
    bool showAnswerInCorrect = !choice.isCorrect &&
        showAnswer &&
        widget.choiceSelectedIds.contains(choice.id);
    if (showAnswerCorrect) {
      return BorderSide(color: _correctBackgroundColor, width: 1.5);
    }
    if (showAnswerInCorrect) {
      return BorderSide(color: _inCorrectBackgroundColor, width: 1.5);
    }
    if (widget.choiceSelectedIds.contains(choice.id)) {
      return BorderSide(
          color: const Color(0xFF1D9AF4).withOpacity(0.08), width: 1.5);
    }
    return BorderSide(color: Colors.black.withOpacity(0.08), width: 1.5);
  }

  Widget _makeContent(IAnswer choice, bool showAnswer) {
    String content = choice.text.replaceAll("\$", "");
    if ((content.endsWith(".png") ||
            content.endsWith(".svg") ||
            content.endsWith(".jpg") ||
            content.endsWith(".jpeg")) &&
        widget.choicePanelCheckApp.isAppFrance) {
      String url = "$API_CONFIG/$_bucket/images/$content";
      return CachedNetworkImage(
        height: 80,
        alignment: Alignment.center,
        imageUrl: url,
        placeholder: (context, url) => makeLoading(context),
        errorWidget: (context, url, error) => Container(
            alignment: Alignment.center,
            color: Colors.grey[300],
            width: double.infinity,
            child: const Icon(Icons.error_outline, size: 30)),
      );
    }
    return Container(
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      child: TextContent(
        choice.text,
        TextAlign.left,
        TextStyle(
            color: _darkMode ? Colors.white : const Color(0xFF212121),
            fontSize: widget.fontSize,
            fontWeight: FontWeight.w500),
        answer: true,
        onTapImage: () {
          if (widget.onChoiceSelected != null && !showAnswer) {
            widget.onChoiceSelected!(choice);
          }
        },
      ),
    );
  }
}

Widget buildExplanation(
  BuildContext context, {
  required String explanation,
  required double fontSize,
  required bool locked,
  required bool show,
  required VoidCallback onTap,
  EdgeInsets? padding,
}) {
  bool darkMode = Theme.of(context).brightness == Brightness.dark;
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: darkMode ? Colors.grey.shade700 : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (locked)
            Padding(
              padding: const EdgeInsets.only(top: 16.0, left: 16, right: 16),
              child: Row(
                children: [
                  Text(
                    "Explanation",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: darkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  SvgPicture.asset("assets/static/icons/pro_content_icon.svg",
                      width: 80)
                ],
              ),
            ),
          if (locked) const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                Padding(
                  padding: padding ?? const EdgeInsets.all(16),
                  child: ExplanationWidget(
                    animation: false,
                    explanation: explanation,
                    fontSize: fontSize,
                    show: show,
                    title: AppStrings.gameStrings.gameShowExplanation,
                  ),
                ),
                if (locked)
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                    child: Container(),
                  ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/models/question/question.dart';
import 'package:flutter_abc_jsc_components/models/test_info/test_info.dart';
import 'package:flutter_abc_jsc_components/models/topic/topic.dart';
import 'package:flutter_abc_jsc_components/src/widgets/games/paragraph_widget.dart';
import 'package:flutter_abc_jsc_components/src/widgets/games/question_actions.dart';
import 'package:flutter_abc_jsc_components/src/widgets/games/question_info_panel.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../flutter_abc_jsc_components.dart';
import '../../../models/enums.dart';
import '../../../models/test_setting/test_setting.dart';
import '../../utils/app_utils.dart';

class QuestionPanelNewDataManager {
  final String bucket;
  final bool isShowNativeAds;
  final Function(
      {IQuestion question,
      String bucket,
      ITestInfo testInfo,
      ITopic topic,
      ITopic mainTopic}) debugQuestion;
  final bool isTester;

  QuestionPanelNewDataManager({
    required this.bucket,
    required this.isShowNativeAds,
    required this.debugQuestion,
    required this.isTester,
  });
}

class QuestionPanelNewQuestionProgress {
  final bool bookmark;

  QuestionPanelNewQuestionProgress({required this.bookmark});
}

class QuestionPanelNew extends StatefulWidget {
  final GlobalKey keyQuestion;
  final IQuestion question;
  final IQuestion prevQuestion;
  final GameType gameType;
  final ModeExam? modeExam;
  final TypeOfGame type;
  final Function(IAnswer) onChoiceSelected;
  final Function? onContinue;
  final Function onSkip;
  final VoidCallback onReport;
  final VoidCallback onFavorite;
  final TestSettingNew? testSetting;
  final bool showAds;
  final ITopic topic;
  final ITopic mainTopic;
  final ITestInfo testInfo;
  final bool showAllAnswer;
  final Widget bannerAds;
  final Widget nativeAds;
  final ValueNotifier<double> fontSize;
  final QuestionPanelNewDataManager questionPanelNewDataManager;
  final QuestionPanelNewQuestionProgress questionPanelNewQuestionProgress;

  const QuestionPanelNew({
    super.key,
    required this.question,
    required this.gameType,
    required this.type,
    required this.onReport,
    required this.keyQuestion,
    required this.onChoiceSelected,
    required this.onContinue,
    this.testSetting,
    required this.prevQuestion,
    required this.onFavorite,
    required this.onSkip,
    this.showAds = true,
    required this.topic,
    required this.mainTopic,
    required this.testInfo,
    this.showAllAnswer = false,
    this.modeExam,
    required this.questionPanelNewDataManager,
    required this.bannerAds,
    required this.fontSize,
    required this.nativeAds,
    required this.questionPanelNewQuestionProgress,
  });

  @override
  QuestionPanelState createState() => QuestionPanelState();
}

class QuestionPanelState extends State<QuestionPanelNew>
    with SingleTickerProviderStateMixin {
  String get bucket => widget.questionPanelNewDataManager.bucket;

  bool get instanceFeedback {
    if (widget.modeExam != null) {
      return widget.modeExam == ModeExam.exam;
    }
    return widget.testSetting != null
        ? widget.testSetting!.instanceFeedback
        : false;
  }

  bool get showBannerAd =>
      widget.showAds != false &&
      !widget.questionPanelNewDataManager.isShowNativeAds;

  bool get showNativeAd =>
      widget.showAds != false &&
      widget.questionPanelNewDataManager.isShowNativeAds;

  double widthScreen(BuildContext context) => MediaQuery.of(context).size.width;

  ScrollController? _scrollController;
  bool disposed = false;

  final GlobalKey<SlideTransitionPanelState> _slideTransitionNextPanelKey =
      GlobalKey(debugLabel: "next");
  final GlobalKey<BorderAnimationState> _borderAnimationKey = GlobalKey();

  bool get _darkMode => Theme.of(context).brightness == Brightness.dark;

  var showFavoriteToast = false;
  bool _hideButton = false;

  @override
  void initState() {
    super.initState();
    disposed = false;
    _scrollController = ScrollController();
    widget.questionPanelNewDataManager.debugQuestion(
      question: widget.question,
      bucket: bucket,
      testInfo: widget.testInfo,
      topic: widget.topic,
      mainTopic: widget.mainTopic,
    );
  }

  toggleHideButton() {
    setState(() {
      _hideButton = !_hideButton;
    });
  }

  void onSlideAnimation() {
    _slideTransitionNextPanelKey.currentState?.onAnimated();
  }

  void _onTextsAnimation() {
    _borderAnimationKey.currentState?.onAnimated();
  }

  @override
  void dispose() {
    disposed = true;
    _scrollController?.dispose();
    super.dispose();
  }

  bool get _isInDebugMode => isInDebugMode;

  @override
  Widget build(BuildContext context) {
    if (_isInDebugMode || widget.questionPanelNewDataManager.isTester) {
      print("questionId ${widget.question.id}");
    }
    return RepaintBoundary(
      key: widget.keyQuestion,
      child: Column(
        children: [
          Expanded(
            child: ValueListenableBuilder<double>(
                valueListenable: widget.fontSize,
                builder: (context, fontSize, child) {
                  return SlideTransitionPanel(
                    key: _slideTransitionNextPanelKey,
                    child: _makeContent(context, widget.question, fontSize),
                  );
                }),
          ),
          _makeNewButton(widget.question, context),
          if (showBannerAd) _makeSpacerAd(),
          if (showBannerAd) widget.bannerAds,
        ],
      ),
    );
  }

  Widget _makeSpacerAd() {
    return Container(
      height: 1,
      color: Colors.grey,
      width: double.infinity,
      margin: const EdgeInsets.only(top: 4),
    );
  }

  bool liveShowAd = true;

  Widget _makeContent(
      BuildContext context, IQuestion question, double fontSize) {
    bool checkShowSelected = question.numberCorrectAnswer > 1;
    if (question.listChoices != null &&
        question.numberCorrectAnswer == question.choices.length) {
      checkShowSelected = false;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: ListView(
            controller: _scrollController,
            padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
            children: <Widget>[
              _makeBorderQuestion(
                  testSetting: widget.testSetting!,
                  question: question,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      QuestionInfoPanel(
                        question,
                        widget.gameType,
                        bucket,
                        fontSize: fontSize,
                      ),
                      const SizedBox(height: 4),
                      ParagraphWidget(
                        fontSize: fontSize,
                        paragraph: question.paragraph?.text,
                      ),
                    ],
                  )),
              if (checkShowSelected)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10)
                      .add(const EdgeInsets.only(bottom: 10)),
                  child: Text.rich(
                    TextSpan(
                      text: "Correct answers: ",
                      children: [
                        TextSpan(
                          text:
                              "${question.numberAnswered}/${question.numberCorrect}",
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                        const TextSpan(text: " selected")
                      ],
                    ),
                    style: TextStyle(
                        color: _darkMode
                            ? Colors.white70
                            : const Color(0xFF212121),
                        fontSize: 12),
                  ),
                ),
              ..._makeChoicePanel(context,
                  question: question,
                  instanceFeedback: instanceFeedback,
                  gameType: widget.gameType,
                  fontSize: fontSize,
                  modeExam: widget.modeExam!),
              _nativeAdFullWidget(context, show: liveShowAd),
            ],
          ),
        ),
      ],
    );
  }

  Widget _nativeAdFullWidget(BuildContext context, {bool show = true}) {
    return showNativeAd ? widget.nativeAds : const SizedBox();
  }

  List<Widget> _makeChoicePanel(
    BuildContext context, {
    required IQuestion question,
    required bool instanceFeedback,
    required GameType gameType,
    required double fontSize,
    required ModeExam modeExam,
  }) {
    bool darkMode = Theme.of(context).brightness == Brightness.dark;
    if (question.listChoices != null && question.choices.isNotEmpty) {
      return [
        ChoicePanel(
          question: question,
          fontSize: fontSize,
          showAllAnswer: widget.showAllAnswer ?? false,
          instanceFeedback: instanceFeedback,
          onChoiceSelected: (IAnswer choice) {
            widget.onChoiceSelected.call(choice);
            _onTextsAnimation();
          },
          gameType: gameType,
          modeExam: modeExam,
        )
      ];
    } else if (question.childs != null && question.childs.isNotEmpty) {
      return question.childs.map((q) {
        return Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
              color:
                  darkMode ? MyColors.darkColorFull : MyColors.colorBlackHover,
              borderRadius: BorderRadius.circular(12),
              border: darkMode
                  ? null
                  : Border.all(width: 1, color: MyColors.colorBlackOutline)),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                QuestionInfoPanel(q, gameType, bucket, fontSize: fontSize),
                const SizedBox(height: 8),
                ParagraphWidget(
                    fontSize: fontSize, paragraph: question.paragraph),
                ..._makeChoicePanel(
                  context,
                  question: q,
                  instanceFeedback: instanceFeedback,
                  gameType: gameType,
                  fontSize: fontSize,
                  modeExam: modeExam,
                ),
              ]),
        );
      }).toList();
    }
    return [];
  }

  bool canClick = false;

  Widget _makeNewButton(Question question, BuildContext context) {
    bool skipStatus = widget.gameType == GameType.TEST &&
        widget.onSkip != null &&
        widget.question.questionStatus == QuestionStatus.notAnswerYet;
    bool canContinue =
        !(widget.question.questionStatus == QuestionStatus.notAnswerYet &&
            widget.gameType != GameType.TEST);
    if (widget.modeExam != null && widget.modeExam == ModeExam.exam) {
      skipStatus = true;
    }
    if (_hideButton) {
      return const SizedBox();
    }
    return AnimatedOpacity(
      opacity: canContinue ? 1 : 0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInToLinear,
      child: AnimatedSlide(
        offset: canContinue ? Offset.zero : const Offset(0, 1),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInToLinear,
        child: InkWell(
          onTap: canContinue
              ? () {
                  if (canClick) {
                    return;
                  }
                  canClick = true;
                  Future.delayed(const Duration(milliseconds: 300), () {
                    if (!disposed) {
                      canClick = false;
                    }
                  });
                  if (widget.onContinue != null) {
                    _scrollController.jumpTo(0);
                    if (widget.question.questionStatus ==
                        QuestionStatus.notAnswerYet) {
                      widget.onSkip?.call();
                    } else {
                      widget.onContinue?.call();
                    }
                    onSlideAnimation();
                  }
                }
              : () {
                  ABCToaster.showToast(
                      context: context,
                      msg: LocaleKeys.game_please_select_an_answer.tr(),
                      type: ABCToasterType.warning,
                      position: BottomPosition(width: 200));
                  // showToastWarning("Please select an answer!");
                },
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            alignment: Alignment.center,
            decoration: ShapeDecoration(
              color: skipStatus ? Colors.white : MyTheme.theme.secondaryColor,
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 1, color: MyTheme.theme.secondaryColor),
                borderRadius:
                    SmoothBorderRadius(cornerRadius: 12, cornerSmoothing: 1),
              ),
            ),
            child: Text(
              skipStatus ? "Skip" : "Continue",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: skipStatus ? MyColors.colorBlackFull : Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget _makeHintIcon({String title, String icon, Color color}) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: FadeScaleAnimation(
                child: SvgPicture.asset(icon, width: 24, color: color)),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 1,
            child: Opacity(
              opacity: 0.8,
              child: TextAnimation(
                title,
                style: TextStyle(
                  color: color,
                  fontSize: 13,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _makeBorderQuestion(
      {Question question, Widget child, TestSettingNew testSetting}) {
    String label = "";
    Widget? hintWidget;
    Color _textColor = Color(0xFFC4C4C4);
    Border border = Border.all(color: _textColor, width: 1.5);

    if (testSetting == null) {
      if (question.questionStatus == QuestionStatus.notAnswerYet) {
        if (question.progress.progress.isEmpty) {
          label = LocaleKeys.game_new_question.tr();
        } else if (question.progress.progress.last ==
            QuestionListProgress.correct.index) {
          label = LocaleKeys.game_reviewing.tr();
          _textColor = Color(0xFF00C17C);
          border = Border.all(color: _textColor, width: 1.5);
          hintWidget = _makeHintIcon(
              title: LocaleKeys.game_you_got_this_question_last_time.tr(),
              icon: "assets/static/checked_icon.svg",
              color: _textColor);
        } else if (question.progress.progress.last ==
            QuestionListProgress.incorrect.index) {
          label = LocaleKeys.game_learning.tr();
          _textColor = Color(0xFFEBAD34);
          border = Border.all(color: _textColor, width: 1.5);
          hintWidget = _makeHintIcon(
              title: LocaleKeys.game_you_got_this_wrong_last_time.tr(),
              icon: "assets/static/warning_icon.svg",
              color: _textColor);
        }
      } else if (question.questionStatus == QuestionStatus.answeredCorrect) {
        label = LocaleKeys.game_correct.tr();
        _textColor = Color(0xFF00C17C);
        border = Border.all(color: _textColor, width: 1.5);
        hintWidget = _makeHintIcon(
            title: LocaleKeys.game_you_will_not_see_question.tr(),
            icon: "assets/static/checked_icon.svg",
            color: _textColor);
      } else if (question.questionStatus == QuestionStatus.answeredIncorrect) {
        label = LocaleKeys.game_incorrect.tr();
        _textColor = _darkMode ? Color(0xFFF08A86) : Color(0xFFE31E18);
        border = Border.all(color: _textColor, width: 1.5);
        hintWidget = _makeHintIcon(
            title: LocaleKeys.game_you_will_see_question.tr(),
            icon: "assets/static/warning_icon.svg",
            color: _textColor);
      }
    }
    if (widget.type == TypeOfGame.practiceTest ||
        widget.type == TypeOfGame.examModeSimulator ||
        widget.type == TypeOfGame.examModeFinal) {
      return Container(
        margin: const EdgeInsets.only(top: 0, bottom: 20),
        child: Stack(
          alignment: Alignment.centerRight,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: ShapeDecoration(
                    // border: widget.border,
                    color: _darkMode ? MyColors.darkColorMid : Colors.white,
                    shape: SmoothRectangleBorder(
                      borderRadius: SmoothBorderRadius(
                          cornerRadius: 16, cornerSmoothing: 1),
                    ),
                    shadows: [
                      BoxShadow(
                        blurRadius: 20,
                        color: Colors.black.withOpacity(0.1),
                        offset: Offset(0, 4),
                      )
                    ]),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (gameProgress != null)
                          Expanded(
                              child: Text(
                            "${gameProgress.currentIndex + 1} / ${gameProgress.total}",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: _darkMode
                                  ? Colors.white.withOpacity(0.52)
                                  : Color(0xFF212121),
                            ),
                          )),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: QuestionActionsWidget(
                            onFavorite: () {
                              FirebaseManagement.logEvent(
                                  Constants.event_test_game_button_add_favorite,
                                  parameters: {
                                    "questionId": widget.question.longId,
                                    "shortId": widget.question.id,
                                  });
                              widget.onFavorite.call();
                              setState(() {
                                showFavoriteToast =
                                    widget.question.progress.bookmark;
                              });
                            },
                            question: widget.question,
                            onReport: widget.onReport,
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                    child,
                  ],
                ),
              ),
            ),
            showFavoriteToast
                ? Positioned(
                    right: 75,
                    top: 18,
                    child: InlineToaster(
                      msg: "Added to Favorite!",
                      type: ABCToasterType.success,
                      onShowToastEnd: () {
                        setState(() {
                          showFavoriteToast = false;
                        });
                      },
                    ),
                  )
                : Container(),
          ],
        ),
      );
    }

    return Stack(
      alignment: Alignment.topRight,
      children: [
        BorderAnimation(
          question: widget.question,
          key: _borderAnimationKey,
          border: border,
          label: label,
          textColor: _textColor,
          actions: QuestionActionsWidget(
            onFavorite: () {
              widget.onFavorite.call();
              setState(() {
                showFavoriteToast = widget.question.progress.bookmark;
              });
            },
            bookmark: widget.question,
            onReport: widget.onReport,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [child, hintWidget ?? const SizedBox()],
          ),
        ),
        showFavoriteToast
            ? Positioned(
                right: 75,
                top: 18,
                child: InlineToaster(
                  msg: "Added to Favorite!",
                  type: ABCToasterType.success,
                  onShowToastEnd: () {
                    setState(() {
                      showFavoriteToast = false;
                    });
                  },
                ),
              )
            : Container(),
      ],
    );
  }
}

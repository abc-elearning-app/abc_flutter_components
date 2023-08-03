import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/models/question/question.dart';
import 'package:flutter_abc_jsc_components/models/test_info/test_info.dart';
import 'package:flutter_abc_jsc_components/models/topic/topic.dart';

import '../../../flutter_abc_jsc_components.dart';
import '../../../models/enums.dart';
import '../../../models/question/question_status.dart';
import '../../../models/test_setting/test_setting.dart';

class QuestionPanelNewDataManager {
  final String bucket;
  final SelectDataType selectDataType;
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
    required this.selectDataType,
    required this.isShowNativeAds,
    required this.debugQuestion,
    required this.isTester,
  });
}

class QuestionPanelNewQuestionProgress {
  final bool bookmark;
  final int numberAnswer;
  final List<int> progress;
  final List<String> choiceSelectedIds;
  final QuestionStatus questionStatus;

  QuestionPanelNewQuestionProgress({
    required this.questionStatus,
    required this.bookmark,
    required this.numberAnswer,
    required this.progress,
    required this.choiceSelectedIds,
  });
}

class QuestionPanelNewGameProgress {
  final int currentIndex;
  final int total;

  QuestionPanelNewGameProgress({
    required this.currentIndex,
    required this.total,
  });
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
  final Function? onSkip;
  final VoidCallback onReport;
  final VoidCallback onFavorite;
  final TestSettingNew? testSetting;
  final bool showAds;
  final ITopic topic;
  final ITopic mainTopic;
  final ITestInfo testInfo;
  final bool? showAllAnswer;
  final Widget bannerAds;
  final Widget nativeAds;
  final ValueNotifier<double> fontSize;
  final QuestionPanelNewDataManager questionPanelNewDataManager;
  final QuestionPanelNewQuestionProgress questionPanelNewQuestionProgress;
  final QuestionPanelNewGameProgress? questionPanelNewGameProgress;
  final CheckAppModel checkAppModel;
  final ChoicePanelInAppPurchase choicePanelInAppPurchase;

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
    this.onSkip,
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
    this.questionPanelNewGameProgress,
    required this.choicePanelInAppPurchase,
    required this.checkAppModel,
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
                  questionPanelNewQuestionProgress:
                      widget.questionPanelNewQuestionProgress,
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
                        selectDataType:
                            widget.questionPanelNewDataManager.selectDataType,
                        questionInfoPanelCheckApp: widget.checkAppModel,
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
                              "${widget.questionPanelNewQuestionProgress.numberAnswer}/${question.numberCorrectAnswer}",
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
          bucket: widget.questionPanelNewDataManager.bucket,
          questionStatus:
              widget.questionPanelNewQuestionProgress.questionStatus,
          isTester: widget.questionPanelNewDataManager.isTester,
          choicePanelCheckApp: widget.checkAppModel,
          choicePanelInAppPurchase: widget.choicePanelInAppPurchase,
          choiceSelectedIds:
              widget.questionPanelNewQuestionProgress.choiceSelectedIds,
        )
      ];
    } else if (question.questions != null && question.questions!.isNotEmpty) {
      return question.questions!.map((q) {
        return Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
              color:
                  darkMode ? const Color(0xFF383838) : const Color(0xFFf6f6f6),
              borderRadius: BorderRadius.circular(12),
              border: darkMode
                  ? null
                  : Border.all(width: 1, color: const Color(0xFFe4e4e4))),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                QuestionInfoPanel(
                  q,
                  gameType,
                  bucket,
                  fontSize: fontSize,
                  selectDataType:
                      widget.questionPanelNewDataManager.selectDataType,
                  questionInfoPanelCheckApp: widget.checkAppModel,
                ),
                const SizedBox(height: 8),
                ParagraphWidget(
                    fontSize: fontSize, paragraph: question.paragraph?.text),
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

  Widget _makeNewButton(IQuestion question, BuildContext context) {
    bool skipStatus = widget.gameType == GameType.TEST &&
        widget.onSkip != null &&
        widget.question.status == QuestionStatus.notAnswerYet;
    bool canContinue =
        !(widget.question.status == QuestionStatus.notAnswerYet &&
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
                    _scrollController?.jumpTo(0);
                    if (widget.question.status == QuestionStatus.notAnswerYet) {
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
                      msg: AppStrings.gameStrings.gamePleaseSelectAnAnswer,
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
              color: skipStatus
                  ? Colors.white
                  : Theme.of(context).colorScheme.secondary,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                    width: 1, color: Theme.of(context).colorScheme.secondary),
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
                  color: skipStatus ? const Color(0xFF212121) : Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget _makeHintIcon(
      {required String title, Widget? icon, required Color color}) {
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
              child: icon ?? const SizedBox(),
            ),
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

  Widget _makeBorderQuestion({
    required IQuestion question,
    required Widget child,
    TestSettingNew? testSetting,
    required QuestionPanelNewQuestionProgress questionPanelNewQuestionProgress,
  }) {
    String label = "";
    Widget? hintWidget;
    Color textColor = const Color(0xFFC4C4C4);

    if (testSetting == null) {
      if (question.status == QuestionStatus.notAnswerYet) {
        if (questionPanelNewQuestionProgress.progress.isEmpty) {
          label = AppStrings.gameStrings.gameNewQuestion;
        } else if (questionPanelNewQuestionProgress.progress.last ==
            QuestionListProgress.correct.index) {
          label = AppStrings.gameStrings.gameReviewing;
          textColor = const Color(0xFF00C17C);
          hintWidget = _makeHintIcon(
              title: AppStrings.gameStrings.gameYouGotThisQuestionLastTime,
              icon: ToastCheckedIcon(
                color: getHexCssColor(textColor),
                height: 24,
                width: 24,
              ),
              color: textColor);
        } else if (questionPanelNewQuestionProgress.progress.last ==
            QuestionListProgress.incorrect.index) {
          label = AppStrings.gameStrings.gameLearning;
          textColor = const Color(0xFFEBAD34);
          hintWidget = _makeHintIcon(
              title: AppStrings.gameStrings.gameYouGotThisWrongLastTime,
              icon: ToastWarningIcon(
                color: getHexCssColor(textColor),
                height: 24,
                width: 24,
              ),
              color: textColor);
        }
      } else if (question.status == QuestionStatus.answeredCorrect) {
        label = AppStrings.gameStrings.gameCorrect;
        textColor = const Color(0xFF00C17C);
        hintWidget = _makeHintIcon(
            title: AppStrings.gameStrings.gameYouWillNotSeeQuestion,
            icon: ToastCheckedIcon(
              color: getHexCssColor(textColor),
              height: 24,
              width: 24,
            ),
            color: textColor);
      } else if (question.status == QuestionStatus.answeredIncorrect) {
        label = AppStrings.gameStrings.gameIncorrect;
        textColor =
            _darkMode ? const Color(0xFFF08A86) : const Color(0xFFE31E18);
        hintWidget = _makeHintIcon(
            title: AppStrings.gameStrings.gameYouWillSeeQuestion,
            icon: ToastWarningIcon(
              color: getHexCssColor(textColor),
              height: 24,
              width: 24,
            ),
            color: textColor);
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
                    color: _darkMode ? const Color(0xFF4D4D4D) : Colors.white,
                    shape: SmoothRectangleBorder(
                      borderRadius: SmoothBorderRadius(
                          cornerRadius: 16, cornerSmoothing: 1),
                    ),
                    shadows: [
                      BoxShadow(
                        blurRadius: 20,
                        color: Colors.black.withOpacity(0.1),
                        offset: const Offset(0, 4),
                      )
                    ]),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (widget.questionPanelNewGameProgress != null)
                          Expanded(
                              child: Text(
                            "${widget.questionPanelNewGameProgress!.currentIndex + 1} / ${widget.questionPanelNewGameProgress!.total}",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: _darkMode
                                  ? Colors.white.withOpacity(0.52)
                                  : const Color(0xFF212121),
                            ),
                          )),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: QuestionActionsWidget(
                            onFavorite: () {
                              FirebaseCallbacks.logEvent(
                                  "event_test_game_button_add_favorite",
                                  parameters: {
                                    "questionId": widget.question.id,
                                    "shortId": widget.question.shortId,
                                  });
                              widget.onFavorite.call();
                              setState(() {
                                showFavoriteToast = widget
                                    .questionPanelNewQuestionProgress.bookmark;
                              });
                            },
                            onReport: widget.onReport,
                            bookmark: widget
                                .questionPanelNewQuestionProgress.bookmark,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
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
          key: _borderAnimationKey,
          label: label,
          textColor: textColor,
          actions: QuestionActionsWidget(
            onFavorite: () {
              widget.onFavorite.call();
              setState(() {
                showFavoriteToast =
                    widget.questionPanelNewQuestionProgress.bookmark;
              });
            },
            bookmark: widget.questionPanelNewQuestionProgress.bookmark,
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

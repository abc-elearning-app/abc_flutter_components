import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

Widget getRatingBottomSheet({
  required BuildContext context,
  required VoidCallback onSubmit,
  required VoidCallback ratingDataRecordDecline,
  required VoidCallback goToAtStore,
  required VoidCallback rattingDataRecordRated,
}) {
  RemoteSettingTotal remoteSettingTotal = RemoteSettingTotal(
    question1: AppStrings.ratingStrings.ratingQuestion1,
    question2: AppStrings.ratingStrings.ratingQuestion2,
    question3: AppStrings.ratingStrings.ratingQuestion3,
  );
  return RatingBottomSheet(
    remoteSettingTotal: remoteSettingTotal,
    onSubmit: onSubmit,
    goToAtStore: goToAtStore,
    ratingDataRecordDecline: ratingDataRecordDecline,
    rattingDataRecordRated: rattingDataRecordRated,
  );
}

void showRatingFeedbackBottomSheet(
  BuildContext context, {
  VoidCallback? callback,
  required bool isDarkMode,
  required VoidCallback onSubmit,
  required VoidCallback ratingDataRecordDecline,
  required VoidCallback goToAtStore,
  required VoidCallback rattingDataRecordRated,
}) {
  showMyModalBottomSheet(
    context: context,
    isScrollControlled: true,
    enableDrag: true,
    backgroundColor: Colors.transparent,
    isDarkMode: isDarkMode,
    widget: getRatingBottomSheet(
        context: context,
        onSubmit: onSubmit,
        ratingDataRecordDecline: ratingDataRecordDecline,
        goToAtStore: goToAtStore,
        rattingDataRecordRated: ratingDataRecordDecline),
  ).then((value) {
    callback?.call();
  });
}

class FeedbackItem {
  int id;
  String name;

  FeedbackItem({required this.id, required this.name});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      "id": id,
      "name": name,
    };
    return map;
  }

  @override
  String toString() {
    return "FeedbackItem: id = $id, name = $name; ";
  }
}

class RatingBottomSheet extends StatefulWidget {
  final String? configAppName;
  final RemoteSettingTotal? remoteSettingTotal;
  final VoidCallback onSubmit;
  final VoidCallback ratingDataRecordDecline;
  final VoidCallback goToAtStore;
  final VoidCallback rattingDataRecordRated;

  const RatingBottomSheet({
    super.key,
    this.remoteSettingTotal,
    required this.onSubmit,
    this.configAppName,
    required this.ratingDataRecordDecline,
    required this.goToAtStore,
    required this.rattingDataRecordRated,
  });

  @override
  State<RatingBottomSheet> createState() => _RatingBottomSheetState();

  final int feedbackItemOther = 6;

  List<FeedbackItem> get feedbackItems {
    List<FeedbackItem> list = [];
    list.add(FeedbackItem(id: 1, name: AppStrings.ratingStrings.feedbackItem1));
    list.add(FeedbackItem(id: 2, name: AppStrings.ratingStrings.feedbackItem2));
    list.add(FeedbackItem(id: 3, name: AppStrings.ratingStrings.feedbackItem3));
    list.add(FeedbackItem(id: 4, name: AppStrings.ratingStrings.feedbackItem4));
    list.add(FeedbackItem(id: 5, name: AppStrings.ratingStrings.feedbackItem5));

    list.add(FeedbackItem(id: 7, name: AppStrings.ratingStrings.feedbackItem7));
    list.add(FeedbackItem(id: 8, name: AppStrings.ratingStrings.feedbackItem8));
    list.add(FeedbackItem(id: 9, name: AppStrings.ratingStrings.feedbackItem9));
    list.add(
        FeedbackItem(id: 10, name: AppStrings.ratingStrings.feedbackItem10));

    list.add(FeedbackItem(
        id: feedbackItemOther, name: AppStrings.ratingStrings.feedbackItem6));

    return list;
  }

  String replaceAppNameStoreName(
      String content, BuildContext context, String configAppName) {
    ThemeData themeData = Theme.of(context);
    String storeName = themeData.platform == TargetPlatform.android
        ? "Google Play"
        : "AppStore";
    return content
        .replaceAll("#appName", configAppName)
        .replaceAll("#storeName", storeName);
  }
}

class _RatingBottomSheetState extends State<RatingBottomSheet> {
  RemoteSettingTotal? get remoteSettingTotal => widget.remoteSettingTotal;

  Map<int, FeedbackItem> feedbackChecked = {};
  FocusNode focusNode = FocusNode();
  final _textContentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final GlobalKey<SlideTransitionPanelState> _slideTransitionPanelState =
      GlobalKey();

  final int screenSendFeedback = 0;
  final int screenAskFeedback = 1;
  final int screenAskRating = 2; // first
  final int screenRating = 3;

  TextStyle get _textStyle {
    return TextStyle(color: Theme.of(context).colorScheme.onSurface);
  }

  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    currentPage = screenAskRating;
  }

  @override
  void dispose() {
    super.dispose();
    focusNode.dispose();
    _textContentController.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget? widget;
    if (currentPage == screenSendFeedback) widget = _makeSendFeedback();
    if (currentPage == screenAskFeedback) widget = _makeAskFeedback();
    if (currentPage == screenRating) widget = _makeRating();
    if (currentPage == screenAskRating) widget = _makeAskRating();
    return SlideTransitionPanel(
      key: _slideTransitionPanelState,
      child: widget,
    );
  }

  Widget _makeSendFeedback() {
    List<FeedbackItem> list = widget.feedbackItems;
    int length = list.length;
    List<Widget> widgets = [];
    for (int index = 0; index < length; index++) {
      int id = list[index].id;
      String name = list[index].name;
      bool selected = feedbackChecked.containsKey(id);
      Color textColor = selected
          ? Theme.of(context).colorScheme.onSurface
          : Theme.of(context).colorScheme.onSurface.withOpacity(0.54);
      widgets.add(_makeRowSelectItem(textColor, id, name, length - 1 == index));
      if (length - 1 == index) {
        widgets.add(_makeRowExpand(selected));
      }
    }
    widgets.add(_makeSubmitButton());
    EdgeInsets viewInsets = MediaQuery.of(context).viewInsets;
    double height = viewInsets.bottom + viewInsets.top;
    return Padding(
      padding: viewInsets,
      child: Container(
        constraints: BoxConstraints(
            maxHeight:
                MediaQuery.of(context).size.height - height - kToolbarHeight),
        padding:
            const EdgeInsets.only(top: 35, left: 20, bottom: 20, right: 20),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: widgets,
          ),
        ),
      ),
    );
  }

  void _scrollTo(double offset) async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          offset + 250,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 200),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Widget _makeSubmitButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      child: MainButton(
        title: AppStrings.ratingStrings.submit,
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: widget.onSubmit,
      ),
    );
  }

  Widget _makeRowExpand(bool selected) {
    return Opacity(
      opacity: selected ? 1 : 0.0,
      child: Container(
        padding: const EdgeInsets.only(left: 15, right: 15),
        height: selected ? 60 : 0.0,
        child: TextField(
          controller: _textContentController,
          cursorColor:
              Theme.of(context).colorScheme.onSurface.withOpacity(0.54),
          focusNode: focusNode,
          decoration: InputDecoration(
              border: const UnderlineInputBorder(
                borderSide: BorderSide(
                  width: 1,
                ),
              ),
              hintText: AppStrings.ratingStrings.ratingHint,
              hintStyle: const TextStyle(
                  color: Color(0xFFB8B8B8), fontWeight: FontWeight.w500),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  width: 1,
                  color: Colors.grey.shade400,
                ),
              )),
          style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface, fontSize: 15),
        ),
      ),
    );
  }

  Widget _makeRowSelectItem(Color textColor, int id, String name, bool other) {
    bool selected = feedbackChecked.containsKey(id);
    return InkWell(
      onTap: () {
        _onSelected(id, name);
        if (other) {
          focusNode.requestFocus();
          if (feedbackChecked.containsKey(id)) {
            _scrollTo(_scrollController.position.maxScrollExtent);
          }
        } else {
          focusNode.unfocus();
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            MyCheckBox(
              value: selected,
              onChanged: (_) {
                _onSelected(id, name);
                if (other) {
                  focusNode.requestFocus();
                  _scrollTo(_scrollController.position.maxScrollExtent);
                } else {
                  focusNode.unfocus();
                }
              },
              activeColor: Theme.of(context).colorScheme.primary,
              checkColor: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                name,
                style: TextStyle(color: textColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSelected(int id, String name) {
    setState(() {
      if (feedbackChecked.containsKey(id)) {
        feedbackChecked.remove(id);
      } else {
        feedbackChecked[id] = FeedbackItem(id: id, name: name);
      }
    });
  }

  Widget _makeAskFeedback() {
    return _makeContentPage(
        icon: const RatingMenuIcon3(width: 120),
        title: Text(
          widget.replaceAppNameStoreName(
            remoteSettingTotal?.question3 ?? "App",
            context,
            widget.configAppName ?? "",
          ),
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w600,
              fontSize: 20),
        ),
        yesButton: _makeYesButton(
          text: AppStrings.ratingStrings.okSure,
          onPressed: () {
            FirebaseCallbacks.logEvent("giving_feedback");
            _gotoPage(screenSendFeedback);
          },
        ),
        noButton: _makeNoButton(
          text: AppStrings.ratingStrings.noThanks,
          onPressed: () {
            FirebaseCallbacks.logEvent("not_giving_feedback");
            Navigator.of(context).pop();
          },
        ));
  }

  Widget _makeRating() {
    return _makeContentPage(
      icon: const RatingMenuIcon2(width: 120),
      title: Text(
        widget.replaceAppNameStoreName(
          remoteSettingTotal?.question2 ?? "App",
          context,
          widget.configAppName ?? "",
        ),
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w600,
            fontSize: 20),
      ),
      yesButton: _makeYesButton(
          text: AppStrings.ratingStrings.okSure,
          onPressed: () {
            Navigator.of(context).pop();
            _gotoRating();
          }),
      noButton: _makeNoButton(
        text: AppStrings.ratingStrings.noThanks,
        onPressed: () {
          FirebaseCallbacks.logEvent("ignore_rate");
          Navigator.of(context).pop();
          widget.ratingDataRecordDecline();
        },
      ),
    );
  }

  Widget _makeYesButton(
      {required String text, required VoidCallback onPressed}) {
    return SizedBox(
      width: double.infinity,
      child: MainButton(
        title: text,
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: onPressed,
      ),
    );
  }

  Widget _makeNoButton(
      {required String text, required VoidCallback onPressed}) {
    return SizedBox(
      width: double.infinity,
      child: MainButton(
        padding: const EdgeInsets.all(8),
        title: text,
        backgroundColor: Colors.transparent,
        onPressed: onPressed,
        borderSize: null,
        textColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _makeAskRating() {
    return _makeContentPage(
        icon: const RatingMenuIcon1(width: 120),
        title: Text(
          widget.replaceAppNameStoreName(
            remoteSettingTotal?.question1 ?? "App",
            context,
            widget.configAppName ?? "",
          ),
          textAlign: TextAlign.center,
          style: _textStyle.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        yesButton: _makeYesButton(
          text: AppStrings.ratingStrings.yes,
          onPressed: () {
            FirebaseCallbacks.logEvent("enjoying_app");
            _gotoPage(screenRating);
          },
        ),
        noButton: _makeNoButton(
          text: AppStrings.ratingStrings.notReally,
          onPressed: () {
            FirebaseCallbacks.logEvent("not_enjoying_app");
            _gotoPage(screenAskFeedback);
          },
        ));
  }

  Widget _makeContentPage({
    required Widget icon,
    required Widget title,
    required Widget yesButton,
    required Widget noButton,
  }) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(20),
            child: icon,
          ),
          title,
          const SizedBox(height: 30),
          Row(
            children: <Widget>[
              Expanded(
                child: yesButton,
              )
            ],
          ),
          noButton,
          const SizedBox(height: 20)
        ],
      ),
    );
  }

  void _gotoPage(int page) {
    setState(() {
      currentPage = page;
    });
    _slideTransitionPanelState.currentState?.onAnimated();
  }

  void _gotoRating() async {
    FirebaseCallbacks.logEvent("accept_rate");
    widget.goToAtStore.call();
// SharedPreferences _sharedPreferences = await DataManager.getInstance().getSharedPreferences();
// String key = "@key.show_review_in_app";
// DateTime currentTime = DateTime.now();
// int time = _sharedPreferences.getInt(key);
// final InAppReview inAppReview = InAppReview.instance;
// debugLog("_gotoRating");
// if(time == null || time <= 0 || currentTime.difference(DateTime.fromMillisecondsSinceEpoch(time)).inDays >= 15) {
//   debugLog("inAppReview.requestReview");
//   try {
//     if(await inAppReview.isAvailable()) {
//       try {
//         inAppReview.requestReview();
//       } catch(e) {
//         debugLog("openStoreListing");
//         try {
//           inAppReview.openStoreListing(appStoreId: CONFIG_APPLE_ID);
//         } catch(e){
//           gotoRatingAtStore();
//         }
//       }
//     } else {
//       gotoRatingAtStore();
//     }
//   } catch(e){
//     gotoRatingAtStore();
//   }
// } else {
//   debugLog("inAppReview.openStoreListing");
//   gotoRatingAtStore();
// }
    widget.rattingDataRecordRated.call();
  }

// void _onReportApp() async {
//   if (feedbackChecked.isEmpty ||
//       (feedbackChecked.length == 1 &&
//           feedbackChecked.containsKey(widget.feedbackItemOther) &&
//           (feedbackChecked[widget.feedbackItemOther] == null ||
//               feedbackChecked[widget.feedbackItemOther].name == null ||
//               feedbackChecked[widget.feedbackItemOther].name.isEmpty))) {
//     FirebaseManagement.logEvent("feedback_empty");
//     return;
//   }
//   try {
//     String json = jsonEncode(
//         feedbackChecked.values.map((FeedbackItem e) => e.toMap()).toList());
//     await NetworkManagement.instance.reportApp(json).then((value) {
//       FirebaseManagement.logEvent("feedback_success");
//     });
//   } catch (e) {
//     print('_onReportApp catchError $e');
//     FirebaseManagement.logEvent("feedback_failed");
//   }
//   ABCToaster.showToast(
//       context: context,
//       msg: LocaleKeys.thanks_for_feedback.tr(),
//       type: ABCToasterType.success);
// }
}

class RemoteSettingTotal {
  String question1;
  String question2; // (yes: question1)
  String question3; // (no: question2)
  List<String> appIds;

  RemoteSettingTotal({
    this.question1 = "",
    this.question2 = "",
    this.question3 = "",
    this.appIds = const [],
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    map['question1'] = question1;
    map['question2'] = question2;
    map['question3'] = question3;
    map['appIds'] = appIds.toString();
    return map;
  }

  factory RemoteSettingTotal.fromMap(Map<String, dynamic> map) =>
      RemoteSettingTotal(
        appIds: map["appIds"].cast<String>(),
        question1: map['question1'] ?? "",
        question2: map['question2'] ?? "",
        question3: map['question3'] ?? "",
      );

  static findConfigFromData(List<dynamic> listConfig, String configAppId) {
    for (int i = 0; i < listConfig.length; i++) {
      List<String> ids = listConfig[i]["appIds"].cast<String>();
      if (ids.contains(configAppId)) {
        return RemoteSettingTotal.fromMap(listConfig[i]);
      }
    }
    return null;
  }
}

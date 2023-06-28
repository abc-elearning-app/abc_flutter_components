// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:figma_squircle/figma_squircle.dart';
// import 'package:flutter/material.dart';
//
// import '../../index.dart';
//
// String get _bucket => DataManager.getInstance().getBucket();
// final int version =
//     2; // 1: hiển thị explanation xuống cuối, 2: hiển thị explanation dưới câu trả lơi đúng
//
// class ReviewChoicePanel extends StatelessWidget {
//   final Question question;
//
//   ReviewChoicePanel({this.question});
//
//   Color get _correctBackgroundColor => Color(0xFF00C17C);
//
//   bool get _darkMode => ThemeUtils.getInstance().isDarkMode();
//
//   @override
//   Widget build(BuildContext context) {
//     if (question.choices == null || question.choices.isEmpty) {
//       return Container();
//     }
//     List<Widget> _items = [];
//     bool checkShowExplanationLastList = true;
//     for (Choice choice in question.choices) {
//       _items.add(_makeChoice(choice: choice, context: context));
//       if (choice.explanation != null && choice.explanation.isNotEmpty) {
//         checkShowExplanationLastList = false;
//       }
//     }
//     if (checkShowExplanationLastList && version == 1) {
//       _items.add(Container(
//         width: double.infinity,
//         padding: EdgeInsets.all(16),
//         decoration: BoxDecoration(
//             color: Colors.white.withOpacity(0.52),
//             borderRadius: BorderRadius.circular(12)),
//         child: ExplanationWidget(
//           animation: false,
//           explanation: question.explanation,
//           fontSize: 12,
//           show: true,
//           title: LocaleKeys.game_show_explanation.tr(),
//         ),
//       ));
//     }
//
//     return Column(
//       children: _items,
//     );
//   }
//
//   Widget _makeChoice({Choice choice, BuildContext context}) {
//     String explanation = question.explanation;
//     bool showExplanation = false;
//     if (version == 2) {
//       showExplanation = explanation != null && explanation.isNotEmpty;
//       if (question.numberCorrect > 1) {
//         showExplanation = showExplanation &&
//             question.choices.where((element) => element.isCorrect).last?.id ==
//                 choice.id;
//       } else {
//         showExplanation = showExplanation && choice.isCorrect;
//       }
//     } else if (choice.explanation != null && choice.explanation.isNotEmpty) {
//       showExplanation = true;
//       explanation = choice.explanation;
//     }
//
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Container(
//           margin: EdgeInsets.symmetric(vertical: 4),
//           width: double.infinity,
//           decoration: ShapeDecoration(
//             color: (_darkMode ? MyColors.darkColorMid : Colors.white),
//             shape: SmoothRectangleBorder(
//                 borderRadius:
//                     SmoothBorderRadius(cornerRadius: 12, cornerSmoothing: 1),
//                 side: _borderAnswer(choice)),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 12),
//             child: _makeContent(choice),
//           ),
//         ),
//         if (showExplanation)
//           Container(
//             width: double.infinity,
//             padding: EdgeInsets.all(16),
//             decoration: BoxDecoration(
//                 color: Colors.white.withOpacity(0.52),
//                 borderRadius: BorderRadius.circular(12)),
//             child: ExplanationWidget(
//               animation: false,
//               explanation: explanation,
//               fontSize: 12,
//               show: true,
//               title: LocaleKeys.game_show_explanation.tr(),
//             ),
//           )
//       ],
//     );
//   }
//
//   BorderSide _borderAnswer(Choice choice) {
//     bool showAnswerCorrect = choice.isCorrect;
//     if (showAnswerCorrect) {
//       return BorderSide(color: _correctBackgroundColor, width: 1.5);
//     }
//     return BorderSide(color: Colors.black.withOpacity(0.08), width: 1.5);
//   }
//
//   Widget _makeContent(Choice choice) {
//     String _content = choice.content.replaceAll("\$", "");
//     if ((_content.endsWith(".png") ||
//             _content.endsWith(".svg") ||
//             _content.endsWith(".jpg") ||
//             _content.endsWith(".jpeg")) &&
//         CheckAppUtils.isAppFrance) {
//       String _url =
//           "${APIConfig.google_cloud_storage_url}/$_bucket/images/$_content";
//       return CachedNetworkImage(
//         height: 80,
//         alignment: Alignment.center,
//         imageUrl: _url,
//         placeholder: (context, url) => makeLoading(context),
//         errorWidget: (context, url, error) => Container(
//             alignment: Alignment.center,
//             color: Colors.grey[300],
//             width: double.infinity,
//             child: const Icon(Icons.error_outline, size: 30)),
//       );
//     }
//     return Container(
//       padding: const EdgeInsets.only(top: 16, bottom: 16),
//       child: TextContent(
//         choice.content,
//         TextAlign.left,
//         TextStyle(
//             color: _darkMode ? Colors.white : MyColors.colorBlackFull,
//             fontWeight: FontWeight.w500),
//         answer: true,
//       ),
//     );
//   }
// }

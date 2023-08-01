import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/src/widgets/games/video_player.dart';
import 'package:path/path.dart';

import '../../../flutter_abc_jsc_components.dart';
import '../../../models/constraints.dart';
import '../../../models/enums.dart';
import '../../../models/question/question.dart';

class QuestionInfoPanelCheckApp {
  final bool isAppFrance;
  final bool isPartner;

  QuestionInfoPanelCheckApp({
    required this.isAppFrance,
    required this.isPartner,
  });
}

class QuestionInfoPanel extends StatelessWidget {
  final IQuestion question;
  final String imageAsset;
  final String imageNetwork;
  final GameType gameType;
  final String bucket;
  final Axis axis;
  final double fontSize;
  final FontWeight fontWeight;
  final int? questionIndex;
  final QuestionInfoPanelCheckApp questionInfoPanelCheckApp;

  const QuestionInfoPanel(
    this.question,
    this.gameType,
    this.bucket, {
    super.key,
    this.fontSize = CONFIG_FONT_SIZE_DEFAULT,
    this.axis = Axis.horizontal,
    this.fontWeight = FontWeight.w500,
    this.questionIndex,
    required this.imageAsset,
    required this.imageNetwork,
    required this.questionInfoPanelCheckApp,
  });

  Widget _genQuestionView(BuildContext context, IQuestion question) {
    if ((question.image.isEmpty) &&
        (question.audio.isEmpty) &&
        (question.video.isEmpty)) {
      return _makeQuestionViewNormal(context);
    } else if (question.image.isNotEmpty) {
      return _makeQuestionViewWithImage(context);
    } else if (question.audio.isNotEmpty) {
      return _makeQuestionViewWithAudio(context);
    } else if (question.video.isNotEmpty) {
      return _makeQuestionViewWithVideo(context);
    }
    return _questionText(question, context);
  }

  @override
  Widget build(BuildContext context) {
    // return ShowMoreWidget(
    //   height: 200,
    //   child: _build(context)
    // );
    return _build(context);
  }

  Widget _build(BuildContext context) {
    return _genQuestionView(context, question);
  }

  Widget _makeQuestionViewNormal(BuildContext context) {
    if (gameType != GameType.TEST) {
      return _questionText(question, context);
    }
    return Align(
      alignment: Alignment.centerLeft,
      child: _questionText(question, context),
    );
  }

  Widget _makeQuestionViewWithImage(BuildContext context) {
    if (question.text.trim().isEmpty ||
        question.text.replaceFirst("\n", "").trim().isEmpty) {
      return _makeHeroImage(context,
          fullWidth: questionInfoPanelCheckApp.isAppFrance);
    }
    return Flex(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: axis == Axis.horizontal
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      mainAxisAlignment: axis == Axis.horizontal
          ? MainAxisAlignment.spaceBetween
          : MainAxisAlignment.start,
      direction: axis,
      children: <Widget>[
        axis == Axis.horizontal
            ? Expanded(
                flex: axis == Axis.horizontal ? 3 : 1,
                child: _questionText(question, context),
              )
            : _questionText(question, context),
        SizedBox(height: axis == Axis.horizontal ? 0 : 16, width: 8),
        axis == Axis.horizontal
            ? Expanded(
                flex: 1,
                child: _makeHeroImage(context),
              )
            : _makeHeroImage(context)
      ],
    );
  }

  Widget _makeHeroImage(BuildContext context, {bool fullWidth = false}) {
    return Hero(
      tag: "imageZoom_${question.id}",
      child: Material(
        color: Colors.transparent,
        child: GestureDetector(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _getImageWidget(imageAsset, imageNetwork, fullWidth, context),
              Icon(Icons.zoom_in,
                  size: 20,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : const Color(0xFF212121)),
            ],
          ),
          onTap: () {
            _showImageZoom(
              context,
              "imageZoom_${question.id}",
              question.image,
              imageAsset,
              imageNetwork,
            );
          },
        ),
      ),
    );
  }

  Widget _makeQuestionViewWithAudio(BuildContext context) {
    // String path = join(documentsDirectoryPath, "assets/audio/" + question.audio);
    // String path = "assets/audio/" + question.audio;
    String url = join(
        "https://storage.googleapis.com/accuplacer/audio/", question.audio);
    return Column(
      children: <Widget>[
        _questionText(question, context),
        //   PlayerWidget(url: url),
      ],
    );
  }

  Widget _makeQuestionViewWithVideo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        _questionText(question, context),
        VideoPlayerWidget(url: question.video, bucket: bucket)
      ],
    );
  }

  void _showImageZoom(
    BuildContext context,
    String heroTag,
    String imageUrl,
    String imageAsset,
    String imageNetwork,
  ) {
    Navigator.push(
      context,
      PageRouteBuilder(
          opaque: false,
          barrierDismissible: true,
          fullscreenDialog: true,
          barrierColor: Colors.black38,
          pageBuilder: (BuildContext context, _, __) {
            return ImageZoomWidget(
              imageUrl: imageUrl,
              bucket: bucket,
              heroTag: heroTag,
              onClose: () => Navigator.of(context).pop(),
              imageAsset: imageNetwork,
              imageNetwork: imageNetwork,
            );
          }),
    );
  }

  Widget _questionText(IQuestion question, BuildContext context) {
    return TextContent(
      questionIndex != null
          ? "${questionIndex! + 1}: ${question.text}"
          : question.text,
      TextAlign.start,
      TextStyle(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black,
          fontSize: fontSize,
          height: 1.5,
          fontWeight: fontWeight),
      question: questionInfoPanelCheckApp.isPartner,
    );
  }

  String getAnswerQuestion(List<IAnswer> choice) {
    String text = "";
    for (int i = 0; i < choice.length; i++) {
      if (choice[i].isCorrect) {
        text = choice[i].text;
        break;
      }
    }
    return text;
  }

  Widget _getImageWidget(String imageAsset, String imageNetwork, bool fullWidth,
      BuildContext context) {
    return Container(
      width: fullWidth ? double.infinity : 120,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.transparent
            : Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: ImageWidget(
          width: 120,
          imageAsset: imageAsset,
          imageNetwork: imageNetwork,
        ),
      ),
    );
  }
}

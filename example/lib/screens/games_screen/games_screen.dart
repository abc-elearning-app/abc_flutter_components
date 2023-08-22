import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';
import 'package:flutter_abc_jsc_components/models/enums.dart';
import 'package:flutter_abc_jsc_components/models/question/question.dart';
import 'package:flutter_abc_jsc_components/models/question/question_status.dart';
import 'package:flutter_abc_jsc_components/models/test_info/test_info.dart';
import 'package:flutter_abc_jsc_components/models/topic/topic.dart';

class GamesScreen extends StatelessWidget {
  const GamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: QuestionPanelNew(
            question: IQuestion(
              id: "4513497759088640",
              parentId: "-1",
              paragraphId: "-1",
              status: 1,
              text:
                  "Who usually leads the divisional organizational structure?",
              video: "",
              audio: "",
              image: "",
              hint: "",
              explanation:
                  "Each division is headed by a divisional manager who is in charge of coordinating the affairs of the division and its operations as well. The employees are accountable to that particular manager and not anyone else.",
              level: 64,
              createDate: 1624701081206,
              lastUpdate: 1624701081206,
              choices: ["A", "B", "C", "D"],
              answers: ["E", "F"],
              fullAnswersJson: "",
              index: 1,
              paragraphShortId: -1,
              point: 10,
              shortId: 1,
            ),
            gameType: GameType.STUDY,
            type: TypeOfGame.study,
            onReport: () {},
            keyQuestion: GlobalKey<State<StatefulWidget>>(),
            onChoiceSelected: (answer) {},
            onContinue: () {},
            prevQuestion: IQuestion(
              id: "4513497759088640",
              parentId: "-1",
              paragraphId: "-1",
              status: 1,
              text:
                  "Who usually leads the divisional organizational structure?",
              video: "",
              audio: "",
              image: "",
              hint: "",
              explanation:
                  "Each division is headed by a divisional manager who is in charge of coordinating the affairs of the division and its operations as well. The employees are accountable to that particular manager and not anyone else.",
              level: 64,
              createDate: 1624701081206,
              lastUpdate: 1624701081206,
              choices: ["A", "B", "C", "D"],
              answers: ["E", "F"],
              fullAnswersJson: """
              [
  {
    "id": "1",
    "text": "A",
    "explanation": "explain",
    "isCorrect": true
  },
  {
    "id": "2",
    "text": "B",
    "explanation": "explain",
    "isCorrect": false
  },
  {
    "id": "3",
    "text": "C",
    "explanation": "explain",
    "isCorrect": false
  }
]
              """,
              index: 1,
              paragraphShortId: -1,
              point: 10,
              shortId: 1,
            ),
            onFavorite: () {},
            showAllAnswer: true,
            topic: ITopic(
                id: "1",
                childrentType: 1,
                icon: '',
                shortId: 1,
                parentShortId: 1,
                lastUpdate: 1,
                name: '',
                orderIndex: 1,
                parentId: '',
                rootTopicId: '',
                totalQuestion: 10,
                type: 1,
                status: 1,
                children: [],
                topicQuestions: []),
            mainTopic: ITopic(
                id: "1",
                childrentType: 1,
                icon: '',
                shortId: 1,
                parentShortId: 1,
                lastUpdate: 1,
                name: '',
                orderIndex: 1,
                parentId: '',
                rootTopicId: '',
                totalQuestion: 10,
                type: 1,
                status: 1,
                children: [],
                topicQuestions: []),
            questionPanelNewDataManager: QuestionPanelNewDataManager(
              bucket: "",
              debugQuestion: debugFuc,
              selectDataType: SelectDataType.NEW_DATA,
              isShowNativeAds: false,
              isTester: true,
            ),
            bannerAds: const Text("Banner Ads"),
            fontSize: ValueNotifier(17),
            nativeAds: const Text("Native Ads"),
            questionPanelNewQuestionProgress: QuestionPanelNewQuestionProgress(
                bookmark: true,
                choiceSelectedIds: [],
                numberAnswer: 0,
                progress: [1, 1, -1],
                questionStatus: QuestionStatus()),
            choicePanelInAppPurchase: ChoicePanelInAppPurchase(
                inAppPurchaseLock: ValueNotifier(false),
                onInAppPurchaseLockClick: () {}),
            checkAppModel: const CheckAppModel(
              pushRankingApp: false,
              isPartner: false,
              isAppFrance: false,
            ),
          ),
        ),
      ),
    );
  }

  void debugFuc(
      {required IQuestion question,
      required String bucket,
      ITestInfo? testInfo,
      ITopic? topic,
      ITopic? mainTopic}) {
    print("object");
  }
}

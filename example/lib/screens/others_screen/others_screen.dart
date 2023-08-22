import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';
import 'package:flutter_abc_jsc_components/models/topic/topic.dart';

class OthersScreen extends StatelessWidget {
  const OthersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: TreeWidget(
            scrollController: ScrollController(),
            treeItems: List.generate(10, (index) => index)
                .map(
                  (e) => TreeItem.topic(
                    entity: ITopic(
                        id: e.toString(),
                        childrentType: 1,
                        icon: '',
                        shortId: e,
                        parentShortId: e,
                        lastUpdate: e,
                        name: '',
                        orderIndex: e,
                        parentId: '',
                        rootTopicId: '',
                        totalQuestion: 10,
                        type: 1,
                        status: 1,
                        children: [],
                        topicQuestions: []),
                    checkFreeToday: true,
                    topicTreeItemProperty: TopicTreeItemProperty(
                      flashCardComplete: 12,
                      percentComplete: 12,
                      progressLock: true,
                    ),
                  ),
                )
                .toList(),
            onClick: (TreeItem treeItem, int index) {},
            isSingleTest: false,
            checkUnlockTopic: false,
          ),
        ),
      ),
    );
  }
}

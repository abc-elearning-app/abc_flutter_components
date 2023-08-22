import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

class CardItemsScreen extends StatefulWidget {
  const CardItemsScreen({super.key});

  @override
  State<CardItemsScreen> createState() => _CardItemsScreenState();
}

class _CardItemsScreenState extends State<CardItemsScreen> {
  final FlipCardController _flipCardController = FlipCardController();
  final CardController _cardController = CardController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          shrinkWrap: true,
          children: [
            FlashCardItem(
              name: "Flash Card Item",
              icon: Icons.ac_unit_outlined,
              mastered: 0,
              total: 150,
              onTap: () {},
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              height: 600,
              child: TinderCardItem(
                swipeUp: false,
                swipeDown: false,
                orientation: AmassOrientation.bottom,
                totalNum: 150,
                stackNum: 3,
                animDuration: 300,
                swipeEdge: 1.0,
                maxWidth: MediaQuery.of(context).size.width - 30,
                maxHeight: 600,
                minWidth: MediaQuery.of(context).size.width - 50,
                minHeight: 600 - 10.0,
                cardBuilder: (context, index) {
                  return FlipCardItem(
                      controller: _flipCardController,
                      flipOnTouch: true,
                      front:
                          _makeContentFlipCard(child: _makeQuestionContent()),
                      back: _makeContentFlipCard(child: _makeChoices()));
                },
                cardController: _cardController,
                swipeUpdateCallback:
                    (DragUpdateDetails details, Alignment align) {},
                swipeCompleteCallback:
                    (CardSwipeOrientation orientation, int index) {},
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _makeContentFlipCard({required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.black
              : Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black
                  : Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius:
                  Theme.of(context).brightness == Brightness.dark ? 10 : 5,
              offset: const Offset(0, 2), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  color: Theme.of(context).colorScheme.background),
              width: double.infinity,
              height: 60,
              child: const Opacity(
                opacity: 0.8,
                child: Text("Flip Card",
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
            ),
            Expanded(child: child),
            Container(
              alignment: Alignment.center,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
                color: Theme.of(context).colorScheme.primary.withOpacity(0.9),
              ),
              child: const TutorialFlipCard(),
            )
          ],
        ),
      ),
    );
  }

  Widget _makeQuestionContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
              child: TextContent(
            "Question Content",
            TextAlign.left,
            TextStyle(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.9),
                fontSize: 25),
          )),
        ],
      ),
    );
  }

  Widget _makeChoices() {
    List<Widget> widgets = [];
    TextStyle style = TextStyle(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Theme.of(context).colorScheme.primary.withOpacity(0.9),
        fontSize: 22);
    for (var element in List.generate(4, (index) => index)) {
      if (element == 2) {
        widgets.add(Center(
          child: TextContent(
            "Answer $element",
            TextAlign.left,
            style,
          ),
        ));
      }
    }
    widgets.add(Center(
      child: TextContent(
        "Explanation",
        TextAlign.left,
        style,
      ),
    ));
    return ListView(
      padding: const EdgeInsets.all(24),
      children: widgets,
    );
  }
}

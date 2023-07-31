import 'package:flutter/material.dart';

class ExpandPanel extends StatefulWidget {
  const ExpandPanel({super.key});

  @override
  State<ExpandPanel> createState() => CriteriaState();
}

class NewItem {
  bool isExpanded;
  final String header;
  final Widget body;
  final Icon iconPic;

  NewItem(this.isExpanded, this.header, this.body, this.iconPic);
}

double discreteValue = 2.0;
double hospitalDiscreteValue = 25.0;

class CriteriaState extends State<ExpandPanel> {
  List<NewItem> items = <NewItem>[
    NewItem(
        false,
        'Schools',
        const Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(children: <Widget>[
              //put the children here
            ])),
        const Icon(Icons.add)),
    //give all your items here
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: ExpansionPanelList(
            expansionCallback: (int index, bool isExpanded) {
              setState(() {
                items[index].isExpanded = !items[index].isExpanded;
              });
            },
            children: items.map((NewItem item) {
              return ExpansionPanel(
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return ListTile(
                      leading: item.iconPic,
                      title: Text(
                        item.header,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ));
                },
                isExpanded: item.isExpanded,
                body: item.body,
              );
            }).toList(),
          ),
        )
      ],
    );
  }
}

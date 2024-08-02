import 'package:flutter/material.dart';

class StateData {
  final String id;
  final String name;
  final String icon;

  StateData({
    required this.id,
    required this.icon,
    required this.name,
  });
}

class SelectStateTab extends StatefulWidget {
  final List<StateData> states;
  final String selectedStateId;

  final bool isDarkMode;

  final Color mainColor;
  final Color secondaryColor;
  final Color backgroundColor;

  final void Function(String currentStateId) onChange;

  const SelectStateTab({
    super.key,
    required this.onChange,
    required this.isDarkMode,
    required this.mainColor,
    required this.secondaryColor,
    required this.backgroundColor,
    required this.states,
    required this.selectedStateId,
  });

  @override
  State<SelectStateTab> createState() => _SelectStateTabState();
}

class _SelectStateTabState extends State<SelectStateTab> {
  String currentStateId = '';
  late List<StateData> queriedStates = [];

  late ScrollController listController;

  @override
  void initState() {
    listController = ScrollController();
    queriedStates = widget.states;
    currentStateId = widget.selectedStateId;
    super.initState();
  }

  @override
  void dispose() {
    listController.dispose();
    super.dispose();
  }

  void _onStateSearch(String value) {
    setState(() {
      if (value.isEmpty) {
        queriedStates = [...widget.states];
      } else {
        queriedStates = widget.states.where((element) => element.name.toLowerCase().contains(value.toLowerCase())).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: _searchBar(),
          ),
          Expanded(
            child: queriedStates.isEmpty
                ? const SizedBox()
                : ListView.builder(
                    controller: listController,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    itemCount: queriedStates.length,
                    itemBuilder: (_, index) => _buildStateItem(
                      queriedStates[index].name,
                      queriedStates[index].id,
                      queriedStates[index].icon,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _searchBar() {
    const border = UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent));
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: !widget.isDarkMode ? [BoxShadow(color: Colors.grey.shade300, blurRadius: 5, spreadRadius: 2, offset: const Offset(0, 2))] : null),
      child: TextField(
        decoration: const InputDecoration(
          hintText: 'Search',
          hintStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          icon: Icon(Icons.search_rounded),
          border: border,
          focusedBorder: border,
          enabledBorder: border,
        ),
        onChanged: (value) => _onStateSearch(value),
      ),
    );
  }

  Widget _buildStateItem(String name, String id, String icon) {
    return GestureDetector(
      onTap: () => _onSelect(id),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
            border: Border.all(color: currentStateId == id ? widget.mainColor : Colors.transparent, width: 2),
            boxShadow: !widget.isDarkMode
                ? [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      offset: const Offset(0, 2),
                      spreadRadius: 1,
                      blurRadius: 5,
                    ),
                  ]
                : null),
        child: Row(
          children: [
            Container(
              height: 34,
              width: 34,
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: AssetImage(icon),
                    fit: BoxFit.cover,
                  )),
            ),
            Expanded(child: Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
            CircleAvatar(
              radius: 14,
              backgroundColor: widget.mainColor,
              child: CircleAvatar(
                radius: 12,
                backgroundColor: Colors.white,
                child: currentStateId == id
                    ? CircleAvatar(
                        radius: 9,
                        backgroundColor: widget.mainColor,
                      )
                    : null,
              ),
            )
          ],
        ),
      ),
    );
  }

  _onSelect(String id) {
    setState(() => currentStateId = id);
    widget.onChange(currentStateId);
  }
}

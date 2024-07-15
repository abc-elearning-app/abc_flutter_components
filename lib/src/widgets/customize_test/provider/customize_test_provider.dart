import 'package:flutter/cupertino.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';
import 'package:flutter_abc_jsc_components/src/widgets/customize_test/widgets/slider_tile.dart';

class CustomizeTestProvider extends ChangeNotifier {
  int selectedModeValue = 0;
  int selectedQuestions = 20;
  int selectedDuration = 20;
  int selectedPassingScore = 80;
  Map<int, bool> mapTopicIdsSelected = {};

  void init(List<int> topicIds, List<ModeData> modes) {
    mapTopicIdsSelected = topicIds.asMap().map((key, value) => MapEntry(value, true));
    selectedModeValue = modes.first.id;
  }

  void selectMode(int index) {
    selectedModeValue = index;
    notifyListeners();
  }

  void updateSlider(SliderType type, int newValue) {
    switch (type) {
      case SliderType.question:
        selectedQuestions = newValue;
        break;
      case SliderType.duration:
        selectedDuration = newValue;
        break;
      case SliderType.passingScore:
        selectedPassingScore = newValue;
        break;
    }
    notifyListeners();
  }

  void toggleSubject(int id) {
    mapTopicIdsSelected[id] = !mapTopicIdsSelected[id]!;
    notifyListeners();
  }

  void toggleAllSubjects(bool value) {
    mapTopicIdsSelected = mapTopicIdsSelected.map((key, _) => MapEntry(key, value));
    notifyListeners();
  }

  List<int> get topicIdsSelected {
    List<int> ids = [];
    for(var entry in mapTopicIdsSelected.entries) {
      if(entry.value) {
        ids.add(entry.key);
      }
    }
    return ids;
  }

  bool get selectedAll => topicIdsSelected.length == mapTopicIdsSelected.length;
}

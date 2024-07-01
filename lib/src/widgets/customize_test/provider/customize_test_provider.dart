import 'package:flutter/cupertino.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';
import 'package:flutter_abc_jsc_components/src/widgets/customize_test/widgets/slider_tile.dart';

class CustomizeTestProvider extends ChangeNotifier {
  int selectedModeValue = 0;
  int selectedQuestions = 20;
  int selectedDuration = 20;
  int selectedPassingScore = 80;
  List<bool> subjectSelection = [];

  bool allSubjectSelected = true;

  void init(int subjectLength, List<ModeData> modes) {
    // Initialize a boolean list for selecting subjects
    subjectSelection.addAll(List.generate(subjectLength, (_) => true));
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

  void toggleSubject(int index) {
    subjectSelection[index] = !subjectSelection[index];
    allSubjectSelected = subjectSelection.where((e) => !e).isEmpty;
    notifyListeners();
  }

  void toggleAllSubjects(bool value) {
    for (int i = 0; i < subjectSelection.length; i++) {
      subjectSelection[i] = value;
    }
    allSubjectSelected = value;
    notifyListeners();
  }
}

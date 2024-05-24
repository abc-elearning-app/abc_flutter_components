import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

class TestLevelsPathScreen extends StatefulWidget {
  const TestLevelsPathScreen({super.key});

  @override
  State<TestLevelsPathScreen> createState() => _TestLevelsPathScreenState();
}

class _TestLevelsPathScreenState extends State<TestLevelsPathScreen> {
  late ScrollController _scrollController;
  late ValueNotifier<double> _backgroundOffset;

  @override
  void initState() {
    _scrollController = ScrollController();
    _backgroundOffset = ValueNotifier<double>(0);

    _scrollController.addListener(
        () => _backgroundOffset.value = _scrollController.offset / 15);

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _backgroundOffset.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final levelList = <UpdatedLevelData>[
      UpdatedLevelData(title: 'Anatomy 1', progress: 85, isLock: false),
      UpdatedLevelData(title: 'Ecology 1', progress: 65, isLock: false),
      UpdatedLevelData(
        title: 'Botany 1',
        progress: 10,
        isLock: false,
        isCurrent: true,
      ),
      UpdatedLevelData(title: 'Anatomy 2', progress: 0),
      UpdatedLevelData(title: 'Anatomy 3', progress: 0),
      UpdatedLevelData(title: 'Anatomy 4', progress: 0),
    ];

    return Container(
      decoration: const BoxDecoration(color: Color(0xFFF5F4EE)),
      child: Stack(alignment: Alignment.topCenter, children: [
        ValueListenableBuilder(
          valueListenable: _backgroundOffset,
          builder: (_, value, __) => Transform.translate(
            offset: Offset(0, -value),
            child: Container(
                height: 500,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                            'assets/images/path_level_background.png'),
                        fit: BoxFit.fitWidth))),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            scrolledUnderElevation: 0,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  _buildDivider('Life Science'),
                  UpdatedPathLevelScreen(
                    levelList: levelList,
                    drawType: DrawType.nextLevel,
                  ),
                  _buildDivider('Earth and Space Science'),
                  UpdatedPathLevelScreen(
                    levelList: levelList,
                    drawType: DrawType.firstTimeOpen,
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _buildDivider(String title) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              height: 1,
              color: Colors.grey.shade400,
            )),
            Text(title,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade400,
                    fontFamily: 'Poppins',
                    fontSize: 18)),
            Expanded(
                child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              height: 1,
              color: Colors.grey.shade400,
            )),
          ],
        ),
      );
}

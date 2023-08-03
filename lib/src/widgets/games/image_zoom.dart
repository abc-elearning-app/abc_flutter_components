import 'package:flutter/material.dart';

import '../../../flutter_abc_jsc_components.dart';
import '../../../models/enums.dart';

class ImageZoomWidget extends StatefulWidget {
  final String imageUrl;
  final String bucket;
  final String? heroTag;
  final VoidCallback onClose;
  final SelectDataType selectDataType;

  const ImageZoomWidget({
    super.key,
    required this.bucket,
    this.heroTag,
    required this.onClose,
    required this.imageUrl,
    required this.selectDataType,
  });

  @override
  State<ImageZoomWidget> createState() => _ImageZoomWidgetState();
}

class _ImageZoomWidgetState extends State<ImageZoomWidget> {
  bool get _darkMode =>
      Theme.of(context).colorScheme.brightness == Brightness.dark;

  Widget getImageWidget(String imageUrl, String bucket) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
          color: _darkMode ? const Color(0xFF212121) : Colors.white,
          borderRadius: BorderRadius.circular(16)),
      constraints: BoxConstraints(minHeight: 100, maxHeight: size.height - 100),
      padding: const EdgeInsets.all(8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: ImageWidget(
          imageUrl: imageUrl,
          bucket: bucket,
          selectDataType: widget.selectDataType,
          width: size.width - 48,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _makeInteractiveViewer({
    required Widget child,
  }) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: InteractiveViewer(
        // constrained: false,
        maxScale: 3,
        minScale: 1,
        scaleEnabled: true,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // return Center(
    //   child: _makeInteractiveViewer(child: _temp()),
    // );
    return _makeInteractiveViewer(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onClose,
          child: Container(
            color: Colors.black38,
            alignment: Alignment.center,
            child: _temp(),
          ),
        ),
      ),
    );
  }

  Widget _temp() {
    return Container(
      alignment: Alignment.center,
      color: Colors.redAccent.withOpacity(0.0),
      margin: const EdgeInsets.all(8),
      child: Stack(
        children: [
          InkWell(child: _getChild(), onTap: () {}),
          Positioned(
              right: 4,
              top: 4,
              child: InkWell(
                onTap: widget.onClose,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                      color: _darkMode
                          ? const Color(0xFF4D4D4D)
                          : const Color(0xFF383838),
                      borderRadius: BorderRadius.circular(32)),
                  child: const Icon(Icons.close, color: Colors.white, size: 20),
                ),
              ))
        ],
      ),
    );
  }

  Widget _getChild() {
    if (widget.heroTag != null) {
      return Hero(
          tag: widget.heroTag!,
          child: getImageWidget(widget.imageUrl, widget.bucket));
    }
    return getImageWidget(widget.imageUrl, widget.bucket);
  }
}

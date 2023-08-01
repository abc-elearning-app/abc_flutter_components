import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../../flutter_abc_jsc_components.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String url;
  final String bucket;

  const VideoPlayerWidget({super.key, required this.url, required this.bucket});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  String get _bucket => widget.bucket;

  String get _videoUrl =>
      'https://storage.googleapis.com/micro-enigma-235001.appspot.com/$_bucket/videos/${widget.url}';
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    if (widget.url.isNotEmpty) {
      _controller = VideoPlayerController.networkUrl(Uri.parse(_videoUrl))
        ..initialize().then((_) {
          _controller?.play();
        })
        ..addListener(() {
          setState(() {});
        });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller?.value.isInitialized ?? false) {
      VideoPlayerValue value = _controller!.value;
      return Container(
        padding: const EdgeInsets.only(top: 8),
        alignment: Alignment.center,
        child: AspectRatio(
          aspectRatio: value.aspectRatio,
          child: InkWell(
            onTap: () {
              if (value.isPlaying) {
                _controller?.pause();
              } else {
                if (value.duration.inMilliseconds ==
                    value.position.inMilliseconds) {
                  _controller?.seekTo(const Duration());
                }
                _controller?.play();
              }
            },
            child: Stack(
              children: [
                VideoPlayer(_controller!),
                !value.isPlaying
                    ? Container(
                        alignment: Alignment.center,
                        color: Colors.black54,
                        child: const Icon(Icons.play_arrow,
                            color: Colors.white, size: 50),
                      )
                    : const SizedBox()
              ],
            ),
          ),
        ),
      );
    }
    return makeLoading(context);
  }
}

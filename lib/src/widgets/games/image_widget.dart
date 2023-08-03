import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/models/enums.dart';
import 'package:flutter_abc_jsc_components/src/utils/asset_utils.dart';
import 'package:flutter_abc_jsc_components/src/utils/image_utils.dart';
import 'package:flutter_svg/svg.dart';

class ImageWidget extends StatelessWidget {
  final String imageUrl;
  final double? height;
  final double? width;
  final String? imageFolder;
  final Alignment alignment;
  final BoxFit fit;
  final Color? color;
  final SelectDataType selectDataType;
  final String bucket;

  const ImageWidget({
    super.key,
    this.height,
    this.width,
    this.imageFolder,
    this.alignment = Alignment.center,
    this.fit = BoxFit.contain,
    this.color,
    required this.imageUrl,
    required this.selectDataType,
    required this.bucket,
  });

  @override
  Widget build(BuildContext context) {
    String imageAsset = getLocalImageUrl(imageUrl, dataType: selectDataType);
    return FutureBuilder<bool>(
        future: detectFileAssets(imageAsset),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            String link = imageAsset;
            if (!snapshot.data!) {
              link = getNetworkImageUrl(imageUrl, bucket: bucket);
            }
            return imageWidget(context, link);
          }
          return const CircularProgressIndicator();
        });
  }

  Widget imageWidget(BuildContext context, String link) {
    if (link.startsWith("data:image/")) {
      return Image.memory(
        base64Decode(link
            .replaceAll("data:image/png;base64,", "")
            .replaceAll("data:image/jpg;base64,", "")
            .replaceAll("data:image/jpeg;base64,", "")),
        width: width,
        height: height,
        alignment: alignment,
        fit: fit,
      );
    }
    if (link.endsWith("svg")) {
      if (link.startsWith("http")) {
        return SvgPicture.network(
          link,
          width: width,
          height: height,
          alignment: alignment,
          fit: fit,
        );
      }
      return SvgPicture.asset(
        link,
        width: width,
        height: height,
        alignment: alignment,
        fit: fit,
      );
    }
    if (link.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: link,
        width: width,
        height: height,
        alignment: alignment,
        fit: fit,
        placeholder: (context, url) => _makeLoading(context),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      );
    }
    return Image.asset(
      link,
      width: width,
      height: height,
      alignment: alignment,
      fit: fit,
    );
  }

  Widget _makeLoading(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
                strokeWidth: 2, color: Theme.of(context).colorScheme.primary)),
      ],
    );
  }
}

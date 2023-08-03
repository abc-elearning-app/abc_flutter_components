import 'package:flutter_abc_jsc_components/models/enums.dart';

String getLocalImageUrl(
  String image, {
  String? imageFolder,
  String? currentApp,
  required SelectDataType dataType,
}) {
  // print("getLocalImageUrl imageFolder $imageFolder");
  if ((imageFolder == null || imageFolder.isEmpty) &&
      currentApp == 'motorcycle') {
    if (currentApp == 'motorcycle') {
      imageFolder = "images-motorcycle";
    }
    if (currentApp == 'dmv') {
      imageFolder = "images-dmv";
    }
  }
  if (dataType == SelectDataType.NEW_DATA) {
    return "assets/images_new/$image";
  }
  if (imageFolder != null && imageFolder.isNotEmpty) {
    return "assets/$imageFolder/$image";
  }
  return currentApp != null && currentApp.isNotEmpty
      ? "assets/images-$currentApp/$image"
      : "assets/images/$image";
}

String getNetworkImageUrl(String image, {required String bucket}) {
  return "https://storage.googleapis.com/micro-enigma-235001.appspot.com/$bucket/images/$image";
}

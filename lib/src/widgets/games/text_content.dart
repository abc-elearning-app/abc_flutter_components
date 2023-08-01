import 'dart:convert';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_text/extended_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_math/flutter_html_math.dart';

const double defaultRatio = 0.8;

class TextContent extends StatelessWidget {
  final String _content;
  final TextAlign _align;
  final TextStyle _style;
  final String? imageFolder;
  final bool? answer;
  final bool? question;
  final void Function()? onTapImage;

  const TextContent(
    this._content,
    this._align,
    this._style, {
    super.key,
    this.imageFolder,
    this.answer,
    this.onTapImage,
    this.question,
  });

  // double getEquationWidth(BuildContext context, String equation) {
  //   double ratio = defaultRatio;
  //   double screenWidth = MediaQuery.of(context).size.width - 20;
  //   List<String> splits = equation.split("_");
  //   double w = 0;
  //   for (int i = 0; i < splits.length; i++) {
  //     if (splits[i].startsWith("w")) {
  //       w = double.parse(splits[i].substring(1));
  //     }
  //   }
  //   if (w > 300) {
  //     // debugLog("w: $w");
  //     while (w * ratio > screenWidth) {
  //       ratio = ratio - 0.01;
  //       // debugLog("new ratio width: $ratio");
  //     }
  //   }
  //
  //   return w == 0 ? 70 : w * ratio;
  // }
  //
  // double getEquationHeight(String equation) {
  //   double ratio = defaultRatio;
  //   // debugLog("equation $equation");
  //   List<String> splits = equation.split("_");
  //   double h = 0;
  //   for (int i = 0; i < splits.length; i++) {
  //     if (splits[i].startsWith("h")) {
  //       h = double.parse(splits[i].substring(1, splits[i].indexOf(".")));
  //     }
  //   }
  //   if (ratio != 0.8) {
  //     // debugLog("new ratio height: $ratio");
  //   }
  //   return h == 0 ? 70 : h * ratio;
  // }
  //
  // List<TextSpan> getHtmlSpans(String content, String split) {
  //   List<String> contents = content.split(split);
  //   List<TextSpan> spans = [];
  //   for (int i = 0; i < contents.length; i++) {
  //     String s = contents[i];
  //     if (s.isEmpty) continue;
  //     if (s.contains(".i")) {
  //       s = s.replaceAll(".i", "");
  //       spans.add(TextSpan(
  //         text: s,
  //         style: _style.merge(const TextStyle(fontStyle: FontStyle.italic)),
  //       ));
  //     } else if (s.contains(".em")) {
  //       s = s.replaceAll(".em", "");
  //       spans.add(TextSpan(
  //         text: s,
  //         style: _style.merge(const TextStyle(fontStyle: FontStyle.italic)),
  //       ));
  //     } else if (s.contains(".strong")) {
  //       s = s.replaceAll(".strong", "");
  //       spans.add(TextSpan(
  //         text: s,
  //         style: _style.merge(const TextStyle(fontWeight: FontWeight.bold)),
  //       ));
  //     } else if (s.contains(".b")) {
  //       s = s.replaceAll(".b", "");
  //       spans.add(TextSpan(
  //         text: s,
  //         style: _style.merge(const TextStyle(fontWeight: FontWeight.bold)),
  //       ));
  //     } else if (s.contains(".code")) {
  //       s = s.replaceAll(".code", "");
  //       spans.add(TextSpan(
  //         text: s,
  //         style: _style.merge(const TextStyle(fontFamily: 'monospace')),
  //       ));
  //     } else if (s.contains(".u")) {
  //       s = s.replaceAll(".u", "");
  //       spans.add(TextSpan(
  //         text: s,
  //         style: _style
  //             .merge(const TextStyle(decoration: TextDecoration.underline)),
  //       ));
  //     } else if (s.contains(".small")) {
  //       s = s.replaceAll(".small", "");
  //       spans.add(TextSpan(
  //         text: s,
  //         style: _style.merge(const TextStyle(fontSize: 12.0)),
  //       ));
  //     } else if (s.contains(".p")) {
  //       s = s.replaceAll(".p", "\n");
  //       spans.add(TextSpan(
  //         text: s,
  //       ));
  //     } else {
  //       spans.add(TextSpan(
  //         text: s,
  //         style: _style,
  //       ));
  //     }
  //   }
  //   return spans;
  // }
  //
  // String _removeAllHtmlTags(String? htmlText) {
  //   if (htmlText == null || htmlText.isEmpty) {
  //     return "";
  //   }
  //   RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
  //   return htmlText.replaceAll(exp, '');
  // }
  //
  // getImageProvider(
  //     String imageName, String networkImageUrl, Uint8List? imageData) {
  //   if (imageData != null) {
  //     return MemoryImage(imageData);
  //   }
  //   if (imageName.startsWith("data:image/")) {
  //     return MemoryImage(base64Decode(imageName));
  //   }
  //   return CachedNetworkImageProvider(networkImageUrl, errorListener: () {
  //     FirebaseCallbacks.logEvent('event_error_image', parameters: {
  //       "type": 1,
  //       "image": networkImageUrl,
  //     });
  //   });
  // }
  //
  // String _covertStringToUnicode(String? content) {
  //   if (content == null || content.isEmpty) {
  //     return "";
  //   }
  //   String regex = "\\u";
  //   try {
  //     int offset = content.indexOf(regex) + regex.length;
  //     while (offset > -1 + regex.length) {
  //       int limit = offset + 4;
  //       if (limit > content!.length) {
  //         limit = content.length;
  //       }
  //       String str = content.substring(offset, limit);
  //       if (str != null && str.isNotEmpty) {
  //         String code = String.fromCharCode(int.parse(str, radix: 16));
  //         content = content.replaceFirst(str, code, offset);
  //       }
  //       offset = content.indexOf(regex, offset) + regex.length;
  //     }
  //   } catch (e) {}
  //   return content!.replaceAll(regex, "");
  // }
  //
  // void _showImageZoom(
  //   BuildContext context,
  //   String heroTag,
  //   String imageUrl,
  //   String imageAsset,
  //   String imageNetwork,
  //   String bucket,
  // ) {
  //   Navigator.push(
  //     context,
  //     PageRouteBuilder(
  //         opaque: false,
  //         barrierDismissible: true,
  //         fullscreenDialog: true,
  //         barrierColor: Colors.black38,
  //         pageBuilder: (BuildContext context, _, __) {
  //           return ImageZoomWidget(
  //             imageUrl: imageUrl,
  //             bucket: bucket,
  //             heroTag: heroTag,
  //             onClose: () => Navigator.of(context).pop(),
  //             imageAsset: imageAsset,
  //             imageNetwork: imageNetwork,
  //           );
  //         }),
  //   );
  // }
  //
  // bool _hasMathImage(String text) {
  //   var regex = RegExp(
  //       r"[a-zA-Z0-9]{0,10000000}_w\d{0,10000000}_h\d{0,10000000}.(png|jpg|jpeg)",
  //       multiLine: true);
  //   return regex.hasMatch(text.toLowerCase());
  // }
  //
  // List<String> getImages(String newContent) {
  //   if (newContent.contains("\$")) {
  //     List<String> images = [];
  //     List<String> list = newContent.split("\$");
  //     for (String str in list) {
  //       if (str != null && str.isNotEmpty) {
  //         str = str.trim();
  //         if (isImage(str)) {
  //           images.add(str);
  //         }
  //       }
  //     }
  //     return images;
  //   }
  //   return [];
  // }
  //
  // bool _isMathJax(String? text) {
  //   if (text == null || text.isEmpty) {
  //     return false;
  //   }
  //   int offset = text.indexOf("\\(");
  //   if (offset == -1) return false;
  //   int limit = text.indexOf("\\)");
  //   if (limit == -1) return false;
  //   int x = text.indexOf("\{");
  //   int y = text.indexOf("\}");
  //   return (x < y && y > 0) || text.contains("\\");
  // }
  //
  // String _replaceFirstContent(String? content) {
  //   content = _replaceUnderline(content);
  //   if (_isMathJax(content)) {
  //     // print("XXX $content");
  //     content = content
  //             ?.replaceAll(" < ", "\\u2039")
  //             .replaceAll("&nbsp;", " ")
  //             .replaceAll(" > ", "\\u203A")
  //             .replaceAll("}<", "} \\u2039")
  //             .replaceAll("}>", "} \\u203A")
  //             .replaceAll("\\mathrm", "") ??
  //         "";
  //   }
  //   return content
  //           ?.replaceAll("<br><br>", "\n")
  //           .replaceAll("\$", "\$")
  //           .replaceAll("\\require{cancel}", "")
  //           .replaceAll("\\\$", "\$")
  //           .replaceAll("<br/><br/>", "\n")
  //           .replaceAll("\\dfrac", "\\frac")
  //           .replaceAll("\\mathrm", "")
  //           .replaceAll("<br /><br />", "\n") ??
  //       "";
  // }

  @override
  Widget build(BuildContext context) {
    // String tempContent = _replaceFirstContent(_content);
    // List<String> allImages = getImages(tempContent);
    // return FutureBuilder<Map<String, ImageAssetData>>(
    //     future: _convertAssetsDataToBase64(allImages),
    //     builder: (context, snapshot) {
    //       if (snapshot != null && snapshot.hasData) {
    //         return widget(context, tempContent, snapshot.data ?? {});
    //       }
    //       return const SizedBox();
    //     });
    return Text(_content);
  }
//
// CustomRenderMatcher mathMatcher() => (context) {
//       return context.tree.element?.localName == "tex";
//     };
//
// CustomRender mathRender() =>
//     CustomRender.widget(widget: (context, buildChildren) {
//       String innerHtml = context.tree.element.innerHtml;
//       if (innerHtml != null && innerHtml.isNotEmpty) {
//         return Padding(
//           padding: const EdgeInsets.only(bottom: 5),
//           child:
//               Math.tex(innerHtml, textStyle: _style, onErrorFallback: (err) {
//             return Text(innerHtml, style: _style);
//           }),
//         );
//       }
//       return Text("#");
//     });
//
// Widget widget(BuildContext context, String? tempContent,
//     Map<String, ImageAssetData> mapImageAssets) {
//   // Dạng dữ liệu cũ (các thẻ cũ, ảnh công thức), có chưa thẻ br và có image trong text, dạng công thức ảnh
//   if (!_isMathJax(tempContent) &&
//       (tempContent != null &&
//               !isHtml(tempContent) &&
//               (_hasMathImage(tempContent) ||
//                   tempContent.contains("\$") ||
//                   tempContent.contains("<>")) ||
//           tempContent!.contains("\$"))) {
//     // nếu có nhiều ảnh không phải dạng công thức trong đoạn văn
//     return _replaceOldContentData(
//         context, _covertStringToUnicode(tempContent), mapImageAssets ?? {});
//   }
//   String newContent = _replaceBugsContent(_covertStringToUnicode(
//       _replaceOldDataToHTML(tempContent!, assets: mapImageAssets ?? {})));
//   // dạng dữ liệu mới
//   if (isHtml(newContent) || _isMathJax(tempContent)) {
//     newContent = _isMathJax(newContent)
//         ? _replaceMathJaxTag(newContent)
//         : newContent;
//     // print("_newContent $_newContent");
//     return Html(
//       data: newContent,
//       customRenders: {
//         mathMatcher(): mathRender(),
//       },
//       tagsList: Html.tags..addAll(["tex", "math"]),
//       style: {
//         "*": Style.fromTextStyle(_style),
//         "b":
//             Style.fromTextStyle(_style).copyWith(fontWeight: FontWeight.bold),
//         "strong":
//             Style.fromTextStyle(_style).copyWith(fontWeight: FontWeight.bold),
//         "u": Style.fromTextStyle(_style)
//             .copyWith(textDecoration: TextDecoration.underline),
//         "i":
//             Style.fromTextStyle(_style).copyWith(fontStyle: FontStyle.italic),
//         "s": Style.fromTextStyle(_style)
//             .copyWith(textDecoration: TextDecoration.lineThrough),
//         "body": Style(margin: Margins.zero, padding: EdgeInsets.zero)
//       },
//       onImageTap: (url, _, __, ___) {
//         if (answer != true) {
//           _showImageZoom(context, "", url);
//         } else {
//           onTapImage?.call();
//         }
//       },
//     );
//   }
//   return Text(newContent, textAlign: _align, style: _style);
// }
//
// CustomRender tagRender() =>
//     CustomRender.widget(widget: (context, buildChildren) {
//       return _renderBoldTag(context);
//     });
//
// Widget _renderBoldTag(RenderContext context) {
//   String _content = context.tree.element.innerHtml;
//   bool _hasTagI = _content.indexOf('<i>') > -1;
//   TextStyle _s = _style.copyWith(fontWeight: FontWeight.bold);
//   if (_hasTagI) {
//     _s = _s.copyWith(fontStyle: FontStyle.italic);
//     _content = _content.replaceAll("<i>", "").replaceAll("</i>", "");
//   }
//   bool _hasTagU = _content.indexOf('<u>') > -1;
//   if (_hasTagU) {
//     _s = _s.copyWith(decoration: TextDecoration.underline);
//     _content = _content.replaceAll("<u>", "").replaceAll("</u>", "");
//   }
//   return Text(_content, style: _s);
// }
//
// // final String _underlineRegex = "____";
// String? _replaceUnderline(String? text) {
//   // if(text.contains(_underlineRegex)) {
//   //   int index = text.indexOf(_underlineRegex);
//   //   int limit = text.lastIndexOf(_underlineRegex, index) + _underlineRegex.length;
//   //   String _regex = text.substring(index, limit);
//   //   print("_regex $_regex");
//   //   return text.replaceAll(_regex, "<u>${List.generate(limit - index, (index) => "&nbsp;").join("")}</u>");
//   // }
//   return text;
// }
//
// String _replaceMathJaxTag(String text) {
//   return text.replaceAll(r"\(", r"<tex>").replaceAll(r"\)", r"</tex>");
//   // return """<tex>-\\frac{\\hbar}{2m}</tex>""";
// }
//
// Future<Map<String, ImageAssetData>> _convertAssetsDataToBase64(
//     List<String> images) async {
//   Map<String, ImageAssetData> map = {};
//   for (String image in images) {
//     String _path = DataManager.getInstance()
//         .getLocalImageUrl(image, imageFolder: imageFolder);
//     Uint8List data = await getFileAssetsBase64(_path);
//     if (data != null) {
//       var size = await decodeImageFromList(data);
//       map[image] =
//           ImageAssetData(data: data, width: size.width, height: size.height);
//     }
//   }
//   return map;
// }
//
// Map<String, TextStyle> get _tags => _regexTags();
//
// bool get _darkMode => ThemeUtils.getInstance().isDarkMode();
//
// Widget _replaceOldContentData(BuildContext context, String _newContent,
//     Map<String, ImageAssetData> _mapImageAssets) {
//   List<dynamic> _spans = [];
//   if (_newContent.indexOf("\$") > -1) {
//     List<String> list = _newContent.split("\$");
//     for (String str in list) {
//       if (str != null && str.isNotEmpty) {
//         if (isImage(str)) {
//           if (_hasMathImage(str)) {
//             // ảnh dạng công thức
//             double imageWidth = getEquationWidth(context, str);
//             double imageHeight = getEquationHeight(str);
//             if (imageWidth < 0) {
//               imageWidth = 70;
//             }
//             if (imageHeight < 0) {
//               imageHeight = 70;
//             }
//             _spans.add(ImageSpan(
//                 getImageProvider(str, _mapImageAssets[str]?.data),
//                 imageWidth: imageWidth,
//                 imageHeight: imageHeight,
//                 color: _darkMode ? Colors.white : MyColors.colorBlackFull));
//           } else {
//             // ảnh khác
//             dynamic data = getImageProvider(str, _mapImageAssets[str]?.data);
//             double _width = _mapImageAssets[str]?.width?.toDouble();
//             double _height = _mapImageAssets[str]?.height?.toDouble();
//             double _screenWidth = MediaQuery.of(context).size.width - 112;
//             _spans.add(ImageSpan(data,
//                 imageWidth:
//                     _width != null && _width > 0 && _width < _screenWidth
//                         ? _width
//                         : _screenWidth,
//                 imageHeight: _height != null &&
//                         _height > 0 &&
//                         _height < _screenWidth * 2 / 3
//                     ? _height
//                     : _screenWidth * 2 / 3, onTap: () {
//               _showImageZoom(context, null, str);
//             }));
//           }
//         } else {
//           List<String> temp = str.split(" ");
//           if (temp.isNotEmpty) {
//             int _num = int.tryParse(
//                 temp.first.replaceAll(".", "").replaceAll(",", ""));
//             if (_num != null) {
//               _spans.add("\$" + str);
//             } else {
//               _spans.add(str);
//             }
//           } else {
//             _spans.add(str);
//           }
//         }
//       }
//     }
//   }
//   // print(_spans);
//   if (_newContent.indexOf("<>") > -1) {
//     Map<int, List<dynamic>> _spans2 = {};
//     for (int index = 0; index < _spans.length; index++) {
//       if (_spans[index] is String) {
//         String _item = _spans[index];
//         List<String> list = _item.split("<>");
//         for (String str in list) {
//           if (str != null && str.isNotEmpty) {
//             bool _hasRegex = false;
//             if (!_spans2.containsKey(index)) {
//               _spans2[index] = [];
//             }
//             for (String _regexTag in _tags.keys) {
//               if (str.indexOf(_regexTag) > -1 &&
//                   str.toLowerCase().indexOf('.png') == -1 &&
//                   str.toLowerCase().indexOf('.jpg') == -1) {
//                 _hasRegex = true;
//                 _spans2[index].add(TextSpan(
//                     text: str.replaceAll(_regexTag, ""),
//                     style: _tags[_regexTag]));
//               }
//             }
//             if (!_hasRegex) {
//               _spans2[index].add(str);
//             }
//           }
//         }
//       }
//     }
//     _spans2.forEach((key, value) {
//       if (value != null && value.isNotEmpty) {
//         _spans.removeAt(key);
//         _spans.insertAll(key, value);
//       }
//     });
//   }
//   return ExtendedText.rich(TextSpan(
//       children: _spans.map<InlineSpan>((item) {
//     if (item is String) {
//       return TextSpan(text: _removeAllHtmlTags(item), style: _style);
//     }
//     return item;
//   }).toList()));
// }
//
// String _replaceBugsContent(String text) {
//   if (text.startsWith("*")) {
//     return text.replaceFirst("*", "");
//   }
//   return text;
// }
//
// Map<String, TextStyle> _regexTags() {
//   return {
//     ".i": _style.copyWith(fontStyle: FontStyle.italic),
//     ".em": _style.copyWith(fontStyle: FontStyle.italic),
//     ".strong": _style.copyWith(fontWeight: FontWeight.bold),
//     ".u": _style.copyWith(decoration: TextDecoration.underline),
//     ".b": _style.copyWith(fontWeight: FontWeight.bold),
//     ".code": _style.copyWith(
//       backgroundColor: MyColors.colorBlackFull.withOpacity(0.1),
//     ),
//     ".small": _style.copyWith(fontSize: _style.fontSize - 1.5),
//     ".p": _style,
//   };
// }
//
// String _replaceOldDataToHTML(String _content,
//     {Map<String, ImageAssetData> assets}) {
//   String _newContent = _content;
//   if (_newContent == null) {
//     _newContent = "";
//   }
//   if (_newContent.indexOf("<>") > -1) {
//     List<String> list = _newContent.split("<>");
//     _newContent = list.map((str) {
//       for (String _regexTag in _tags.keys) {
//         if (str.indexOf(_regexTag) > -1 &&
//             str.toLowerCase().indexOf('.png') == -1 &&
//             str.toLowerCase().indexOf('.jpg') == -1) {
//           String _tag = _regexTag.replaceFirst(".", "");
//           return "<$_tag>" + str.replaceAll(_regexTag, "") + "</$_tag>";
//         }
//       }
//       return str;
//     }).join(" ");
//   }
//   if (_newContent.indexOf("\$") > -1) {
//     List<String> list = _newContent.split("\$");
//     _newContent = list
//         .map((str) {
//           if (isImage(str)) {
//             String _assetsPath = DataManager.getInstance()
//                 .getLocalImageUrl(str, imageFolder: imageFolder);
//             if (assets != null && assets[_assetsPath] != null) {
//               return "<img src=\"${uint8ListTob64(assets[_assetsPath].data)}\" />";
//             }
//             return "<img src=\"${DataManager.getInstance().getNetworkImageUrl(str)}\" />";
//           }
//           return str;
//         })
//         .toList()
//         .join(" ");
//   }
//   return _newContent;
// }
}
//
// class ImageAssetData {
//   Uint8List data;
//   int width;
//   int height;
//
//   ImageAssetData({this.width, this.height, this.data});
// }

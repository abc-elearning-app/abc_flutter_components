bool isImage(String name) {
  if(name.isEmpty) {
    return false;
  }
  name = name.trim().toLowerCase();
  return name.endsWith(".png") || name.endsWith(".jpg") || name.endsWith(".jpeg") || name.endsWith(".svg") || name.endsWith(".gif") || name.endsWith(".webp");
}

final RegExp htmlRegex = RegExp(
    r'<[^>]*>|&[^;]+;',
    multiLine: true,
    caseSensitive: true
);

bool isHtml(String str) {
  if(str == null || str.isEmpty) {
    return false;
  }
  return htmlRegex.hasMatch(str);
}

extension StringExtension on String {
  String get shortUrl {
    return replaceAll('http://www.', '')
        .replaceAll('https://www.', '')
        .replaceAll('http://', '')
        .replaceAll('https://', '')
        .replaceAll('www.', '');
  }
}

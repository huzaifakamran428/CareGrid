import 'dart:typed_data';
bool isValidDemoDocument(String name, Uint8List bytes) {
  if (bytes.isEmpty || bytes.length > 5 * 1024 * 1024) return false;
  final n = name.toLowerCase();
  bool starts(List<int> s) => bytes.length >= s.length &&
      List.generate(s.length, (i) => bytes[i] == s[i]).every((v) => v);
  return (n.endsWith('.pdf') && starts([37,80,68,70,45])) ||
      (n.endsWith('.png') && starts([137,80,78,71,13,10,26,10])) ||
      ((n.endsWith('.jpg') || n.endsWith('.jpeg')) && starts([255,216,255]));
}

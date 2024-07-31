import 'package:flutter/material.dart';
import 'slice.dart';
import 'translation.dart';

class HighlightSegment {
  final String text;
  final Color color;

  HighlightSegment({required this.text, required this.color});
}

class AyahHighlighter {
  List<Map<String, dynamic>>? ayats;
  List<List<List<HighlightSegment>>> ayahHighlights = [];
  List<List<List<String>>> translations = [];

  AyahHighlighter({required this.ayats}) {
    generateAyahHighlights();
  }

  void generateAyahHighlights() {
    if (ayats == null) return;

    ayahHighlights = AyahSlicer.generateSlices(ayats!);
    translations = ayats!.map((ayah) => getTranslations(ayah['aya'])).toList();
  }

  List<String> getCurrentTranslations(int ayahIndex, int sliceIndex) {
    if (ayahIndex >= 0 && ayahIndex < translations.length &&
        sliceIndex >= 0 && sliceIndex < translations[ayahIndex].length) {
      return translations[ayahIndex][sliceIndex];
    }
    return [];
  }

  int getNumberOfSlices(int ayahIndex) {
    if (ayahIndex >= 0 && ayahIndex < ayahHighlights.length) {
      return ayahHighlights[ayahIndex].length;
    }
    return 0;
  }

  TextSpan getCurrentSliceTextSpan(int ayahIndex, int sliceIndex) {
    if (ayahIndex >= 0 && ayahIndex < ayahHighlights.length &&
        sliceIndex >= 0 && sliceIndex < ayahHighlights[ayahIndex].length) {
      List<HighlightSegment> segments = ayahHighlights[ayahIndex][sliceIndex];
      String ayahText = ayats![ayahIndex]['text'] ?? '';
      return highlightAyah(ayahText, segments);
    }
    return const TextSpan(text: '');
  }

  TextSpan highlightAyah(String text, List<HighlightSegment> segmentsToHighlight) {
    List<TextSpan> spans = [];
    Map<String, int> wordOccurrences = {};

    for (var segment in segmentsToHighlight) {
      wordOccurrences[segment.text] = (wordOccurrences[segment.text] ?? 0) + 1;
    }

    for (var segment in segmentsToHighlight) {
      String part = segment.text;
      Color color = segment.color;

      int startIndex = text.indexOf(part);
      while (startIndex != -1 && wordOccurrences[part]! > 0) {
        spans.add(
          TextSpan(
            text: text.substring(0, startIndex),
            style: const TextStyle(
              fontFamily: "MeQuran2",
              fontSize: 20,
              color: Colors.black,
            ),
          ),
        );
        spans.add(
          TextSpan(
            text: part,
            style: TextStyle(
              fontFamily: "MeQuran2",
              fontSize: 20,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
        text = text.substring(startIndex + part.length);
        startIndex = text.indexOf(part);
        wordOccurrences[part] = wordOccurrences[part]! - 1;
      }
    }

    if (text.isNotEmpty) {
      spans.add(
        TextSpan(
          text: text,
          style: const TextStyle(
            fontFamily: "MeQuran2",
            fontSize: 20,
            color: Colors.black,
          ),
        ),
      );
    }

    return TextSpan(children: spans);
  }
}

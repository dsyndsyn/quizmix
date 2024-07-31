import 'package:flutter/material.dart';
import 'highlighter.dart';

class AyahSlicer {
  // Static method to generate highlighted slices for Quranic verses
  static List<List<List<HighlightSegment>>> generateSlices(List<Map<String, dynamic>> ayats) {
    List<List<List<HighlightSegment>>> ayahSlices = [];

    if (ayats.isEmpty) return ayahSlices; // Return empty list if ayats is empty

    for (var ayah in ayats) {
      List<List<HighlightSegment>> slices = [];
      String text = ayah['text'] ?? '';

      // Split text into words or chunks based on space or any delimiter
      List<String> words = text.split(' ');

      // Create HighlightSegments for each word except the last one
      for (var i = 0; i < words.length - 1; i++) {
        slices.add([
          HighlightSegment(text: words[i], color: Colors.blue),
        ]);
      }

      ayahSlices.add(slices); // Add slices for current ayah to ayahSlices
    }

    return ayahSlices;
  }
}

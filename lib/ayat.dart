import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'highlighter.dart';

class AyatScreen extends StatefulWidget {
  const AyatScreen({super.key});

  @override
  AyatScreenState createState() => AyatScreenState();
}

class AyatScreenState extends State<AyatScreen> {
  List<Map<String, dynamic>>? ayats;
  bool isLoading = false;
  int currentIndex = 0;
  int currentSliceIndex = 0;
  late AyahHighlighter ayahHighlighter;

  @override
  void initState() {
    super.initState();
    loadJson();
  }

  Future<void> loadJson() async {
    setState(() {
      isLoading = true;
    });

    try {
      String jsonString = await rootBundle.loadString('assets/data/quran_texts-alfatihah.json');
      Map<String, dynamic> jsonMap = json.decode(jsonString);
      ayats = jsonMap['data'].values.toList().cast<Map<String, dynamic>>();

      ayats?.sort((a, b) => int.parse(a['aya']).compareTo(int.parse(b['aya'])));
      ayahHighlighter = AyahHighlighter(ayats: ayats!);
    } catch (e) {
      debugPrint('Failed to load Ayat: $e');
    }

    setState(() {
      isLoading = false;
    });
  }

  void showNextAya() {
    if (currentIndex < (ayats?.length ?? 0) - 1) {
      setState(() {
        currentIndex++;
        currentSliceIndex = 0;
      });
    }
  }

  void showPreviousAya() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        currentSliceIndex = 0;
      });
    }
  }

  void nextSlice() {
    if (currentSliceIndex < ayahHighlighter.getNumberOfSlices(currentIndex) - 1) {
      setState(() {
        currentSliceIndex++;
      });
    }
  }

  void previousSlice() {
    if (currentSliceIndex > 0) {
      setState(() {
        currentSliceIndex--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    int totalAyats = ayats?.length ?? 0;
    double progress = totalAyats > 0 ? (currentIndex + 1) / totalAyats : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Surah Al-Fatihah'),
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_left),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.grey,
            height: 1.0,
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ayats == null || ayats!.isEmpty
          ? const Center(child: Text('Failed to load Ayat'))
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 10,
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  const Text(
                    'Choose the correct words',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                      text: ayahHighlighter.getCurrentSliceTextSpan(
                        currentIndex,
                        currentSliceIndex,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '~ Al-Fatihah 1:${ayats![currentIndex]['aya']}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (currentSliceIndex > 0)
                        IconButton(
                          onPressed: previousSlice,
                          icon: const Icon(Icons.keyboard_arrow_left, color: Colors.black),
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                        ),
                      const SizedBox(width: 8),
                      if (currentSliceIndex < ayahHighlighter.getNumberOfSlices(currentIndex) - 1)
                        IconButton(
                          onPressed: nextSlice,
                          icon: const Icon(Icons.keyboard_arrow_right, color: Colors.black),
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: ayahHighlighter
                    .getCurrentTranslations(currentIndex, currentSliceIndex)
                    .map((translation) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    translation,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ))
                    .toList(),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (currentIndex > 0)
                GestureDetector(
                  onTap: showPreviousAya,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: Colors.orange,
                        width: 2,
                      ),
                    ),
                    child: const Text(
                      'Previous',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              const SizedBox(width: 8),
              if (currentIndex < (ayats?.length ?? 0) - 1)
                GestureDetector(
                  onTap: showNextAya,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: Colors.orange,
                        width: 2,
                      ),
                    ),
                    child: const Text(
                      'Next',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

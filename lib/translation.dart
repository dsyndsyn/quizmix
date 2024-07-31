// translation.dart

List<List<String>> getTranslations(String ayahNumber) {
  switch (ayahNumber) {
    case '1':
      return [
        ['In (the) name'],
        ['(of) Allah'],
        ['the Most Gracious'],
        ['the Most Merciful'],
      ];
    case '2':
      return [
        ['All praises and thanks'],
        ['(be) to Allah'],
        ['the Lord'],
        ['of the universe'],
      ];
    case '3':
      return [
        ['The Most Gracious'],
        ['the Most Merciful'],
      ];
    case '4':
      return [
        ['(The) Master'],
        ['(of the) Day'],
        ['(of the) Judgement'],
      ];
    case '5':
      return [
        ['You Alone'],
        ['we worship'],
        ['and You Alone'],
        ['we ask for help'],
      ];
    case '6':
      return [
        ['Guide us'],
        ['(to) the path'],
        ['the straight'],
      ];
    case '7':
      return [
        ['(The) path'],
        ['(of) those'],
        ['You have bestowed (Your) Favors'],
        ['on them'],
        ['not (of)'],
        ['those who earned (Your) wrath'],
        ['on themselves'],
        ['and not'],
        ['(of) those who go astray'],
      ];
  // Add translations for other ayahs as needed
    default:
      return [];
  }
}

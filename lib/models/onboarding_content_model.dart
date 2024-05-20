class OnboardingInfo {
  final String imageAsset;
  final String title;
  final String description;

  OnboardingInfo({
    required this.imageAsset,
    required this.title,
    required this.description,
  });
}

List<OnboardingInfo> onboardingPages = [
  OnboardingInfo(
    imageAsset: 'assets/images/books.png',
    title: 'Dijital Kitaplarla Tanışın',
    description:
        'Dijital dünyada binlerce kitabı keşfedin ve favorilerinizi belirleyin.',
  ),
  OnboardingInfo(
    imageAsset: 'assets/images/reading.png',
    title: 'Toplulukla Birlikte Okuyun',
    description:
        'Kitapseverlerle buluşun, deneyimlerinizi paylaşın ve yeni okuma arkadaşlıkları kurun.',
  ),
  OnboardingInfo(
    imageAsset: 'assets/images/reading_and_listening.png',
    title: 'Okuma ve Dinleme Keyfi',
    description:
        'Kitapları okuyun veya sesli kitap olarak dinleyin. Her iki deneyimi bir arada yaşayın.',
  ),
];

class OnBoardingItem {
  OnBoardingItem({
    this.buttonBack,
    this.buttonNext,
    required this.image,
    required this.subtitle,
    required this.title,
  });

  String image;

  String title;

  String? subtitle;

  String? buttonNext;

  String? buttonBack;
}

class OnboardingModel {
  final String image;
  final String title;
  final String subtitle1;
  final String subtitle2;

  OnboardingModel({
    required this.image,
    required this.title,
    required this.subtitle1,
    required this.subtitle2,
  });

  // Factory method for creating an instance from JSON
  factory OnboardingModel.fromJson(Map<String, dynamic> json) {
    return OnboardingModel(
      image: json['image'] ?? '',
      title: json['title'] ?? '',
      subtitle1: json['subtitle1'] ?? '',
      subtitle2: json['subtitle2'] ?? '',
    );
  }

  // Convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'title': title,
      'subtitle1': subtitle1,
      'subtitle2': subtitle2,
    };
  }
}

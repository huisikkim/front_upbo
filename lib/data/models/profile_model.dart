class ProfileModel {
  final int id;
  final String name;
  final String? relationship;
  final String? organization;
  final String? profileImage;
  final int totalDebt;

  ProfileModel({
    required this.id,
    required this.name,
    this.relationship,
    this.organization,
    this.profileImage,
    this.totalDebt = 0,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      name: json['name'],
      relationship: json['relationship'],
      organization: json['organization'],
      profileImage: json['profile_image'],
      totalDebt: json['total_debt'] ?? 0,
    );
  }
}

class ProfileModel {
  final int id;
  final String name;
  final String? relation;
  final String? organization;
  final String? phone;
  final String? memo;
  final String? profileImage;
  final int totalDebt;

  ProfileModel({
    required this.id,
    required this.name,
    this.relation,
    this.organization,
    this.phone,
    this.memo,
    this.profileImage,
    this.totalDebt = 0,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      name: json['name'],
      relation: json['relation'],
      organization: json['organization'],
      phone: json['phone'],
      memo: json['memo'],
      profileImage: json['profile_image'],
      totalDebt: json['total_debt'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'relation': relation,
      'organization': organization,
      'phone': phone,
      'memo': memo,
    };
  }
}

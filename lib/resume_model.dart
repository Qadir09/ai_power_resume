class ResumeModel {
  String name;
  String email;
  String phone;
  List<String> skills;
  String experience;
  String objective;
  List<Education> education;
  String linkedin;

  ResumeModel({
    this.name = '',
    this.email = '',
    this.phone = '',
    this.skills = const [],
    this.experience = '',
    this.objective = '',
    this.education = const [],
    this.linkedin = '',
  });

  toPromptString() {}
}

class Education {
  final String degree;
  final String institution;
  final String year;

  Education({
    required this.degree,
    required this.institution,
    required this.year,
  });
}

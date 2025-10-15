class Voter {
  final int? id;
  final String pkNumber;
  final String lastName;
  final String firstName;
  final bool hasVoted;

  Voter({
    this.id,
    required this.pkNumber,
    required this.lastName,
    required this.firstName,
    this.hasVoted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'pkNumber': pkNumber,
      'lastName': lastName,
      'firstName': firstName,
      'hasVoted': hasVoted ? 1 : 0,
    };
  }

  factory Voter.fromMap(Map<String, dynamic> map) {
    return Voter(
      id: map['id'] as int?,
      pkNumber: map['pkNumber'] as String,
      lastName: map['lastName'] as String,
      firstName: map['firstName'] as String,
      hasVoted: map['hasVoted'] == 1,
    );
  }

  Voter copyWith({
    int? id,
    String? pkNumber,
    String? lastName,
    String? firstName,
    bool? hasVoted,
  }) {
    return Voter(
      id: id ?? this.id,
      pkNumber: pkNumber ?? this.pkNumber,
      lastName: lastName ?? this.lastName,
      firstName: firstName ?? this.firstName,
      hasVoted: hasVoted ?? this.hasVoted,
    );
  }
}

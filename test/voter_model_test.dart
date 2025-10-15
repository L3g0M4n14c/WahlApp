import 'package:flutter_test/flutter_test.dart';
import 'package:wahlapp/models/voter.dart';

void main() {
  group('Voter Model Tests', () {
    test('Voter should be created with required fields', () {
      final voter = Voter(
        pkNumber: '12345',
        lastName: 'Müller',
        firstName: 'Hans',
      );

      expect(voter.pkNumber, '12345');
      expect(voter.lastName, 'Müller');
      expect(voter.firstName, 'Hans');
      expect(voter.hasVoted, false);
      expect(voter.id, null);
    });

    test('Voter should convert to map correctly', () {
      final voter = Voter(
        id: 1,
        pkNumber: '12345',
        lastName: 'Müller',
        firstName: 'Hans',
        hasVoted: true,
      );

      final map = voter.toMap();

      expect(map['id'], 1);
      expect(map['pkNumber'], '12345');
      expect(map['lastName'], 'Müller');
      expect(map['firstName'], 'Hans');
      expect(map['hasVoted'], 1);
    });

    test('Voter should be created from map correctly', () {
      final map = {
        'id': 1,
        'pkNumber': '12345',
        'lastName': 'Müller',
        'firstName': 'Hans',
        'hasVoted': 1,
      };

      final voter = Voter.fromMap(map);

      expect(voter.id, 1);
      expect(voter.pkNumber, '12345');
      expect(voter.lastName, 'Müller');
      expect(voter.firstName, 'Hans');
      expect(voter.hasVoted, true);
    });

    test('Voter copyWith should update only specified fields', () {
      final voter = Voter(
        id: 1,
        pkNumber: '12345',
        lastName: 'Müller',
        firstName: 'Hans',
        hasVoted: false,
      );

      final updatedVoter = voter.copyWith(hasVoted: true);

      expect(updatedVoter.id, 1);
      expect(updatedVoter.pkNumber, '12345');
      expect(updatedVoter.lastName, 'Müller');
      expect(updatedVoter.firstName, 'Hans');
      expect(updatedVoter.hasVoted, true);
    });

    test('hasVoted should default to false', () {
      final voter = Voter(
        pkNumber: '12345',
        lastName: 'Müller',
        firstName: 'Hans',
      );

      expect(voter.hasVoted, false);
    });
  });
}

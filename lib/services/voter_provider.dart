import 'package:flutter/foundation.dart';
import '../models/voter.dart';
import '../services/database_service.dart';

class VoterProvider extends ChangeNotifier {
  List<Voter> _voters = [];
  List<Voter> _filteredVoters = [];
  bool _isLoading = false;
  String _searchQuery = '';

  List<Voter> get voters => _filteredVoters;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;

  int get totalVoters => _voters.length;
  int get votedCount => _voters.where((v) => v.hasVoted).length;
  int get notVotedCount => _voters.where((v) => !v.hasVoted).length;

  Future<void> loadVoters() async {
    _isLoading = true;
    notifyListeners();

    try {
      _voters = await DatabaseService.instance.getAllVoters();
      _applyFilter();
    } catch (e) {
      debugPrint('Error loading voters: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  void searchVoters(String query) {
    _searchQuery = query;
    _applyFilter();
    notifyListeners();
  }

  void _applyFilter() {
    if (_searchQuery.isEmpty) {
      _filteredVoters = List.from(_voters);
    } else {
      final lowerQuery = _searchQuery.toLowerCase();
      _filteredVoters = _voters.where((voter) {
        return voter.pkNumber.toLowerCase().contains(lowerQuery) ||
            voter.lastName.toLowerCase().contains(lowerQuery) ||
            voter.firstName.toLowerCase().contains(lowerQuery);
      }).toList();
    }
  }

  Future<void> toggleVoted(Voter voter) async {
    try {
      final updatedVoter = voter.copyWith(hasVoted: !voter.hasVoted);
      await DatabaseService.instance.updateVoter(updatedVoter);
      
      final index = _voters.indexWhere((v) => v.id == voter.id);
      if (index != -1) {
        _voters[index] = updatedVoter;
        _applyFilter();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error toggling voted status: $e');
    }
  }

  Future<void> addVoter(Voter voter) async {
    try {
      final createdVoter = await DatabaseService.instance.createVoter(voter);
      _voters.add(createdVoter);
      _applyFilter();
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding voter: $e');
      rethrow;
    }
  }

  Future<void> deleteVoter(Voter voter) async {
    if (voter.id == null) return;

    try {
      await DatabaseService.instance.deleteVoter(voter.id!);
      _voters.removeWhere((v) => v.id == voter.id);
      _applyFilter();
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting voter: $e');
    }
  }
}

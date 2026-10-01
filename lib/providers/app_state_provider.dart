import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/syllabus_models.dart';
import '../data/syllabus_data.dart';

class AppStateProvider extends ChangeNotifier {
  List<SectionModel> _sections = [];
  bool _isLoading = true;
  String _searchQuery = '';
  int? _selectedSectionFilter;

  // Bookmarks
  final Set<String> _bookmarkedNoteIds = {};
  final Set<String> _bookmarkedMcqIds = {};

  List<SectionModel> get sections => _sections;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  int? get selectedSectionFilter => _selectedSectionFilter;

  AppStateProvider() {
    _initializeData();
  }

  Future<void> _initializeData() async {
    _isLoading = true;
    notifyListeners();

    _sections = getInitialSyllabusData();

    try {
      final prefs = await SharedPreferences.getInstance();
      final completedTopicIds = prefs.getStringList('completed_topics') ?? [];
      final savedBookmarkedNotes = prefs.getStringList('bookmarked_notes') ?? [];
      final savedBookmarkedMcqs = prefs.getStringList('bookmarked_mcqs') ?? [];

      _bookmarkedNoteIds.addAll(savedBookmarkedNotes);
      _bookmarkedMcqIds.addAll(savedBookmarkedMcqs);

      for (var section in _sections) {
        for (var topic in section.topics) {
          if (completedTopicIds.contains(topic.id)) {
            topic.isCompleted = true;
          }
        }
      }
    } catch (e) {
      debugPrint('Error loading saved state: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // Toggle Topic Completion
  Future<void> toggleTopicCompletion(String topicId) async {
    for (var section in _sections) {
      for (var topic in section.topics) {
        if (topic.id == topicId) {
          topic.isCompleted = !topic.isCompleted;
          break;
        }
      }
    }
    notifyListeners();
    await _saveCompletedTopics();
  }

  Future<void> _saveCompletedTopics() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> completedIds = [];
      for (var section in _sections) {
        for (var topic in section.topics) {
          if (topic.isCompleted) {
            completedIds.add(topic.id);
          }
        }
      }
      await prefs.setStringList('completed_topics', completedIds);
    } catch (e) {
      debugPrint('Error saving completed topics: $e');
    }
  }

  // Add Extracted Content from YouTube Video
  void addVideoContentToTopic({
    required String topicId,
    required VideoSourceModel video,
    List<RevisionNoteModel> notes = const [],
    List<McqModel> mcqs = const [],
  }) {
    for (var section in _sections) {
      for (var i = 0; i < section.topics.length; i++) {
        if (section.topics[i].id == topicId) {
          final current = section.topics[i];
          final updatedVideos = List<VideoSourceModel>.from(current.videos)..add(video);
          final updatedNotes = List<RevisionNoteModel>.from(current.notes)..addAll(notes);
          final updatedMcqs = List<McqModel>.from(current.mcqs)..addAll(mcqs);

          section.topics[i] = current.copyWith(
            videos: updatedVideos,
            notes: updatedNotes,
            mcqs: updatedMcqs,
          );
          notifyListeners();
          return;
        }
      }
    }
  }

  // Search and Filter
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSectionFilter(int? sectionId) {
    _selectedSectionFilter = sectionId;
    notifyListeners();
  }

  // Bookmark handlers
  bool isNoteBookmarked(String noteId) => _bookmarkedNoteIds.contains(noteId);
  bool isMcqBookmarked(String mcqId) => _bookmarkedMcqIds.contains(mcqId);

  Future<void> toggleNoteBookmark(String noteId) async {
    if (_bookmarkedNoteIds.contains(noteId)) {
      _bookmarkedNoteIds.remove(noteId);
    } else {
      _bookmarkedNoteIds.add(noteId);
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('bookmarked_notes', _bookmarkedNoteIds.toList());
  }

  Future<void> toggleMcqBookmark(String mcqId) async {
    if (_bookmarkedMcqIds.contains(mcqId)) {
      _bookmarkedMcqIds.remove(mcqId);
    } else {
      _bookmarkedMcqIds.add(mcqId);
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('bookmarked_mcqs', _bookmarkedMcqIds.toList());
  }

  // Analytics & Progress
  int get totalTopicsCount {
    return _sections.fold(0, (sum, sec) => sum + sec.topics.length);
  }

  int get totalCompletedTopicsCount {
    return _sections.fold(0, (sum, sec) => sum + sec.completedTopicsCount);
  }

  double get overallProgress {
    if (totalTopicsCount == 0) return 0.0;
    return totalCompletedTopicsCount / totalTopicsCount;
  }

  int get estimatedCoveredMarks {
    double totalMarksEarned = 0;
    for (var section in _sections) {
      if (section.topics.isNotEmpty) {
        totalMarksEarned += (section.completedTopicsCount / section.topics.length) * section.marks;
      }
    }
    return totalMarksEarned.round();
  }

  int get totalVideoLecturesCount {
    int count = 0;
    for (var sec in _sections) {
      for (var t in sec.topics) {
        count += t.videos.length;
      }
    }
    return count;
  }

  int get totalNotesCount {
    int count = 0;
    for (var sec in _sections) {
      for (var t in sec.topics) {
        count += t.notes.length;
      }
    }
    return count;
  }

  int get totalMcqsCount {
    int count = 0;
    for (var sec in _sections) {
      for (var t in sec.topics) {
        count += t.mcqs.length;
      }
    }
    return count;
  }
}

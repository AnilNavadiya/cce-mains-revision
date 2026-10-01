import 'package:flutter/material.dart';

class SectionModel {
  final int id;
  final String title;
  final String shortTitle;
  final int marks;
  final IconData icon;
  final Color color;
  final List<TopicModel> topics;

  SectionModel({
    required this.id,
    required this.title,
    required this.shortTitle,
    required this.marks,
    required this.icon,
    required this.color,
    required this.topics,
  });

  int get completedTopicsCount => topics.where((t) => t.isCompleted).length;
  double get progress => topics.isEmpty ? 0.0 : completedTopicsCount / topics.length;
}

class TopicModel {
  final String id;
  final int sectionId;
  final String title;
  final List<String> microSyllabusPoints;
  bool isCompleted;
  final List<RevisionNoteModel> notes;
  final List<McqModel> mcqs;
  final List<VideoSourceModel> videos;

  TopicModel({
    required this.id,
    required this.sectionId,
    required this.title,
    this.microSyllabusPoints = const [],
    this.isCompleted = false,
    this.notes = const [],
    this.mcqs = const [],
    this.videos = const [],
  });

  TopicModel copyWith({
    String? id,
    int? sectionId,
    String? title,
    List<String>? microSyllabusPoints,
    bool? isCompleted,
    List<RevisionNoteModel>? notes,
    List<McqModel>? mcqs,
    List<VideoSourceModel>? videos,
  }) {
    return TopicModel(
      id: id ?? this.id,
      sectionId: sectionId ?? this.sectionId,
      title: title ?? this.title,
      microSyllabusPoints: microSyllabusPoints ?? this.microSyllabusPoints,
      isCompleted: isCompleted ?? this.isCompleted,
      notes: notes ?? this.notes,
      mcqs: mcqs ?? this.mcqs,
      videos: videos ?? this.videos,
    );
  }
}

class RevisionNoteModel {
  final String id;
  final String title;
  final String markdownContent;
  final List<String> tags;
  final String? sourceVideoId;
  final String? videoTimestamp;

  RevisionNoteModel({
    required this.id,
    required this.title,
    required this.markdownContent,
    this.tags = const [],
    this.sourceVideoId,
    this.videoTimestamp,
  });
}

class McqModel {
  final String id;
  final String question;
  final List<String> options;
  final int correctOptionIndex; // 0, 1, 2, 3
  final String explanation;
  final String? sourceVideoTitle;

  McqModel({
    required this.id,
    required this.question,
    required this.options,
    required this.correctOptionIndex,
    required this.explanation,
    this.sourceVideoTitle,
  });
}

class VideoSourceModel {
  final String id;
  final String youtubeUrl;
  final String youtubeVideoId;
  final String title;
  final String channelName;
  final String duration;
  final String summary;
  final List<String> keyTakeaways;
  final String topicId;

  VideoSourceModel({
    required this.id,
    required this.youtubeUrl,
    required this.youtubeVideoId,
    required this.title,
    required this.channelName,
    this.duration = '',
    required this.summary,
    this.keyTakeaways = const [],
    required this.topicId,
  });

  String get thumbnailUrl => 'https://img.youtube.com/vi/$youtubeVideoId/hqdefault.jpg';
}

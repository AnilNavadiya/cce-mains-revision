import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/syllabus_models.dart';
import '../providers/app_state_provider.dart';
import '../screens/topic_detail_screen.dart';

class TopicTile extends StatelessWidget {
  final TopicModel topic;
  final bool showSectionTitle;

  const TopicTile({
    super.key,
    required this.topic,
    this.showSectionTitle = false,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppStateProvider>();
    final section = provider.sections.firstWhere((s) => s.id == topic.sectionId);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      elevation: 0.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: topic.isCompleted ? Colors.green.shade200 : Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TopicDetailScreen(
                sectionId: topic.sectionId,
                topicId: topic.id,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showSectionTitle) ...[
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: section.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      section.shortTitle,
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: section.color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
              ],
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Checkbox
                  Transform.scale(
                    scale: 1.1,
                    child: Checkbox(
                      value: topic.isCompleted,
                      activeColor: Colors.green.shade700,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      onChanged: (val) {
                        provider.toggleTopicCompletion(topic.id);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          topic.title,
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w600,
                            color: topic.isCompleted ? Colors.grey.shade600 : const Color(0xFF0F172A),
                            decoration: topic.isCompleted ? TextDecoration.lineThrough : null,
                            decorationColor: Colors.grey.shade400,
                            height: 1.35,
                          ),
                        ),
                        if (topic.microSyllabusPoints.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            '• ${topic.microSyllabusPoints.first}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                              height: 1.3,
                            ),
                          ),
                        ],
                        const SizedBox(height: 8),
                        // Badges for notes, videos, MCQs
                        Row(
                          children: [
                            if (topic.videos.isNotEmpty) ...[
                              _buildPill(
                                icon: Icons.play_circle_fill_rounded,
                                label: '${topic.videos.length} વિડિયો',
                                color: Colors.red.shade700,
                                bgColor: Colors.red.shade50,
                              ),
                              const SizedBox(width: 6),
                            ],
                            if (topic.notes.isNotEmpty) ...[
                              _buildPill(
                                icon: Icons.description_rounded,
                                label: '${topic.notes.length} નોટ્સ',
                                color: Colors.blue.shade700,
                                bgColor: Colors.blue.shade50,
                              ),
                              const SizedBox(width: 6),
                            ],
                            if (topic.mcqs.isNotEmpty) ...[
                              _buildPill(
                                icon: Icons.help_outline_rounded,
                                label: '${topic.mcqs.length} MCQs',
                                color: Colors.purple.shade700,
                                bgColor: Colors.purple.shade50,
                              ),
                            ],
                            const Spacer(),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 13,
                              color: Colors.grey.shade400,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPill({
    required IconData icon,
    required String label,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

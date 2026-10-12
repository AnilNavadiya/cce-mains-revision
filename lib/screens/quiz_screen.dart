import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';
import '../models/syllabus_models.dart';
import '../widgets/mcq_quiz_widget.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int? _selectedSectionId;
  String? _selectedTopicId;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppStateProvider>();
    final sections = provider.sections;

    // Collect MCQs based on selected section and topic
    final List<McqModel> availableMcqs = [];
    for (var sec in sections) {
      if (_selectedSectionId == null || _selectedSectionId == sec.id) {
        for (var topic in sec.topics) {
          if (_selectedTopicId == null || _selectedTopicId == topic.id) {
            availableMcqs.addAll(topic.mcqs);
          }
        }
      }
    }

    final currentSection = _selectedSectionId == null
        ? null
        : sections.where((s) => s.id == _selectedSectionId).firstOrNull;

    return Scaffold(
      appBar: AppBar(
        title: const Text('CCE મોક ટેસ્ટ & MCQ પ્રેક્ટિસ'),
      ),
      body: Column(
        children: [
          // Filter Header
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.filter_list_rounded, size: 20, color: Color(0xFF1E3A8A)),
                    const SizedBox(width: 8),
                    const Text(
                      'વિભાગ:',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: DropdownButton<int?>(
                          value: _selectedSectionId,
                          isExpanded: true,
                          underline: const SizedBox(),
                          hint: const Text('બધા વિભાગો (સંપૂર્ણ મોક ટેસ્ટ)', style: TextStyle(fontSize: 13)),
                          items: [
                            const DropdownMenuItem(
                              value: null,
                              child: Text('બધા વિભાગો (સંપૂર્ણ ટેસ્ટ)', style: TextStyle(fontSize: 13)),
                            ),
                            ...sections.map((s) {
                              return DropdownMenuItem(
                                value: s.id,
                                child: Text('વિભાગ ${s.id}: ${s.shortTitle}', style: const TextStyle(fontSize: 13)),
                              );
                            }),
                          ],
                          onChanged: (val) {
                            setState(() {
                              _selectedSectionId = val;
                              _selectedTopicId = null;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                if (currentSection != null && currentSection.topics.any((t) => t.mcqs.isNotEmpty)) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.topic_outlined, size: 20, color: Color(0xFF0D9488)),
                      const SizedBox(width: 8),
                      const Text(
                        'મુદ્દો:',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: DropdownButton<String?>(
                            value: _selectedTopicId,
                            isExpanded: true,
                            underline: const SizedBox(),
                            hint: const Text('તમામ મુદ્દાઓ', style: TextStyle(fontSize: 13)),
                            items: [
                              const DropdownMenuItem(
                                value: null,
                                child: Text('તમામ મુદ્દાઓ (સંપૂર્ણ વિભાગ)', style: TextStyle(fontSize: 13)),
                              ),
                              ...currentSection.topics
                                  .where((t) => t.mcqs.isNotEmpty)
                                  .map((t) {
                                return DropdownMenuItem(
                                  value: t.id,
                                  child: Text(
                                    '${t.title} (${t.mcqs.length})',
                                    style: const TextStyle(fontSize: 12),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              }),
                            ],
                            onChanged: (val) {
                              setState(() {
                                _selectedTopicId = val;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          // Sub header info
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ઉપલબ્ધ પ્રશ્નો: ${availableMcqs.length}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF475569),
                  ),
                ),
                const Text(
                  'CCE ગ્રુપ B પેટર્ન',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E3A8A),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: McqQuizWidget(
              key: ValueKey('quiz_${_selectedSectionId}_$_selectedTopicId'),
              mcqs: availableMcqs,
            ),
          ),
        ],
      ),
    );
  }
}

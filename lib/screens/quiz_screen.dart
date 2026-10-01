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

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppStateProvider>();
    final sections = provider.sections;

    // Collect MCQs based on selected section or all
    final List<McqModel> availableMcqs = [];
    for (var sec in sections) {
      if (_selectedSectionId == null || _selectedSectionId == sec.id) {
        for (var topic in sec.topics) {
          availableMcqs.addAll(topic.mcqs);
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('CCE મોક ટેસ્ટ & MCQ પ્રેક્ટિસ'),
      ),
      body: Column(
        children: [
          // Filter Header
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                const Icon(Icons.filter_list_rounded, size: 20, color: Color(0xFF1E3A8A)),
                const SizedBox(width: 8),
                const Text(
                  'વિભાગ પસંદ કરો:',
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
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Sub header info
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
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
            child: McqQuizWidget(mcqs: availableMcqs),
          ),
        ],
      ),
    );
  }
}

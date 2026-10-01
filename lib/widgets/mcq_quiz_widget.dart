import 'package:flutter/material.dart';
import '../models/syllabus_models.dart';

class McqQuizWidget extends StatefulWidget {
  final List<McqModel> mcqs;

  const McqQuizWidget({super.key, required this.mcqs});

  @override
  State<McqQuizWidget> createState() => _McqQuizWidgetState();
}

class _McqQuizWidgetState extends State<McqQuizWidget> {
  final Map<int, int?> _selectedAnswers = {};
  final Map<int, bool> _showExplanations = {};

  @override
  Widget build(BuildContext context) {
    if (widget.mcqs.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.quiz_outlined, size: 54, color: Colors.grey.shade400),
              const SizedBox(height: 12),
              const Text(
                'આ ટોપિક માટે હજુ સુધી MCQs ઉપલબ્ધ નથી.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'YouTube લેક્ચર ઉમેરતાની સાથે નવા પ્રશ્નો અહીં ઉમેરાશે.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.black45),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: widget.mcqs.length,
      itemBuilder: (context, index) {
        final mcq = widget.mcqs[index];
        final selectedIndex = _selectedAnswers[index];
        final isAnswered = selectedIndex != null;
        final isCorrect = selectedIndex == mcq.correctOptionIndex;
        final showExplanation = _showExplanations[index] ?? false;

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: isAnswered
                  ? (isCorrect ? Colors.green.shade300 : Colors.red.shade300)
                  : Colors.grey.shade200,
              width: 1.2,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Question Header
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Q ${index + 1}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        mcq.question,
                        style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0F172A),
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Options A, B, C, D
                ...List.generate(mcq.options.length, (optIndex) {
                  final optionText = mcq.options[optIndex];
                  final optionPrefix = String.fromCharCode(65 + optIndex); // A, B, C, D

                  Color optionBg = Colors.white;
                  Color borderColor = Colors.grey.shade300;
                  Color textColor = Colors.black87;

                  if (isAnswered) {
                    if (optIndex == mcq.correctOptionIndex) {
                      optionBg = Colors.green.shade50;
                      borderColor = Colors.green.shade600;
                      textColor = Colors.green.shade900;
                    } else if (optIndex == selectedIndex) {
                      optionBg = Colors.red.shade50;
                      borderColor = Colors.red.shade600;
                      textColor = Colors.red.shade900;
                    }
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        if (!isAnswered) {
                          setState(() {
                            _selectedAnswers[index] = optIndex;
                            _showExplanations[index] = true;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: optionBg,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: borderColor, width: 1.2),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 26,
                              height: 26,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isAnswered && optIndex == mcq.correctOptionIndex
                                    ? Colors.green
                                    : (isAnswered && optIndex == selectedIndex
                                        ? Colors.red
                                        : Colors.grey.shade100),
                              ),
                              child: Text(
                                optionPrefix,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: isAnswered &&
                                          (optIndex == mcq.correctOptionIndex ||
                                              optIndex == selectedIndex)
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                optionText,
                                style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: optIndex == selectedIndex || (isAnswered && optIndex == mcq.correctOptionIndex)
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                  color: textColor,
                                ),
                              ),
                            ),
                            if (isAnswered && optIndex == mcq.correctOptionIndex)
                              const Icon(Icons.check_circle_rounded, color: Colors.green, size: 20),
                            if (isAnswered && optIndex == selectedIndex && !isCorrect)
                              const Icon(Icons.cancel_rounded, color: Colors.red, size: 20),
                          ],
                        ),
                      ),
                    ),
                  );
                }),

                // Explanation Block
                if (showExplanation) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.amber.shade300, width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.lightbulb_rounded, size: 16, color: Colors.amber.shade900),
                            const SizedBox(width: 6),
                            Text(
                              'વિગતવાર સમજૂતી (Explanation):',
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.bold,
                                color: Colors.amber.shade900,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          mcq.explanation,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF334155),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

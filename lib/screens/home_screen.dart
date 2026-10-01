import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';
import '../widgets/progress_card.dart';
import '../widgets/section_card.dart';
import 'syllabus_tracker_screen.dart';
import 'videos_screen.dart';
import 'quiz_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    _DashboardView(),
    SyllabusTrackerScreen(),
    VideosScreen(),
    QuizScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: Colors.white,
        elevation: 3,
        indicatorColor: const Color(0xFF1E3A8A).withValues(alpha: 0.12),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard_rounded, color: Color(0xFF1E3A8A)),
            label: 'ડેશબોર્ડ',
          ),
          NavigationDestination(
            icon: Icon(Icons.checklist_rounded),
            selectedIcon: Icon(Icons.checklist_rounded, color: Color(0xFF1E3A8A)),
            label: 'માઇક્રો-સિલેબસ',
          ),
          NavigationDestination(
            icon: Icon(Icons.video_library_outlined),
            selectedIcon: Icon(Icons.video_library_rounded, color: Color(0xFF1E3A8A)),
            label: 'લેક્ચર્સ',
          ),
          NavigationDestination(
            icon: Icon(Icons.quiz_outlined),
            selectedIcon: Icon(Icons.quiz_rounded, color: Color(0xFF1E3A8A)),
            label: 'MCQ ટેસ્ટ',
          ),
        ],
      ),
    );
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppStateProvider>();
    final sections = provider.sections;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'GSSSB CCE મુખ્ય પરીક્ષા (ગ્રુપ B)',
              style: TextStyle(
                fontSize: 16.5,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            Text(
              '૨૦૦ ગુણ માઇક્રો-સિલેબસ રિવિઝન એપ',
              style: TextStyle(
                fontSize: 11.5,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'સિલેબસ માહિતી',
            icon: const Icon(Icons.info_outline_rounded),
            onPressed: () {
              _showExamPatternDialog(context);
            },
          ),
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.only(bottom: 30),
              children: [
                // Top Progress Card
                const ProgressCard(),

                // Ingestion helper banner
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade700,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.smart_display_rounded, color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'YouTube વિડિયો લિંક આપો',
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E3A8A),
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'ચેટમાં લિંક શેર કરો, હું વિડિયો નોટ્સ અને MCQs કાઢીને યોગ્ય સેક્શનમાં જોડી દઈશ.',
                              style: TextStyle(
                                fontSize: 11.5,
                                color: Color(0xFF334155),
                                height: 1.35,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Section List Title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'પરીક્ષાના ૧૦ મુખ્ય વિભાગો',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      Text(
                        'કુલ: ૨૦૦ ગુણ',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber.shade800,
                        ),
                      ),
                    ],
                  ),
                ),

                // 10 Section Cards
                ...sections.map((section) => SectionCard(section: section)),
              ],
            ),
    );
  }

  void _showExamPatternDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.assessment_rounded, color: Color(0xFF1E3A8A)),
            SizedBox(width: 8),
            Text('CCE ગ્રુપ B પરીક્ષા પદ્ધતિ'),
          ],
        ),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('• પરીક્ષા પદ્ધતિ: હેતુલક્ષી / MCQ આધારિત'),
              SizedBox(height: 6),
              Text('• કુલ ગુણ: ૨૦૦ ગુણ'),
              SizedBox(height: 6),
              Text('• સમય: ૧૨૦ મિનિટ (૨ કલાક)'),
              SizedBox(height: 6),
              Text('• કુલ વિભાગો: ૧૦ વિભાગો'),
              Divider(height: 24),
              Text(
                'આ એપમાં તમામ ૧૦ વિભાગોના માઇક્રો-સિલેબસ ટોપિક્સ, રિવિઝન નોટ્સ, YouTube લેક્ચર્સ અને MCQ ટેસ્ટ ઉપલબ્ધ છે.',
                style: TextStyle(fontSize: 12.5, color: Colors.black54),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('સમજાયું'),
          ),
        ],
      ),
    );
  }
}

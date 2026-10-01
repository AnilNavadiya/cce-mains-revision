import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/app_state_provider.dart';
import '../models/syllabus_models.dart';
import '../widgets/mcq_quiz_widget.dart';

class TopicDetailScreen extends StatefulWidget {
  final int sectionId;
  final String topicId;

  const TopicDetailScreen({
    super.key,
    required this.sectionId,
    required this.topicId,
  });

  @override
  State<TopicDetailScreen> createState() => _TopicDetailScreenState();
}

class _TopicDetailScreenState extends State<TopicDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _launchYouTube(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppStateProvider>();
    final section = provider.sections.firstWhere((s) => s.id == widget.sectionId);
    final topic = section.topics.firstWhere((t) => t.id == widget.topicId);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          section.shortTitle,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: topic.isCompleted ? 'અપૂર્ણ ચિહ્નિત કરો' : 'પૂર્ણ ચિહ્નિત કરો',
            icon: Icon(
              topic.isCompleted ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
              color: topic.isCompleted ? Colors.green : Colors.grey,
            ),
            onPressed: () {
              provider.toggleTopicCompletion(topic.id);
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Topic Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: section.color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'વિભાગ ${section.id} • ${section.marks} ગુણ',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                          color: section.color,
                        ),
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => provider.toggleTopicCompletion(topic.id),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: topic.isCompleted ? Colors.green.shade50 : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: topic.isCompleted ? Colors.green.shade300 : Colors.grey.shade300,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              topic.isCompleted ? Icons.check_circle : Icons.circle_outlined,
                              size: 14,
                              color: topic.isCompleted ? Colors.green.shade700 : Colors.grey.shade600,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              topic.isCompleted ? 'પૂર્ણ થયેલ' : 'બાકી છે',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: topic.isCompleted ? Colors.green.shade800 : Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  topic.title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),

          // Tabs
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              labelColor: section.color,
              unselectedLabelColor: Colors.grey.shade600,
              indicatorColor: section.color,
              indicatorWeight: 3,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
              tabs: [
                Tab(
                  icon: const Icon(Icons.list_alt_rounded, size: 18),
                  text: 'સિલેબસ (${topic.microSyllabusPoints.length})',
                ),
                Tab(
                  icon: const Icon(Icons.menu_book_rounded, size: 18),
                  text: 'નોટ્સ (${topic.notes.length})',
                ),
                Tab(
                  icon: const Icon(Icons.video_library_rounded, size: 18),
                  text: 'વિડિયોઝ (${topic.videos.length})',
                ),
                Tab(
                  icon: const Icon(Icons.quiz_rounded, size: 18),
                  text: 'MCQs (${topic.mcqs.length})',
                ),
              ],
            ),
          ),

          // Tab View
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // 1. Syllabus Points Tab
                _buildSyllabusTab(topic),

                // 2. Revision Notes Tab
                _buildNotesTab(topic, section),

                // 3. YouTube Videos Tab
                _buildVideosTab(topic),

                // 4. MCQs Tab
                McqQuizWidget(mcqs: topic.mcqs),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSyllabusTab(TopicModel topic) {
    if (topic.microSyllabusPoints.isEmpty) {
      return const Center(
        child: Text('કોઈ માઇક્રો-પોઇન્ટ્સ ઉપલબ્ધ નથી.'),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'આ ટોપિક હેઠળ તૈયાર કરવાના મુખ્ય મુદ્દાઓ:',
          style: TextStyle(
            fontSize: 14.5,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 12),
        ...topic.microSyllabusPoints.map((point) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 2),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.arrow_right_rounded, size: 18, color: Colors.blue.shade800),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    point,
                    style: const TextStyle(
                      fontSize: 13.5,
                      color: Color(0xFF334155),
                      height: 1.45,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildNotesTab(TopicModel topic, SectionModel section) {
    if (topic.notes.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.notes_rounded, size: 54, color: Colors.grey.shade400),
              const SizedBox(height: 12),
              const Text(
                'આ ટોપિક માટે હજુ સુધી નોટ્સ ઉમેરાયેલી નથી.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'YouTube લેક્ચરની વિગતો અહીં ઓટોમેટિક રિવિઝન નોટ્સ તરીકે ઉપલબ્ધ થશે.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.black45),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: topic.notes.length,
      itemBuilder: (context, index) {
        final note = topic.notes[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        note.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: section.color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'રિવિઝન બાઇટ',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: section.color,
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 20),
                MarkdownBody(
                  data: note.markdownContent,
                  styleSheet: MarkdownStyleSheet(
                    p: const TextStyle(fontSize: 13.5, height: 1.5, color: Color(0xFF334155)),
                    h3: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                    strong: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                  ),
                ),
                if (note.tags.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: note.tags.map((tag) {
                      return Chip(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                        label: Text(tag, style: const TextStyle(fontSize: 11)),
                        backgroundColor: Colors.grey.shade100,
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildVideosTab(TopicModel topic) {
    if (topic.videos.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.video_library_outlined, size: 54, color: Colors.grey.shade400),
              const SizedBox(height: 12),
              const Text(
                'કોઈ YouTube લેક્ચર હજી સુધી ઉમેરાયેલ નથી.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'તમે YouTube વિડિયો લિંક આપશો એટલે આ ટોપિક સાથે જોડાઈ જશે.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.black45),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: topic.videos.length,
      itemBuilder: (context, index) {
        final video = topic.videos[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail / Video banner
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        video.thumbnailUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, err, stack) {
                          return Container(
                            color: Colors.grey.shade800,
                            alignment: Alignment.center,
                            child: const Icon(Icons.play_circle_fill, color: Colors.white70, size: 50),
                          );
                        },
                      ),
                      Container(
                        color: Colors.black.withValues(alpha: 0.25),
                      ),
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.85),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 32),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      video.title,
                      style: const TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'ચેનલ: ${video.channelName}',
                      style: TextStyle(fontSize: 12.5, color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      video.summary,
                      style: const TextStyle(fontSize: 13, color: Color(0xFF334155), height: 1.4),
                    ),
                    if (video.keyTakeaways.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      const Text(
                        'મુખ્ય પરીક્ષાલક્ષી તારણો:',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      ...video.keyTakeaways.map((takeaway) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.check_circle_outline, size: 14, color: Colors.green),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  takeaway,
                                  style: const TextStyle(fontSize: 12.5, color: Color(0xFF334155)),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.open_in_new_rounded, size: 16),
                        label: const Text('YouTube પર વિડિયો જુઓ'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade700,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () => _launchYouTube(video.youtubeUrl),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

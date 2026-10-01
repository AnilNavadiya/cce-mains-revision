import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/app_state_provider.dart';
import '../models/syllabus_models.dart';
import 'topic_detail_screen.dart';

class VideosScreen extends StatelessWidget {
  const VideosScreen({super.key});

  Future<void> _launchYouTube(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppStateProvider>();
    final sections = provider.sections;

    // Collect all videos
    final List<Map<String, dynamic>> allVideoEntries = [];
    for (var sec in sections) {
      for (var t in sec.topics) {
        for (var v in t.videos) {
          allVideoEntries.add({
            'video': v,
            'topic': t,
            'section': sec,
          });
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('YouTube વિડિયો લેક્ચર્સ & નોટ્સ'),
      ),
      body: allVideoEntries.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(28.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.video_library_rounded, size: 54, color: Colors.red.shade600),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'કોઈ વિડિયો હજુ ઉમેરાયેલ નથી',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'તમે ચેટમાં જે પણ YouTube વિડિયો લિંક આપશો, તેના તમામ મહત્વપૂર્ણ પોઇન્ટ્સ, સારાંશ અને MCQs કાઢીને સિલેબસના યોગ્ય વિભાગમાં ઉમેરવામાં આવશે!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13.5,
                        color: Color(0xFF64748B),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.amber.shade300),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.info_outline_rounded, color: Colors.amber, size: 20),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'તમારી પ્રથમ YouTube લિંક ચેટમાં મોકલો અને હું સંપૂર્ણ ડેટા પ્રોસેસ કરીને એપમાં ઉમેરી આપીશ.',
                              style: TextStyle(fontSize: 12.5, color: Color(0xFF78350F)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: allVideoEntries.length,
              itemBuilder: (context, index) {
                final entry = allVideoEntries[index];
                final video = entry['video'] as VideoSourceModel;
                final topic = entry['topic'] as TopicModel;
                final section = entry['section'] as SectionModel;

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Thumbnail
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
                                errorBuilder: (c, e, s) => Container(
                                  color: Colors.grey.shade900,
                                  child: const Icon(Icons.play_circle_fill, color: Colors.white, size: 50),
                                ),
                              ),
                              Container(color: Colors.black26),
                              Center(
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.play_arrow, color: Colors.white, size: 30),
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
                            // Section & Topic Tag
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: section.color.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    'વિભાગ ${section.id}: ${section.shortTitle}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: section.color,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              video.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'ટોપિક: ${topic.title}',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              video.summary,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 13, color: Color(0xFF334155)),
                            ),
                            const SizedBox(height: 14),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton.icon(
                                    icon: const Icon(Icons.menu_book, size: 16),
                                    label: const Text('નોટ્સ & ક્વિઝ જુઓ'),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (c) => TopicDetailScreen(
                                            sectionId: section.id,
                                            topicId: topic.id,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton.icon(
                                  icon: const Icon(Icons.play_arrow, size: 16),
                                  label: const Text('જુઓ'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red.shade700,
                                    foregroundColor: Colors.white,
                                  ),
                                  onPressed: () => _launchYouTube(video.youtubeUrl),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

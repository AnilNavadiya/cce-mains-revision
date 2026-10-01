import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';
import '../models/syllabus_models.dart';
import '../widgets/topic_tile.dart';

enum FilterStatus { all, pending, completed }

class SyllabusTrackerScreen extends StatefulWidget {
  const SyllabusTrackerScreen({super.key});

  @override
  State<SyllabusTrackerScreen> createState() => _SyllabusTrackerScreenState();
}

class _SyllabusTrackerScreenState extends State<SyllabusTrackerScreen> {
  FilterStatus _filterStatus = FilterStatus.all;
  final TextEditingController _searchController = TextEditingController();
  int? _selectedSectionId;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppStateProvider>();
    final sections = provider.sections;

    // Collect all topics
    List<TopicModel> allTopics = [];
    for (var sec in sections) {
      if (_selectedSectionId == null || _selectedSectionId == sec.id) {
        allTopics.addAll(sec.topics);
      }
    }

    // Filter by status
    if (_filterStatus == FilterStatus.pending) {
      allTopics = allTopics.where((t) => !t.isCompleted).toList();
    } else if (_filterStatus == FilterStatus.completed) {
      allTopics = allTopics.where((t) => t.isCompleted).toList();
    }

    // Filter by search query
    final query = _searchController.text.trim().toLowerCase();
    if (query.isNotEmpty) {
      allTopics = allTopics.where((t) {
        final titleMatch = t.title.toLowerCase().contains(query);
        final subPointMatch = t.microSyllabusPoints.any((p) => p.toLowerCase().contains(query));
        return titleMatch || subPointMatch;
      }).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('CCE માઇક્રો-સિલેબસ ચેકલિસ્ટ'),
      ),
      body: Column(
        children: [
          // Search & Filter Box
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Column(
              children: [
                // Search TextField
                TextField(
                  controller: _searchController,
                  onChanged: (val) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'ટોપિક અથવા કીવર્ડ શોધો (દા.ત. DPSP, RTI, લોથલ)...',
                    hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade400),
                    prefixIcon: const Icon(Icons.search, size: 20),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Filter chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildStatusFilterChip('તમામ', FilterStatus.all),
                      const SizedBox(width: 8),
                      _buildStatusFilterChip('બાકી છે', FilterStatus.pending),
                      const SizedBox(width: 8),
                      _buildStatusFilterChip('પૂર્ણ થયેલ', FilterStatus.completed),
                      const SizedBox(width: 14),
                      Container(height: 20, width: 1, color: Colors.grey.shade300),
                      const SizedBox(width: 14),
                      DropdownButton<int?>(
                        value: _selectedSectionId,
                        hint: const Text('બધા વિભાગો', style: TextStyle(fontSize: 12.5)),
                        isDense: true,
                        underline: const SizedBox(),
                        items: [
                          const DropdownMenuItem(
                            value: null,
                            child: Text('બધા વિભાગો (૧ થી ૧૦)', style: TextStyle(fontSize: 12.5)),
                          ),
                          ...sections.map((s) {
                            return DropdownMenuItem(
                              value: s.id,
                              child: Text('વિભાગ ${s.id}: ${s.shortTitle}', style: const TextStyle(fontSize: 12.5)),
                            );
                          }),
                        ],
                        onChanged: (val) {
                          setState(() {
                            _selectedSectionId = val;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Count indicator
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'કુલ પરિણામો: ${allTopics.length} ટોપિક્સ',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
                Text(
                  'પ્રગતિ: ${(provider.overallProgress * 100).toInt()}%',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E3A8A),
                  ),
                ),
              ],
            ),
          ),

          // Topics List
          Expanded(
            child: allTopics.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search_off_rounded, size: 54, color: Colors.grey.shade400),
                        const SizedBox(height: 8),
                        Text(
                          'કોઈ ટોપિક મળ્યો નથી',
                          style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 24),
                    itemCount: allTopics.length,
                    itemBuilder: (context, index) {
                      final topic = allTopics[index];
                      return TopicTile(topic: topic, showSectionTitle: true);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusFilterChip(String label, FilterStatus status) {
    final isSelected = _filterStatus == status;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: const Color(0xFF1E3A8A),
      labelStyle: TextStyle(
        fontSize: 12,
        color: isSelected ? Colors.white : Colors.black87,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      onSelected: (val) {
        if (val) {
          setState(() {
            _filterStatus = status;
          });
        }
      },
    );
  }
}

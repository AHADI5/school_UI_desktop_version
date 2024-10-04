import 'package:flutter/material.dart';

class StatsCards extends StatefulWidget {
  const StatsCards({super.key});

  @override
  _StatsCardsState createState() => _StatsCardsState();
}

class _StatsCardsState extends State<StatsCards> {
  final ScrollController _scrollController = ScrollController();

  bool _showLeftChevron = false;
  bool _showRightChevron = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateChevrons);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _updateChevrons() {
    setState(() {
      _showLeftChevron = _scrollController.offset > 0;
      _showRightChevron =
          _scrollController.offset < _scrollController.position.maxScrollExtent;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double width = constraints.maxWidth;

        if (width < 600) {
          // Compact: For phones in portrait
          return _buildScrollableLayout(compact: true);
        } else if (width >= 600 && width < 840) {
          // Medium: For tablets in portrait with horizontal scrolling
          return _buildScrollableLayout(compact: false);
        } else {
          // Expanded: For larger screens, show all cards with horizontal scroll
          return _buildScrollableLayout(compact: false);
        }
      },
    );
  }

  // Build layout for all screen sizes with horizontal scrolling
  Widget _buildScrollableLayout({required bool compact}) {
    return Row(
      children: [
        if (_showLeftChevron)
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () {
              _scrollController.animateTo(
                _scrollController.offset - 200,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
          ),
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _buildCards(compact: compact)
                  .map((card) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: card,
                      ))
                  .toList(),
            ),
          ),
        ),
        if (_showRightChevron)
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () {
              _scrollController.animateTo(
                _scrollController.offset + 200,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
          ),
      ],
    );
  }

  // Helper method to create a list of cards with size adjustments
  List<Widget> _buildCards({required bool compact}) {
    double cardWidth = compact ? 150 : 200; // Smaller size for compact (mobile)
    double cardHeight = compact ? 100 : 120;

    return [
      _buildCard(
          icon: Icons.school,
          value: "1500",
          title: "Students",
          color: Colors.blue,
          cardWidth: cardWidth,
          cardHeight: cardHeight),
      _buildCard(
          icon: Icons.person,
          value: "75",
          title: "Teachers",
          color: Colors.green,
          cardWidth: cardWidth,
          cardHeight: cardHeight),
      _buildCard(
          icon: Icons.class_,
          value: "40",
          title: "Classrooms",
          color: Colors.orange,
          cardWidth: cardWidth,
          cardHeight: cardHeight),
      _buildCard(
          icon: Icons.announcement,
          value: "120",
          title: "Communiques",
          color: Colors.red,
          cardWidth: cardWidth,
          cardHeight: cardHeight),
      _buildCard(
          icon: Icons.warning,
          value: "10",
          title: "Alerts",
          color: Colors.purple,
          cardWidth: cardWidth,
          cardHeight: cardHeight),
      _buildCard(
          icon: Icons.event,
          value: "20",
          title: "Events",
          color: Colors.teal,
          cardWidth: cardWidth,
          cardHeight: cardHeight),
    ];
  }

  // Helper method to create a card with icon, value, title, and color
  Widget _buildCard({
    required IconData icon,
    required String value,
    required String title,
    required Color color,
    required double cardWidth,
    required double cardHeight,
  }) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: cardWidth,
        height: cardHeight,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(8.0),
                child: Icon(icon, size: 30, color: Colors.white),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(fontSize: 18, color: Colors.black),
              ),
              const SizedBox(height: 2),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

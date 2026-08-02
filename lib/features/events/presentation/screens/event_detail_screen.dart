import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../leads/data/models/event_model.dart';

class EventDetailScreen extends StatelessWidget {
  final EventModel event;

  const EventDetailScreen({super.key, required this.event});

  Color _getDifficultyColor(String? difficulty) =>
      switch (difficulty?.toLowerCase()) {
        'beginner' || 'easy' => Colors.green.shade600,
        'moderate' => Colors.orange.shade700,
        'advanced' => Colors.blue.shade700,
        'expert' || 'hard' => Colors.red.shade700,
        _ => Colors.teal.shade700,
      };

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('EEE, MMM dd, yyyy • hh:mm a');
    final formattedDate = event.startsAt != null
        ? dateFormat.format(event.startsAt!.toLocal())
        : 'TBD';

    final diffColor = _getDifficultyColor(event.difficulty);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Collapsible Image App Bar
          SliverAppBar(
            expandedHeight: 240.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                event.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.black54,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  if (event.imageUrl != null && event.imageUrl!.isNotEmpty)
                    Image.network(
                      event.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Theme.of(context).primaryColor,
                        child: const Icon(
                          Icons.landscape,
                          size: 80,
                          color: Colors.white70,
                        ),
                      ),
                    )
                  else
                    Container(
                      color: Theme.of(context).primaryColor,
                      child: const Icon(
                        Icons.landscape,
                        size: 80,
                        color: Colors.white70,
                      ),
                    ),
                  // Dark Gradient Overlay for readability
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withAlpha(76),
                          Colors.black.withAlpha(178),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Event Info Details List
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badges Row
                  Row(
                    children: [
                      if (event.difficulty != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: diffColor.withAlpha(38),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: diffColor),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.terrain, size: 16, color: diffColor),
                              const SizedBox(width: 4),
                              Text(
                                event.difficulty!.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: diffColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(width: 8),
                      if (event.status != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.green.shade600),
                          ),
                          child: Text(
                            event.status!.toUpperCase(),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade700,
                            ),
                          ),
                        ),
                      const Spacer(),
                      if (event.price != null)
                        Text(
                          '${event.currency ?? 'AED'} ${event.price!.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Location
                  if (event.locationName != null)
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.redAccent,
                          size: 20,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            event.locationName!,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 8),

                  // Date
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_month,
                        color: Theme.of(context).primaryColor,
                        size: 20,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        formattedDate,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Quick Stats Grid
                  Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _StatItem(
                            icon: Icons.straighten,
                            label: 'Distance',
                            value: event.distanceKm != null
                                ? '${event.distanceKm} km'
                                : 'N/A',
                          ),
                          _StatItem(
                            icon: Icons.landscape,
                            label: 'Elevation',
                            value: event.elevationGainM != null
                                ? '${event.elevationGainM?.toInt()} m'
                                : 'N/A',
                          ),
                          _StatItem(
                            icon: Icons.timer_outlined,
                            label: 'Duration',
                            value: event.durationMinutes != null
                                ? '${(event.durationMinutes! / 60).toStringAsFixed(1)} hrs'
                                : 'N/A',
                          ),
                          _StatItem(
                            icon: Icons.event_seat,
                            label: 'Available',
                            value: event.availableSlots != null
                                ? '${event.availableSlots} slots'
                                : 'Open',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Description
                  if (event.description != null &&
                      event.description!.isNotEmpty) ...[
                    Text(
                      'About This Hike',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      event.description!,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Highlights
                  if (event.highlights != null &&
                      event.highlights!.isNotEmpty) ...[
                    Text(
                      'Trail Highlights',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: event.highlights!.map((highlight) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4.0,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    size: 18,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      highlight,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Included Items
                  if (event.includedItems != null &&
                      event.includedItems!.isNotEmpty) ...[
                    Text(
                      'What\'s Included',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: event.includedItems!.map((item) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4.0,
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.verified,
                                    size: 18,
                                    color: Colors.orange,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      item,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Meeting Point
                  if (event.meetingPointLabel != null &&
                      event.meetingPointLabel!.isNotEmpty) ...[
                    Text(
                      'Meeting Point',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Card(
                      color: Colors.blue.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            const Icon(Icons.map, color: Colors.blue),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                event.meetingPointLabel!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 22, color: Theme.of(context).primaryColor),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}

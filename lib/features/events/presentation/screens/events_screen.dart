import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/navigation/app_navigator_provider.dart';
import '../../../leads/data/models/event_model.dart';
import '../providers/events_provider.dart';

class EventsScreen extends ConsumerWidget {
  const EventsScreen({super.key});

  Color _getDifficultyColor(String? difficulty) =>
      switch (difficulty?.toLowerCase()) {
        'beginner' || 'easy' => Colors.green.shade600,
        'moderate' => Colors.orange.shade700,
        'advanced' => Colors.blue.shade700,
        'expert' || 'hard' => Colors.red.shade700,
        _ => Colors.teal.shade700,
      };

  void _showDeleteConfirmation(
      BuildContext context, WidgetRef ref, EventModel event) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.redAccent),
            SizedBox(width: 8),
            Text('Delete Event'),
          ],
        ),
        content: Text(
          'Are you sure you want to delete "${event.name}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              final success = await ref
                  .read(eventsNotifierProvider.notifier)
                  .deleteEvent(event.id);
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    success
                        ? 'Event "${event.name}" deleted successfully.'
                        : 'Failed to delete event.',
                  ),
                  backgroundColor:
                      success ? Colors.green.shade700 : Colors.redAccent,
                ),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showEditEventModal(
      BuildContext context, WidgetRef ref, EventModel event) {
    final nameController = TextEditingController(text: event.name);
    final locationController =
        TextEditingController(text: event.locationName ?? '');
    final priceController =
        TextEditingController(text: event.price?.toString() ?? '');
    final distanceController =
        TextEditingController(text: event.distanceKm?.toString() ?? '');
    final descriptionController =
        TextEditingController(text: event.description ?? '');

    DateTime? selectedStartsAt = event.startsAt;

    String selectedDifficulty =
        (event.difficulty != null && event.difficulty!.isNotEmpty)
            ? event.difficulty!.toLowerCase()
            : 'moderate';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setStateModal) {
            Future<void> pickDateTime() async {
              final initialDate = selectedStartsAt ?? DateTime.now();
              final pickedDate = await showDatePicker(
                context: context,
                initialDate: initialDate,
                firstDate: DateTime(2024),
                lastDate: DateTime(2030),
              );

              if (pickedDate != null) {
                if (!context.mounted) return;
                final initialTime = TimeOfDay.fromDateTime(initialDate);
                final pickedTime = await showTimePicker(
                  context: context,
                  initialTime: initialTime,
                );

                final finalDateTime = DateTime(
                  pickedDate.year,
                  pickedDate.month,
                  pickedDate.day,
                  pickedTime?.hour ?? initialTime.hour,
                  pickedTime?.minute ?? initialTime.minute,
                );

                setStateModal(() {
                  selectedStartsAt = finalDateTime;
                });
              }
            }

            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Edit Event',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.of(sheetContext).pop(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Event Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: locationController,
                      decoration: const InputDecoration(
                        labelText: 'Location Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Calendar Date & Time Selector
                    InkWell(
                      onTap: pickDateTime,
                      borderRadius: BorderRadius.circular(4),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Event Date & Time (Calendar)',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.calendar_today,
                              color: Colors.teal),
                        ),
                        child: Text(
                          selectedStartsAt != null
                              ? DateFormat('EEE, MMM dd, yyyy • hh:mm a')
                                  .format(selectedStartsAt!.toLocal())
                              : 'Tap to select event date & time',
                          style: TextStyle(
                            color: selectedStartsAt != null
                                ? Colors.black87
                                : Colors.grey,
                            fontWeight: selectedStartsAt != null
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: priceController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Price (AED)',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: distanceController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Distance (km)',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: ['beginner', 'easy', 'moderate', 'advanced', 'expert']
                              .contains(selectedDifficulty)
                          ? (selectedDifficulty == 'easy'
                              ? 'beginner'
                              : selectedDifficulty)
                          : 'moderate',
                      decoration: const InputDecoration(
                        labelText: 'Difficulty Level',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                            value: 'beginner', child: Text('Beginner')),
                        DropdownMenuItem(
                            value: 'moderate', child: Text('Moderate')),
                        DropdownMenuItem(
                            value: 'advanced', child: Text('Advanced')),
                        DropdownMenuItem(
                            value: 'expert', child: Text('Expert')),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          setStateModal(() {
                            selectedDifficulty = val;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: descriptionController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async {
                          final updated = EventModel(
                            id: event.id,
                            name: nameController.text.trim(),
                            locationName: locationController.text.trim(),
                            price: double.tryParse(priceController.text),
                            distanceKm: double.tryParse(distanceController.text),
                            difficulty: selectedDifficulty,
                            description: descriptionController.text.trim(),
                            startsAt: selectedStartsAt,
                            currency: event.currency,
                            imageUrl: event.imageUrl,
                            availableSlots: event.availableSlots,
                            availability: event.availability,
                            status: event.status,
                          );

                          Navigator.of(sheetContext).pop();
                          final success = await ref
                              .read(eventsNotifierProvider.notifier)
                              .updateEvent(updated);

                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                success
                                    ? 'Event "${updated.name}" updated successfully.'
                                    : 'Failed to update event.',
                              ),
                              backgroundColor: success
                                  ? Colors.green.shade700
                                  : Colors.redAccent,
                            ),
                          );
                        },
                        child: const Text('Save Changes'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(eventsNotifierProvider);
    final notifier = ref.read(eventsNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Published Events'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Events',
            onPressed: () => notifier.fetchEvents(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search & Filter Header Container
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Column(
              children: [
                // Search Input Field
                TextField(
                  onChanged: notifier.setSearchQuery,
                  decoration: InputDecoration(
                    hintText: 'Search events by name or location...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Difficulty Filter Chips
                SizedBox(
                  height: 38,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: FilterChip(
                          label: const Text('All Difficulties'),
                          selected: state.selectedDifficulty == null ||
                              state.selectedDifficulty == 'all',
                          onSelected: (_) =>
                              notifier.setSelectedDifficulty('all'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: FilterChip(
                          label: const Text('Beginner'),
                          selected: state.selectedDifficulty == 'beginner' ||
                              state.selectedDifficulty == 'easy',
                          onSelected: (_) =>
                              notifier.setSelectedDifficulty('beginner'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: FilterChip(
                          label: const Text('Moderate'),
                          selected: state.selectedDifficulty == 'moderate',
                          onSelected: (_) =>
                              notifier.setSelectedDifficulty('moderate'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: FilterChip(
                          label: const Text('Advanced'),
                          selected: state.selectedDifficulty == 'advanced',
                          onSelected: (_) =>
                              notifier.setSelectedDifficulty('advanced'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: FilterChip(
                          label: const Text('Expert'),
                          selected: state.selectedDifficulty == 'expert' ||
                              state.selectedDifficulty == 'hard',
                          onSelected: (_) =>
                              notifier.setSelectedDifficulty('expert'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Main Body Content
          Expanded(
            child: _buildBody(context, ref, state, notifier),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    EventsState state,
    EventsNotifier notifier,
  ) {
    if (state.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.redAccent,
              ),
              const SizedBox(height: 16),
              Text(
                'Failed to load events',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                state.errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => notifier.fetchEvents(),
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final filteredEvents = state.filteredEvents;

    if (filteredEvents.isEmpty) {
      return RefreshIndicator(
        onRefresh: notifier.fetchEvents,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.5,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.event_busy_outlined,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 12),
                Text(
                  'No events found matching criteria',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: notifier.fetchEvents,
      child: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: filteredEvents.length,
        itemBuilder: (context, index) {
          final event = filteredEvents[index];
          return _EventCard(
            event: event,
            getDifficultyColor: _getDifficultyColor,
            onEdit: () => _showEditEventModal(context, ref, event),
            onDelete: () => _showDeleteConfirmation(context, ref, event),
          );
        },
      ),
    );
  }
}

class _EventCard extends ConsumerWidget {
  final EventModel event;
  final Color Function(String?) getDifficultyColor;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _EventCard({
    required this.event,
    required this.getDifficultyColor,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateFormat = DateFormat('EEE, MMM dd, yyyy • hh:mm a');
    final formattedDate = event.startsAt != null
        ? dateFormat.format(event.startsAt!.toLocal())
        : 'TBD';

    final diffColor = getDifficultyColor(event.difficulty);

    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: InkWell(
        onTap: () {
          ref.read(appNavigatorProvider).goToEventDetail(event);
        },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Banner Section
            Stack(
              children: [
                Container(
                  height: 160,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withAlpha(25),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: event.imageUrl != null && event.imageUrl!.isNotEmpty
                      ? ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                          child: Image.network(
                            event.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              color: Theme.of(context).primaryColor,
                              child: const Icon(Icons.landscape,
                                  size: 64, color: Colors.white60),
                            ),
                          ),
                        )
                      : Container(
                          color: Theme.of(context).primaryColor,
                          child: const Icon(Icons.landscape,
                              size: 64, color: Colors.white60),
                        ),
                ),

                // Difficulty Tag Overlay
                if (event.difficulty != null)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(191),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: diffColor, width: 1.5),
                      ),
                      child: Text(
                        event.difficulty!.toUpperCase(),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: diffColor,
                        ),
                      ),
                    ),
                  ),

                // Vertical Dotted Menu (PopupMenuButton)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(165),
                      shape: BoxShape.circle,
                    ),
                    child: PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert, color: Colors.white),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      onSelected: (value) {
                        if (value == 'edit') {
                          onEdit();
                        } else if (value == 'delete') {
                          onDelete();
                        }
                      },
                      itemBuilder: (BuildContext context) => [
                        const PopupMenuItem<String>(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit_outlined,
                                  size: 20, color: Colors.blue),
                              SizedBox(width: 10),
                              Text('Edit Event'),
                            ],
                          ),
                        ),
                        const PopupMenuItem<String>(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete_outline,
                                  size: 20, color: Colors.redAccent),
                              SizedBox(width: 10),
                              Text(
                                'Delete Event',
                                style: TextStyle(color: Colors.redAccent),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Card Body Content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Event Title
                  Text(
                    event.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Location Name
                  if (event.locationName != null)
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined,
                            size: 16, color: Colors.redAccent),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            event.locationName!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 6),

                  // Date
                  Row(
                    children: [
                      Icon(Icons.calendar_today_outlined,
                          size: 15, color: Theme.of(context).primaryColor),
                      const SizedBox(width: 6),
                      Text(
                        formattedDate,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),

                  // Bottom Info Row (Distance, Price)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Distance & Elevation
                      Row(
                        children: [
                          const Icon(Icons.straighten,
                              size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            event.distanceKm != null
                                ? '${event.distanceKm} km'
                                : 'Trail',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (event.elevationGainM != null) ...[
                            const SizedBox(width: 8),
                            Text(
                              '• ${event.elevationGainM?.toInt()}m gain',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ],
                      ),

                      // Price
                      if (event.price != null)
                        Text(
                          '${event.currency ?? 'AED'} ${event.price!.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

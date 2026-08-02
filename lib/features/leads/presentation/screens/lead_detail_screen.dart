import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../domain/repositories/leads_repository.dart';

class LeadDetailScreen extends StatelessWidget {
  final LeadModel lead;

  const LeadDetailScreen({super.key, required this.lead});

  Future<void> _makeCall(String phoneNumber) async {
    final Uri url = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Future<void> _sendEmail(String email) async {
    final Uri url = Uri.parse('mailto:$email');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy - hh:mm a');
    final formattedDate = lead.createdAt != null
        ? dateFormat.format(lead.createdAt!)
        : 'N/A';

    return Scaffold(
      appBar: AppBar(title: const Text('Lead Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Header Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: Theme.of(
                        context,
                      ).primaryColor.withAlpha(25),
                      child: Text(
                        lead.contactName.isNotEmpty
                            ? lead.contactName[0].toUpperCase()
                            : '?',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lead.contactName,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          if (lead.referenceNumber != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'Ref: #${lead.referenceNumber}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          const SizedBox(height: 4),
                          Text(
                            'Registered: $formattedDate',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Quick Actions
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: lead.contactPhone != 'N/A'
                        ? () => _makeCall(lead.contactPhone)
                        : null,
                    icon: const Icon(Icons.phone),
                    label: const Text('Call'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: lead.contactEmail != 'N/A'
                        ? () => _sendEmail(lead.contactEmail)
                        : null,
                    icon: const Icon(Icons.email),
                    label: const Text('Email'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Section: Contact Details
            Text(
              'Contact Information',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _DetailRow(
                      icon: Icons.person,
                      label: 'Full Name',
                      value: lead.contactName,
                    ),
                    const Divider(),
                    _DetailRow(
                      icon: Icons.email,
                      label: 'Email Address',
                      value: lead.contactEmail,
                    ),
                    const Divider(),
                    _DetailRow(
                      icon: Icons.phone,
                      label: 'Phone Contact',
                      value: lead.contactPhone,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Section: Event & Booking Info
            Text(
              'Event Details',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _DetailRow(
                      icon: Icons.landscape,
                      label: 'Event Name',
                      value: lead.event?.name ?? 'General Registration',
                    ),
                    if (lead.numberOfHikers != null) ...[
                      const Divider(),
                      _DetailRow(
                        icon: Icons.groups,
                        label: 'Number of Hikers',
                        value: '${lead.numberOfHikers} hiker(s)',
                      ),
                    ],
                    if (lead.totalAmount != null) ...[
                      const Divider(),
                      _DetailRow(
                        icon: Icons.payments,
                        label: 'Total Amount',
                        value:
                            '${lead.currency ?? 'AED'} ${lead.totalAmount?.toStringAsFixed(2)}',
                      ),
                    ],
                    if (lead.paymentStatus != null) ...[
                      const Divider(),
                      _DetailRow(
                        icon: Icons.verified_user,
                        label: 'Payment Status',
                        value: lead.paymentStatus!.toUpperCase(),
                        valueColor:
                            lead.paymentStatus == 'paid' ||
                                lead.paymentStatus == 'succeeded'
                            ? Colors.green.shade700
                            : Colors.orange.shade700,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Section: Enquiry Details (if applicable)
            if (lead.customerNotes != null &&
                lead.customerNotes!.trim().isNotEmpty) ...[
              Text(
                'Enquiry & Customer Notes',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Card(
                color: Colors.amber.shade50,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.amber.shade300),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.question_answer_rounded,
                        color: Colors.amber.shade900,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'User Query / Special Request',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.amber.shade900,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              lead.customerNotes!,
                              style: const TextStyle(
                                fontSize: 14,
                                height: 1.4,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ] else ...[
              Card(
                color: Colors.grey.shade50,
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.grey),
                      SizedBox(width: 12),
                      Text(
                        'No custom enquiry or notes provided.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).primaryColor),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: valueColor ?? Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

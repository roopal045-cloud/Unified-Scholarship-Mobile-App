import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// Phase 4 (D): "milestone alert mock". The dashboard fires a real call to
// POST /api/notifications/trigger the moment it sees an application at
// sanctioned / disbursed / action_required, then hands the resulting
// GET /api/notifications/:studentId future in here so the bell badge and
// this sheet stay in sync with what actually got triggered.
class NotificationBell extends StatelessWidget {
  const NotificationBell({super.key, required this.notificationsFuture});

  final Future<List<dynamic>> notificationsFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: notificationsFuture,
      builder: (context, snapshot) {
        final notifications = snapshot.data ?? const [];
        final count = notifications.length;
        return IconButton(
          tooltip: 'Milestone alerts',
          onPressed: () => _showSheet(context, notifications),
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(Icons.notifications_outlined, color: AppColors.navy),
              if (count > 0)
                Positioned(
                  right: -4,
                  top: -4,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                    decoration: const BoxDecoration(
                      color: Color(0xFFD32F2F),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$count',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 10, height: 1.2),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void _showSheet(BuildContext context, List<dynamic> notifications) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      builder: (ctx) => SafeArea(
        child: notifications.isEmpty
            ? const Padding(
                padding: EdgeInsets.all(28),
                child: Text(
                  'No milestone alerts yet. You will be notified here when an '
                  'application is sanctioned, disbursed, or needs attention.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              )
            : ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 4, 16, 8),
                    child: Text('Milestone alerts', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  ...notifications.map((n) => ListTile(
                        leading: const Icon(Icons.notifications_active_outlined, color: AppColors.navy),
                        title: Text(
                          n['message']?.toString() ?? '',
                          style: const TextStyle(fontSize: 13),
                        ),
                        subtitle: Text(
                          '${n['applicationId']} \u2022 ${n['sentAt']}',
                          style: const TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                      )),
                ],
              ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_submission_3/provider/preferences_provider.dart';
import 'package:restaurant_app_submission_3/provider/scheduling_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body:
          Consumer<PreferencesProvider>(builder: (context, preference, child) {
        return ListView(
          children: [
            Material(
              child: ListTile(
                title: Text(
                  'Notification',
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
                subtitle: Text(
                  "Enable Notification",
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey,
                  ),
                ),
                trailing: Consumer<SchedulingProvider>(
                  builder: (context, scheduled, _) {
                    return Switch(
                        value: preference.isNotificationsActive,
                        onChanged: (change) async {
                          preference.enableNotifications(change);
                          scheduled.scheduledNotification(change);
                        });
                  },
                ),
              ),
            )
          ],
        );
      }),
    );
  }
}

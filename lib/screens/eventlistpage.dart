import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/eventprovider.dart';
import 'eventdetailspage.dart';

class EventListPage extends StatelessWidget {
  const EventListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Event Listing')),
      body: ListView.builder(
        itemCount: eventProvider.events.length,
        itemBuilder: (context, index) {
          final event = eventProvider.events[index];
          return Card(
            child: ListTile(
              title: Text(event.title),
              subtitle: Text(event.date),
              trailing: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EventDetailPage(event: event),
                    ),
                  );
                },
                child: const Text('RSVP'),
              ),
            ),
          );
        },
      ),
    );
  }
}

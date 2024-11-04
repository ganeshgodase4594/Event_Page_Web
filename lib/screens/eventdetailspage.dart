import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/eventprovider.dart';
import '../services/eventmodel.dart';

class EventDetailPage extends StatefulWidget {
  final Event event;

  const EventDetailPage({super.key, required this.event});

  @override
  _EventDetailPageState createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context);
    final attendees = eventProvider.eventAttendees[widget.event.title] ?? [];

    return Scaffold(
      appBar: AppBar(title: Text(widget.event.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Date: ${widget.event.date}',
                style: const TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text(widget.event.description,
                style: const TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            Text('RSVP Form',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _name = value ?? '';
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Email'),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          !value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _email = value ?? '';
                    },
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        eventProvider.rsvp(widget.event.title, _name, _email);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('RSVP submitted successfully')),
                        );
                      }
                    },
                    child: Text('Submit'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text('Attendees:', style: TextStyle(fontSize: 18)),
            Expanded(
              child: ListView.builder(
                itemCount: attendees.length,
                itemBuilder: (context, index) {
                  final attendee = attendees[index];
                  return ListTile(
                    title: Text(attendee['name'] ?? ''),
                    subtitle: Text(attendee['email'] ?? ''),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

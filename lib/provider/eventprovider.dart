import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../services/eventmodel.dart';

class EventProvider with ChangeNotifier {
  List<Event> _events = [];
  // Ensure this map exists in the EventProvider class
  final Map<String, List<Map<String, String>>> _eventAttendees = {};

  List<Event> get events => _events;
  // This is the getter for _eventAttendees
  Map<String, List<Map<String, String>>> get eventAttendees => _eventAttendees;

  EventProvider() {
    _fetchEvents();
  }

  void _fetchEvents() {
    _events = [
      Event(
          title: 'Flutter Workshop',
          date: '2024-11-10',
          description: 'Learn Flutter basics.'),
      Event(
          title: 'Dart Conference',
          date: '2024-11-15',
          description: 'Discuss Dart features.'),
    ];
    // Initialize an empty list for attendees for each event
    for (var event in _events) {
      _eventAttendees[event.title] = [];
    }
    notifyListeners();
  }

  Future<void> rsvp(String eventName, String name, String email) async {
    try {
      final response = await http.post(
        Uri.parse('https://jsonplaceholder.typicode.com/posts'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'eventName': eventName,
          'name': name,
          'email': email,
        }),
      );

      if (response.statusCode == 201) {
        // Add the RSVP entry to the specific event's attendees list
        _eventAttendees[eventName]?.add({'name': name, 'email': email});
        notifyListeners();
      } else {
        throw Exception('Failed to RSVP.');
      }
    } catch (error) {
      debugPrint('Error: $error');
    }
  }
}

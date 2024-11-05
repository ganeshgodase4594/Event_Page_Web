import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../services/eventmodel.dart';

class EventProvider with ChangeNotifier {
  List<Event> _events = [];
  final Map<String, List<Map<String, String>>> _eventAttendees = {};

  List<Event> get events => _events;
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

    for (var event in _events) {
      _eventAttendees[event.title] = [];
    }
    notifyListeners();
  }

  Future<void> rsvp(String eventName, String name, String email) async {
    // Basic validation before making the API call
    if (name.isEmpty ||
        email.isEmpty ||
        !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      throw Exception('Please provide a valid name and email.');
    }

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
        _eventAttendees[eventName]?.add({'name': name, 'email': email});
        notifyListeners();
      } else if (response.statusCode == 400) {
        throw Exception('Bad request. Please check the data.');
      } else {
        throw Exception('Failed to RSVP. Status code: ${response.statusCode}');
      }
    } catch (error) {
      // handle network error ....
      if (error is http.ClientException) {
        debugPrint('Network error: $error');
        throw Exception('Network error. Please check your connection.');
      } else {
        debugPrint('Unexpected error: $error');
        throw Exception(
            'An unexpected error occurred. Please try again later.');
      }
    }
  }
}

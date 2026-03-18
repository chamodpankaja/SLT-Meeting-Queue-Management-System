import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

Widget buildSessionCard(DocumentSnapshot session) {
  
  final data = session.data() as Map<String, dynamic>;
  return Card(
     color: Colors.lightBlue.shade50,
    elevation: 3,
    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(
        color: Colors.black87,
        width: 1,
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  data['sessionName'] ?? 'Unnamed Session',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A5EBF),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
                 Text(
                   DateFormat('MMMM d, yyyy  h:mm a').format(data['createdAt'].toDate().toLocal()),
                   style: TextStyle(
                     color: Colors.grey.shade600,
                     fontWeight: FontWeight.w500,
                   ),
                 ),
             
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, 
                color: Color(0xFF1A5EBF), size: 16),
              const SizedBox(width: 4),
              Text(
                data['venue'] ?? 'No venue specified',
                style: TextStyle(color: Colors.grey.shade700),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined, 
                color: Color(0xFF1A5EBF), size: 16),
              const SizedBox(width: 4),
              Text(
                data['date'] ?? '',
                style: TextStyle(color: Colors.grey.shade700),
              ),
            ],
          ),
          const SizedBox(height: 12),
           Row(
            children: [
              const Icon(Icons.punch_clock, 
                color: Color(0xFF1A5EBF), size: 16),
              const SizedBox(width: 4),
              Text(
                data['time'] ?? '',
                style: TextStyle(color: Colors.grey.shade700),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
           Row(
            children: [
              const Icon(Icons.person, 
                color: Color(0xFF1A5EBF), size: 16),
              const SizedBox(width: 4),
              Text(
                data['createdBy'] ?? '',
                style: TextStyle(color: Colors.grey.shade700),
              ),
            ],
          ),
          const SizedBox(height: 12),
           Row(
            children: [
              const Icon(Icons.notes_outlined, 
                color: Color(0xFF1A5EBF), size: 16),
              const SizedBox(width: 4),
              Text(
                data['notes'] ?? '',
                style: TextStyle(color: Colors.grey.shade700),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: (data['techStacks'] as List<dynamic>?)?.map((tech) =>
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A5EBF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  tech.toString(),
                  style: const TextStyle(
                    color: Color(0xFF1A5EBF),
                    fontSize: 12,
                  ),
                ),
              ),
            ).toList() ?? [],
          ),
        ],
      ),
    ),
  );
}
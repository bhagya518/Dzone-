import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void showFeedbackDialog(BuildContext context) {
  String? selectedFeedback;
  final suggestionController = TextEditingController();

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("How was your experience?"),
      content: StatefulBuilder(
        builder: (context, setState) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile(
              title: const Text('😃 Great'),
              value: 'Great',
              groupValue: selectedFeedback,
              onChanged: (value) => setState(() => selectedFeedback = value),
            ),
            RadioListTile(
              title: const Text('😐 Okay'),
              value: 'Okay',
              groupValue: selectedFeedback,
              onChanged: (value) => setState(() => selectedFeedback = value),
            ),
            RadioListTile(
              title: const Text('😟 Frustrating'),
              value: 'Frustrating',
              groupValue: selectedFeedback,
              onChanged: (value) => setState(() => selectedFeedback = value),
            ),
            TextField(
              controller: suggestionController,
              decoration: const InputDecoration(hintText: "Any suggestions?"),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
        ElevatedButton(
          onPressed: () async {
            if (selectedFeedback != null) {
              await FirebaseFirestore.instance.collection('feedbacks').add({
                'rating': selectedFeedback,
                'suggestion': suggestionController.text,
                'timestamp': Timestamp.now(),
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Thanks for your feedback!")),
              );
            }
          },
          child: const Text("Submit"),
        )
      ],
    ),
  );
}

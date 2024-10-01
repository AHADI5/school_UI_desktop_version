import 'package:flutter/material.dart';

class CommuniqueCard extends StatelessWidget {
  const CommuniqueCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Last Communique", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text(
              "Remove extra div for each container added. I hope there won’t be...",
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 10),
            Text("DONE", style: TextStyle(color: Colors.green)),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

class DashboardTopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: Colors.white,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Dashboard", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Row(
            children: [
              Icon(Icons.search, size: 30),
              SizedBox(width: 20),
              Icon(Icons.notifications, size: 30),
              SizedBox(width: 20),
              CircleAvatar(backgroundColor: Colors.blue, child: Icon(Icons.person)),
            ],
          ),
        ],
      ),
    );
  }
}

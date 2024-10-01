import 'package:flutter/material.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({super.key});

  @override
  SidebarState createState() => SidebarState();
}

class SidebarState extends State<Sidebar> {
  int activeIndex = 0; // Track the active menu item

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: Colors.white, // Modern dark background color
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          const Column(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage('assets/logo.png'),
                backgroundColor: Colors.transparent,
                radius: 30,
              ),
              SizedBox(width: 12),
              Text(
                "Ushirik",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 5,
                  color: Colors.black38,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Divider(
              color: Colors.grey,
              thickness: 0.5,
              indent: 10,
            
            ),
          ),
          SidebarItem(
            icon: Icons.dashboard,
            label: 'Dashboard',
            isActive: activeIndex == 0,
            onTap: () {
              setState(() {
                activeIndex = 0;
              });
            },
          ),
          SidebarItem(
            icon: Icons.school,
            label: 'Students',
            isActive: activeIndex == 1,
            onTap: () {
              setState(() {
                activeIndex = 1;
              });
            },
          ),
          SidebarItem(
            icon: Icons.people,
            label: 'Teachers',
            isActive: activeIndex == 2,
            onTap: () {
              setState(() {
                activeIndex = 2;
              });
            },
          ),
          SidebarItem(
            icon: Icons.room_service,
            label: 'Classrooms',
            isActive: activeIndex == 3,
            onTap: () {
              setState(() {
                activeIndex = 3;
              });
            },
          ),
          SidebarItem(
            icon: Icons.book,
            label: 'Courses',
            isActive: activeIndex == 4,
            onTap: () {
              setState(() {
                activeIndex = 4;
              });
            },
          ),
          SidebarItem(
            icon: Icons.announcement,
            label: 'Announcements',
            isActive: activeIndex == 5,
            onTap: () {
              setState(() {
                activeIndex = 5;
              });
            },
          ),
          SidebarItem(
            icon: Icons.event,
            label: 'Events',
            isActive: activeIndex == 6,
            onTap: () {
              setState(() {
                activeIndex = 6;
              });
            },
          ),
          SidebarItem(
            icon: Icons.rule,
            label: 'Rules',
            isActive: activeIndex == 7,
            onTap: () {
              setState(() {
                activeIndex = 7;
              });
            },
          ),
          const Spacer(),
          SidebarItem(
            icon: Icons.settings,
            label: 'Settings',
            isActive: activeIndex == 8,
            onTap: () {
              setState(() {
                activeIndex = 8;
              });
            },
          ),
        ],
      ),
    );
  }
}

class SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const SidebarItem({
    super.key,
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 45.0 , bottom: 10),
      child: ListTile(
        leading: Icon(icon, color: Colors.grey),
        title: Text(
          label,
          style: TextStyle(
              color: isActive ? Colors.lightBlueAccent : Colors.grey),
        ),
        tileColor: isActive
            ? Colors.blue[700]
            : Colors.transparent, // Highlight active menu
      
        onTap: onTap,
      ),
      
    );
  }
}

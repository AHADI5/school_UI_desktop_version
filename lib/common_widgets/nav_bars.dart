import 'package:flutter/material.dart';
import 'package:school_desktop/features/classrooms/classroom_management.dart';
import 'package:school_desktop/features/communique/communique_management.dart';
import 'package:school_desktop/features/course/courses_management.dart';
import 'package:school_desktop/features/dashboard/screens/director_dashboard.dart';
import 'package:school_desktop/features/discipline/screens/discipline_screen.dart';
import 'package:school_desktop/features/events/events_management.dart';
import 'package:school_desktop/features/parents/screens/parents.dart';
import 'package:school_desktop/features/students/student_management.dart';
import 'package:school_desktop/features/teacher/teachers_management.dart';

class NavigationDrawerApp extends StatelessWidget {
  const NavigationDrawerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue, // Use any primary color that suits your app
            brightness:
                Brightness.light, // Set to Brightness.dark for dark mode
          )),
      home: const NavigationDrawerExample(),
    );
  }
}

class NavigationDrawerExample extends StatefulWidget {
  const NavigationDrawerExample({super.key});

  @override
  State<NavigationDrawerExample> createState() =>
      _NavigationDrawerExampleState();
}

class _NavigationDrawerExampleState extends State<NavigationDrawerExample> {
  int screenIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget getSelectedScreen(int index) {
    return destinations[index].screen;
  }

  void handleScreenChanged(int selectedScreen) {
    setState(() {
      screenIndex = selectedScreen;
    });
    Navigator.pop(context); // Close the drawer when an item is selected
  }

  // Build drawer for mobile screens
  Widget buildMobileDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          DrawerHeader(
            child: Text(
              'Menu',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: ListView(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                children: destinations.map(
                  (NavBar destination) {
                    return ListTile(
                      leading: destination.icon,
                      title: Text(destination.label),
                      onTap: () {
                        handleScreenChanged(destinations.indexOf(destination));
                      },
                      selected:
                          destinations.indexOf(destination) == screenIndex,
                    );
                  },
                ).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Build NavigationRail for desktop and tablet screens
  Widget buildNavigationRail(BuildContext context) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.width >= 840
                ? MediaQuery.of(context).size.height + 300
                : MediaQuery.of(context).size.height + 300),
        child: NavigationRail(
          selectedIndex: screenIndex,
          onDestinationSelected: (int index) {
            setState(() {
              screenIndex = index;
            });
          },
          labelType: MediaQuery.of(context).size.width >= 840
              ? NavigationRailLabelType.all
              : NavigationRailLabelType.none,
          destinations: destinations.map((NavBar destination) {
            return NavigationRailDestination(
              icon: destination.icon,
              selectedIcon: destination.selectedIcon,
              label: Text(destination.label),
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= 840;
    final isTablet = width >= 600 && width < 840;

    return Scaffold(
      key: _scaffoldKey,

      body: Row(
        children: [
          if (isDesktop || isTablet)
            buildNavigationRail(
                context), // Display NavigationRail for desktop/tablet
          Expanded(
            child: getSelectedScreen(screenIndex), // Display selected screen
          ),
        ],
      ),
      drawer: isDesktop
          ? null
          : buildMobileDrawer(context), // Show drawer for mobile
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: isDesktop
            ? Text(destinations[screenIndex].label)
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(destinations[screenIndex].label),
              ),
        leading: isDesktop
            ? null
            : IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => _scaffoldKey.currentState?.openDrawer(),
              ),
        actions: [
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                // Handle search button press here
                showSearch(
                  context: context,
                  delegate: CustomSearchDelegate(),
                );
              },
            ),
          ),
          // Notification icon
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () {
                // Handle notification press
              },
            ),
          ),
          // Settings icon
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: IconButton(
              icon: const Icon(Icons.settings_outlined),
              onPressed: () {
                // Handle settings press
              },
            ),
          ),
          // User avatar (initial letter)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Text(
                'A', // Initial letter of the user
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom search delegate for the search bar functionality
class CustomSearchDelegate extends SearchDelegate<String> {
  final List<String> data = [
    'Dashboard',
    'Élèves',
    'Classes',
    'Enseignants',
    'Cours',
    'Communiqués',
    'Events',
    'Parents',
    'Discipline',
    'Settings',
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = data
        .where((element) => element.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView(
      children: results
          .map((result) => ListTile(
                title: Text(result),
                onTap: () {
                  close(context, result); // Close search and return result
                },
              ))
          .toList(),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = data
        .where(
            (element) => element.toLowerCase().startsWith(query.toLowerCase()))
        .toList();

    return ListView(
      children: suggestions
          .map((suggestion) => ListTile(
                title: Text(suggestion),
                onTap: () {
                  query = suggestion;
                  showResults(context); // Show results when tapped
                },
              ))
          .toList(),
    );
  }
}

// Define the NavBar class for navigation items
class NavBar {
  const NavBar(this.label, this.icon, this.selectedIcon, this.screen);

  final String label;
  final Widget icon;
  final Widget selectedIcon;
  final Widget screen;
}

// Fake screens

class EnseignantsScreen extends StatelessWidget {
  const EnseignantsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Enseignants Screen'));
  }
}

class CoursScreen extends StatelessWidget {
  const CoursScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Cours Screen'));
  }
}

class CommuniquesScreen extends StatelessWidget {
  const CommuniquesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Communiqués Screen'));
  }
}

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Events Screen'));
  }
}



class DisciplineScreen extends StatelessWidget {
  const DisciplineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Discipline Screen'));
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Settings Screen'));
  }
}

// List of destinations for the navigation bar or drawer
List<NavBar> destinations = <NavBar>[
  const NavBar('Dashboard', Icon(Icons.dashboard_outlined),
      Icon(Icons.dashboard), DirectorDashboard()),
  const NavBar('Élèves', Icon(Icons.people_outline), Icon(Icons.people),
      StudentWidget()),
  NavBar('Classes', const Icon(Icons.class_outlined), const Icon(Icons.class_),
      ClassroomManagement()),
  const NavBar('Enseignants', Icon(Icons.person_outline), Icon(Icons.person),
      TeacherWidget()),
  // const NavBar('Cours', Icon(Icons.book_outlined), const Icon(Icons.book), CourseManagementPage()),
  const NavBar('Communiqués', Icon(Icons.announcement_outlined),
      Icon(Icons.announcement), SchoolHomePage()),
  const NavBar('Events', Icon(Icons.event_outlined), Icon(Icons.event),
      EventsManagementScreen()),
  const NavBar('Parents', Icon(Icons.family_restroom_outlined),
      Icon(Icons.family_restroom), ParentScreen()),
  NavBar('Discipline', const Icon(Icons.gavel_outlined), const Icon(Icons.gavel),
      DisciplinePage ()),
  const NavBar('Settings', Icon(Icons.settings_outlined), Icon(Icons.settings),
      SettingsScreen()),
];

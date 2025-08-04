import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:tech_fun/views/main/layout_page.dart';
import 'package:tech_fun/views/mid/event_page.dart';

class EventDetailPage extends StatefulWidget {
  final EventStatus eventStatus;
  const EventDetailPage({super.key, required this.eventStatus});

  @override
  State<EventDetailPage> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage>
    with TickerProviderStateMixin {
  bool isExpanded = false;
  // Sample event data
  final String eventTitle = 'Flutter Global Summit 2025';
  final String eventDescription = List.generate(
    60,
    (i) => 'Event Detail Line ${i + 1}',
  ).join('\n');
  final String organizer = 'TechFun Global';
  final String dateTime = 'Aug 12, 2025 – 9:00 AM to 5:00 PM';
  final String location = 'San Francisco Convention Center';
  int attendees = 157;

  late final AnimationController _bgController;
  late final Animation<Color?> _color1;
  late final Animation<Color?> _color2;
  late final Animation<Color?> _color3;

  @override
  void initState() {
    super.initState();

    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);

    _color1 = ColorTween(
      begin: const Color(0xFF263238), // blueGrey800
      end: const Color(0xFF607D8B), // blueGrey
    ).animate(_bgController);

    _color2 = ColorTween(
      begin: const Color(0xFF000000),
      end: const Color(0xFF1C1C1C),
    ).animate(_bgController);

    _color3 = ColorTween(
      begin: const Color(0xFF90A4AE),
      end: const Color(0xFFB0BEC5),
    ).animate(_bgController);
  }

  @override
  void dispose() {
    _bgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _bgController,
        builder: (context, child) {
          return Stack(
            children: [
              // 🟢 Animated Background
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.center,
                      radius: 1.2,
                      colors: [
                        _color1.value ?? Colors.black,
                        _color2.value ?? Colors.grey,
                        _color3.value ?? Colors.white,
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ),

              // 🧱 Foreground Content
              ScrollConfiguration(
                behavior: const MaterialScrollBehavior().copyWith(
                  dragDevices: {
                    PointerDeviceKind.touch,
                    PointerDeviceKind.mouse,
                  },
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 60, 16, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // DateTime
                      Text(
                        dateTime,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Title
                      Text(
                        eventTitle,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Organizer & Location
                      Text(
                        'Organized by $organizer',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 18,
                            color: Colors.orangeAccent,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              location,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Attendees
                      Row(
                        children: [
                          const Icon(
                            Icons.people_alt,
                            size: 18,
                            color: Colors.tealAccent,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$attendees attendees',
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Description
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1E1E),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[800]!),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              eventDescription,
                              maxLines: isExpanded ? null : 20,
                              overflow: isExpanded
                                  ? TextOverflow.visible
                                  : TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () =>
                                    setState(() => isExpanded = !isExpanded),
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.cyanAccent,
                                ),
                                child: Text(
                                  isExpanded ? 'View Less' : 'View More',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      if (widget.eventStatus == EventStatus.none) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  attendees++;
                                  Navigator.pop(context, EventStatus.joined);
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                minimumSize: const Size(120, 44),
                              ),
                              child: const Text('Join'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  Navigator.pop(context, EventStatus.refused);
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                minimumSize: const Size(120, 44),
                              ),
                              child: const Text('Refuse'),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              // 🏠 Home Button
              Positioned(
                top: 20,
                right: 16,
                child: IconButton(
                  icon: const Icon(Icons.home, color: Colors.white70),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LayoutPage(),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

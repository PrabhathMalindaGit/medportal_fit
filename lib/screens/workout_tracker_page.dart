import 'package:flutter/material.dart';

class WorkoutTrackerPage extends StatelessWidget {
  const WorkoutTrackerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                _buildWorkoutGraph(),
                const SizedBox(height: 24),
                _buildDailyWorkoutSchedule(),
                const SizedBox(height: 24),
                _buildUpcomingWorkouts(),
                const SizedBox(height: 24),
                _buildWorkoutCategories(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const BackButton(),
        const Expanded(
          child: Text(
            'Workout Tracker',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.more_horiz),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildWorkoutGraph() {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF92A3FD),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Upperbody Workout',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: CustomPaint(
              size: const Size(double.infinity, 120),
              painter: WorkoutGraphPainter(),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Sun',
                style: TextStyle(color: Colors.white.withOpacity(0.7)),
              ),
              Text(
                'Mon',
                style: TextStyle(color: Colors.white.withOpacity(0.7)),
              ),
              Text(
                'Tue',
                style: TextStyle(color: Colors.white.withOpacity(0.7)),
              ),
              Text(
                'Wed',
                style: TextStyle(color: Colors.white.withOpacity(0.7)),
              ),
              Text(
                'Thu',
                style: TextStyle(color: Colors.white.withOpacity(0.7)),
              ),
              Text(
                'Fri',
                style: TextStyle(color: Colors.white.withOpacity(0.7)),
              ),
              Text(
                'Sat',
                style: TextStyle(color: Colors.white.withOpacity(0.7)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDailyWorkoutSchedule() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Daily Workout Schedule',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        TextButton(
          onPressed: () {},
          child: const Text('Check'),
        ),
      ],
    );
  }

  Widget _buildUpcomingWorkouts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Upcoming Workout',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('See more'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildWorkoutItem('Fullbody Workout', true),
        const SizedBox(height: 12),
        _buildWorkoutItem('Upperbody Workout', false),
      ],
    );
  }

  Widget _buildWorkoutCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'What Do You Want to Train',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        _buildWorkoutCategoryItem(
          'Fullbody Workout',
          '11 Exercises | 32mins',
          Icons.accessibility_new,
        ),
        const SizedBox(height: 12),
        _buildWorkoutCategoryItem(
          'Lowerbody Workout',
          '12 Exercises | 40mins',
          Icons.sports_gymnastics,
        ),
        const SizedBox(height: 12),
        _buildWorkoutCategoryItem(
          'Ab Workout',
          '14 Exercises | 25mins',
          Icons.fitness_center,
        ),
      ],
    );
  }

  Widget _buildWorkoutItem(String title, bool isActive) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF92A3FD).withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.fitness_center, color: Color(0xFF92A3FD)),
          ),
          const SizedBox(width: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Switch(
            value: isActive,
            onChanged: (value) {},
            activeColor: const Color(0xFF92A3FD),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutCategoryItem(String title, String subtitle, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF92A3FD).withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF92A3FD)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text('View more'),
          ),
        ],
      ),
    );
  }
}

class WorkoutGraphPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(0, size.height * 0.8);
    path.cubicTo(
      size.width * 0.2,
      size.height * 0.3,
      size.width * 0.4,
      size.height * 0.6,
      size.width * 0.6,
      size.height * 0.2,
    );
    path.cubicTo(
      size.width * 0.8,
      size.height * 0.4,
      size.width * 0.9,
      size.height * 0.7,
      size.width,
      size.height * 0.5,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
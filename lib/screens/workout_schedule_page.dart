import 'package:flutter/material.dart';

class WorkoutSchedulePage extends StatelessWidget {
  const WorkoutSchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildMonthSelector(),
              const SizedBox(height: 24),
              _buildScheduleCalendar(),
              const SizedBox(height: 24),
              Expanded(
                child: _buildTimelineView(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFFEEA4CE),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const BackButton(),
        const Expanded(
          child: Text(
            'Workout Schedule',
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

  Widget _buildMonthSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () {},
        ),
        const Text(
          'May 2021',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildScheduleCalendar() {
    return SizedBox(
      height: 80,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildDateItem('Wed', '12', false),
          _buildDateItem('Thu', '13', false),
          _buildDateItem('Fri', '14', true),
          _buildDateItem('Sat', '15', false),
          _buildDateItem('Sun', '16', false),
        ],
      ),
    );
  }

  Widget _buildDateItem(String day, String date, bool isSelected) {
    return Container(
      width: 60,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF92A3FD) : Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            day,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey,
              fontSize: 12,
            ),
          ),
          Text(
            date,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineView() {
    return ListView(
      children: [
        _buildTimeSlot('06:00 AM'),
        _buildTimeSlot('07:00 AM'),
        _buildTimeSlot('08:00 AM', workout: 'Ab Workout'),
        _buildTimeSlot('09:00 AM', workout: 'Upperbody Workout'),
        _buildTimeSlot('10:00 AM'),
        _buildTimeSlot('11:00 AM'),
        _buildTimeSlot('12:00 AM'),
        _buildTimeSlot('01:00 PM'),
        _buildTimeSlot('02:00 PM'),
        _buildTimeSlot('03:00 PM', workout: 'Lowerbody Workout'),
        _buildTimeSlot('04:00 PM'),
        _buildTimeSlot('05:00 PM'),
        _buildTimeSlot('06:00 PM'),
        _buildTimeSlot('07:00 PM'),
        _buildTimeSlot('08:00 PM'),
      ],
    );
  }

  Widget _buildTimeSlot(String time, {String? workout}) {
    return SizedBox(
      height: 60,
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              time,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ),
          if (workout != null)
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: workout.contains('Ab') 
                      ? const Color(0xFFEEA4CE).withOpacity(0.2)
                      : const Color(0xFF92A3FD).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  workout,
                  style: TextStyle(
                    color: workout.contains('Ab')
                        ? const Color(0xFFEEA4CE)
                        : const Color(0xFF92A3FD),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
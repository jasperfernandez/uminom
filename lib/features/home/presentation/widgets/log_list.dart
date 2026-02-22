import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uminom/features/home/domain/entities/water_intake_entry.dart';

class LogList extends StatelessWidget {
  final List<WaterIntakeEntry> entries;
  final ValueChanged<WaterIntakeEntry> onDelete;

  const LogList({super.key, required this.entries, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return SliverToBoxAdapter(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFF1F5F9), width: 2),
          ),
          child: Column(
            children: [
              Icon(
                Icons.water_drop_outlined,
                size: 56,
                color: const Color(0xFF94A3B8).withValues(alpha: 0.5),
              ),
              const SizedBox(height: 20),
              const Text(
                'No logs yet.\nStart with a refreshing glass of water!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 16,
                  height: 1.5,
                  fontFamily: 'PT Sans',
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final entry = entries[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFF1F5F9), width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2FE),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.water_drop_rounded,
                  color: Color(0xFF0EA5E9),
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Water Intake',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                        fontFamily: 'PT Sans',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formatTime(entry.timestamp),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF94A3B8),
                        fontWeight: FontWeight.w600,
                        fontFamily: 'PT Sans',
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '+${entry.volumeMl} ml',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF0EA5E9),
                  fontFamily: 'PT Sans',
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                onPressed: () => onDelete(entry),
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color: Color(0xFFEF4444),
                ),
                tooltip: 'Delete entry',
              ),
            ],
          ),
        );
      }, childCount: entries.length),
    );
  }

  static String formatTime(DateTime time) {
    return DateFormat.jm().format(time);
  }
}

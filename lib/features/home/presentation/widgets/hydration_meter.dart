import 'package:flutter/material.dart';
import 'package:uminom/features/home/domain/entities/daily_goal.dart';
import 'package:uminom/features/home/presentation/widgets/bottle_meter.dart';

class HydrationMeter extends StatelessWidget {
  final DailyGoal goal;
  final int totalToday;
  final VoidCallback onEdit;

  const HydrationMeter({
    super.key,
    required this.goal,
    required this.totalToday,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final target = goal.targetMl <= 0 ? 1 : goal.targetMl;
    final progress = (totalToday / target).clamp(0.0, 1.0);
    final percent = (progress * 100).round();
    final remaining = goal.targetMl - totalToday;
    final remainingLabel = remaining <= 0
        ? 'Goal reached'
        : '${remaining.clamp(0, goal.targetMl)} ml remaining';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: progress),
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return BottleMeter(fill: value);
            },
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Daily Goal',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                        fontFamily: 'PT Sans',
                      ),
                    ),
                    TextButton(
                      onPressed: onEdit,
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF0072FF),
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'PT Sans',
                        ),
                      ),
                      child: const Text('Edit'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '$percent% of daily goal',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0EA5E9),
                    fontFamily: 'PT Sans',
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '$totalToday ml / ${goal.targetMl} ml',
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w600,
                    fontFamily: 'PT Sans',
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  remainingLabel,
                  style: TextStyle(
                    fontSize: 14,
                    color: remaining <= 0
                        ? const Color(0xFF22C55E)
                        : const Color(0xFF94A3B8),
                    fontWeight: FontWeight.w600,
                    fontFamily: 'PT Sans',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

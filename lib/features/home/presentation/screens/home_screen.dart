import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uminom/features/auth/presentation/controllers/auth_controller.dart';
import 'package:uminom/features/auth/presentation/providers/auth_provider.dart';
import 'package:uminom/features/home/domain/entities/daily_goal.dart';
import 'package:uminom/features/home/domain/entities/water_intake_entry.dart';
import 'package:uminom/features/home/presentation/providers/daily_goal_stream_provider.dart';
import 'package:uminom/features/home/presentation/providers/water_intake_providers.dart';
import 'package:uminom/features/home/presentation/providers/water_intake_stream_provider.dart';
import 'package:uminom/features/home/presentation/widgets/daily_goal_sheet.dart';
import 'package:uminom/features/home/presentation/widgets/hydration_meter.dart';
import 'package:uminom/features/home/presentation/widgets/log_list.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _customController = TextEditingController();
  final List<int> _presets = [200, 300, 500];
  int? _selectedPreset;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  void _selectPreset(int value) {
    setState(() {
      _selectedPreset = value;
      _customController.text = '';
    });
  }

  int? _resolveVolume() {
    if (_selectedPreset != null) {
      return _selectedPreset;
    }
    final parsed = int.tryParse(_customController.text.trim());
    if (parsed == null || parsed <= 0) {
      return null;
    }
    return parsed;
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final dailyEntries = ref.watch(todayWaterIntakeProvider);
    final dailyGoal = ref.watch(dailyGoalProvider);
    final controller = ref.watch(waterLogControllerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: authState.when(
        data: (user) {
          if (user == null) {
            return const Center(
              child: Text(
                'Please log in',
                style: TextStyle(fontFamily: 'PT Sans'),
              ),
            );
          }
          return CustomScrollView(
            slivers: [
              // Header & Quick Log
              SliverAppBar(
                pinned: true,
                scrolledUnderElevation: 0,
                expandedHeight: 420,
                elevation: 0,
                backgroundColor: Colors.transparent,
                flexibleSpace: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                  child: FlexibleSpaceBar(
                    background: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 140, 16, 0),
                      child: Column(
                        spacing: 36,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(28),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 24,
                                  offset: const Offset(0, 12),
                                ),
                              ],
                            ),
                            child: _buildQuickLog(controller, context, user),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                title: _buildUserInfo(user),
              ),

              // Daily Goal and Hydration Meter
              SliverAppBar(
                primary: false,
                automaticallyImplyLeading: false,
                titleSpacing: 0,
                pinned: true,
                backgroundColor: const Color(0xFFF8FAFC),
                scrolledUnderElevation: 0,
                elevation: 0,
                toolbarHeight: 280,
                title: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: dailyGoal.when(
                    data: (goal) => HydrationMeter(
                      goal: goal,
                      totalToday: _totalVolume(dailyEntries),
                      onEdit: () => _openGoalSheet(user.uid, goal),
                    ),
                    loading: () => const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF0072FF),
                      ),
                    ),
                    error: (err, stack) => Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFFF1F5F9),
                          width: 2,
                        ),
                      ),
                      child: Text(
                        'Goal error: $err',
                        style: const TextStyle(
                          color: Color(0xFFEF4444),
                          fontFamily: 'PT Sans',
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Today's Hydration Section
              SliverAppBar(
                primary: false,
                automaticallyImplyLeading: false,
                titleSpacing: 16,
                pinned: true,
                toolbarHeight: 50,
                backgroundColor: const Color(0xFFF8FAFC),
                scrolledUnderElevation: 0,
                elevation: 0,
                title: const Text(
                  "Today's Hydration",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E293B),
                    fontFamily: 'PT Sans',
                  ),
                ),
              ),

              // Log List
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 24,
                ),
                sliver: dailyEntries.when(
                  data: (entries) => LogList(
                    entries: entries,
                    onDelete: (entry) =>
                        _confirmDeleteEntry(uid: user.uid, entry: entry),
                  ),
                  loading: () => const SliverToBoxAdapter(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF0072FF),
                      ),
                    ),
                  ),
                  error: (err, stack) => SliverToBoxAdapter(
                    child: Center(
                      child: Text(
                        'Error: $err',
                        style: const TextStyle(
                          color: Color(0xFFEF4444),
                          fontFamily: 'PT Sans',
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SliverFillRemaining(),
            ],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: Color(0xFF0072FF)),
        ),
        error: (err, stack) => Center(
          child: Text(
            'Error: $err',
            style: const TextStyle(
              color: Color(0xFFEF4444),
              fontFamily: 'PT Sans',
            ),
          ),
        ),
      ),
    );
  }

  Row _buildUserInfo(User user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      spacing: 16,
      children: [
        // User Info
        Row(
          spacing: 16,
          children: [
            Container(
              padding: const EdgeInsets.all(3),
              child: CircleAvatar(
                radius: 22,
                backgroundColor: const Color(0xFFE2E8F0),
                backgroundImage: user.photoURL != null
                    ? NetworkImage(user.photoURL!)
                    : null,
                child: user.photoURL == null
                    ? const Icon(Icons.person, color: Color(0xFF0072FF))
                    : null,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getGreeting(),
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white.withValues(alpha: 0.9),
                    fontFamily: 'PT Sans',
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  user.displayName ?? 'Friend',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'PT Sans',
                  ),
                ),
              ],
            ),
          ],
        ),

        // Logout Button
        IconButton(
          icon: const Icon(Icons.logout_rounded, color: Colors.white, size: 28),
          onPressed: () => ref.read(authControllerProvider.notifier).signOut(),
          splashRadius: 24,
        ),
      ],
    );
  }

  Column _buildQuickLog(
    AsyncValue<void> controller,
    BuildContext context,
    User user,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.water_drop_rounded, color: Color(0xFF0072FF), size: 24),
            SizedBox(width: 10),
            Text(
              'Quick Log',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
                fontFamily: 'PT Sans',
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _presets.map((value) {
            final isSelected = _selectedPreset == value;
            return Expanded(
              child: GestureDetector(
                onTap: () => _selectPreset(value),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF0072FF)
                        : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF0072FF)
                          : Colors.transparent,
                      width: 2,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: const Color(
                                0xFF0072FF,
                              ).withValues(alpha: 0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      '$value ml',
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF475569),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        fontFamily: 'PT Sans',
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _customController,
          keyboardType: TextInputType.number,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
            fontFamily: 'PT Sans',
          ),
          decoration: InputDecoration(
            hintText: 'Custom amount (ml)',
            hintStyle: const TextStyle(
              color: Color(0xFF94A3B8),
              fontWeight: FontWeight.normal,
              fontFamily: 'PT Sans',
            ),
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            prefixIcon: const Icon(
              Icons.edit_rounded,
              color: Color(0xFF94A3B8),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 18),
          ),
          onChanged: (_) {
            if (_selectedPreset != null) {
              setState(() => _selectedPreset = null);
            }
          },
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0072FF),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(vertical: 18),
            ),
            onPressed: controller.isLoading
                ? null
                : () async {
                    final volume = _resolveVolume();
                    if (volume == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                            'Please enter a valid amount.',
                            style: TextStyle(fontFamily: 'PT Sans'),
                          ),
                          backgroundColor: const Color(0xFFEF4444),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: const EdgeInsets.all(20),
                        ),
                      );
                      return;
                    }
                    await ref
                        .read(waterLogControllerProvider.notifier)
                        .logIntake(user.uid, volume);
                  },
            child: controller.isLoading
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  )
                : const Text(
                    'Log Intake',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'PT Sans',
                      letterSpacing: 0.5,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  int _totalVolume(AsyncValue<List<WaterIntakeEntry>> entries) {
    return entries.maybeWhen(
      data: (items) => items.fold(0, (sum, entry) => sum + entry.volumeMl),
      orElse: () => 0,
    );
  }

  Future<void> _openGoalSheet(String uid, DailyGoal goal) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DailyGoalSheet(uid: uid, goal: goal);
      },
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return 'Good Morning,';
    } else if (hour >= 12 && hour < 17) {
      return 'Good Afternoon,';
    } else if (hour >= 17 && hour < 21) {
      return 'Good Evening,';
    } else {
      return 'Good Night,';
    }
  }

  Future<void> _confirmDeleteEntry({
    required String uid,
    required WaterIntakeEntry entry,
  }) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Text(
            'Delete entry?',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
              fontFamily: 'PT Sans',
            ),
          ),
          content: Text(
            'Remove ${entry.volumeMl} ml logged at ${LogList.formatTime(entry.timestamp)}?',
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF64748B),
              fontFamily: 'PT Sans',
              height: 1.5,
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF64748B),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'PT Sans',
                ),
              ),
              child: const Text('Cancel'),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'PT Sans',
                ),
              ),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirm != true || !mounted) {
      return;
    }

    await ref
        .read(waterLogControllerProvider.notifier)
        .deleteIntake(uid, entry.id);
  }
}

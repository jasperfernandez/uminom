import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uminom/features/auth/presentation/controllers/auth_controller.dart';
import 'package:uminom/features/auth/presentation/providers/auth_provider.dart';
import 'package:uminom/features/home/domain/entities/daily_goal.dart';
import 'package:uminom/features/home/domain/entities/water_intake_entry.dart';
import 'package:uminom/features/home/presentation/providers/daily_goal_stream_provider.dart';
import 'package:uminom/features/home/presentation/providers/daily_goal_providers.dart';
import 'package:uminom/features/home/presentation/providers/water_intake_providers.dart';
import 'package:uminom/features/home/presentation/providers/water_intake_stream_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _customController = TextEditingController();
  final List<int> _presets = [200, 300, 500];
  int? _selectedPreset;
  late final ScrollController _scrollController;
  bool _showQuickLog = true;
  double _lastScrollOffset = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_handleScroll);
  }

  void _handleScroll() {
    final offset = _scrollController.offset;
    if (offset <= 0 && !_showQuickLog) {
      setState(() => _showQuickLog = true);
      _lastScrollOffset = offset;
      return;
    }

    if (offset > _lastScrollOffset + 8 && _showQuickLog) {
      setState(() => _showQuickLog = false);
    } else if (offset < _lastScrollOffset - 8 && !_showQuickLog) {
      setState(() => _showQuickLog = true);
    }

    _lastScrollOffset = offset;
  }

  @override
  void dispose() {
    _customController.dispose();
    _scrollController
      ..removeListener(_handleScroll)
      ..dispose();
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
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(28, 64, 28, 36),
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
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(3),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: CircleAvatar(
                                  radius: 26,
                                  backgroundColor: const Color(0xFFE2E8F0),
                                  backgroundImage: user.photoURL != null
                                      ? NetworkImage(user.photoURL!)
                                      : null,
                                  child: user.photoURL == null
                                      ? const Icon(
                                          Icons.person,
                                          color: Color(0xFF0072FF),
                                        )
                                      : null,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _getGreeting(),
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white.withValues(
                                        alpha: 0.9,
                                      ),
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
                          Material(
                            color: Colors.transparent,
                            child: IconButton(
                              icon: const Icon(
                                Icons.logout_rounded,
                                color: Colors.white,
                                size: 28,
                              ),
                              onPressed: () => ref
                                  .read(authControllerProvider.notifier)
                                  .signOut(),
                              splashRadius: 24,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 36),
                      ClipRect(
                        child: AnimatedSize(
                          duration: const Duration(milliseconds: 260),
                          curve: Curves.easeInOutCubic,
                          alignment: Alignment.topCenter,
                          child: Align(
                            alignment: Alignment.topCenter,
                            heightFactor: _showQuickLog ? 1 : 0,
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 180),
                              curve: Curves.easeInOut,
                              opacity: _showQuickLog ? 1 : 0,
                              child: IgnorePointer(
                                ignoring: !_showQuickLog,
                                child: Container(
                                  padding: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(28),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.1,
                                        ),
                                        blurRadius: 24,
                                        offset: const Offset(0, 12),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Row(
                                        children: [
                                          Icon(
                                            Icons.water_drop_rounded,
                                            color: Color(0xFF0072FF),
                                            size: 24,
                                          ),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: _presets.map((value) {
                                          final isSelected =
                                              _selectedPreset == value;
                                          return Expanded(
                                            child: GestureDetector(
                                              onTap: () => _selectPreset(value),
                                              child: AnimatedContainer(
                                                duration: const Duration(
                                                  milliseconds: 200,
                                                ),
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 4,
                                                    ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 16,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: isSelected
                                                      ? const Color(0xFF0072FF)
                                                      : const Color(0xFFF1F5F9),
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  border: Border.all(
                                                    color: isSelected
                                                        ? const Color(
                                                            0xFF0072FF,
                                                          )
                                                        : Colors.transparent,
                                                    width: 2,
                                                  ),
                                                  boxShadow: isSelected
                                                      ? [
                                                          BoxShadow(
                                                            color:
                                                                const Color(
                                                                  0xFF0072FF,
                                                                ).withValues(
                                                                  alpha: 0.3,
                                                                ),
                                                            blurRadius: 12,
                                                            offset:
                                                                const Offset(
                                                                  0,
                                                                  6,
                                                                ),
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
                                                          : const Color(
                                                              0xFF475569,
                                                            ),
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                            borderSide: BorderSide.none,
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                vertical: 18,
                                              ),
                                        ),
                                        onChanged: (_) {
                                          if (_selectedPreset != null) {
                                            setState(
                                              () => _selectedPreset = null,
                                            );
                                          }
                                        },
                                      ),
                                      const SizedBox(height: 20),
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(
                                              0xFF0072FF,
                                            ),
                                            foregroundColor: Colors.white,
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 18,
                                            ),
                                          ),
                                          onPressed: controller.isLoading
                                              ? null
                                              : () async {
                                                  final volume =
                                                      _resolveVolume();
                                                  if (volume == null) {
                                                    ScaffoldMessenger.of(
                                                      context,
                                                    ).showSnackBar(
                                                      SnackBar(
                                                        content: const Text(
                                                          'Please enter a valid amount.',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'PT Sans',
                                                          ),
                                                        ),
                                                        backgroundColor:
                                                            const Color(
                                                              0xFFEF4444,
                                                            ),
                                                        behavior:
                                                            SnackBarBehavior
                                                                .floating,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                12,
                                                              ),
                                                        ),
                                                        margin:
                                                            const EdgeInsets.all(
                                                              20,
                                                            ),
                                                      ),
                                                    );
                                                    return;
                                                  }
                                                  await ref
                                                      .read(
                                                        waterLogControllerProvider
                                                            .notifier,
                                                      )
                                                      .logIntake(
                                                        user.uid,
                                                        volume,
                                                      );
                                                },
                                          child: controller.isLoading
                                              ? const SizedBox(
                                                  height: 24,
                                                  width: 24,
                                                  child:
                                                      CircularProgressIndicator(
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
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      dailyGoal.when(
                        data: (goal) => _HydrationMeter(
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
                      const SizedBox(height: 32),
                      const Center(
                        child: Text(
                          "Today's Hydration",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1E293B),
                            fontFamily: 'PT Sans',
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      dailyEntries.when(
                        data: (entries) => _LogList(
                          entries: entries,
                          onDelete: (entry) =>
                              _confirmDeleteEntry(uid: user.uid, entry: entry),
                        ),
                        loading: () => const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF0072FF),
                          ),
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
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
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
        return _DailyGoalSheet(uid: uid, goal: goal);
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
            'Remove ${entry.volumeMl} ml logged at ${_LogList._formatTime(entry.timestamp)}?',
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

class _DailyGoalSheet extends ConsumerStatefulWidget {
  final String uid;
  final DailyGoal goal;

  const _DailyGoalSheet({required this.uid, required this.goal});

  @override
  ConsumerState<_DailyGoalSheet> createState() => _DailyGoalSheetState();
}

class _DailyGoalSheetState extends ConsumerState<_DailyGoalSheet> {
  late final TextEditingController _goalController;
  final List<int> _presets = [1500, 2000, 2500];
  int? _selectedPreset;

  @override
  void initState() {
    super.initState();
    _goalController = TextEditingController(
      text: widget.goal.targetMl.toString(),
    );
  }

  @override
  void dispose() {
    _goalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(dailyGoalControllerProvider);
    final isLoading = controller.isLoading;

    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Set Daily Goal',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                  fontFamily: 'PT Sans',
                ),
              ),
              IconButton(
                onPressed: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.close, color: Color(0xFF94A3B8)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Choose a target that feels achievable today.',
            style: TextStyle(color: Color(0xFF64748B), fontFamily: 'PT Sans'),
          ),
          const SizedBox(height: 20),
          Row(
            children: _presets.map((value) {
              final isSelected = _selectedPreset == value;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedPreset = value;
                      _goalController.text = value.toString();
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(vertical: 14),
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
                    ),
                    child: Center(
                      child: Text(
                        '$value ml',
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF475569),
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
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
            controller: _goalController,
            keyboardType: TextInputType.number,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
              fontFamily: 'PT Sans',
            ),
            decoration: InputDecoration(
              hintText: 'Custom goal (ml)',
              hintStyle: const TextStyle(
                color: Color(0xFF94A3B8),
                fontFamily: 'PT Sans',
              ),
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
              prefixIcon: const Icon(
                Icons.flag_rounded,
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
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: isLoading
                  ? null
                  : () async {
                      final value = int.tryParse(_goalController.text.trim());
                      if (value == null || value <= 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                              'Enter a valid goal amount.',
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
                      FocusManager.instance.primaryFocus?.unfocus();
                      await ref
                          .read(dailyGoalControllerProvider.notifier)
                          .setGoal(widget.uid, value);
                      if (!mounted) {
                        return;
                      }
                      Navigator.of(context).pop();
                    },
              child: isLoading
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      ),
                    )
                  : const Text(
                      'Save Goal',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'PT Sans',
                        letterSpacing: 0.3,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HydrationMeter extends StatelessWidget {
  final DailyGoal goal;
  final int totalToday;
  final VoidCallback onEdit;

  const _HydrationMeter({
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
              return _BottleMeter(fill: value);
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

class _BottleMeter extends StatelessWidget {
  final double fill;

  const _BottleMeter({required this.fill});

  @override
  Widget build(BuildContext context) {
    const bottleWidth = 90.0;
    const bottleHeight = 160.0;
    const neckWidth = 44.0;
    const neckHeight = 26.0;
    const borderColor = Color(0xFFB6E5FB);
    const backgroundFill = Color(0xFFE0F2FE);

    return Column(
      children: [
        Container(
          width: neckWidth,
          height: neckHeight,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: borderColor, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: bottleWidth,
          height: bottleHeight,
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: borderColor, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(26),
            child: Stack(
              children: [
                Container(color: backgroundFill),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: FractionallySizedBox(
                    heightFactor: fill.clamp(0.0, 1.0),
                    widthFactor: 1,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [Color(0xFF0072FF), Color(0xFF00C6FF)],
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: 10,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _LogList extends StatelessWidget {
  final List<WaterIntakeEntry> entries;
  final ValueChanged<WaterIntakeEntry> onDelete;

  const _LogList({required this.entries, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return Container(
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
      );
    }

    return Column(
      children: entries
          .map(
            (entry) => Container(
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
                          _formatTime(entry.timestamp),
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
            ),
          )
          .toList(),
    );
  }

  static String _formatTime(DateTime time) {
    return DateFormat.jm().format(time);
  }
}

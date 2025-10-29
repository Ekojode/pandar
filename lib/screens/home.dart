import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../repositories/task_repository.dart';
import '../widgets/filter_chip_button.dart';
import '../widgets/picker_row.dart';
import '../widgets/task_tile.dart';

class Task {
  Task({
    required this.id,
    required this.title,
    this.description,
    this.time,
    this.date,
    this.hasNotification = false,
    this.repeatRule,
    this.completed = false,
  });

  final int id;
  String title;
  String? description;
  String? time;
  String? date;
  bool hasNotification;
  String? repeatRule;
  bool completed;
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Task> _tasks = [];

  DateTime? _fltDate;
  TimeOfDay? _fltTime;
  bool? _fltCompleted;
  String? _fltRepeat;
  bool? _fltReminder;

  String _fmtDate(DateTime d) => DateFormat('dd/MM/yy').format(d);
  String _fmtTime(TimeOfDay t) =>
      DateFormat('h:mm a').format(DateTime(0, 1, 1, t.hour, t.minute));

  List<Task> get _filteredTasks {
    Iterable<Task> it = _tasks;

    if (_fltDate != null) {
      final d = _fmtDate(_fltDate!);
      it = it.where((t) => (t.date ?? '') == d);
    }
    if (_fltTime != null) {
      final tm = _fmtTime(_fltTime!);
      it = it.where((t) => (t.time ?? '') == tm);
    }
    if (_fltCompleted != null) {
      it = it.where((t) => t.completed == _fltCompleted);
    }
    if (_fltRepeat != null) {
      it = it.where((t) {
        final r = (t.repeatRule ?? '').trim();
        if (r.isEmpty) return false;
        if (_fltRepeat == 'Weekly') return r.startsWith('Weekly');
        return r == _fltRepeat;
      });
    }
    if (_fltReminder != null) {
      it = it.where((t) => t.hasNotification == _fltReminder);
    }

    final a = it.where((t) => !t.completed).toList();
    final b = it.where((t) => t.completed).toList();
    return [...a, ...b];
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await _load();
  }

  Future<void> _load() async {
    final rows = await TaskRepository().fetchAll();
    final mapped = rows
        .map(
          (e) => Task(
            id: e.id!,
            title: e.title,
            description: e.description,
            time: e.time,
            date: e.date,

            repeatRule: e.repeatRule,
            completed: e.completed,
          ),
        )
        .toList();

    if (!mounted) return;
    setState(() {
      _tasks
        ..clear()
        ..addAll(mapped);
    });
  }

  Future<void> _toggle(Task t) async {
    await TaskRepository().toggle(t.id, !t.completed);
    await _load();
  }

  Future<void> _delete(Task t) async {
    await TaskRepository().delete(t.id);
    await _load();
  }

  void _openSettings() {
    Navigator.of(context).pushNamed('settings');
  }

  double verticalPadding(BuildContext context) =>
      MediaQuery.of(context).size.height * 0.07;
  double horizontalPadding(BuildContext context) =>
      MediaQuery.of(context).size.width * 0.05;

  Future<void> _openFilterSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            Future<void> pickDate() async {
              final now = DateTime.now();
              final picked = await showDatePicker(
                context: context,
                initialDate: _fltDate ?? now,
                firstDate: DateTime(now.year - 1),
                lastDate: DateTime(now.year + 5),
                helpText: 'Select date',
              );
              if (picked != null) setSheetState(() => _fltDate = picked);
            }

            Future<void> pickTime() async {
              final picked = await showTimePicker(
                context: context,
                initialTime: _fltTime ?? TimeOfDay.now(),
                helpText: 'Select time',
              );
              if (picked != null) setSheetState(() => _fltTime = picked);
            }

            Widget chip(String label, bool selected, VoidCallback onTap) {
              final bg = selected ? Colors.black : Colors.white;
              final fg = selected ? Colors.white : Colors.black;
              return Material(
                color: bg,
                shape: StadiumBorder(
                  side: BorderSide(color: Colors.grey.shade300),
                ),
                child: InkWell(
                  onTap: onTap,
                  customBorder: const StadiumBorder(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    child: Text(
                      label,
                      style: TextStyle(color: fg, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              );
            }

            final bottomInset = MediaQuery.of(context).viewInsets.bottom;

            return Padding(
              padding: EdgeInsets.only(bottom: bottomInset),
              child: SafeArea(
                top: false,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Container(
                          width: 44,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      const Text(
                        'Date & Time',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 12),

                      PickerRow(
                        icon: Icons.calendar_today,
                        label: _fltDate != null
                            ? _fmtDate(_fltDate!)
                            : 'Set date',
                        onTap: pickDate,
                        onClear: _fltDate != null
                            ? () => setSheetState(() => _fltDate = null)
                            : null,
                      ),
                      const SizedBox(height: 12),
                      PickerRow(
                        icon: Icons.access_time,
                        label: _fltTime != null
                            ? _fmtTime(_fltTime!)
                            : 'Set time',
                        onTap: pickTime,
                        onClear: _fltTime != null
                            ? () => setSheetState(() => _fltTime = null)
                            : null,
                      ),

                      const SizedBox(height: 20),
                      const Text(
                        'Completion Status',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          chip(
                            'Completed',
                            _fltCompleted == true,
                            () => setSheetState(() => _fltCompleted = true),
                          ),
                          chip(
                            'Incomplete',
                            _fltCompleted == false,
                            () => setSheetState(() => _fltCompleted = false),
                          ),
                          chip(
                            'Any',
                            _fltCompleted == null,
                            () => setSheetState(() => _fltCompleted = null),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                      const Text(
                        'Repeat',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          chip(
                            'Daily',
                            _fltRepeat == 'Daily',
                            () => setSheetState(() => _fltRepeat = 'Daily'),
                          ),
                          chip(
                            'Weekly',
                            _fltRepeat == 'Weekly',
                            () => setSheetState(() => _fltRepeat = 'Weekly'),
                          ),
                          chip(
                            'Monthly',
                            _fltRepeat == 'Monthly',
                            () => setSheetState(() => _fltRepeat = 'Monthly'),
                          ),
                          chip(
                            'No repeat',
                            _fltRepeat == null,
                            () => setSheetState(() => _fltRepeat = null),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF3B82F6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            setState(() {});
                          },
                          child: const Text('Apply Filter'),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            setSheetState(() {
                              _fltDate = null;
                              _fltTime = null;
                              _fltCompleted = null;
                              _fltRepeat = null;
                              _fltReminder = null;
                            });
                          },
                          child: const Text('Clear selections'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding(context),
                verticalPadding(context),
                horizontalPadding(context),
                12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset("assets/images/pandar.png", height: 28),
                      const Spacer(),
                      IconButton(
                        iconSize: 28,
                        splashRadius: 28,
                        tooltip: 'Settings',
                        onPressed: _openSettings,
                        icon: const Icon(Icons.menu, color: Colors.black87),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Today',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                          fontSize: 24,
                          height: 1.3,
                        ),
                      ),
                      const Spacer(),
                      ConstrainedBox(
                        constraints: const BoxConstraints(
                          minWidth: 96,
                          minHeight: 48,
                        ),
                        child: FilterChipButton(
                          label: 'Filter',
                          onTap: _openFilterSheet,
                          height: 36,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          SliverList.separated(
            itemBuilder: (context, index) {
              final task = _filteredTasks[index];
              return Dismissible(
                key: ValueKey(task.id),
                direction: task.completed
                    ? DismissDirection.endToStart
                    : DismissDirection.none,
                background: const SizedBox.shrink(),
                secondaryBackground: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  color: Colors.red.shade50,
                  child: Icon(Icons.delete, color: Colors.red.shade400),
                ),
                confirmDismiss: (_) async => task.completed,
                onDismissed: (_) => _delete(task),
                child: InkWell(
                  onTap: () async {
                    final result = await Navigator.pushNamed(
                      context,
                      'edit_task',
                      arguments: task,
                    );
                    if (result == true) await _load();
                  },
                  child: TaskTile(task: task, onToggle: () => _toggle(task)),
                ),
              );
            },
            separatorBuilder: (_, __) => const Padding(
              padding: EdgeInsets.only(left: 72, right: 16),
              child: Column(
                children: [
                  SizedBox(height: 8),
                  Divider(height: 1),
                  SizedBox(height: 8),
                ],
              ),
            ),
            itemCount: _filteredTasks.length,
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 96)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final saved = await Navigator.pushNamed(context, 'add_task');
          if (saved == true) await _load();
        },
        backgroundColor: Colors.black,
        shape: const CircleBorder(),
        elevation: 3,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}

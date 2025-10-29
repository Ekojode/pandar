import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/task_entity.dart';
import '../repositories/task_repository.dart';
import '../widgets/field_label.dart';
import '../widgets/input_field.dart';
import '../widgets/picker_field.dart';
import '../widgets/repeat_chip.dart';
import '../widgets/save_button.dart';
import '../widgets/weekday_chip.dart';
import 'home.dart';

class EditTaskPage extends StatefulWidget {
  const EditTaskPage({super.key});

  @override
  State<EditTaskPage> createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  late Task _task;

  String? _repeatRule;
  final Set<int> _repeatWeekdays = {};
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  EdgeInsets get _screenHPad {
    final w = MediaQuery.of(context).size.width;
    final hpad = (w * 0.05).clamp(16.0, 24.0);
    return EdgeInsets.symmetric(horizontal: hpad);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final arg = ModalRoute.of(context)!.settings.arguments;
      _task = arg as Task;

      _titleCtrl.text = _task.title;
      _descCtrl.text = _task.description ?? '';

      _repeatRule = _task.repeatRule;
      _hydrateWeekdaysFromRule(_repeatRule);

      _selectedDate = _parseDateOrNull(_task.date);
      _selectedTime = _parseTimeOrNull(_task.time);

      setState(() {});
    });
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  String _formatDate(DateTime d) => DateFormat('dd/MM/yy').format(d);

  String _formatTime(TimeOfDay t) {
    final dt = DateTime(0, 1, 1, t.hour, t.minute);
    return DateFormat('h:mm a').format(dt);
  }

  DateTime? _parseDateOrNull(String? s) {
    if (s == null || s.trim().isEmpty) return null;
    try {
      return DateFormat('dd/MM/yy').parseStrict(s);
    } catch (_) {
      return null;
    }
  }

  TimeOfDay? _parseTimeOrNull(String? s) {
    if (s == null || s.trim().isEmpty) return null;
    try {
      final dt = DateFormat('h:mm a').parseStrict(s);
      return TimeOfDay.fromDateTime(dt);
    } catch (_) {
      return null;
    }
  }

  void _hydrateWeekdaysFromRule(String? rule) {
    _repeatWeekdays.clear();
    if (rule == null) return;
    if (!rule.startsWith('Weekly')) return;

    final exp = RegExp(r'(\d+)');
    for (final m in exp.allMatches(rule)) {
      final v = int.tryParse(m.group(1)!);
      if (v != null && v >= 1 && v <= 7) _repeatWeekdays.add(v);
    }
  }

  void _selectRepeatRule(String rule) {
    setState(() {
      _repeatRule = rule;
      if (rule != 'Weekly') {
        _repeatWeekdays.clear();
      }
    });
  }

  void _toggleWeekday(int weekday) {
    setState(() {
      if (_repeatWeekdays.contains(weekday)) {
        _repeatWeekdays.remove(weekday);
      } else {
        _repeatWeekdays.add(weekday);
      }
      if (_repeatWeekdays.isNotEmpty) {
        _repeatRule = 'Weekly';
      }
    });
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
      helpText: 'Select date',
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      helpText: 'Select time',
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  Future<void> _save() async {
    final title = _titleCtrl.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter a title')));
      return;
    }

    final dateStr = _selectedDate != null ? _formatDate(_selectedDate!) : null;
    final timeStr = _selectedTime != null ? _formatTime(_selectedTime!) : null;

    String? normalizedRepeat;
    if (_repeatRule == null || _repeatRule == 'No repeat') {
      normalizedRepeat = null;
    } else if (_repeatRule == 'Weekly' && _repeatWeekdays.isNotEmpty) {
      final list = _repeatWeekdays.toList()..sort();
      normalizedRepeat = 'Weekly:${list.toString()}';
    } else {
      normalizedRepeat = _repeatRule;
    }

    final entity = TaskEntity(
      id: _task.id,
      title: title,
      description: _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
      time: timeStr,
      date: dateStr,

      repeatRule: normalizedRepeat,
      completed: _task.completed,
    );

    await TaskRepository().update(entity);

    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    if (!(_titleCtrl.text.isNotEmpty ||
        ModalRoute.of(context)?.settings.arguments != null)) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final spacing = 16.0;
    final bigSpacing = 24.0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context, false),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          tooltip: 'Back',
        ),
        title: const Text(
          'Modify to-do',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: _screenHPad.add(const EdgeInsets.only(bottom: 24, top: 8)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const FieldLabel(text: 'Tell us about your task'),
              SizedBox(height: spacing),

              InputField(
                controller: _titleCtrl,
                hint: 'Title',
                textInputAction: TextInputAction.next,
              ),
              SizedBox(height: spacing),
              InputField(
                controller: _descCtrl,
                hint: 'Description',
                maxLines: 3,
              ),
              SizedBox(height: bigSpacing),

              const FieldLabel(text: 'Repeat'),
              SizedBox(height: spacing),

              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  RepeatChip(
                    label: 'Daily',
                    selected: _repeatRule == 'Daily',
                    onTap: () => _selectRepeatRule('Daily'),
                  ),
                  RepeatChip(
                    label: 'Weekly',
                    selected: _repeatRule == 'Weekly',
                    onTap: () => _selectRepeatRule('Weekly'),
                  ),
                  RepeatChip(
                    label: 'Monthly',
                    selected: _repeatRule == 'Monthly',
                    onTap: () => _selectRepeatRule('Monthly'),
                  ),
                  RepeatChip(
                    label: 'No repeat',
                    selected: _repeatRule == null || _repeatRule == 'No repeat',
                    onTap: () => _selectRepeatRule('No repeat'),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  WeekdayChip(
                    label: 'Sunday',
                    selected: _repeatWeekdays.contains(7),
                    onTap: () => _toggleWeekday(7),
                  ),
                  WeekdayChip(
                    label: 'Monday',
                    selected: _repeatWeekdays.contains(1),
                    onTap: () => _toggleWeekday(1),
                  ),
                  WeekdayChip(
                    label: 'Tuesday',
                    selected: _repeatWeekdays.contains(2),
                    onTap: () => _toggleWeekday(2),
                  ),
                  WeekdayChip(
                    label: 'Wednesday',
                    selected: _repeatWeekdays.contains(3),
                    onTap: () => _toggleWeekday(3),
                  ),
                  WeekdayChip(
                    label: 'Thursday',
                    selected: _repeatWeekdays.contains(4),
                    onTap: () => _toggleWeekday(4),
                  ),
                  WeekdayChip(
                    label: 'Friday',
                    selected: _repeatWeekdays.contains(5),
                    onTap: () => _toggleWeekday(5),
                  ),
                  WeekdayChip(
                    label: 'Saturday',
                    selected: _repeatWeekdays.contains(6),
                    onTap: () => _toggleWeekday(6),
                  ),
                ],
              ),
              SizedBox(height: bigSpacing),

              const FieldLabel(text: 'Date & Time'),
              SizedBox(height: spacing),

              PickerField(
                hint: 'Set date',
                valueText: _selectedDate != null
                    ? _formatDate(_selectedDate!)
                    : null,
                iconAsset: 'assets/icons/calendar.svg',
                onTap: _pickDate,
                onClear: _selectedDate != null
                    ? () => setState(() => _selectedDate = null)
                    : null,
              ),
              SizedBox(height: spacing),

              PickerField(
                hint: 'Set time',
                valueText: _selectedTime != null
                    ? _formatTime(_selectedTime!)
                    : null,
                iconAsset: 'assets/icons/clock.svg',
                onTap: _pickTime,
                onClear: _selectedTime != null
                    ? () => setState(() => _selectedTime = null)
                    : null,
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
        child: SafeArea(top: false, child: SaveButton(onPressed: _save)),
      ),
    );
  }
}

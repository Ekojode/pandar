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

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  String? _repeatRule;
  final Set<int> _repeatWeekdays = {};

  static const Color white = Colors.white;

  EdgeInsets get _screenHPad {
    final w = MediaQuery.of(context).size.width;
    final hpad = (w * 0.05).clamp(16.0, 24.0);
    return EdgeInsets.symmetric(horizontal: hpad);
  }

  String _formatDate(DateTime d) => DateFormat('dd/MM/yy').format(d);
  String _formatTime(TimeOfDay t) {
    final dt = DateTime(0, 1, 1, t.hour, t.minute);
    return DateFormat('h:mm a').format(dt);
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: now.subtract(const Duration(days: 0)),
      lastDate: DateTime(now.year + 5),
      helpText: 'Select date',
      builder: (ctx, child) {
        return child!;
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      helpText: 'Select time',
      builder: (ctx, child) => child!,
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  void _selectRepeatRule(String rule) {
    setState(() {
      _repeatRule = rule;
      if (rule != 'Weekly') _repeatWeekdays.clear();
    });
  }

  void _toggleWeekday(int weekday) {
    setState(() {
      if (_repeatWeekdays.contains(weekday)) {
        _repeatWeekdays.remove(weekday);
      } else {
        _repeatWeekdays.add(weekday);
      }
      if (_repeatWeekdays.isNotEmpty) _repeatRule = 'Weekly';
    });
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

    String? repeatRule;
    if (_repeatRule == null || _repeatRule == 'No repeat') {
      repeatRule = null;
    } else if (_repeatRule == 'Weekly' && _repeatWeekdays.isNotEmpty) {
      repeatRule = 'Weekly:${_repeatWeekdays.toList()..sort()}';
    } else {
      repeatRule = _repeatRule;
    }

    final entity = TaskEntity(
      title: title,
      description: _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
      time: timeStr,
      date: dateStr,
      repeatRule: repeatRule,
      completed: false,
    );

    await TaskRepository().add(entity);
    if (mounted) Navigator.pop(context, true);
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final spacing = 16.0;
    final bigSpacing = 24.0;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: white,
        elevation: 0,
        surfaceTintColor: white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context, false),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          tooltip: 'Back',
        ),
        title: const Text(
          'Create to-do',
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
          padding: EdgeInsets.only(bottom: 24).add(_screenHPad),
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
              SizedBox(height: spacing),

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

              SizedBox(height: width * 0.1),
            ],
          ),
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
        child: SafeArea(child: SaveButton(onPressed: _save)),
      ),
    );
  }
}

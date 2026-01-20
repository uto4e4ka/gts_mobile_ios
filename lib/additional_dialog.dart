import 'package:flutter/material.dart';

class OvertimeDialog extends StatefulWidget {
  const OvertimeDialog({super.key});

  @override
  State<OvertimeDialog> createState() => _OvertimeDialogState();
}

class _OvertimeDialogState extends State<OvertimeDialog> {
  double hours = 8.0;
  bool isDayOff = false;
  final TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// ❌ Кнопка закрытия
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => Navigator.pop(context),
                  child: const Padding(
                    padding: EdgeInsets.all(6),
                    child: Icon(Icons.close),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              /// ⏱ Заголовок + часы
              Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'Переработка:',
                      style: TextStyle(
                        fontSize: 16,
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                    ),
                  ),
                  Text(
                    '${hours % 1 == 0 ? hours.toInt() : hours}ч',
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 5),

              /// 🎚 Слайдер всегда активен
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 20,
                  activeTrackColor: Theme.of(context).primaryColor,
                  inactiveTrackColor: Colors.grey.shade300,
                  thumbColor: Theme.of(context).primaryColor,
                  overlayColor: Theme.of(context).primaryColor.withOpacity(0.2),
                  disabledActiveTrackColor: Theme.of(context).primaryColor,
                  disabledInactiveTrackColor: Colors.grey.shade300,
                  disabledThumbColor: Theme.of(context).primaryColor,
                ),
                child: Slider(
                  value: hours,
                  min: 0,
                  max: 8,
                  divisions: 16,
                  onChanged: (value) {
                    setState(() {
                      hours = value;
                    });
                  },
                ),
              ),

              const SizedBox(height: 20),

              /// ☑ Чекбокс Выходной
              Row(
                children: [
                  Checkbox(
                    value: isDayOff,
                    onChanged: (value) {
                      // setState(() {
                      //   isDayOff = value ?? false;
                      //   // hours остаются без изменений
                      // });
                    },
                  ),
                  const Text('Выхо111дной'),
                ],
              ),

              const SizedBox(height: 10),

              /// 📝 Комментарий
              TextField(
                controller: commentController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Комментарий',
                  filled: true,
                  fillColor: isDark
                      ? Colors.grey.shade800
                      : Colors.grey.shade200,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 15,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              /// 💾 Сохранить
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, {
                      'hours': hours,
                      'isDayOff': isDayOff,
                      'comment': commentController.text,
                    });
                  },
                  child: const Text('Сохранить'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

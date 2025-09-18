import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../features/survey/provider/survey_provider.dart';

class QuestionWidget extends StatelessWidget {
  final Map<String, dynamic> question;

  const QuestionWidget({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SurveyProvider>(context);
    final currentAnswer = provider.currentAnswers[question['id']];
    final error = provider.errors[question['id']];

    Widget field;
    switch (question['type']) {
      case 'text':
      case 'textarea':
        field = TextField(
          controller: provider.getController(question['id']),
          maxLines: question['type'] == 'textarea' ? 3 : 1,
          decoration: InputDecoration(
            labelText: question['question'],
            labelStyle: const TextStyle(fontWeight: FontWeight.w600),
            errorText: error,
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onChanged: (val) => provider.updateAnswer(question['id'], val),
        );
        break;

      case 'radio':
        field = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(question['question'],
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
            if (error != null)
              Text(error, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 8),
            ...(question['options'] as List).map((option) {
              return Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: RadioListTile(
                  title: Text(option),
                  value: option,
                  groupValue: currentAnswer,
                  onChanged: (val) => provider.updateAnswer(question['id'], val),
                  activeColor: Colors.blueAccent,
                ),
              );
            }),
          ],
        );
        break;

      case 'dropdown':
        field = DropdownButtonFormField(
          decoration: InputDecoration(
            labelText: question['question'],
            labelStyle: const TextStyle(fontWeight: FontWeight.w600),
            errorText: error,
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          items: (question['options'] as List)
              .map((opt) =>
              DropdownMenuItem(value: opt, child: Text(opt.toString())))
              .toList(),
          value: currentAnswer,
          onChanged: (val) => provider.updateAnswer(question['id'], val),
        );
        break;

      case 'checkbox':
        field = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading, //
              title: Text(
                question['question'],
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              value: currentAnswer ?? false,
              onChanged: (val) => provider.updateAnswer(question['id'], val),
              activeColor: Colors.blueAccent,
            ),
            if (error != null)
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(error, style: const TextStyle(color: Colors.red)),
              )
          ],
        );
        break;

      case 'slider':
        field = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(question['question'],
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
            Slider(
              value: (currentAnswer ?? question['min']).toDouble(),
              min: question['min'].toDouble(),
              max: question['max'].toDouble(),
              divisions: (question['max'] - question['min']),
              label: "${currentAnswer ?? question['min']}",
              activeColor: Colors.blueAccent,
              onChanged: (val) {
                provider.updateAnswer(question['id'], val.toInt());
              },
            ),
            if (error != null)
              Text(error, style: const TextStyle(color: Colors.red)),
          ],
        );
        break;

      case 'date':
        field = InkWell(
          onTap: () async {
            DateTime? picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );
            if (picked != null) {
              provider.updateAnswer(
                  question['id'], "${picked.toLocal()}".split(' ')[0]);
            }
          },
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: question['question'],
              labelStyle: const TextStyle(fontWeight: FontWeight.w600),
              errorText: error,
              filled: true,
              fillColor: Colors.grey[50],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              suffixIcon:
              const Icon(Icons.calendar_today, color: Colors.blueAccent),
            ),
            child: Text(
              currentAnswer ?? "Select a date",
              style: TextStyle(
                  color: currentAnswer == null ? Colors.grey : Colors.black87),
            ),
          ),
        );
        break;

      default:
        field = const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: field,
    );
  }
}

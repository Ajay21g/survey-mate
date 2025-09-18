import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:survey_mate/core/strings/app_string.dart';
import 'package:survey_mate/features/survey/view/survey_results.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/question_widget.dart';
import '../provider/survey_provider.dart';

class SurveyForm extends StatefulWidget {
  const SurveyForm({super.key});

  @override
  State<SurveyForm> createState() => _SurveyFormState();
}

class _SurveyFormState extends State<SurveyForm> {
  List<dynamic> questions = [];

  @override
  void initState() {
    super.initState();
    loadQuestions();
  }

  Future<void> loadQuestions() async {
    String data =
    await rootBundle.loadString('assets/json/survey_questions.json');
    final qs = jsonDecode(data);
    setState(() {
      questions = qs;
    });
    Provider.of<SurveyProvider>(context, listen: false).setQuestions(qs);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SurveyProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(AppStrings.surveyFormTitle),
        centerTitle: true,
        elevation: 2,
      ),
      body: questions.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              AppStrings.surveyFormInstruction,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
            const SizedBox(height: 20),
            ...questions.map((q) => QuestionWidget(question: q)),
            const SizedBox(height: 30),
            PrimaryButton(
              text: AppStrings.submitSurvey,
              onPressed: () {
                if (!provider.validateAnswers(questions)) {
                  return;
                }
                provider.submitResponse();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SurveyResults(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

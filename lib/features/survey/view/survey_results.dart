import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:survey_mate/core/strings/app_string.dart';
import 'package:survey_mate/features/survey/view/survey_form.dart';
import '../../../core/widgets/primary_button.dart';
import '../provider/survey_provider.dart';

class SurveyResults extends StatelessWidget {
  const SurveyResults({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SurveyProvider>(context);
    final responses = provider.allResponses;
    final questions = provider.questions;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(AppStrings.surveyResultsTitle),
        centerTitle: true,
      ),
      body: responses.isEmpty
          ? const Center(
              child: Text(
                AppStrings.noResponses,
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            )
          : Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                physics: const BouncingScrollPhysics(),
                itemCount: responses.length,
                itemBuilder: (context, responseIndex) {
                  final response = responses[responseIndex];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.person,
                                color: Colors.blueAccent,
                                size: 22,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "${AppStrings.responseLabel} #${responseIndex + 1}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueAccent,
                                ),
                              ),
                            ],
                          ),
                          const Divider(),
                          ...questions.map((q) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    q['question'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    child: Text(
                                      "${response[q['id']] ?? 'No answer'}",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                          PrimaryButton(
                            text: AppStrings.submitAnotherResponse,
                            height: 50,
                            borderRadius: 12,
                            fontSize: 16,
                            onPressed: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (_) => const SurveyForm(),
                                ),
                                    (Route<dynamic> route) => false,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}

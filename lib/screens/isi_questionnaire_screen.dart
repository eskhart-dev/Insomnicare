import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/isi_provider.dart';
import '../providers/auth_provider.dart';
import 'result_screen.dart';

/// Screen for ISI Questionnaire using Stepper
class ISIQuestionnaireScreen extends StatefulWidget {
  const ISIQuestionnaireScreen({super.key});

  @override
  State<ISIQuestionnaireScreen> createState() => _ISIQuestionnaireScreenState();
}

class _ISIQuestionnaireScreenState extends State<ISIQuestionnaireScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    // Reset questionnaire when starting
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ISIProvider>().resetQuestionnaire();
    });
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Batalkan Kuesioner?'),
            content: const Text('Progres Anda akan hilang jika Anda keluar.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Tidak'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Ya, Keluar'),
              ),
            ],
          ),
        );
        return shouldPop ?? false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Kuesioner ISI'),
        ),
        body: Consumer<ISIProvider>(
          builder: (context, isiProvider, child) {
            return Column(
              children: [
                // Progress bar
                LinearProgressIndicator(
                  value: isiProvider.progress,
                  backgroundColor: Colors.grey[200],
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Pertanyaan ${isiProvider.currentQuestionIndex + 1} dari ${isiProvider.totalQuestions}',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Text(
                        '${((isiProvider.progress * 100).toInt())}%',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                    ],
                  ),
                ),

                // Question content
                Expanded(
                  child: PageView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: (index) {
                      // Sync provider with page
                      isiProvider.jumpToQuestion(index);
                    },
                    itemCount: isiProvider.totalQuestions,
                    itemBuilder: (context, index) {
                      final question = isiProvider.currentQuestion;
                      return _buildQuestionPage(question, isiProvider);
                    },
                  ),
                ),

                // Navigation buttons
                _buildNavigationControls(isiProvider),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildQuestionPage(dynamic question, ISIProvider isiProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question card
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Pertanyaan ${question.id}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    question.question,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Options
          Text(
            'Pilih jawaban yang paling sesuai:',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 16),

          ...List.generate(question.options.length, (index) {
            final option = question.options[index];
            final isSelected = isiProvider.answers[question.id] == option.score;

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              elevation: isSelected ? 4 : 1,
              color: isSelected ? Theme.of(context).colorScheme.primary.withOpacity(0.1) : null,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey.shade300,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: InkWell(
                onTap: () {
                  isiProvider.setAnswer(option.score);
                },
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey.shade300,
                        ),
                        child: Center(
                          child: isSelected
                              ? const Icon(Icons.check, color: Colors.white, size: 18)
                              : Text(
                                  option.score.toString(),
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          option.label,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? Theme.of(context).colorScheme.primary : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),

          // Error message
          if (isiProvider.errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red.shade700, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        isiProvider.errorMessage!,
                        style: TextStyle(color: Colors.red.shade700),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNavigationControls(ISIProvider isiProvider) {
    final isFirstQuestion = isiProvider.currentQuestionIndex == 0;
    final isLastQuestion = isiProvider.currentQuestionIndex == isiProvider.totalQuestions - 1;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Previous button
            Expanded(
              child: ElevatedButton(
                onPressed: isFirstQuestion
                    ? null
                    : () {
                        isiProvider.goToPreviousQuestion();
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Sebelumnya'),
              ),
            ),
            const SizedBox(width: 16),

            // Next/Submit button
            Expanded(
              child: Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  return ElevatedButton(
                    onPressed: isiProvider.isLoading
                        ? null
                        : () async {
                            if (isLastQuestion) {
                              // Submit questionnaire
                              final userId = authProvider.userId;
                              if (userId != null) {
                                final success = await isiProvider.submitQuestionnaire(userId);
                                if (success && mounted) {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (_) => ResultScreen(
                                        result: isiProvider.lastResult!,
                                      ),
                                    ),
                                  );
                                }
                              }
                            } else {
                              isiProvider.goToNextQuestion();
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: isiProvider.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(isLastQuestion ? 'Selesai' : 'Selanjutnya'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

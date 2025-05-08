import 'package:flutter/material.dart';

class LearnSummaryScreen extends StatelessWidget {
  final int total;
  final int correct;

  const LearnSummaryScreen({
    super.key,
    required this.total,
    required this.correct,
  });

  @override
  Widget build(BuildContext context) {
    final incorrect = total - correct;
    final scorePercent = ((correct / total) * 100).round();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FF),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ✅ Big check icon
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.green,
                  size: 60,
                ),
              ),
              const SizedBox(height: 24),

              // 🎉 Finished text
              Text(
                'You finished the quiz!',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              // ✅ ❌ Score line
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$correct correct',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.green.shade700,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text('·'),
                  const SizedBox(width: 12),
                  Text(
                    '$incorrect incorrect',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.red.shade600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // 🔢 Percentage (optional)
              Text(
                'Score: $scorePercent%',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),

              const SizedBox(height: 48),

              // 🔙 Back button
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Back to Course'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                  textStyle: const TextStyle(fontSize: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

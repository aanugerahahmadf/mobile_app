import 'package:flutter/material.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import 'package:mobile_app/core/api/api_endpoints.dart';
import 'package:mobile_app/core/api/dio_client.dart';
import 'package:mobile_app/core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';

class AdminCbirEvaluationPage extends StatefulWidget {
  const AdminCbirEvaluationPage({super.key});

  @override
  State<AdminCbirEvaluationPage> createState() => _AdminCbirEvaluationPageState();
}

class _AdminCbirEvaluationPageState extends State<AdminCbirEvaluationPage> {
  bool _loading = false;
  bool _hasRun = false;
  Map<String, dynamic>? _data;
  String? _error;

  Future<void> _evaluate() async {
    setState(() { _loading = true; _error = null; _hasRun = false; });
    try {
      final res = await DioClient.instance.get(ApiEndpoints.cbirEvaluate);
      final body = res.data as Map<String, dynamic>;
      if (body['success'] == true) {
        setState(() { _data = body; _loading = false; _hasRun = true; });
      } else {
        setState(() { _error = body['message'] as String? ?? 'Evaluation failed'; _loading = false; });
      }
    } catch (e) {
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l.adminCbirEvaluation), backgroundColor: Colors.transparent, elevation: 0),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.error_outline, size: 48, color: AppColors.errorColor),
                        const SizedBox(height: 16),
                        Text(_error!, style: AppTextStyles.bodyMedium, textAlign: TextAlign.center),
                        const SizedBox(height: 16),
                        FilledButton.icon(
                          onPressed: _evaluate,
                          icon: const Icon(Icons.refresh),
                          label: Text(l.retry),
                        ),
                      ],
                    ),
                  ),
                )
              : _hasRun && _data != null
                  ? _buildResults(l)
                  : _buildStartPrompt(l),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _loading ? null : _evaluate,
        icon: _loading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.play_arrow),
        label: Text(l.evaluate),
      ),
    );
  }

  Widget _buildStartPrompt(AppLocalizations l) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.analytics_outlined, size: 64, color: AppColors.primaryColor.withValues(alpha: 0.6)),
            const SizedBox(height: 16),
            Text(l.evaluationResult, style: AppTextStyles.titleMedium),
            const SizedBox(height: 8),
            Text(l.adminCbirEvaluation, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildResults(AppLocalizations l) {
    final metrics = _data!['metrics'] as Map<String, dynamic>? ?? {};
    final precisionAt3 = _data!['precision_at_3'];
    final nImages = _data!['n_images'] ?? 0;
    final nQueries = _data!['n_queries'] ?? 0;
    final evalTime = _data!['evaluation_time_seconds'];

    return RefreshIndicator(
      onRefresh: _evaluate,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection(l.evaluationResult, [
            _buildMetricCard(l.map, '${metrics['map'] ?? '-'}', Icons.auto_awesome, AppColors.primaryColor),
            _buildMetricCard(l.mrr, '${metrics['mrr'] ?? '-'}', Icons.sort, AppColors.infoColor),
            _buildMetricCard('Precision@3', '$precisionAt3', Icons.precision_manufacturing, AppColors.successColor),
            _buildMetricCard(l.firstRankAccuracy, '${metrics['first_rank_accuracy'] ?? '-'}', Icons.looks_one, AppColors.warningColor),
          ]),
          const SizedBox(height: 16),
          _buildSection('Info', [
            _buildInfoRow(l.totalImages, '$nImages'),
            _buildInfoRow(l.totalQueries, '$nQueries'),
            _buildInfoRow(l.evaluationTime, '${metrics['avg_query_time_s'] ?? evalTime}s'),
          ]),
          const SizedBox(height: 16),
          _buildSection('Raw Metrics', [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.dividerColor),
              ),
              child: Text(
                _formatJson(metrics),
                style: const TextStyle(fontSize: 11, fontFamily: 'monospace'),
              ),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.titleMedium),
        const SizedBox(height: 8),
        ...children,
      ],
    );
  }

  Widget _buildMetricCard(String label, String value, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: AppTextStyles.bodyMedium)),
          Text(value, style: AppTextStyles.titleMedium.copyWith(color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodyMedium),
          Text(value, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  String _formatJson(Map<String, dynamic> json) {
    try {
      return json.toString();
    } catch (_) {
      return '$json';
    }
  }
}

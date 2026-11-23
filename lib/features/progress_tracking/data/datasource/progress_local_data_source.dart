import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/utils/constants.dart';
import '../../domain/entities/progress_entities.dart';

abstract class ProgressLocalDataSource {
  Future<List<WeightEntryEntity>> getWeights();
  Future<void> saveWeight(WeightEntryEntity entry);
  Future<List<InBodyReportEntity>> getInBodyList();
  Future<void> saveInBody(InBodyReportEntity report);
  Future<List<ClinicVisitEntity>> getVisits();
}

class ProgressLocalDataSourceImpl implements ProgressLocalDataSource {
  final SharedPreferences sharedPreferences;

  ProgressLocalDataSourceImpl({required this.sharedPreferences});

  static List<WeightEntryEntity> get defaultWeights => [
        WeightEntryEntity(
          id: 'w_1',
          weight: 92.0,
          date: DateTime.now().subtract(const Duration(days: 42)),
          note: 'Starting weight check at clinic',
        ),
        WeightEntryEntity(
          id: 'w_2',
          weight: 90.5,
          date: DateTime.now().subtract(const Duration(days: 28)),
          note: 'Week 2 progress after meal routine',
        ),
        WeightEntryEntity(
          id: 'w_3',
          weight: 89.2,
          date: DateTime.now().subtract(const Duration(days: 14)),
          note: 'Steady fat loss observed',
        ),
        WeightEntryEntity(
          id: 'w_4',
          weight: 88.0,
          date: DateTime.now().subtract(const Duration(days: 2)),
          note: 'Current recorded morning weigh-in',
        ),
      ];

  static List<InBodyReportEntity> get defaultInBody => [
        InBodyReportEntity(
          id: 'inbody_01',
          date: DateTime.now().subtract(const Duration(days: 40)),
          weight: 92.0,
          bodyFatPercentage: 27.8,
          muscleMassKg: 36.5,
          bmi: 28.4,
          visceralFatLevel: 10,
          bodyWaterKg: 42.1,
          notes: 'Baseline scan. Elevated visceral fat and water retention.',
        ),
        InBodyReportEntity(
          id: 'inbody_02',
          date: DateTime.now().subtract(const Duration(days: 10)),
          weight: 88.0,
          bodyFatPercentage: 24.2,
          muscleMassKg: 37.1,
          bmi: 26.8,
          visceralFatLevel: 8,
          bodyWaterKg: 43.5,
          notes: 'Superb progress: 3.6% fat reduction and muscle mass maintained.',
        ),
      ];

  static List<ClinicVisitEntity> get defaultVisits => [
        ClinicVisitEntity(
          id: 'visit_01',
          date: DateTime.now().subtract(const Duration(days: 42)),
          weight: 92.0,
          specialistNotes: 'Initial consultation and dietary history assessment.',
          recommendations: 'Initiate caloric restriction protocol, reduce refined sugar.',
          status: 'Completed',
        ),
        ClinicVisitEntity(
          id: 'visit_02',
          date: DateTime.now().subtract(const Duration(days: 21)),
          weight: 89.8,
          specialistNotes: 'Follow-up consultation. Patient is compliant with water intake.',
          recommendations: 'Slightly raise protein intake on strength training days.',
          status: 'Completed',
        ),
      ];

  @override
  Future<List<WeightEntryEntity>> getWeights() async {
    final raw = sharedPreferences.getString(AppConstants.prefsWeightKey);
    if (raw != null) {
      try {
        final list = jsonDecode(raw) as List<dynamic>;
        return list
            .map((item) => WeightEntryEntity(
                  id: item['id'],
                  weight: (item['weight'] as num).toDouble(),
                  date: DateTime.parse(item['date']),
                  note: item['note'],
                ))
            .toList();
      } catch (_) {
        return defaultWeights;
      }
    }
    return defaultWeights;
  }

  @override
  Future<void> saveWeight(WeightEntryEntity entry) async {
    final weights = await getWeights();
    final updated = [entry, ...weights];
    final encoded = jsonEncode(updated
        .map((e) => {
              'id': e.id,
              'weight': e.weight,
              'date': e.date.toIso8601String(),
              'note': e.note,
            })
        .toList());
    await sharedPreferences.setString(AppConstants.prefsWeightKey, encoded);
  }

  @override
  Future<List<InBodyReportEntity>> getInBodyList() async {
    final raw = sharedPreferences.getString(AppConstants.prefsInBodyKey);
    if (raw != null) {
      try {
        final list = jsonDecode(raw) as List<dynamic>;
        return list
            .map((item) => InBodyReportEntity(
                  id: item['id'],
                  date: DateTime.parse(item['date']),
                  weight: (item['weight'] as num).toDouble(),
                  bodyFatPercentage: (item['bodyFatPercentage'] as num).toDouble(),
                  muscleMassKg: (item['muscleMassKg'] as num).toDouble(),
                  bmi: (item['bmi'] as num).toDouble(),
                  visceralFatLevel: (item['visceralFatLevel'] as num).toInt(),
                  bodyWaterKg: (item['bodyWaterKg'] as num).toDouble(),
                  notes: item['notes'],
                  documentUrl: item['documentUrl'],
                ))
            .toList();
      } catch (_) {
        return defaultInBody;
      }
    }
    return defaultInBody;
  }

  @override
  Future<void> saveInBody(InBodyReportEntity report) async {
    final reports = await getInBodyList();
    final updated = [report, ...reports];
    final encoded = jsonEncode(updated
        .map((e) => {
              'id': e.id,
              'date': e.date.toIso8601String(),
              'weight': e.weight,
              'bodyFatPercentage': e.bodyFatPercentage,
              'muscleMassKg': e.muscleMassKg,
              'bmi': e.bmi,
              'visceralFatLevel': e.visceralFatLevel,
              'bodyWaterKg': e.bodyWaterKg,
              'notes': e.notes,
              'documentUrl': e.documentUrl,
            })
        .toList());
    await sharedPreferences.setString(AppConstants.prefsInBodyKey, encoded);
  }

  @override
  Future<List<ClinicVisitEntity>> getVisits() async {
    return defaultVisits;
  }
}

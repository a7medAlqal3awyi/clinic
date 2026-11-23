import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/utils/constants.dart';
import '../../domain/entities/online_followup_entity.dart';

abstract class OnlineFollowupLocalDataSource {
  Future<List<OnlineFollowupEntity>> getFollowups();
  Future<OnlineFollowupEntity> saveFollowup(OnlineFollowupEntity followup);
  Future<void> updateStatus(String id, FollowupStatus status, String? feedback);
}

class OnlineFollowupLocalDataSourceImpl implements OnlineFollowupLocalDataSource {
  final SharedPreferences sharedPreferences;

  OnlineFollowupLocalDataSourceImpl({required this.sharedPreferences});

  static List<OnlineFollowupEntity> get defaultSeed => [
        OnlineFollowupEntity(
          id: 'fol_01',
          submissionDate: DateTime.now().subtract(const Duration(days: 14)),
          currentWeight: 89.5,
          chestCm: 104,
          waistCm: 88,
          hipsCm: 100,
          notes: 'Adhering to meal times strictly, digestion improved noticeably.',
          medicalTestFiles: ['cbc_report_nov.pdf'],
          progressPhotos: ['photo_front_w1.jpg'],
          status: FollowupStatus.reviewed,
          specialistFeedback: 'Great adherence! Waist circumference decreased by 2cm. Keep the current macros for another 2 weeks.',
        ),
      ];

  @override
  Future<List<OnlineFollowupEntity>> getFollowups() async {
    final raw = sharedPreferences.getString(AppConstants.prefsFollowupsKey);
    if (raw != null) {
      try {
        final list = jsonDecode(raw) as List<dynamic>;
        return list
            .map((item) => OnlineFollowupEntity(
                  id: item['id'],
                  submissionDate: DateTime.parse(item['submissionDate']),
                  currentWeight: (item['currentWeight'] as num).toDouble(),
                  chestCm: (item['chestCm'] as num).toDouble(),
                  waistCm: (item['waistCm'] as num).toDouble(),
                  hipsCm: (item['hipsCm'] as num).toDouble(),
                  notes: item['notes'] ?? '',
                  medicalTestFiles: List<String>.from(item['medicalTestFiles'] ?? []),
                  progressPhotos: List<String>.from(item['progressPhotos'] ?? []),
                  status: _parseStatus(item['status']),
                  specialistFeedback: item['specialistFeedback'],
                ))
            .toList();
      } catch (_) {
        return defaultSeed;
      }
    }
    return defaultSeed;
  }

  static FollowupStatus _parseStatus(dynamic s) {
    switch (s) {
      case 'underReview':
        return FollowupStatus.underReview;
      case 'reviewed':
        return FollowupStatus.reviewed;
      case 'needInfo':
        return FollowupStatus.needInfo;
      default:
        return FollowupStatus.submitted;
    }
  }

  @override
  Future<OnlineFollowupEntity> saveFollowup(OnlineFollowupEntity followup) async {
    final list = await getFollowups();
    final updated = [followup, ...list];
    final encoded = jsonEncode(updated
        .map((f) => {
              'id': f.id,
              'submissionDate': f.submissionDate.toIso8601String(),
              'currentWeight': f.currentWeight,
              'chestCm': f.chestCm,
              'waistCm': f.waistCm,
              'hipsCm': f.hipsCm,
              'notes': f.notes,
              'medicalTestFiles': f.medicalTestFiles,
              'progressPhotos': f.progressPhotos,
              'status': f.status.name,
              'specialistFeedback': f.specialistFeedback,
            })
        .toList());
    await sharedPreferences.setString(AppConstants.prefsFollowupsKey, encoded);
    return followup;
  }

  @override
  Future<void> updateStatus(String id, FollowupStatus status, String? feedback) async {
    final list = await getFollowups();
    final updated = list.map((item) {
      if (item.id == id) {
        return OnlineFollowupEntity(
          id: item.id,
          submissionDate: item.submissionDate,
          currentWeight: item.currentWeight,
          chestCm: item.chestCm,
          waistCm: item.waistCm,
          hipsCm: item.hipsCm,
          notes: item.notes,
          medicalTestFiles: item.medicalTestFiles,
          progressPhotos: item.progressPhotos,
          status: status,
          specialistFeedback: feedback ?? item.specialistFeedback,
        );
      }
      return item;
    }).toList();

    final encoded = jsonEncode(updated
        .map((f) => {
              'id': f.id,
              'submissionDate': f.submissionDate.toIso8601String(),
              'currentWeight': f.currentWeight,
              'chestCm': f.chestCm,
              'waistCm': f.waistCm,
              'hipsCm': f.hipsCm,
              'notes': f.notes,
              'medicalTestFiles': f.medicalTestFiles,
              'progressPhotos': f.progressPhotos,
              'status': f.status.name,
              'specialistFeedback': f.specialistFeedback,
            })
        .toList());
    await sharedPreferences.setString(AppConstants.prefsFollowupsKey, encoded);
  }
}

import 'package:equatable/equatable.dart';

enum FollowupStatus {
  submitted,
  underReview,
  reviewed,
  needInfo,
}

class OnlineFollowupEntity extends Equatable {
  final String id;
  final DateTime submissionDate;
  final double currentWeight;
  final double chestCm;
  final double waistCm;
  final double hipsCm;
  final String notes;
  final List<String> medicalTestFiles;
  final List<String> progressPhotos;
  final FollowupStatus status;
  final String? specialistFeedback;

  const OnlineFollowupEntity({
    required this.id,
    required this.submissionDate,
    required this.currentWeight,
    required this.chestCm,
    required this.waistCm,
    required this.hipsCm,
    required this.notes,
    required this.medicalTestFiles,
    required this.progressPhotos,
    required this.status,
    this.specialistFeedback,
  });

  @override
  List<Object?> get props => [
        id,
        submissionDate,
        currentWeight,
        chestCm,
        waistCm,
        hipsCm,
        notes,
        medicalTestFiles,
        progressPhotos,
        status,
        specialistFeedback,
      ];
}

import 'package:equatable/equatable.dart';

class WeightEntryEntity extends Equatable {
  final String id;
  final double weight;
  final DateTime date;
  final String? note;

  const WeightEntryEntity({
    required this.id,
    required this.weight,
    required this.date,
    this.note,
  });

  @override
  List<Object?> get props => [id, weight, date, note];
}

class InBodyReportEntity extends Equatable {
  final String id;
  final DateTime date;
  final double weight;
  final double bodyFatPercentage;
  final double muscleMassKg;
  final double bmi;
  final int visceralFatLevel;
  final double bodyWaterKg;
  final String? notes;
  final String? documentUrl;

  const InBodyReportEntity({
    required this.id,
    required this.date,
    required this.weight,
    required this.bodyFatPercentage,
    required this.muscleMassKg,
    required this.bmi,
    required this.visceralFatLevel,
    required this.bodyWaterKg,
    this.notes,
    this.documentUrl,
  });

  @override
  List<Object?> get props => [
        id,
        date,
        weight,
        bodyFatPercentage,
        muscleMassKg,
        bmi,
        visceralFatLevel,
        bodyWaterKg,
        notes,
        documentUrl,
      ];
}

class ClinicVisitEntity extends Equatable {
  final String id;
  final DateTime date;
  final double weight;
  final String specialistNotes;
  final String recommendations;
  final String status;

  const ClinicVisitEntity({
    required this.id,
    required this.date,
    required this.weight,
    required this.specialistNotes,
    required this.recommendations,
    required this.status,
  });

  @override
  List<Object?> get props => [
        id,
        date,
        weight,
        specialistNotes,
        recommendations,
        status,
      ];
}

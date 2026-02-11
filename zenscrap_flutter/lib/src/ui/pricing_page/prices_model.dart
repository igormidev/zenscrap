import 'package:flutter/material.dart';

class PricesModel {
  final String title;
  final String subTitle;
  final double monthlyPrice;
  final double yearlyPrice;
  final List<String> advantagesListage;
  final int advantagesMaxLines = 2;
  final BoxDecoration? decoration;
  final Future<void> Function(bool isYearly) onTap;
  final String? emphasisText;

  const PricesModel({
    required this.title,
    required this.subTitle,
    required this.monthlyPrice,
    required this.yearlyPrice,
    required this.advantagesListage,
    this.emphasisText,
    this.decoration,
    required this.onTap,
  });
}

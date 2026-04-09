import 'model/wheather_model.dart';

double calculateScore(Weather weather) {
  double score = 0;

  final temp = weather.current?.tempC ?? 0.0; // ✅ always double
  final humidity = weather.current?.humidity ?? 0;
  final condition =
      weather.current?.condition?.text?.toLowerCase() ?? "";

  // Ideal temperature
  if (temp >= 18 && temp <= 30) {
    score += 50;
  } else {
    score -= (temp - 24).abs();
  }

  // Humidity (lower is better)
  score += (100 - humidity) * 0.2;

  // Weather condition
  if (condition.contains("rain")) score -= 20;
  if (condition.contains("clear")) score += 20;

  return score;
}
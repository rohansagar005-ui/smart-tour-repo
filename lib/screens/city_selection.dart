import 'package:flutter/material.dart';

import '../model/wheather_model.dart';
import '../repo/repo.dart';
import '../utils.dart';

class CitySelectionScreen extends StatefulWidget {
  @override
  _CitySelectionScreenState createState() => _CitySelectionScreenState();
}

class _CitySelectionScreenState extends State<CitySelectionScreen> {
  final repo = WeatherRepository("10a318d7a7c243ae845103849260904");

  final List<String> allCities = [
    "Delhi", "Mumbai", "Jaipur", "Bangalore", "Chennai",
    "Kolkata", "Hyderabad", "Pune", "Goa", "Chandigarh",
    "Ahmedabad", "Surat", "Lucknow", "Kanpur", "Nagpur",
    "Indore", "Bhopal", "Patna", "Ranchi", "Raipur",
    "Varanasi", "Amritsar", "Agra", "Shimla", "Manali",
    "Dehradun", "Udaipur", "Jodhpur", "Mysore", "Coimbatore",
    "Trivandrum", "Visakhapatnam"
  ];

  List<String> selectedCities = [];
  List<Weather> results = [];
  bool loading = false;

  List<Weather> sortCities(List<Weather> cities) {
    cities.sort((a, b) {
      final scoreA = calculateScore(a);
      final scoreB = calculateScore(b);
      return scoreB.compareTo(scoreA);
    });
    return cities;
  }

  String getTravelTag(double score) {
    if (score >= 60) return "🌴 Great";
    if (score >= 40) return "🙂 Good";
    if (score >= 20) return "😐 Okay";
    return "⚠️ Avoid";
  }

  void toggleCity(String city) {
    setState(() {
      selectedCities.contains(city)
          ? selectedCities.remove(city)
          : selectedCities.add(city);
    });
  }

  Future<void> fetchData() async {
    setState(() => loading = true);

    try {
      final data = await repo.fetchMultipleCities(selectedCities);
      final sorted = sortCities(data);

      setState(() {
        results = sorted;
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("🌍 Travel Weather"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade200, Colors.blue.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [

            Padding(
              padding: const EdgeInsets.all(12),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: allCities.map((city) {
                  final isSelected = selectedCities.contains(city);

                  return ChoiceChip(
                    label: Text(city),
                    selected: isSelected,
                    selectedColor: Colors.blue,
                    backgroundColor: Colors.white,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                    onSelected: (_) => toggleCity(city),
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: selectedCities.isEmpty ? null : fetchData,
                child: Text("Check Best Cities"),
              ),
            ),

            const SizedBox(height: 10),

            if (loading)
              Padding(
                padding: const EdgeInsets.all(20),
                child: CircularProgressIndicator(),
              ),

            /// 🏆 Results
            if (!loading && results.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  "🏆 Best to Worst Cities to Travel",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),

              Expanded(
                child: ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    final city = results[index];
                    final score = calculateScore(city);

                    return Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 6,
                            color: Colors.black12,
                          )
                        ],
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(12),

                        leading: CircleAvatar(
                          backgroundColor: index == 0
                              ? Colors.amber
                              : Colors.blue,
                          child: Text(
                            "#${index + 1}",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),

                        title: Text(
                          city.location?.name ?? "",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),

                        subtitle: Text(
                          "${city.current?.tempC}°C • ${city.current?.condition?.text} • ${getTravelTag(score)}",
                        ),

                        trailing: Icon(Icons.arrow_forward_ios, size: 16),
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
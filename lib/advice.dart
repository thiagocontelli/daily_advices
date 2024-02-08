import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Advice> fetchAdvice() async {
  final response =
      await http.get(Uri.parse('https://api.adviceslip.com/advice'));

  if (response.statusCode == 200) {
    return Advice.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception('Failed.');
  }
}

class Slip {
  final int id;
  final String advice;

  const Slip({required this.id, required this.advice});

  factory Slip.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {'id': int id, 'advice': String advice} => Slip(id: id, advice: advice),
      _ => throw const FormatException('Failed to load slip.'),
    };
  }
}

class Advice {
  final Slip slip;

  const Advice({
    required this.slip,
  });

  factory Advice.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {'slip': Map<String, dynamic> slip} => Advice(
          slip: Slip.fromJson(slip),
        ),
      _ => throw const FormatException('Failed to load advice.'),
    };
  }
}

class AdviceScreen extends StatefulWidget {
  const AdviceScreen({super.key});

  @override
  State<AdviceScreen> createState() => _AdviceScreenState();
}

class _AdviceScreenState extends State<AdviceScreen> {
  late Future<Advice> futureAdvice;

  @override
  void initState() {
    super.initState();
    futureAdvice = fetchAdvice();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Flex(
        direction: Axis.vertical,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              runSpacing: 32,
              children: [
                const Center(
                  child: Text('This is your daily advice:'),
                ),
                FutureBuilder<Advice>(
                  future: futureAdvice,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Center(
                          child: Text(
                        '"${snapshot.data!.slip.advice}"',
                        style: const TextStyle(
                            fontSize: 24, fontStyle: FontStyle.italic),
                        textAlign: TextAlign.center,
                      ));
                    } else if (snapshot.hasError) {
                      return Center(child: Text('${snapshot.error}'));
                    }

                    return const Center(
                      child: Text('Loading...'),
                    );
                  },
                ),
                const Center(
                  child: Text('Come back tomorrow for more advices!'),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

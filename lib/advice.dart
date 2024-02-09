import 'dart:async';
import 'dart:convert';

import 'package:daily_advices/database_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

Future<Advice> fetchAdvice() async {
  final response =
      await http.get(Uri.parse('https://api.adviceslip.com/advice'));

  if (response.statusCode == 200) {
    var advice =
        Advice.fromJson(jsonDecode(response.body) as Map<String, dynamic>);

    var adviceEntity = AdviceEntity(
        id: advice.slip.id,
        advice: advice.slip.advice,
        createdAt: DateTime.now());

    await DatabaseService.insertAdvice(adviceEntity.toMap());

    return advice;
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

class AdviceEntity {
  int id;
  String advice;
  DateTime createdAt;

  AdviceEntity(
      {required this.id, required this.advice, required this.createdAt});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'advice': advice,
      'created_at': DateFormat('yyyy-MM-dd').format(DateTime.now())
    };
  }
}

class AdviceScreen extends StatefulWidget {
  const AdviceScreen({super.key});

  @override
  State<AdviceScreen> createState() => _AdviceScreenState();
}

class _AdviceScreenState extends State<AdviceScreen> {
  Advice? advice;

  @override
  initState() {
    super.initState();
    onInit();
  }

  onInit() async {
    final AdviceEntity? adviceEntity = await DatabaseService.getTodaysAdvice();

    if (adviceEntity == null) {
      Advice newAdvice = await fetchAdvice();
      setState(() {
        advice = newAdvice;
      });
      return;
    }

    setState(() {
      advice =
          Advice(slip: Slip(advice: adviceEntity.advice, id: adviceEntity.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Flex(
        direction: Axis.vertical,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Wrap(
              runSpacing: 32,
              children: [
                const Center(
                  child: Text('This is your daily advice:'),
                ),
                Column(
                  children: [
                    Center(
                        child: Text(
                      '"${advice?.slip.advice}"',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 24, fontStyle: FontStyle.italic),
                    )),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '- ${DateFormat('EEEE, MMM d, yyyy').format(DateTime.now())}',
                        ),
                      ],
                    ),
                  ],
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

import 'package:daily_advices/advice.dart';
import 'package:daily_advices/database_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<AdviceEntity> advices = [];

  @override
  void initState() {
    super.initState();
    onInit();
  }

  onInit() async {
    List<AdviceEntity> newAdvices = await DatabaseService.getAdvices();

    setState(() {
      advices = newAdvices;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Advice history')),
      body: ListView.builder(
        itemCount: advices.length,
        itemBuilder: (context, index) {
          AdviceEntity advice = advices[index];

          String createdAt =
              '- ${DateFormat('EEEE, MMM d, yyyy').format(advice.createdAt)}';

          return ListTile(
            title: Card(
                child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    '"${advice.advice}"',
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        createdAt,
                      ),
                    ],
                  ),
                ],
              ),
            )),
          );
        },
      ),
    );
  }
}

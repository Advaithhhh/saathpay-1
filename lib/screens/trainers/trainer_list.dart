import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/trainer_provider.dart';
import 'add_trainer.dart';
import 'trainer_details.dart';

class TrainerListScreen extends StatelessWidget {
  const TrainerListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final trainerProvider = Provider.of<TrainerProvider>(context);
    final trainers = trainerProvider.trainers;

    return Scaffold(
      appBar: AppBar(title: const Text('Trainers')),
      body: trainers.isEmpty
          ? const Center(child: Text('No trainers found'))
          : ListView.builder(
              itemCount: trainers.length,
              itemBuilder: (context, index) {
                final trainer = trainers[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: trainer.photoUrl != null
                        ? NetworkImage(trainer.photoUrl!)
                        : null,
                    child: trainer.photoUrl == null
                        ? Text(trainer.name[0])
                        : null,
                  ),
                  title: Text(trainer.name),
                  subtitle: Text(trainer.contact),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TrainerDetailsScreen(trainer: trainer),
                      ),
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddTrainerScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

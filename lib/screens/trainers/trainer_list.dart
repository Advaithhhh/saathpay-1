import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/trainer_provider.dart';
import 'add_trainer.dart';
import 'trainer_details.dart';
import '../../widgets/glass_card.dart';
import '../../theme/app_theme.dart';

class TrainerListScreen extends StatelessWidget {
  const TrainerListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final trainerProvider = Provider.of<TrainerProvider>(context);
    final trainers = trainerProvider.trainers;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Trainers'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.primaryGradient,
        ),
        child: SafeArea(
          child: trainers.isEmpty
              ? const Center(child: Text('No trainers found', style: TextStyle(color: AppTheme.textSecondary)))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: trainers.length,
                  itemBuilder: (context, index) {
                    final trainer = trainers[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: GlassCard(
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          leading: CircleAvatar(
                            radius: 25,
                            backgroundImage: trainer.photoUrl != null
                                ? NetworkImage(trainer.photoUrl!)
                                : null,
                            child: trainer.photoUrl == null
                                ? Text(trainer.name[0], style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.maroon))
                                : null,
                          ),
                          title: Text(trainer.name, style: AppTheme.titleMedium.copyWith(fontSize: 16)),
                          subtitle: Text(trainer.contact, style: AppTheme.bodyMedium),
                          trailing: const Icon(Icons.chevron_right, color: AppTheme.maroon),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => TrainerDetailsScreen(trainer: trainer),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.secondaryColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddTrainerScreen()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

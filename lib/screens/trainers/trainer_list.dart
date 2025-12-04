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
          child: Column(
            children: [
              // Header info
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: AppTheme.radiusMedium,
                      ),
                      child: const Icon(
                        Icons.sports_gymnastics_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${trainers.length} ${trainers.length == 1 ? 'Trainer' : 'Trainers'}',
                            style: AppTheme.titleMediumLight,
                          ),
                          Text(
                            'Manage your gym staff',
                            style: AppTheme.bodySmallLight,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Trainer list
              Expanded(
                child: trainers.isEmpty
                    ? EmptyState(
                        icon: Icons.sports_gymnastics_rounded,
                        title: 'No trainers yet',
                        subtitle: 'Add trainers to manage your gym staff',
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: trainers.length,
                        itemBuilder: (context, index) {
                          final trainer = trainers[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: GlassCard(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => TrainerDetailsScreen(trainer: trainer),
                                  ),
                                );
                              },
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  // Avatar with gradient border
                                  Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: AppTheme.softGradient,
                                    ),
                                    child: CircleAvatar(
                                      radius: 26,
                                      backgroundColor: Colors.white,
                                      backgroundImage: trainer.photoUrl != null
                                          ? NetworkImage(trainer.photoUrl!)
                                          : null,
                                      child: trainer.photoUrl == null
                                          ? Text(
                                              trainer.name.isNotEmpty ? trainer.name[0].toUpperCase() : '?',
                                              style: AppTheme.titleMedium.copyWith(
                                                color: AppTheme.maroon,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            )
                                          : null,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  
                                  // Trainer info
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          trainer.name,
                                          style: AppTheme.titleSmall,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 6),
                                        Row(
                                          children: [
                                            _buildInfoChip(
                                              Icons.phone_rounded,
                                              trainer.contact,
                                            ),
                                            if (trainer.email.isNotEmpty) ...[
                                              const SizedBox(width: 12),
                                              _buildInfoChip(
                                                Icons.email_rounded,
                                                trainer.email.split('@').first,
                                              ),
                                            ],
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  
                                  // Arrow
                                  Icon(
                                    Icons.chevron_right_rounded,
                                    color: AppTheme.iconMuted,
                                    size: 24,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddTrainerScreen()),
          );
        },
        icon: const Icon(Icons.person_add_rounded, size: 22),
        label: const Text('Add Trainer'),
        backgroundColor: AppTheme.warmPink,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppTheme.iconMuted),
        const SizedBox(width: 4),
        Text(
          text,
          style: AppTheme.bodySmall,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

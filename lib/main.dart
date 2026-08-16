import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/crops/data/crops_local.dart';
import 'package:flutter_application_1/features/crops/domain/crop.dart';
import 'package:flutter_application_1/features/crops/domain/crop_state.dart';

void main() {
  runApp(const CropApp());
}

class CropApp extends StatelessWidget {
  const CropApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cultivos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.green,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F7F5),
      ),
      home: const CropsPage(),
    );
  }
}

class CropsPage extends StatefulWidget {
  const CropsPage({super.key});

  @override
  State<CropsPage> createState() => _CropsPageState();
}

class _CropsPageState extends State<CropsPage> {
  late final Future<List<Crop>> _crops = CropsLocal().getAll();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mis cultivos',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<List<Crop>>(
        future: _crops,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 56,
                      color: Colors.redAccent,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No se pudieron cargar los cultivos',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          final crops = snapshot.data ?? const <Crop>[];

          if (crops.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.agriculture_outlined,
                    size: 64,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No hay cultivos registrados.',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {});
              await _crops;
            },
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildHeader(crops),
                const SizedBox(height: 16),

                ...crops.map(
                  (crop) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: CropCard(crop: crop),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(List<Crop> crops) {
    final growing = crops.where((crop) => crop.state is Growing).length;
    final planned = crops.where((crop) => crop.state is Planned).length;
    final harvested = crops.where((crop) => crop.state is Harvested).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Resumen de cultivos',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${crops.length} cultivos registrados',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: SummaryCard(
                icon: Icons.event_note,
                label: 'Planeados',
                value: planned.toString(),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: SummaryCard(
                icon: Icons.grass,
                label: 'Creciendo',
                value: growing.toString(),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: SummaryCard(
                icon: Icons.check_circle_outline,
                label: 'Cosechados',
                value: harvested.toString(),
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        const Text(
          'Tus cultivos',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class SummaryCard extends StatelessWidget {
  const SummaryCard({
    required this.icon,
    required this.label,
    required this.value,
    super.key,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 8,
        ),
        child: Column(
          children: [
            Icon(icon, size: 25),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class CropCard extends StatelessWidget {
  const CropCard({
    required this.crop,
    super.key,
  });

  final Crop crop;

  @override
  Widget build(BuildContext context) {
    final status = _statusInfo(crop.state);

    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: status.backgroundColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    status.icon,
                    color: status.foregroundColor,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        crop.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _cropTypeName(crop.cropType),
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                StatusBadge(
                  label: status.label,
                  backgroundColor: status.backgroundColor,
                  foregroundColor: status.foregroundColor,
                ),
              ],
            ),

            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _InfoItem(
                    icon: Icons.calendar_today_outlined,
                    label: 'Cosecha estimada',
                    value: _formatDate(
                      crop.period.estimatedHarvestDate,
                    ),
                  ),
                ),
                Expanded(
                  child: _InfoItem(
                    icon: Icons.person_outline,
                    label: 'Responsable',
                    value: crop.responsibleId,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            _buildStateDetails(crop.state),
          ],
        ),
      ),
    );
  }

  Widget _buildStateDetails(CropState state) {
    return switch (state) {
      Planned(:final plannedDate) => _StateDetail(
        icon: Icons.event_available_outlined,
        title: 'Fecha planificada',
        value: _formatDate(plannedDate),
      ),

      Growing(
        :final lastInspection,
        :final observations,
      ) =>
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _StateDetail(
              icon: Icons.fact_check_outlined,
              title: 'Última inspección',
              value: _formatDate(lastInspection),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.notes_outlined,
                    size: 20,
                    color: Colors.green.shade700,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      observations,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

      Harvested(
        :final harvestDate,
        :final harvestedQuantityKg,
      ) =>
        Row(
          children: [
            Expanded(
              child: _InfoItem(
                icon: Icons.agriculture_outlined,
                label: 'Fecha de cosecha',
                value: _formatDate(harvestDate),
              ),
            ),
            Expanded(
              child: _InfoItem(
                icon: Icons.scale_outlined,
                label: 'Cantidad obtenida',
                value: '${_formatNumber(harvestedQuantityKg)} kg',
              ),
            ),
          ],
        ),
    };
  }

  String _cropTypeName(String type) {
    return switch (type.toLowerCase()) {
      'corn' => 'Maíz',
      'tomato' => 'Tomate',
      'cassava' => 'Yuca',
      _ => type,
    };
  }

  String _formatDate(DateTime date) {
    final local = date.toLocal();

    const months = [
      'ene',
      'feb',
      'mar',
      'abr',
      'may',
      'jun',
      'jul',
      'ago',
      'sep',
      'oct',
      'nov',
      'dic',
    ];

    return '${local.day} ${months[local.month - 1]} ${local.year}';
  }

  String _formatNumber(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }

    return value.toStringAsFixed(1);
  }

  _StatusInfo _statusInfo(CropState state) {
    return switch (state) {
      Planned() => const _StatusInfo(
        label: 'Planeado',
        icon: Icons.event_note_outlined,
        backgroundColor: Color(0xFFFFF3CD),
        foregroundColor: Color(0xFF856404),
      ),
      Growing() => const _StatusInfo(
        label: 'Creciendo',
        icon: Icons.grass,
        backgroundColor: Color(0xFFDFF3E4),
        foregroundColor: Color(0xFF287A3E),
      ),
      Harvested() => const _StatusInfo(
        label: 'Cosechado',
        icon: Icons.check_circle_outline,
        backgroundColor: Color(0xFFDDEBFF),
        foregroundColor: Color(0xFF245A9C),
      ),
    };
  }
}

class StatusBadge extends StatelessWidget {
  const StatusBadge({
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
    super.key,
  });

  final String label;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: foregroundColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.grey.shade600,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StateDetail extends StatelessWidget {
  const _StateDetail({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.grey.shade600,
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatusInfo {
  const _StatusInfo({
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final String label;
  final IconData icon;
  final Color backgroundColor;
  final Color foregroundColor;
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/wallet_provider.dart';
import '../../data/wallet_repository.dart';

class WalletScreen extends ConsumerWidget {
  const WalletScreen({super.key});

  // TODO: Get actual user ID from auth
  static const _userId = 'user_1';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final balanceState = ref.watch(balanceProvider(_userId));
    final transactionsState = ref.watch(transactionsProvider(_userId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallet'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(balanceProvider(_userId));
              ref.invalidate(transactionsProvider(_userId));
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onPressed: () async {
          ref.invalidate(balanceProvider(_userId));
          ref.invalidate(transactionsProvider(_userId));
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Balance card
            balanceState.when(
              data: (balance) => _BalanceCard(balance: balance),
              loading: () => const _LoadingBalanceCard(),
              error: (err, stack) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('Fehler: $err'),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {
                      _showDepositDialog(context);
                    },
                    icon: const Icon(Icons.arrow_downward),
                    label: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text('Einzahlen'),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _showWithdrawDialog(context);
                    },
                    icon: const Icon(Icons.arrow_upward),
                    label: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text('Auszahlen'),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.tonal(
                onPressed: () {
                  // TODO: Lightning-Adresse anzeigen
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Lightning-Adresse kopiert!'),
                    ),
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.bolt, size: 20),
                    SizedBox(width: 8),
                    Text('Lightning-Adresse anzeigen'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Quick stats (Static for now)
            Row(
              children: [
                Expanded(
                  child: _QuickStat(
                    label: 'Einnahmen\ndiesen Monat',
                    value: '+3.200',
                    icon: Icons.trending_up,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _QuickStat(
                    label: 'Ausgaben\ndiesen Monat',
                    value: '-1.800',
                    icon: Icons.trending_down,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Transaction history
            Text(
              'Transaktionen',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            transactionsState.when(
              data: (transactions) => transactions.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: Text('Noch keine Transaktionen'),
                      ),
                    )
                  : Column(
                      children: transactions
                          .map((t) => _TransactionTile(transaction: t))
                          .toList(),
                    ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Text('Fehler beim Laden: $err'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDepositDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Einzahlen'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Scanne den QR-Code oder kopiere die Lightning-Adresse, um Satoshi einzuzahlen.',
            ),
            const SizedBox(height: 16),
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Icon(Icons.qr_code, size: 120, color: Colors.black54),
              ),
            ),
            const SizedBox(height: 16),
            const SelectableText(
              'lnbc1p...xyz123',
              style: TextStyle(fontFamily: 'monospace', fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Schliessen'),
          ),
          FilledButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Adresse kopiert!')),
              );
            },
            icon: const Icon(Icons.copy),
            label: const Text('Kopieren'),
          ),
        ],
      ),
    );
  }

  void _showWithdrawDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Auszahlen'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Gib die Menge und die Lightning-Adresse ein, um Satoshi auszuzahlen.',
            ),
            const SizedBox(height: 16),
            const TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Betrag (Sats)',
                hintText: 'z.B. 1000',
                prefixIcon: Icon(Icons.toll),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Lightning-Adresse',
                hintText: 'lnbc1p...',
                prefixIcon: Icon(Icons.bolt),
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Auszahlung wird bearbeitet...'),
                ),
              );
            },
            child: const Text('Auszahlen'),
          ),
        ],
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  final int balance;

  const _BalanceCard({required this.balance});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final numberFormat = NumberFormat('#,###', 'de_DE');
    
    // Simple conversion for UI (placeholder)
    final eurValue = (balance * 0.00034).toStringAsFixed(2);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primary,
              theme.colorScheme.tertiary,
            ],
          ),
        ),
        child: Column(
          children: [
            Text(
              'Guthaben',
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.toll,
                  color: Colors.white,
                  size: 32,
                ),
                const SizedBox(width: 8),
                Text(
                  numberFormat.format(balance),
                  style: theme.textTheme.displaySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Satoshi',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '\u2248 $eurValue EUR',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.white54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingBalanceCard extends StatelessWidget {
  const _LoadingBalanceCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: 160,
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        child: const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class _QuickStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _QuickStat({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final Transaction transaction;

  const _TransactionTile({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final numberFormat = NumberFormat('#,###', 'de_DE');
    final dateFormat = DateFormat('dd. MMM, HH:mm', 'de_DE');

    final icon = _getIcon(transaction.title);
    final iconColor = _getColor(transaction.title);

    return Card(
      margin: const EdgeInsets.only(bottom: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: iconColor.withValues(alpha: 0.15),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        title: Text(
          transaction.title,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          dateFormat.format(transaction.timestamp),
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        trailing: Text(
          '${transaction.isPositive ? '+' : '-'}${numberFormat.format(transaction.amount)} Sats',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: transaction.isPositive ? Colors.green : Colors.red,
          ),
        ),
      ),
    );
  }

  IconData _getIcon(String title) {
    if (title.contains('gefüttert')) return Icons.restaurant;
    if (title.contains('gespielt')) return Icons.sports_esports;
    if (title.contains('gewaschen')) return Icons.shower;
    if (title.contains('trainiert')) return Icons.fitness_center;
    if (title.contains('Sieg')) return Icons.shield;
    if (title.contains('Gewinn')) return Icons.emoji_events;
    if (title.contains('Einkauf')) return Icons.shopping_bag;
    return Icons.toll;
  }

  Color _getColor(String title) {
    if (title.contains('gefüttert')) return Colors.orange;
    if (title.contains('gespielt')) return Colors.pink;
    if (title.contains('gewaschen')) return Colors.blue;
    if (title.contains('trainiert')) return Colors.green;
    if (title.contains('Sieg')) return Colors.blue;
    if (title.contains('Gewinn')) return Colors.amber;
    if (title.contains('Einkauf')) return Colors.orange;
    return Colors.grey;
  }
}

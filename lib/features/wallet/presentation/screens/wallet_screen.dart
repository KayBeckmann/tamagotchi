import 'package:flutter/material.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallet'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Balance card
          Card(
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
                        '12.500',
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
                    '\u2248 4,25 EUR',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white54,
                    ),
                  ),
                ],
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

          // Quick stats
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
          const _TransactionTile(
            title: 'Turnier-Gewinn',
            subtitle: 'Wochenend-Duell · 3. Platz',
            amount: '+2.500',
            isPositive: true,
            icon: Icons.emoji_events,
            iconColor: Colors.amber,
            date: 'Heute, 14:23',
          ),
          const _TransactionTile(
            title: 'Shop-Einkauf',
            subtitle: 'Goldener Apfel',
            amount: '-1.000',
            isPositive: false,
            icon: Icons.shopping_bag,
            iconColor: Colors.orange,
            date: 'Heute, 10:15',
          ),
          const _TransactionTile(
            title: 'Arena-Sieg',
            subtitle: 'vs. Spieler_42',
            amount: '+500',
            isPositive: true,
            icon: Icons.shield,
            iconColor: Colors.blue,
            date: 'Gestern, 20:45',
          ),
          const _TransactionTile(
            title: 'Einzahlung',
            subtitle: 'Lightning Network',
            amount: '+5.000',
            isPositive: true,
            icon: Icons.bolt,
            iconColor: Colors.purple,
            date: 'Gestern, 18:00',
          ),
          const _TransactionTile(
            title: 'Shop-Einkauf',
            subtitle: 'Heiltrank x3',
            amount: '-300',
            isPositive: false,
            icon: Icons.shopping_bag,
            iconColor: Colors.orange,
            date: '30. Maerz, 09:30',
          ),
          const _TransactionTile(
            title: 'Turnier-Eintritt',
            subtitle: 'Wochenend-Duell',
            amount: '-500',
            isPositive: false,
            icon: Icons.confirmation_number,
            iconColor: Colors.red,
            date: '29. Maerz, 15:00',
          ),
          const _TransactionTile(
            title: 'Handelsgewinn',
            subtitle: 'Verkauf: Zauberstab',
            amount: '+1.200',
            isPositive: true,
            icon: Icons.swap_horiz,
            iconColor: Colors.teal,
            date: '28. Maerz, 11:20',
          ),
        ],
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
  final String title;
  final String subtitle;
  final String amount;
  final bool isPositive;
  final IconData icon;
  final Color iconColor;
  final String date;

  const _TransactionTile({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.isPositive,
    required this.icon,
    required this.iconColor,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: iconColor.withValues(alpha: 0.15),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        title: Text(
          title,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          '$subtitle\n$date',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        isThreeLine: true,
        trailing: Text(
          '$amount Sats',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: isPositive ? Colors.green : Colors.red,
          ),
        ),
      ),
    );
  }
}

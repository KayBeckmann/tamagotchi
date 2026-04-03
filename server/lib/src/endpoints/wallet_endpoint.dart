import 'package:serverpod/serverpod.dart';

/// Bitcoin wallet and transaction management endpoint.
///
/// Handles:
/// - Balance and address management
/// - Deposits (Lightning invoice generation)
/// - Withdrawals
/// - Transaction history
class WalletEndpoint extends Endpoint {
  /// Get wallet overview.
  Future<WalletInfo> getWallet(Session session) async {
    // TODO: Implement wallet info retrieval
    throw UnimplementedError('Get wallet not yet implemented');
  }

  /// Generate a Lightning invoice for deposit.
  Future<DepositInvoice> createDepositInvoice(
    Session session, {
    required int amountSatoshis,
    String? memo,
  }) async {
    // TODO: Implement invoice generation via BTCPay/LND
    // 1. Validate amount (minimum/maximum)
    // 2. Generate Lightning invoice via BTCPay Server
    // 3. Store invoice in database
    // 4. Return invoice data
    throw UnimplementedError('Create deposit invoice not yet implemented');
  }

  /// Check status of a deposit invoice.
  Future<InvoiceStatus> checkInvoiceStatus(
    Session session, {
    required String paymentHash,
  }) async {
    // TODO: Implement invoice status check
    // Query BTCPay Server for payment status
    throw UnimplementedError('Check invoice status not yet implemented');
  }

  /// Request a withdrawal.
  Future<WithdrawalRequest> requestWithdrawal(
    Session session, {
    required int amountSatoshis,
    required String lightningAddress, // LNURL or Lightning Address
  }) async {
    // TODO: Implement withdrawal request
    // 1. Validate amount and address
    // 2. Check user balance
    // 3. Check withdrawal limits
    // 4. Create pending withdrawal
    // 5. Queue for processing
    throw UnimplementedError('Request withdrawal not yet implemented');
  }

  /// Cancel a pending withdrawal.
  Future<void> cancelWithdrawal(
    Session session, {
    required int withdrawalId,
  }) async {
    // TODO: Implement withdrawal cancellation
    // Only possible if still pending
    throw UnimplementedError('Cancel withdrawal not yet implemented');
  }

  /// Get transaction history.
  Future<List<TransactionEntry>> getTransactionHistory(
    Session session, {
    String? type, // Filter by type
    int limit = 50,
    int offset = 0,
  }) async {
    // TODO: Implement transaction history retrieval
    throw UnimplementedError('Get transaction history not yet implemented');
  }

  /// Get specific transaction details.
  Future<TransactionDetail> getTransaction(
    Session session, {
    required int transactionId,
  }) async {
    // TODO: Implement transaction detail retrieval
    throw UnimplementedError('Get transaction not yet implemented');
  }
}

/// Wallet overview information.
class WalletInfo {
  final int balanceSatoshis;
  final double balanceBtc;
  final int pendingDeposits;
  final int pendingWithdrawals;
  final int totalEarned;
  final int totalSpent;
  final int totalDeposited;
  final int totalWithdrawn;

  WalletInfo({
    required this.balanceSatoshis,
    required this.balanceBtc,
    required this.pendingDeposits,
    required this.pendingWithdrawals,
    required this.totalEarned,
    required this.totalSpent,
    required this.totalDeposited,
    required this.totalWithdrawn,
  });
}

/// Lightning deposit invoice.
class DepositInvoice {
  final String paymentRequest; // BOLT11 invoice
  final String paymentHash;
  final int amountSatoshis;
  final DateTime expiresAt;
  final String? qrCodeUrl;

  DepositInvoice({
    required this.paymentRequest,
    required this.paymentHash,
    required this.amountSatoshis,
    required this.expiresAt,
    this.qrCodeUrl,
  });
}

/// Invoice payment status.
class InvoiceStatus {
  final String paymentHash;
  final String status; // 'pending', 'paid', 'expired'
  final int amountSatoshis;
  final DateTime? paidAt;
  final int? newBalance;

  InvoiceStatus({
    required this.paymentHash,
    required this.status,
    required this.amountSatoshis,
    this.paidAt,
    this.newBalance,
  });
}

/// Withdrawal request result.
class WithdrawalRequest {
  final int withdrawalId;
  final String status; // 'pending', 'processing', 'completed', 'failed'
  final int amountSatoshis;
  final int feeSatoshis;
  final int totalDeducted;
  final int newBalance;
  final String message;

  WithdrawalRequest({
    required this.withdrawalId,
    required this.status,
    required this.amountSatoshis,
    required this.feeSatoshis,
    required this.totalDeducted,
    required this.newBalance,
    required this.message,
  });
}

/// Transaction history entry.
class TransactionEntry {
  final int id;
  final String type;
  final int amountSatoshis;
  final int balanceAfter;
  final String status;
  final String description;
  final DateTime createdAt;

  TransactionEntry({
    required this.id,
    required this.type,
    required this.amountSatoshis,
    required this.balanceAfter,
    required this.status,
    required this.description,
    required this.createdAt,
  });
}

/// Detailed transaction information.
class TransactionDetail {
  final int id;
  final String type;
  final int amountSatoshis;
  final int balanceAfter;
  final String status;
  final String description;
  final DateTime createdAt;
  final DateTime? confirmedAt;
  // Bitcoin specific
  final String? btcAddress;
  final String? btcTxId;
  final String? lightningInvoice;
  final String? lightningPaymentHash;
  final int? confirmations;
  // Reference
  final String? referenceType;
  final int? referenceId;

  TransactionDetail({
    required this.id,
    required this.type,
    required this.amountSatoshis,
    required this.balanceAfter,
    required this.status,
    required this.description,
    required this.createdAt,
    this.confirmedAt,
    this.btcAddress,
    this.btcTxId,
    this.lightningInvoice,
    this.lightningPaymentHash,
    this.confirmations,
    this.referenceType,
    this.referenceId,
  });
}

/// Central registry for every API endpoint path.
///
/// Change URLs here only — all services call through [ApiClient] using these paths.
/// Base URL is configured in [ApiConfig.baseUrl].
class ApiEndpoints {
  ApiEndpoints._();

  // ─── Agency Banking ────────────────────────────────────────────────────────
  static const agency = _AgencyEndpoints();

  // ─── Merchant Banking (add endpoints here as they are integrated) ──────────
  // static const merchant = _MerchantEndpoints();

  // ─── Smart Branch (add endpoints here as they are integrated) ──────────────
  // static const smartBranch = _SmartBranchEndpoints();
}

class _AgencyEndpoints {
  const _AgencyEndpoints();

  static const _agencyBase =
      '/autoAPIGenerator/plx/api/gen/c4940473-99d0-4981-aab1-2e689791b143';

  /// Agent login
  String get login => '$_agencyBase/agent/login';

  // Add new agency endpoints below, e.g.:
  // String get cashDeposit => '$_agencyBase/agent/cash-deposit';
  // String get balanceEnquiry => '$_agencyBase/agent/balance-enquiry';
}

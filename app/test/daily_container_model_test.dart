import 'package:flutter_test/flutter_test.dart';
import 'package:app/features/auth/data/models/daily_container_model.dart';

void main() {
  group('DailyContainerModel', () {
    test('parses API payload into a usable model', () {
      final model = DailyContainerModel.fromJson({
        'actionDate': '2026-07-19T00:00:00Z',
        'actionDay': 'Sunday',
        'recvdQty': 12,
        'shippedQty': 8,
      });

      expect(model.actionDate, isNotNull);
      expect(model.actionDay, 'Sunday');
      expect(model.recvdQty, 12.0);
      expect(model.shippedQty, 8.0);
    });
  });
}

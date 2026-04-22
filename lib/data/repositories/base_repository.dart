abstract class BaseRepository {
  List<Map<String, dynamic>> extractListPayload(dynamic response) {
    if (response == null) return [];

    if (response is List) {
      return response.cast<Map<String, dynamic>>();
    }

    if (response is Map && response.containsKey('data')) {
      final data = response['data'];
      if (data is List) {
        return data.cast<Map<String, dynamic>>();
      }
    }

    if (response is Map && response.containsKey('items')) {
      final items = response['items'];
      if (items is List) {
        return items.cast<Map<String, dynamic>>();
      }
    }

    return [];
  }

  Map<String, dynamic> extractMapPayload(Map<String, dynamic> response) {
    if (response.containsKey('data') && response['data'] is Map) {
      return response['data'] as Map<String, dynamic>;
    }
    return response;
  }
}

enum RequestType { connection, community, link }

class RequestModel {
  final String id;
  final String name;
  final String avatar;
  final RequestType type;
  final String? communityName;
  final String message;
  final int daysAgo;

  RequestModel({
    required this.id,
    required this.name,
    required this.avatar,
    required this.type,
    this.communityName,
    required this.message,
    required this.daysAgo,
  });
}

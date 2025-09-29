import 'package:flutter_cache_manager/flutter_cache_manager.dart';

final appCacheManager = CacheManager(
  Config(
    'customCacheKey',
    stalePeriod: const Duration(days: 7),
    maxNrOfCacheObjects: 200,
    repo: JsonCacheInfoRepository(databaseName: 'customCache'),
    fileService: HttpFileService(),
  ),
);

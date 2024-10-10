import 'dart:io';

class TestSpeedInfo {
  final String domain;
  final int time;

  TestSpeedInfo({
    required this.domain,
    required this.time,
  });

  Future<Duration> downloadImg({required String domain}) async {
    String baseUrl = 'https://{$domain}/test-img';

    final client = HttpClient();
    Stopwatch watcher = Stopwatch()..start();
    final request = await client.getUrl(Uri.parse(baseUrl));
    await request.close().timeout(const Duration(seconds: 2));
    watcher.stop();
    client.close();
    return watcher.elapsed;
  }

  List<TestSpeedInfo> setTestSpeedResultByDomain({
    required List<TestSpeedInfo> speedResultList,
    required String domain,
    required Duration time,
  }) {
    int indexOfResult =
        speedResultList.indexWhere((element) => element.domain == domain);

    if (indexOfResult == -1) {
      speedResultList.add(TestSpeedInfo(
        domain: domain,
        time: time.inMicroseconds,
      ));
    } else {
      speedResultList[indexOfResult] =
          speedResultList[indexOfResult].copyWith(time: time.inMicroseconds);
    }

    speedResultList.sort((a, b) => a.time.compareTo(b.time));

    return speedResultList;
  }

  int getTestSpeedResultByDomain({
    required List<TestSpeedInfo> speedResultList,
    required String domain,
  }) {
    return speedResultList
        .firstWhere((element) => element.domain == domain)
        .time;
  }

  TestSpeedInfo copyWith({
    String? domain,
    int? time,
  }) {
    return TestSpeedInfo(
      domain: domain ?? this.domain,
      time: time ?? this.time,
    );
  }
}

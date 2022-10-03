import 'dart:async';
import 'dart:developer';

import 'package:laravel_echo/laravel_echo.dart';
import 'package:laravel_flutter_pusher/laravel_flutter_pusher.dart';
import 'package:mysocial_app/core/cache/local_cache.dart';

class SocketService {
  final LocalCache _localCache;
  SocketService(this._localCache);

  Echo _echo;
  LaravelFlutterPusher _pusherClient;
  final String _socketHost = '127.0.0.1';
  final int _socketPort = 6001;
  final String _authEndpoint = "http://127.0.0.1:8000/api/broadcasting/auth";
  Future<LaravelFlutterPusher> _getPusherClient() async {
    var user = await _localCache.fetch('USER');
    PusherOptions options = PusherOptions(
      host: _socketHost,
      port: _socketPort,
      cluster: 'mt1',
      encrypted: false,
      auth: PusherAuth(
        _authEndpoint,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${user['token']}'
        },
      ),
    );
    return LaravelFlutterPusher(
      'ABCDEF',
      options,
      enableLogging: true,
      lazyConnect: true,
      onConnectionStateChange: (state) {
        log(state.currentState);
      },
      onError: (error) {
        log(error.exception);
      },
    );
  }

  Future<Echo> _echoSetup({LaravelFlutterPusher client}) async {
    var user = await _localCache.fetch('USER');
    return Echo({
      'broadcaster': 'pusher',
      'client': client,
      "wsHost": _socketHost,
      "httpHost": _socketHost,
      "wsPort": _socketPort,
      'auth': {
        "headers": {'Authorization': 'Bearer ${user['token']}'}
      },
      'authEndpoint': _authEndpoint,
      "disableStats": true,
      "forceTLS": false,
      "enabledTransports": ['ws', 'wss'],
      'transports': ['websocket', 'polling', 'flashsocket'],
      'disabledTransports': ['sockjs', 'xhr_polling', 'xhr_streaming']
    });
  }

  Future connect() async {
    _pusherClient = await _getPusherClient();
    _pusherClient.connect();
    _echo = await _echoSetup(client: _pusherClient);
    _echo.connect();
  }

  Future disconnect() async {
    _pusherClient.disconnect();
    _echo.disconnect();
  }

  Future goOnline() async {
    _echo.join('online-channel').here(
      (users) {
        log(users.toString());
      },
    ).joining(
      (user) {
        log(user.toString());
      },
    ).leaving(
      (user) {
        log(user.toString());
      },
    ).listen(
      '.OnlineStatus',
      (e) => {log(e.toString())},
    );
  }

  Future<void> goOffline() async {
    _echo.leave('online-channel');
  }

  Echo get streamEvent {
    return _echo;
  }
}

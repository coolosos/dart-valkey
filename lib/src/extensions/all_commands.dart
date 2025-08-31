import 'dart:async';

import '../client/valkey_client.dart';
import '../commands/commands.dart';

/// Extends [ValkeyCommandClient] with all commands.
extension ValkeyCommands on ValkeyCommandClient {
  // Connection
  Future<String> ping([String? message]) => execute(PingCommand(message));
  Future<String> echo(String message) => execute(EchoCommand(message));
  Future<String?> clientGetname() => execute(ClientGetnameCommand());
  Future<int> clientId() => execute(ClientIdCommand());
  Future<String> clientHelp() => execute(ClientHelpCommand());
  Future<String> auth({required String password, String? username}) =>
      execute(AuthCommand(username: username, password: password));
  Future<String> clientSetname(String name) =>
      execute(ClientSetnameCommand(name));
  Future<void> quit() async {
    try {
      await execute(QuitCommand());
    } finally {
      close();
    }
  }

  Future<String> reset() => execute(ResetCommand());
  Future<String> clientCaching(bool enable) =>
      execute(ClientCachingCommand(enable));
  Future<int> clientGetredir() => execute(ClientGetredirCommand());
  Future<String> clientNoEvict(bool enable) =>
      execute(ClientNoEvictCommand(enable));
  Future<String> clientNoTouch(bool enable) =>
      execute(ClientNoTouchCommand(enable));
  Future<int> clientUnblock(int clientId, {UnblockType? unblockType}) =>
      execute(ClientUnblockCommand(clientId, unblockType: unblockType));
  Future<String> clientUnpause() => execute(ClientUnpauseCommand());
  Future<Map<String, dynamic>> hello({
    int? protocolVersion,
    String? username,
    String? password,
    String? clientName,
  }) =>
      execute(
        HelloCommand(
          protocolVersion: protocolVersion,
          username: username,
          password: password,
          clientName: clientName,
        ),
      );

  // Hashes
  Future<int> hset(String key, Map<String, Object> fields) =>
      execute(HSetCommand(key, fields));
  Future<String?> hget(String key, String field) =>
      execute(HGetCommand(key, field));
  Future<Map<String, String>> hgetall(String key) =>
      execute(HGetAllCommand(key));
  Future<int> hdel(String key, List<String> fields) =>
      execute(HDelCommand(key, fields));
  Future<bool> hexists(String key, String field) =>
      execute(HExistsCommand(key, field));
  Future<int> hincrby(String key, String field, int increment) =>
      execute(HIncrByCommand(key, field, increment));
  Future<int> hlen(String key) => execute(HLenCommand(key));
  Future<List<String?>> hmget(String key, List<String> fields) =>
      execute(HMGetCommand(key, fields));
  Future<bool> hsetnx(String key, String field, String value) =>
      execute(HSetNxCommand(key, field, value));
  Future<List<String>> hkeys(String key) => execute(HKeysCommand(key));
  Future<List<String>> hvals(String key) => execute(HValsCommand(key));
  Future<double> hincrbyfloat(String key, String field, double increment) =>
      execute(HIncrByFloatCommand(key, field, increment));
  Future<int> hstrlen(String key, String field) =>
      execute(HStrLenCommand(key, field));

  // Keys
  Future<int> del(List<String> keys) => execute(DelCommand(keys));
  Future<int> exists(List<String> keys) => execute(ExistsCommand(keys));
  Future<int> ttl(String key) => execute(TtlCommand(key));
  Future<bool> persist(String key) => execute(PersistCommand(key));
  Future<String> type(String key) => execute(TypeCommand(key));
  Future<bool> rename(String key, String newKey) =>
      execute(RenameCommand(key, newKey));
  Future<bool> renamenx(String key, String newKey) =>
      execute(RenameNxCommand(key, newKey));
  Future<bool> expire(
    String key,
    int seconds, {
    bool nx = false,
    bool xx = false,
    bool gt = false,
    bool lt = false,
  }) =>
      execute(ExpireCommand(key, seconds, nx: nx, xx: xx, gt: gt, lt: lt));

  // Lists
  Future<int> lpush(String key, List<String> values) =>
      execute(LPushCommand(key, values));
  Future<int> rpush(String key, List<String> values) =>
      execute(RPushCommand(key, values));
  Future<dynamic> lpop(String key, [int? count]) =>
      execute(LPopCommand(key, count));
  Future<dynamic> rpop(String key, [int? count]) =>
      execute(RPopCommand(key, count));
  Future<int> llen(String key) => execute(LLenCommand(key));
  Future<List<String>> lrange(String key, int start, int stop) =>
      execute(LRangeCommand(key, start, stop));
  Future<String?> lindex(String key, int index) =>
      execute(LIndexCommand(key, index));
  Future<bool> ltrim(String key, int start, int stop) =>
      execute(LTrimCommand(key, start, stop));
  Future<int> linsert(
    String key,
    bool before,
    String pivot,
    String value,
  ) =>
      execute(LInsertCommand(key, before, pivot, value));
  Future<int> lrem(String key, int count, String value) =>
      execute(LRemCommand(key, count, value));
  Future<String?> rpoplpush(String source, String destination) =>
      execute(RPopLPushCommand(source, destination));

  // Sets
  Future<int> sadd(String key, List<String> members) =>
      execute(SAddCommand(key, members));
  Future<int> srem(String key, List<String> members) =>
      execute(SRemCommand(key, members));
  Future<bool> sismember(String key, String member) =>
      execute(SIsMemberCommand(key, member));
  Future<int> scard(String key) => execute(SCardCommand(key));
  Future<List<String>> smembers(String key) => execute(SMembersCommand(key));
  Future<String?> srandmember(String key) => execute(SRandMemberCommand(key));
  Future<List<String>> srandmemberCount(String key, int count) =>
      execute(SRandMemberCountCommand(key, count));
  Future<String?> spop(String key) => execute(SPopCommand(key));
  Future<List<String>> spopCount(String key, int count) =>
      execute(SPopCountCommand(key, count));
  Future<List<String>> sunion(List<String> keys) =>
      execute(SUnionCommand(keys));
  Future<List<String>> sinter(List<String> keys) =>
      execute(SInterCommand(keys));
  Future<List<String>> sdiff(List<String> keys) => execute(SDiffCommand(keys));
  Future<bool> smove(String source, String destination, String member) =>
      execute(SMoveCommand(source, destination, member));
  Future<int> sunionstore(String destination, List<String> keys) =>
      execute(SUnionStoreCommand(destination, keys));
  Future<int> sinterstore(String destination, List<String> keys) =>
      execute(SInterStoreCommand(destination, keys));
  Future<int> sdiffstore(String destination, List<String> keys) =>
      execute(SDiffStoreCommand(destination, keys));

  // Strings
  Future<String?> get(String key) => execute(GetCommand(key));
  Future<String?> set(
    String key,
    String value, {
    Duration? expire,
    DateTime? expireAt,
    bool keepTtl = false,
    bool onlyIfNotExists = false,
    bool onlyIfExists = false,
  }) =>
      execute(
        SetCommand(
          key,
          value,
          expire: expire,
          expireAt: expireAt,
          keepTtl: keepTtl,
          onlyIfNotExists: onlyIfNotExists,
          onlyIfExists: onlyIfExists,
        ),
      );
  Future<String?> setAndGet(String key, String value) =>
      execute(SetAndGetCommand(key, value));
  Future<int> incr(String key) => execute(IncrCommand(key));
  Future<int> decr(String key) => execute(DecrCommand(key));
  Future<int> decrby(String key, int decrement) =>
      execute(DecrByCommand(key, decrement));
  Future<int> incrby(String key, int increment) =>
      execute(IncrByCommand(key, increment));
  Future<List<String?>> mget(List<String> keys) => execute(MGetCommand(keys));
  Future<String> mset(Map<String, String> keyValuePairs) =>
      execute(MSetCommand(keyValuePairs));
  Future<int> append(String key, String value) =>
      execute(AppendCommand(key, value));
  Future<String> getrange(String key, int start, int end) =>
      execute(GetRangeCommand(key, start, end));
  Future<int> setrange(String key, int offset, String value) =>
      execute(SetRangeCommand(key, offset, value));
  Future<String?> getset(String key, String value) =>
      execute(GetSetCommand(key, value));
  Future<int> strlen(String key) => execute(StrLenCommand(key));

  // ZSets
  Future<dynamic> zadd(
    String key,
    Map<String, double> membersWithScores, {
    bool onlyIfNotExists = false,
    bool onlyIfAlreadyExists = false,
    bool changed = false,
    bool incr = false,
  }) =>
      execute(
        ZAddCommand(
          key,
          membersWithScores,
          onlyIfNotExists: onlyIfNotExists,
          onlyIfAlreadyExists: onlyIfAlreadyExists,
          changed: changed,
          incr: incr,
        ),
      );
  Future<dynamic> zrange(
    String key,
    String start,
    String stop, {
    bool byLex = false,
    bool byScore = false,
    bool rev = false,
    int? limitOffset,
    int? limitCount,
    bool withScores = false,
  }) =>
      execute(
        ZRangeCommand(
          key,
          start,
          stop,
          byLex: byLex,
          byScore: byScore,
          rev: rev,
          limitOffset: limitOffset,
          limitCount: limitCount,
          withScores: withScores,
        ),
      );
  Future<List> zrangeWithScores(
    String key,
    String start,
    String stop, {
    bool byLex = false,
    bool byScore = false,
    bool rev = false,
    int? limitOffset,
    int? limitCount,
  }) =>
      execute(
        ZRangeCommand(
          key,
          start,
          stop,
          byLex: byLex,
          byScore: byScore,
          rev: rev,
          limitOffset: limitOffset,
          limitCount: limitCount,
          withScores: true,
        ),
      );
  Future<dynamic> zrangebyscore(
    String key,
    String min,
    String max, {
    bool withScores = false,
    int? limitOffset,
    int? limitCount,
  }) =>
      execute(
        ZRangeByScoreCommand(
          key,
          min,
          max,
          withScores: withScores,
          limitOffset: limitOffset,
          limitCount: limitCount,
        ),
      );
  Future<List> zrangebyscoreWithScores(
    String key,
    String min,
    String max, {
    int? limitOffset,
    int? limitCount,
  }) =>
      execute(
        ZRangeByScoreWithScoresCommand(
          key,
          min,
          max,
          limitOffset: limitOffset,
          limitCount: limitCount,
        ),
      );
  Future<int> zrem(String key, List<String> members) =>
      execute(ZRemCommand(key, members));
  Future<int> zcard(String key) => execute(ZCardCommand(key));
  Future<double?> zscore(String key, String member) =>
      execute(ZScoreCommand(key, member));
  Future<double> zincrby(String key, double increment, String member) =>
      execute(ZIncrByCommand(key, increment, member));
  Future<int> zcount(String key, String min, String max) =>
      execute(ZCountCommand(key, min, max));
  Future<int?> zrank(String key, String member) =>
      execute(ZRankCommand(key, member));
  Future<int?> zrevrank(String key, String member) =>
      execute(ZRevRankCommand(key, member));
  Future<dynamic> zrevrange(
    String key,
    String start,
    String stop, {
    bool byLex = false,
    bool byScore = false,
    int? limitOffset,
    int? limitCount,
    bool withScores = false,
  }) =>
      execute(
        ZRevRangeCommand(
          key,
          start,
          stop,
          byLex: byLex,
          byScore: byScore,
          limitOffset: limitOffset,
          limitCount: limitCount,
          withScores: withScores,
        ),
      );
  Future<List> zrevrangeWithScores(
    String key,
    String start,
    String stop, {
    bool byLex = false,
    bool byScore = false,
    int? limitOffset,
    int? limitCount,
  }) =>
      execute(
        ZRevRangeCommand(
          key,
          start,
          stop,
          byLex: byLex,
          byScore: byScore,
          limitOffset: limitOffset,
          limitCount: limitCount,
          withScores: true,
        ),
      );
  Future<dynamic> zrevrangebyscore(
    String key,
    String max,
    String min, {
    bool withScores = false,
    int? limitOffset,
    int? limitCount,
  }) =>
      execute(
        ZRevRangeByScoreCommand(
          key,
          max,
          min,
          withScores: withScores,
          limitOffset: limitOffset,
          limitCount: limitCount,
        ),
      );
  Future<List> zrevrangebyscoreWithScores(
    String key,
    String max,
    String min, {
    int? limitOffset,
    int? limitCount,
  }) =>
      execute(
        ZRevRangeByScoreWithScoresCommand(
          key,
          max,
          min,
          limitOffset: limitOffset,
          limitCount: limitCount,
        ),
      );

  // Pub/Sub
  /// Posts a [message] to a given [channel].
  ///
  /// Returns a [Future] that completes with the number of clients that received the message.
  Future<int> publish(String channel, String message) =>
      execute(PublishCommand(channel, message));

  /// Lists the currently active channels.
  ///
  /// Optionally a [pattern] can be specified to match channel names.
  Future<List<String>> pubsubChannels([String? pattern]) =>
      execute(PubsubChannelsCommand(pattern));

  /// Returns the number of subscriptions to patterns.
  Future<int> pubsubNumpat() => execute(PubsubNumpatCommand());

  /// Returns the number of subscribers for the specified channels.
  Future<Map<String, int>> pubsubNumsub([List<String> channels = const []]) =>
      execute(PubsubNumsubCommand(channels));

  /// Returns the help text for the PUBSUB command.
  Future<List<String>> pubsubHelp() => execute(PubsubHelpCommand());

  /// Posts a message to a shard channel.
  Future<int> spublish(String channel, String message) =>
      execute(SpublishCommand(channel, message));

  /// Lists the currently active shard channels.
  Future<List<String>> pubsubShardChannels([String? pattern]) =>
      execute(PubsubShardchannelsCommand(pattern));

  /// Returns the number of subscribers for the specified shard channels.
  Future<Map<String, int>> pubsubShardNumsub([
    List<String> channels = const [],
  ]) =>
      execute(PubsubShardnumsubCommand(channels));
}

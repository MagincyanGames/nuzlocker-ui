import 'package:json_annotation/json_annotation.dart';
import 'package:collection/collection.dart';

enum CreateBattleDtoStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('scheduled')
  scheduled('scheduled'),
  @JsonValue('completed')
  completed('completed'),
  @JsonValue('canceled')
  canceled('canceled');

  final String? value;

  const CreateBattleDtoStatus(this.value);
}

enum EnrichedBattleResponseDtoStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('scheduled')
  scheduled('scheduled'),
  @JsonValue('completed')
  completed('completed'),
  @JsonValue('canceled')
  canceled('canceled');

  final String? value;

  const EnrichedBattleResponseDtoStatus(this.value);
}

enum UpdateBattleDtoStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('scheduled')
  scheduled('scheduled'),
  @JsonValue('completed')
  completed('completed'),
  @JsonValue('canceled')
  canceled('canceled');

  final String? value;

  const UpdateBattleDtoStatus(this.value);
}

enum ApiLockesGetActive {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('true')
  $true('true'),
  @JsonValue('false')
  $false('false');

  final String? value;

  const ApiLockesGetActive(this.value);
}

enum ApiLockesUserUserIdGetIncludeParticipating {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('true')
  $true('true'),
  @JsonValue('false')
  $false('false');

  final String? value;

  const ApiLockesUserUserIdGetIncludeParticipating(this.value);
}

enum ApiLockesUserUserIdGetActive {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('true')
  $true('true'),
  @JsonValue('false')
  $false('false');

  final String? value;

  const ApiLockesUserUserIdGetActive(this.value);
}

enum ApiLockesMyLockesGetIncludeParticipating {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('true')
  $true('true'),
  @JsonValue('false')
  $false('false');

  final String? value;

  const ApiLockesMyLockesGetIncludeParticipating(this.value);
}

enum ApiLockesMyLockesGetActive {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('true')
  $true('true'),
  @JsonValue('false')
  $false('false');

  final String? value;

  const ApiLockesMyLockesGetActive(this.value);
}

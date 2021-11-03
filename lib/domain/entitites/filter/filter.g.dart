// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Filter _$FilterFromJson(Map<String, dynamic> json) {
  return Filter(
    connector: _$enumDecodeNullable(_$ConnectorTypesEnumMap, json['connector']),
    voltage: _$enumDecodeNullable(_$VoltageTypesEnumMap, json['voltage']),
    availability: json['availability'] as bool,
  );
}

Map<String, dynamic> _$FilterToJson(Filter instance) => <String, dynamic>{
      'availability': instance.availability,
      'voltage': _$VoltageTypesEnumMap[instance.voltage],
      'connector': _$ConnectorTypesEnumMap[instance.connector],
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

K? _$enumDecodeNullable<K, V>(
  Map<K, V> enumValues,
  dynamic source, {
  K? unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<K, V>(enumValues, source, unknownValue: unknownValue);
}

const _$ConnectorTypesEnumMap = {
  ConnectorTypes.CHADEMO: 'chademo',
  ConnectorTypes.TYPE2: 'type2',
};

const _$VoltageTypesEnumMap = {
  VoltageTypes.AC7: '7ac',
  VoltageTypes.AC22: '22ac',
  VoltageTypes.DC50: '50dc',
  VoltageTypes.DC80: '80dc',
  VoltageTypes.DC90: '90dc',
  VoltageTypes.DC120: '120dc',
  VoltageTypes.DC150: '150dc',
  VoltageTypes.DC180: '180dc',
};

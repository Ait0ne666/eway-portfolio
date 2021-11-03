import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:lseway/domain/entitites/coordinates/coordinates.dart';

part 'filter.g.dart';



enum ConnectorTypes {
  @JsonValue('chademo') CHADEMO,
  @JsonValue('type2') TYPE2
}

String mapConnectorTypesToString(ConnectorTypes type) {
  switch(type){
    case ConnectorTypes.CHADEMO:
      return 'CHAdeMO';
    case ConnectorTypes.TYPE2:
      return 'type2';
  }
}

enum VoltageTypes {
  @JsonValue('7ac') AC7,
  @JsonValue('22ac') AC22,
  
  @JsonValue('50dc')  DC50,
  @JsonValue('80dc') DC80,
  @JsonValue('90dc') DC90,
  @JsonValue('120dc') DC120,
  @JsonValue('150dc') DC150,
  @JsonValue('180dc') DC180
}


String mapVoltageToString(VoltageTypes type) {
  switch (type) {
    case VoltageTypes.AC7:
      return '7AC';
        case VoltageTypes.AC22:
      return '22AC';

          case VoltageTypes.DC50:
      return '50DC';
          case VoltageTypes.DC80:
      return '80DC';
          case VoltageTypes.DC90:
      return '90DC';
          case VoltageTypes.DC120:
      return '120DC';
          case VoltageTypes.DC150:
      return '150DC';
          case VoltageTypes.DC180:
      return '180DC';
  }
}




@JsonSerializable()
class Filter extends Equatable {
  final bool availability;
  final VoltageTypes? voltage;
  final ConnectorTypes? connector;

  const Filter(
      {
      this.connector,
      this.voltage,
      required this.availability,
      
      });

  Filter copyWith({
   bool? availability,
   VoltageTypes? voltage,
   ConnectorTypes? connector,
  }) {
    return Filter(
      
      availability: availability ?? this.availability,
      voltage: voltage ?? this.voltage,
      connector: connector ?? this.connector,
    );
  }


  bool isEqual(Filter filterToCompare) {
    if (filterToCompare.availability != availability) return false;
    if (filterToCompare.connector != connector) return false;
    if (filterToCompare.voltage != voltage) return false;
    return true;
  }


  int get numberOfFilledFields {
    var filled = 0;
    if (availability) filled +=1;
    if (voltage != null) filled+=1;
    if (connector!=null) filled+=1;

    return filled;

  } 

  @override
  List<Object?> get props => [availability,  voltage, connector];


  
  factory Filter.fromJson(Map<String, dynamic> json) => _$FilterFromJson(json);

  /// Connect the generated [_$FilterToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$FilterToJson(this);
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lseway/domain/entitites/filter/filter.dart';
import 'package:lseway/presentation/bloc/points/points.bloc.dart';
import 'package:lseway/presentation/bloc/points/points.event.dart';
import 'package:lseway/presentation/widgets/Core/CustomButton/custom_button.dart';
import 'package:lseway/presentation/widgets/Core/CustomSelect/custom_select.dart';
import 'package:lseway/presentation/widgets/IconButton/icon_button.dart';

class FilterModal extends StatefulWidget {
  final Filter filter;
  const FilterModal({Key? key, required this.filter}) : super(key: key);

  @override
  _FilterModalState createState() => _FilterModalState();
}

enum Voltage {
  ALL,
  AC7,
  AC22,

  DC50,
  DC80,
  DC90,
  DC120,
  DC150,
  DC180
}

Voltage mapVoltageTypeToVoltage(VoltageTypes? type) {
  switch (type) {
    case VoltageTypes.AC7:
      return Voltage.AC7;
    case VoltageTypes.AC22:
      return Voltage.AC22;
    case VoltageTypes.DC50:
      return Voltage.DC50;
    case VoltageTypes.DC80:
      return Voltage.DC80;
    case VoltageTypes.DC90:
      return Voltage.DC90;
    case VoltageTypes.DC120:
      return Voltage.DC120;
    case VoltageTypes.DC150:
      return Voltage.DC150;
    case VoltageTypes.DC180:
      return Voltage.DC180;

    default:
      return Voltage.ALL;
  }
}



VoltageTypes? mapVoltageToVoltageType(Voltage type) {
  switch (type) {
    case Voltage.AC7:
      return VoltageTypes.AC7;
    case Voltage.AC22:
      return VoltageTypes.AC22;
    case Voltage.DC50:
      return VoltageTypes.DC50;
    case Voltage.DC80:
      return VoltageTypes.DC80;
    case Voltage.DC90:
      return VoltageTypes.DC90;
    case Voltage.DC120:
      return VoltageTypes.DC120;
    case Voltage.DC150:
      return VoltageTypes.DC150;
    case Voltage.DC180:
      return VoltageTypes.DC180;
    case Voltage.ALL:
    return null;

  }
}

String mapVoltageToString(Voltage type) {
  switch (type) {
    case Voltage.AC7:
      return '7AC';
    case Voltage.AC22:
      return '22AC';

    case Voltage.DC50:
      return '50DC';
    case Voltage.DC80:
      return '80DC';
    case Voltage.DC90:
      return '90DC';
    case Voltage.DC120:
      return '120DC';
    case Voltage.DC150:
      return '150DC';
    case Voltage.DC180:
      return '180DC';
    case Voltage.ALL:
      return 'Все';
  }
}

enum Connector {
  ALL,
  CHADEMO,
  TYPE2,
}

Connector mapConnectorTypeToConnector(ConnectorTypes? type) {
  switch (type) {
    case ConnectorTypes.CHADEMO:
      return Connector.CHADEMO;
    case ConnectorTypes.TYPE2:
      return Connector.TYPE2;

    default:
      return Connector.ALL;
  }
}

ConnectorTypes? mapConnectorToConnector(Connector type) {
  switch (type) {
    case Connector.CHADEMO:
      return ConnectorTypes.CHADEMO;
    case Connector.TYPE2:
      return ConnectorTypes.TYPE2;
    case Connector.ALL:
    return null;
  }
}

String mapConnectorToString(Connector type) {
  switch (type) {
    case Connector.ALL:
      return 'Все';
    case Connector.CHADEMO:
      return 'CHAdeMO';
    case Connector.TYPE2:
      return 'type2';
  }
}

class _FilterModalState extends State<FilterModal> {
  late bool status;
  late Voltage voltage;
  late Connector connector;

  @override
  void initState() {
    status = widget.filter.availability;
    voltage = mapVoltageTypeToVoltage(widget.filter.voltage);
    connector = mapConnectorTypeToConnector(widget.filter.connector);
    super.initState();
  }

  void onStatusChange(bool selected) {
    setState(() {
      status = selected;
    });
  }

  void onVoltageChange(Voltage selected) {
    setState(() {
      voltage = selected;
    });
  }

    void onConnectorChange(Connector selected) {
    setState(() {
      connector = selected;
    });
  }

  List<SelectOption<bool>> _buildStatusOptions() {
    return [
      SelectOption<bool>(value: false, label: 'Все'),
      SelectOption<bool>(value: true, label: 'Свободна'),
    ];
  }

  List<SelectOption<Voltage>> _buildVoltageOptions() {
    return Voltage.values.map((e) {
      return SelectOption<Voltage>(label: mapVoltageToString(e), value: e);
    }).toList();
  }

  List<SelectOption<Connector>> _buildConnectorOptions() {
    return Connector.values.map((e) {
      return SelectOption<Connector>(label: mapConnectorToString(e), value: e);
    }).toList();
  }


  void clearFilter() {
    setState(() {
      voltage = Voltage.ALL;
      status = false;
      connector = Connector.ALL;
    });
  }


  void applyFilter() {
    Filter newFilter = Filter(
      availability: status,
      connector: mapConnectorToConnector(connector),
      voltage: mapVoltageToVoltageType(voltage)
    );
    BlocProvider.of<PointsBloc>(context).add(ChangeFilter(filter: newFilter));
    Navigator.of(context).pop(newFilter);
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 30 + MediaQuery.of(context).viewPadding.top),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Фильтр',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  CustomIconButton(
                      icon: SvgPicture.asset('assets/cross.svg'),
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).pop();
                      })
                ],
              ),
              const SizedBox(
                height: 38,
              ),
              CustomSelect<bool>(
                  onChange: onStatusChange,
                  value: status,
                  options: _buildStatusOptions(),
                  label: 'Выберите статус',
                  icon: Image.asset(
                    'assets/graph.png',
                    width: 82 / 3,
                    height: 95 / 3,
                  )),
              const SizedBox(
                height: 20,
              ),
              CustomSelect<Voltage>(
                  onChange: onVoltageChange,
                  value: voltage,
                  options: _buildVoltageOptions(),
                  label: 'Выберите мощность',
                  icon: Image.asset(
                    'assets/bolt.png',
                    width: 82 / 3,
                    height: 95 / 3,
                  )),
              const SizedBox(
                height: 20,
              ),
              CustomSelect<Connector>(
                  onChange: onConnectorChange,
                  value: connector,
                  options: _buildConnectorOptions(),
                  label: 'Выберите тип разъема',
                  icon: Image.asset(
                    'assets/fork.png',
                    width: 82 / 3,
                    height: 95 / 3,
                  )),
              const SizedBox(
                height: 56,
              ),
              CustomButton(text: 'Применить', onPress: applyFilter),
                            const SizedBox(
                height: 20,
              ),
              CustomButton(text: 'Сбросить', onPress: clearFilter, type: ButtonTypes.SECONDARY, bgColor: Colors.white,),
            ],
          ),
        ),
      ),
    );
  }
}

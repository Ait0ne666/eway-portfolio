import 'package:lseway/domain/entitites/filter/filter.dart';
import 'package:lseway/domain/entitites/point/point.entity.dart';
import 'package:lseway/domain/entitites/point/pointInfo.entity.dart';

List<Point> tempPoints = [
  const Point(
    address: 'test',
    availability: true,
    id: 1,
    latitude: 55.751244, 
    longitude: 37.618423
  ),
  const  Point(
    address: 'test',
    availability: true,
    id: 2,
    latitude: 55.752244, 
    longitude: 37.618423
  ),
  const  Point(
    address: 'test',
    availability: false,
    id: 3,
    latitude: 55.751244, 
    longitude: 37.617423
  ),
  const  Point(
    address: 'test',
    availability: false,
    id: 4,
    latitude: 55.750244, 
    longitude: 37.617423
  )
];


PointInfo tempInfo = const PointInfo(
  point: Point(
    address: 'Старая Басманная, 9',
    availability: true,
    id: 1,
    latitude: 55.751244, 
    longitude: 37.618423
  ),
  connectors: [],
  price: 7.23,
  voltage: VoltageTypes.DC50,
  tariffs: []
);
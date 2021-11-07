
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class NearestPointsEvent extends Equatable {



  @override
  List<Object> get props => [];
}




class LoadNearestPoints extends NearestPointsEvent {
  final LatLng coords;


  LoadNearestPoints({required this.coords});


  @override
  List<Object> get props => [coords];


}
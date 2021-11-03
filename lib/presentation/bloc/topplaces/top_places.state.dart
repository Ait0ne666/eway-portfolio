import 'package:equatable/equatable.dart';
import 'package:lseway/domain/entitites/history/history.entity.dart';
import 'package:lseway/domain/entitites/history/top_place.entity.dart';

class TopPlacesState {
  final List<TopPlace> topPlaces;


  const TopPlacesState({required this.topPlaces});


}




class TopPlacesInitialState extends TopPlacesState {


  TopPlacesInitialState():super(topPlaces: []);

}


class TopPlacesLoadedState extends TopPlacesState {


  const TopPlacesLoadedState({required List<TopPlace> topPlaces}):super(topPlaces: topPlaces);

}



import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lseway/domain/entitites/history/top_place.entity.dart';
import 'package:lseway/domain/use-cases/topPlaces/top_places.usecase.dart';
import 'package:lseway/presentation/bloc/topplaces/top_places.event.dart';
import 'package:lseway/presentation/bloc/topplaces/top_places.state.dart';

class TopPlacesBloc extends Bloc<TopPlacesEvent, TopPlacesState> {
  final TopPlacesuseCase usecase;
  
  List<TopPlace> topPlaces = [];

  TopPlacesBloc({required this.usecase}):super(TopPlacesInitialState()){


    on<FetchTTopPlaces>((event, emit) async {
      
        List<TopPlace> items = await usecase.getTopPlaces();


        topPlaces = items;


        emit(TopPlacesLoadedState(topPlaces: topPlaces));


      
    });
  }



}

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:lseway/core/network/network_info.dart';
import 'package:lseway/core/network/retry_interceptor.dart';
import 'package:lseway/core/network/tokens_interceptor.dart';
import 'package:lseway/data/data-sources/booking/booking.remote_data_source.dart';
import 'package:lseway/data/data-sources/charge/charge.remote_data_source.dart';
import 'package:lseway/data/data-sources/chat/chat.remote_data_source.dart';
import 'package:lseway/data/data-sources/history/history_remote_data_source.dart';
import 'package:lseway/data/data-sources/payment/payment.dart';
import 'package:lseway/data/data-sources/points/points_remote_data_source.dart';
import 'package:lseway/data/data-sources/topPlaces/top_places.data-source.dart';
import 'package:lseway/data/data-sources/user/user_local_data_source.dart';
import 'package:lseway/data/data-sources/user/user_remote_data_source.dart';
import 'package:lseway/data/repositories/booking/booking.repository.impl.dart';
import 'package:lseway/data/repositories/charge/charge.repository.impl.dart';
import 'package:lseway/data/repositories/chat/chat.repository.impl.dart';
import 'package:lseway/data/repositories/history/history_repository_impl.dart';
import 'package:lseway/data/repositories/payment/payment.repository.impl.dart';
import 'package:lseway/data/repositories/points/points_repository_impl.dart';
import 'package:lseway/data/repositories/topPlaces/top_places.repository.impl.dart';
import 'package:lseway/data/repositories/user/user_repository_impl.dart';
import 'package:lseway/domain/repositories/booking/booking.repository.dart';
import 'package:lseway/domain/repositories/charge/charge.repository.dart';
import 'package:lseway/domain/repositories/chat/chat.repository.dart';
import 'package:lseway/domain/repositories/history/history.repository.dart';
import 'package:lseway/domain/repositories/payment/payment.repository.dart';
import 'package:lseway/domain/repositories/points/points.repository.dart';
import 'package:lseway/domain/repositories/topPlaces/top_places.repository.dart';
import 'package:lseway/domain/repositories/user/user.repository.dart';
import 'package:lseway/domain/use-cases/booking/booking_use_case.dart';
import 'package:lseway/domain/use-cases/charge/charge_use_case.dart';
import 'package:lseway/domain/use-cases/chat/chat.use_case.dart';
import 'package:lseway/domain/use-cases/history/history_use_case.dart';
import 'package:lseway/domain/use-cases/payment/payment.usecase.dart';
import 'package:lseway/domain/use-cases/points/points.use_case.dart';
import 'package:lseway/domain/use-cases/topPlaces/top_places.usecase.dart';
import 'package:lseway/domain/use-cases/user/user.use-case.dart';
import 'package:lseway/presentation/bloc/activePoints/active_points_bloc.dart';
import 'package:lseway/presentation/bloc/charge/charge.bloc.dart';
import 'package:lseway/presentation/bloc/chat/chat.bloc.dart';
import 'package:lseway/presentation/bloc/history/history.bloc.dart';
import 'package:lseway/presentation/bloc/nearestPoints/nearest_points.bloc.dart';
import 'package:lseway/presentation/bloc/payment/payment.bloc.dart';
import 'package:lseway/presentation/bloc/pointInfo/pointinfo.bloc.dart';
import 'package:lseway/presentation/bloc/points/points.bloc.dart';
import 'package:lseway/presentation/bloc/topplaces/top_places.bloc.dart';
import 'package:lseway/presentation/bloc/user/user.bloc.dart';
import 'package:lseway/presentation/widgets/Main/Map/geolocation.dart';
import 'package:lseway/utils/ImageService/image_service.dart';

final sl = GetIt.instance;

Future<void> init() async {


  sl.registerFactory(() => UserBloc(useCase: sl()));
  
  sl.registerFactory(() => PointInfoBloc(usecase: sl(), localDataSource: sl()));
  sl.registerFactory(() => HistoryBloc(usecase: sl()));
  sl.registerFactory(() => TopPlacesBloc(usecase: sl()));
  sl.registerFactory(() => PaymentBloc(usecase: sl()));
  sl.registerFactory(() => NearestPointsBloc(usecase: sl()));
  sl.registerFactory(() => ChatBloc(usecase: sl()));




  sl.registerLazySingleton(() => GeolocatorService(localDataSource: sl()));
  sl.registerLazySingleton(() => UserUseCase(repository: sl()));
  sl.registerLazySingleton(() => PointsUseCase(repository: sl()));
  sl.registerLazySingleton(() => HistoryuseCase(repository: sl()));
  sl.registerLazySingleton(() => TopPlacesuseCase(repository: sl()));
  sl.registerLazySingleton(() => PaymentUsecase(repository: sl()));
  sl.registerLazySingleton(() => ChargeUseCase(repository: sl()));
  sl.registerLazySingleton(() => BookingUseCase(repository: sl()));
  sl.registerLazySingleton(() => ChatUseCase(repository: sl()));




  sl.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(remoteDataSource: sl(), networkInfo: sl(), localDataSource: sl()));
  sl.registerLazySingleton<PointsRepository>(() => PointsRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()));
  sl.registerLazySingleton<HistoryRepository>(() => HistoryRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()));
  sl.registerLazySingleton<TopPlacesRepository>(() => TopPlacesRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()));
  sl.registerLazySingleton<PaymentRepository>(() => PaymentRepositoryImpl(remoteDataSource: sl(), networkInfo: sl(), localDataSource: sl()));
  sl.registerLazySingleton<ChargeRepository>(() => ChargeRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()));
  sl.registerLazySingleton<BookingRepository>(() => BookingRepositoryImpl(remoteDataSource: sl(), pointsRemoteDataSource: sl(), networkInfo: sl()));
  sl.registerLazySingleton<ChatRepository>(() => ChatRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()));
  
  



  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());

  sl.registerLazySingleton(() => UserLocalDataSource());

  sl.registerLazySingleton(() => UserRemoteDataSource(dio: sl()));
  sl.registerLazySingleton(() => PointsRemoteDataSource(dio: sl()));
  sl.registerLazySingleton(() => HistoryRemoteDataSource(dio: sl()));
  sl.registerLazySingleton(() => TopPlacesRemoteDataSource(dio: sl()));
  sl.registerLazySingleton(() => PaymentRemoteDataSource(dio: sl()));
  sl.registerLazySingleton(() => ChargeRemoteDataSource(dio: sl()));
  sl.registerLazySingleton(() => BookingRemoteDataSource(dio: sl()));
  sl.registerLazySingleton(() => ChatRemoteDataSource(dio: sl()));
  

  sl.registerLazySingleton(() => initDioClient());
  sl.registerLazySingleton(() => ImageService());

}

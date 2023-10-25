import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kmschool/screens/controller/FCMDatabaseController.dart';
import '../event/get_device_event.dart';
import '../state/get_device_state.dart';
import '../event/RealtimeDataUpdateEvent.dart';

class GetDeviceBloc extends Bloc<DeviceEvent, GetDeviceState> {


  GetDeviceBloc() : super(InitialGetDataState()) {
    // Register the event handler for FetchDataEvent
    on<GetAllDevicesData>(_onFetchAllDevicesDataEvent);
    // Register the event handler in your GetDeviceBloc constructor
    on<RealtimeDataUpdateEvent>(onRealtimeDataUpdateEvent);
    on<DeleteAllAlerts>(onDeleteAllAlertsEvent);
    on<DeleteSingleAlert>(onDeleteAlertEvent);

  }


  // Event handler for FetchDataEvent
  void _onFetchAllDevicesDataEvent(
      GetAllDevicesData event, Emitter<GetDeviceState> emit) async {
    // Handle the event and emit appropriate states
    emit(LoadingGetDataState());

    try {
      // Fetch initial data from Firestore
      final docRef = FCMDatabaseController()
          .hpPrinterCollection
          .doc(event.documentId.toString());
      final DocumentSnapshot doc = await docRef.get();


      if (!doc.exists) {
        // Document doesn't exist, emit a state indicating this
        emit(DocumentNotFoundState("Collection Not Found"));
        return;
      }

      final initialData = doc.data() as Map<String, dynamic>;

      // Emit the LoadedGetDataState with the fetched data
      emit(LoadedGetDataState(initialData));


      // Listen for real-time updates
      docRef.snapshots().listen((docSnapshot) {
        if (docSnapshot.exists) {
          final updatedData = docSnapshot.data() as Map<String, dynamic>;
          // Emit the real-time update state asynchronously
          Future<void>.microtask(() {
            add(RealtimeDataUpdateEvent(updatedData));
          });
        }
      });

    } catch (error) {
      // Handle errors and emit the ErrorGetDataState
      emit(ErrorGetDataState('An error occurred: $error'));
    }
  }


  // Event handler for deleting all alerts
  void onDeleteAllAlertsEvent(DeleteAllAlerts event, Emitter<GetDeviceState> emit) async {
    try {
      await FCMDatabaseController().deleteAlertsToDevice(event.documentId,event.deviceId);
      // Fetch updated data after deletion
      final updatedData = await FCMDatabaseController().getDeviceList(event.documentId);
      emit(RealtimeDataUpdateState(updatedData));
    } catch (error) {
      emit(ErrorGetDataState('An error occurred while deleting all alerts: $error'));
    }
  }

// Event handler for deleting a single alert
  void onDeleteAlertEvent(DeleteSingleAlert event, Emitter<GetDeviceState> emit) async {
    try {
      await FCMDatabaseController().deleteSingleAlert(event.documentId,event.deviceId, event.alertId);
      // Fetch updated data after deletion
      final updatedData = await FCMDatabaseController().getDeviceList(event.documentId);
      emit(RealtimeDataUpdateState(updatedData));
    } catch (error) {
      emit(ErrorGetDataState('An error occurred while deleting the alert: $error'));
    }
  }
// Rest of your GetDataBloc code...
}


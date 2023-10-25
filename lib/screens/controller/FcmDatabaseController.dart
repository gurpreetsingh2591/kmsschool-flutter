import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../../bloc/state/get_device_state.dart';
import '../../utils/constant.dart';

class FCMDatabaseController {
  /// Instance of FCM database
  final CollectionReference hpPrinterCollection =
      FirebaseFirestore.instance.collection(kCollectionId);

  dynamic deviceList = [];
  List<dynamic> alertsList = [];

  var outputFormat = DateFormat('MMM dd, yyyy hh:mm a');
  var outputDateFormat = DateFormat('MMM dd, yyyy');
  var outputTimeFormat = DateFormat('hh:mm a');
  Timestamp stamp = Timestamp.now();

  /// Function to Get Document List with collection Id
  Future<List<String>> getDocumentIds() async {
    try {
      QuerySnapshot querySnapshot = await hpPrinterCollection.get();

      List<String> documentIds =
          querySnapshot.docs.map((doc) => doc.id).toList();
      if (kDebugMode) {
        print(' getting document IDs: $documentIds');
      }
      return documentIds;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting document IDs: $e');
      }
      return [];
    }
  }

  ///Function to Get device list with document ID
  Future<Map<String, dynamic>> getDeviceList(String documentId) async {
    final docRef = hpPrinterCollection.doc(documentId);
    try {
      final DocumentSnapshot doc = await docRef.get();
      deviceList = doc.data() as Map<String, dynamic>;

      if (kDebugMode) {
        print(deviceList);
      }

      return deviceList;
    } catch (e) {
      if (kDebugMode) {
        print("Error getting device: $e");
      }
      return {}; // Return an empty map or handle the error as needed.
    }
  }

  /// Function to Get alerts list with device ID
  Future<List<dynamic>> getAlertsList(
      String documentId, String deviceName) async {
    final docRef = hpPrinterCollection.doc(documentId);

    try {
      final DocumentSnapshot doc = await docRef.get();
      final deviceData = doc.data() as Map<String, dynamic>;

      final List<dynamic> devices = deviceData['devices'];
      alertsList.clear();
      for (var device in devices) {
        if (device['device_name'] == deviceName) {
          alertsList = device['alerts'];

          if (kDebugMode) {
            print(alertsList);
          }

          return alertsList;
        }
      }

      if (kDebugMode) {
        print("Device not found or no alerts: $deviceName");
      }

      return []; // Return an empty list if the device or alerts are not found.
    } catch (e) {
      if (kDebugMode) {
        print("Error getting device: $e");
      }
      return []; // Return an empty list or handle the error as needed.
    }
  }

  /// Function to Add device with new document
  Future<void> addDeviceWithNewDocument(String documentId, String deviceName,
      String alertName, String image) async {
    DateTime date = stamp.toDate();
    var outputLastUpdateDate = outputFormat.format(date);
    var outputAlertDate = outputDateFormat.format(date);
    var outputAlertTime = outputTimeFormat.format(date);

    var deviceId = Random().nextInt(9999);
    var alertId = Random().nextInt(99);

    Map<String, dynamic> newDocumentData = {
      'devices': [
        {
          'device_id': deviceId,
          'device_name': deviceName,
          'alert_numbers': '1',
          'device_status': 'Online',
          'last_update': outputLastUpdateDate,
          'alerts': [
            {
              'id': deviceId + alertId,
              'name': alertName,
              'date': outputAlertDate,
              'time': outputAlertTime,
              'image': image,
            },
          ],
        },
      ],
    };
    // Add a new document with a generated ID
    try {
      hpPrinterCollection.doc(documentId).set(newDocumentData);
      if (kDebugMode) {
        print("Document successfully written!");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error writing document: $e");
      }
    }
  }

  /// Function to Add device to exist document
  Future<void> addDevicesToExistDocument(String documentId, String deviceName,
      String alertName, String image) async {
    DateTime date = stamp.toDate();
    var outputLastUpdateDate = outputFormat.format(date);
    var outputAlertDate = outputDateFormat.format(date);
    var outputAlertTime = outputTimeFormat.format(date);

    var deviceId = Random().nextInt(9999);
    var alertId = Random().nextInt(99);
    try {
      DocumentSnapshot documentSnapshot =
          await hpPrinterCollection.doc(documentId).get();

      if (documentSnapshot.exists) {
        // Get the current data as a Map
        Map<String, dynamic>? currentData =
            (documentSnapshot.data() ?? {}) as Map<String, dynamic>?;
        // Retrieve the "devices" list or create it if it doesn't exist
        List<dynamic> devices = currentData?['devices'] ?? [];
        // Add new devices to the list
        devices.addAll([
          {
            'device_id': deviceId,
            'device_name': deviceName,
            'alert_numbers': '1',
            'device_status': 'Online',
            'last_update': outputLastUpdateDate,
            'alerts': [
              {
                'id': deviceId + alertId,
                'name': alertName,
                'date': outputAlertDate,
                'time': outputAlertTime,
                'image': image,
              },
            ],
          },
        ]);

        // Update the "devices" list
        currentData?['devices'] = devices;

        // Write the updated data back to Firestore
        await hpPrinterCollection.doc(documentId).set(currentData);

        if (kDebugMode) {
          print("Devices added successfully!");
        }
      } else {
        if (kDebugMode) {
          print("Document '$documentId' does not exist.");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error adding devices: $e");
      }
    }
  }

  /// Function toAdd alerts to exist device
  Future<void> addAlertsToDevice(
      String documentId, int deviceId, List<dynamic> alertList) async {
    try {
      // Retrieve the current data for "PhotoBooth"
      DocumentSnapshot documentSnapshot =
          await hpPrinterCollection.doc(documentId).get();

      if (documentSnapshot.exists) {
        // Get the current data as a Map
        Map<String, dynamic>? currentData =
            (documentSnapshot.data() ?? {}) as Map<String, dynamic>?;

        // Find the device with the matching device ID
        List<dynamic>? devices = currentData?['devices'];
        if (devices is List) {
          for (var device in devices) {
            if (device['device_id'] == deviceId) {
              // Add new alerts to the 'alerts' list
              List<dynamic> alerts = device['alerts'] ?? [];

              alerts.addAll(alertList);
              /* alerts.add([
                {
                  'id': '11',
                  'name': 'Out of Paper',
                  'date': 'Jun 30, 2023',
                  'time': '11:30 PM',
                  'image': 'assets/images/out_paper_Icon.png',
                },
                {
                  'id': '22',
                  'name': 'Out of Paper',
                  'date': 'Jun 30, 2023',
                  'time': '11:30 PM',
                  'image': 'assets/images/out_paper_Icon.png',
                },
                {
                  'id': '33',
                  'name': 'Out of Paper',
                  'date': 'Jun 30, 2023',
                  'time': '11:30 PM',
                  'image': 'assets/images/out_paper_Icon.png',
                }
              ]);
*/
              for (int i = 0; i < alerts.length; i++) {
                // Update the 'alerts' list for this device
                device['alerts'] = alerts[i];

                // Write the updated data back to Firestore
                await hpPrinterCollection
                    .doc(documentId)
                    .update({'devices': devices});
              }

              if (kDebugMode) {
                print("Alerts added successfully!");
              }
              return;
            }
          }
        }
      }

      if (kDebugMode) {
        print("Device not found or document doesn't exist.");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error adding alerts: $e");
      }
    }
  }

  /// Function to clear (delete all alerts) from a Collection
  Future<void> deleteAlertsToDevice(String documentId, int deviceId) async {
    try {
      // Retrieve the current data for the document
      DocumentSnapshot documentSnapshot =
          await hpPrinterCollection.doc(documentId).get();

      if (documentSnapshot.exists) {
        // Get the current data as a Map
        Map<String, dynamic> currentData =
            documentSnapshot.data() as Map<String, dynamic>;

        // Find the device with the matching device ID
        List<dynamic>? devices = currentData['devices'];
        if (devices is List) {
          for (var device in devices) {
            if (device['device_id'] == deviceId) {
              device['alerts'] = [];

              // Write the updated data back to Firestore
              await hpPrinterCollection
                  .doc(documentId)
                  .update({'devices': devices});

              if (kDebugMode) {
                print("Alerts deleted successfully!");
              }
              return;
            }
          }
        }
      }

      if (kDebugMode) {
        print("Device not found or document doesn't exist.");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error adding alerts: $e");
      }
    }
  }

  /// Function to delete an individual alert
  Future<void> deleteSingleAlert(
      String documentId, int deviceId, int alertId) async {
    try {
      // Retrieve the current data for the document
      DocumentSnapshot documentSnapshot =
          await hpPrinterCollection.doc(documentId).get();

      if (documentSnapshot.exists) {
        // Get the current data as a Map
        Map<String, dynamic> currentData =
            documentSnapshot.data() as Map<String, dynamic>;

        // Find the device with the matching device ID
        List<dynamic>? devices = currentData['devices'];
        if (devices is List) {
          for (var device in devices) {
            if (device['device_id'] == deviceId) {
              // Update the 'alerts' list for this device
              List<dynamic> alerts = device['alerts'] ?? [];
              alerts.removeWhere((alert) => alert['id'] == alertId);
              device['alerts'] = alerts;

              // Write the updated data back to Firestore
              await hpPrinterCollection
                  .doc(documentId)
                  .update({'devices': devices});

              if (kDebugMode) {
                print("Alert deleted successfully!");
              }
              return;
            }
          }
        }
      }

      if (kDebugMode) {
        print("Device not found or document doesn't exist.");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error deleting alert: $e");
      }
    }
  }

/*
  Future<void> deleteSingleAlert(
    String documentId,
    int deviceId,
    int alertId,
  ) async {
    try {
      final deviceQuery = await hpPrinterCollection
          .doc(documentId)
          .collection('devices')
          .where('device_id', isEqualTo: deviceId)
          .limit(1)
          .get();

      if (kDebugMode) {
        print("querySnapshot-----${deviceQuery.docChanges}");
        print("deviceId-----$deviceId");
        print("kCollectionId-----$kCollectionId");
        print("documentId-----$documentId");
      }
      if (deviceQuery.docs.isNotEmpty) {
        final deviceDoc = deviceQuery.docs.first;
        final alertsCollection = deviceDoc.reference.collection('alerts');
        final alertQuery = await alertsCollection
            .where('id', isEqualTo: alertId)
            .limit(1)
            .get();

        if (alertQuery.docs.isNotEmpty) {
          final alertDoc = alertQuery.docs.first;
          await alertDoc.reference.delete();
        } else {
          if (kDebugMode) {
            print('Alert not found for alertId: $alertId');
          }
        }
      } else {
        if (kDebugMode) {
          print('Device not found for deviceId: $deviceId');
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print("Error deleting alert: $error");
      }
    }
  }
*/

/*
  Future<void> deleteSingleAlert(
    String documentId,
    int deviceId,
    int alertId,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection(kCollectionId)
          .doc(documentId)
          .collection('devices')
          .where('device_id', isEqualTo: deviceId)
          .get()
          .then((querySnapshot) {
        if (kDebugMode) {
          print("querySnapshot-----${querySnapshot.docs}");
          print("deviceId-----$deviceId");
          print("kCollectionId-----$kCollectionId");
          print("documentId-----$documentId");
        }
        if (querySnapshot.docs.isNotEmpty) {
          if (kDebugMode) {
            print(querySnapshot.docs);
          }
          final deviceDoc = querySnapshot.docs.first;
          deviceDoc.reference
              .collection('alerts')
              .where('id', isEqualTo: alertId)
              .get()
              .then((alertSnapshot) {
            if (alertSnapshot.docs.isNotEmpty) {
              final alertDoc = alertSnapshot.docs.first;
              alertDoc.reference.delete();
            }
          });
        }
      });
    } catch (error) {
      if (kDebugMode) {
        print("Error deleting alert: $error");
      }
    }
  }
*/
/* Future<void> deleteSingleAlert(
      String documentId, String deviceId, String alertId) async {
    // Construct the path to the specific alert document
    DocumentReference alertRef = hpPrinterCollection
        .doc(documentId)
        .collection('devices')
        .doc(deviceId)
        .collection('alerts')
        .doc(alertId);

    if (kDebugMode) {
      print(alertRef);
    }

    // Check if the alert document exists before deleting it
    DocumentSnapshot alertSnapshot = await alertRef.get();
    if (kDebugMode) {
      print(alertSnapshot);
    }

    if (alertSnapshot.exists) {
      // The alert document exists, proceed to delete it
      await alertRef.delete();

      if (kDebugMode) {
        print("delete");
      }
    } else {
      // Handle the case where the alert document doesn't exist or handle errors accordingly.
    }
  }*/
}

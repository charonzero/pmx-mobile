import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pmx/models/login.dart';
import 'package:pmx/models/modals.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<PackageData?> getPackageDetails(
    String packageSecret, BuildContext buildContext) async {
  final path = '/getPackages?packageSecret=$packageSecret';

  try {
    final response = await Api.get(path, buildContext);
    if (response.statusCode == 200) {
      // Successful response, parse the JSON data
      final jsonData = json.decode(response.body);
      print(jsonData);
      return PackageData.fromJson(jsonData);
    } else {
      // Error response
      print('Error: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    // Exception occurred
    print('Exception: $e');
    return null;
  }
}

Future<List<PackageData>> fetchInventory(
    String path, BuildContext buildContext) async {
  final response = await Api.get(path, buildContext);
  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body);
    if (jsonData == null) {
      return []; // or return an appropriate value for an empty list
    } else {
      try {
        final packageList = List.from(jsonData)
            .map((packageJson) => PackageData.fromJson(packageJson))
            .toList();
        return packageList;
      } catch (e) {
        print('Error parsing JSON data: $e');
        return []; // or return an appropriate value for parsing error
      }
    }
  } else if (response.statusCode == 404) {
    return []; // or return an appropriate value for an empty list
  } else {
    print(
        'Error fetching inventory packages: ${response.body} : ${response.statusCode}');
    return []; // or return an appropriate value for other error cases
  }
}

Future<void> addPackage(int packageId, BuildContext buildContext) async {
  const path = '/addDelivery';

  try {
    final response = await Api.post(
      path,
      buildContext,
      body: {'packageId': packageId},
    );
    if (response.statusCode == 200) {
      // Package added successfully
      final responseBody = json.decode(response.body);
      final message = responseBody['message'] as String;
      if (buildContext.mounted) {
        showDialog(
          context: buildContext,
          builder: (context) => AlertDialog(
            title: const Text('Success'),
            content: Text(
                message.isNotEmpty ? message : 'Package added successfully.'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } else {
      // Error response
      print('Error: ${response.statusCode}');
      final responseBody = json.decode(response.body);
      final message = responseBody['message'] as String;
      if (buildContext.mounted) {
        showDialog(
          context: buildContext,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: Text(
                message.isNotEmpty ? message : 'Failed to add the package.'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  } catch (e) {
    // Exception occurred
    print('Exception: $e');
    if (buildContext.mounted) {
      showDialog(
        context: buildContext,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Failed to add the package.'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}

Future<void> submitPackage(
    int packageId, int statusId, BuildContext buildContext) async {
  const path = '/submitDelivery';

  try {
    final response = await Api.post(
      path,
      buildContext,
      body: {'packageId': packageId, 'statusId': statusId},
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      final message = responseBody['message'] as String;
      if (buildContext.mounted) {
        showDialog(
          context: buildContext,
          builder: (context) => AlertDialog(
            title: const Text('Success'),
            content: Text(
              message.isNotEmpty ? message : 'Successfully updated package.',
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } else {
      final responseBody = json.decode(response.body);
      final message = responseBody['message'] as String;
      if (buildContext.mounted) {
        showDialog(
          context: buildContext,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: Text(
              message.isNotEmpty ? message : 'Failed to update the package.',
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  } catch (e) {
    print('Exception: $e');
    if (buildContext.mounted) {
      showDialog(
        context: buildContext,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Failed to update the package.'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}

Future<void> revertPackage(int packageId, BuildContext buildContext) async {
  const path = '/revertDelivery';

  try {
    final response = await Api.post(
      path,
      buildContext,
      body: {
        'packageId': packageId,
      },
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      final message = responseBody['message'] as String;
      if (buildContext.mounted) {
        showDialog(
          context: buildContext,
          builder: (context) => AlertDialog(
            title: const Text('Success'),
            content: Text(
              message.isNotEmpty ? message : 'Successfully reverted delivery.',
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } else {
      final responseBody = json.decode(response.body);
      final message = responseBody['message'] as String;
      if (buildContext.mounted) {
        showDialog(
          context: buildContext,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: Text(
              message.isNotEmpty ? message : 'Failed to revert the package.',
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  } catch (e) {
    print('Exception: $e');
    if (buildContext.mounted) {
      showDialog(
        context: buildContext,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Failed to revert the package.'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}

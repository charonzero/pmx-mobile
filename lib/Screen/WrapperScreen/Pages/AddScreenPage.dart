import 'package:flutter/material.dart';
import 'package:pmx/models/modals.dart';
import 'package:pmx/models/package.dart';

class AddScreenPage extends StatefulWidget {
  final String packageSecret;

  const AddScreenPage({
    Key? key,
    required this.packageSecret,
  }) : super(key: key);

  @override
  AddScreenPageState createState() => AddScreenPageState();
}

class AddScreenPageState extends State<AddScreenPage> {
  PackageData? packageData;
  bool isAddButtonPressed = false;
  bool isBackButtonPressed = false;
  @override
  void initState() {
    super.initState();
    _fetchPackageData();
  }

  Future<void> _fetchPackageData() async {
    try {
      PackageData? packageDatatmp =
          await getPackageDetails(widget.packageSecret, context);
      setState(() {
        packageData = packageDatatmp;
      });
    } catch (e) {
      // Handle error while fetching package data
      print('Error fetching package data: $e');
    }
  }

  Future<void> _addPackage() async {
    if (packageData != null && packageData?.packageId != null) {
      print('api');
      await addPackage(packageData!.packageId!, context);
    } else {
      print('no api');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: packageData != null
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.center,
          mainAxisAlignment: packageData != null
              ? MainAxisAlignment.start
              : MainAxisAlignment.center,
          children: [
            if (packageData != null) ...[
              const Text(
                'Package ID:',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                packageData!.packageId.toString(),
                style: const TextStyle(
                  fontSize: 32,
                ),
              ),
              const SizedBox(height: 40),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildInfoColumn(
                      'Name:',
                      packageData!.name ?? 'N/A',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildInfoColumn(
                      'Phone:',
                      packageData!.phone ?? 'N/A',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildInfoColumn(
                      'Address:',
                      packageData!.address ?? 'N/A',
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildInfoColumn(
                      'Weight:',
                      packageData!.weight.toString(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildInfoColumn(
                      'Township:',
                      packageData!.townshipName ?? 'N/A',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildInfoColumn(
                      'City:',
                      packageData!.cityName ?? 'N/A',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildInfoColumn(
                      'State:',
                      packageData!.stateName ?? 'N/A',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildInfoColumn(
                      'Country:',
                      packageData!.countryName ?? 'N/A',
                    ),
                  ),
                ],
              ),
              const Spacer(),
            ] else ...[
              const Center(
                child: CircularProgressIndicator(),
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 56,
        child: BottomAppBar(
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTapDown: (_) {
                    setState(() {
                      isAddButtonPressed = true;
                    });
                  },
                  onTapUp: (_) {
                    setState(() {
                      isAddButtonPressed = false;
                    });
                    _addPackage();
                  },
                  onTapCancel: () {
                    setState(() {
                      isAddButtonPressed = false;
                    });
                  },
                  child: SizedBox(
                    height: double.infinity,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add,
                            color:
                                isAddButtonPressed ? Colors.blue : Colors.black,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Add',
                            style: TextStyle(
                                fontSize: 18,
                                color: isAddButtonPressed
                                    ? Colors.blue
                                    : Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTapDown: (_) {
                    setState(() {
                      isBackButtonPressed = true;
                    });
                  },
                  onTapUp: (_) {
                    setState(() {
                      isBackButtonPressed = false;
                    });
                    Navigator.pop(context);
                  },
                  onTapCancel: () {
                    setState(() {
                      isBackButtonPressed = false;
                    });
                  },
                  child: SizedBox(
                    height: double.infinity,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.arrow_back,
                            color: isBackButtonPressed
                                ? Colors.blue
                                : Colors.black,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Back',
                            style: TextStyle(
                                fontSize: 18,
                                color: isBackButtonPressed
                                    ? Colors.blue
                                    : Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

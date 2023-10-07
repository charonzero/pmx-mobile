import 'package:flutter/material.dart';
import 'package:pmx/Screen/LoginScreen/LoginScreen.dart';
import 'package:pmx/constant.dart';
import 'package:pmx/main.dart';
import 'package:pmx/models/login.dart';
import 'package:pmx/models/modals.dart';
import 'package:pmx/models/package.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class Inventory extends StatelessWidget {
  final List<PackageData> packages;
  final String title;
  final VoidCallback refreshPackages;

  const Inventory(
      {Key? key,
      required this.packages,
      required this.title,
      required this.refreshPackages})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: SharedPref().read('session_data'),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          } else if (snapshot.data.isEmpty) {
            Future.delayed(Duration.zero, () {
              navigatorKey.currentState!.push(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            });
            return const SizedBox.shrink();
          } else {
            try {
              SessionData session = SessionData.fromJson(snapshot.data);
              DefaultCacheManager().emptyCache();
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: secondaryColor,
                  title: Text(title),
                ),
                body: Builder(
                  builder: (context) {
                    if (packages.isEmpty) {
                      return const Center(
                        child: Text(
                          'No packages to deliver, Good work!',
                          style: TextStyle(fontSize: 16),
                        ),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: packages.length,
                        itemBuilder: (context, index) {
                          final package = packages[index];
                          return GestureDetector(
                            onTap: () {
                              showPackageOverlay(
                                  context, package, session, refreshPackages);
                            },
                            child: Card(
                              elevation: 2,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                              child: ListTile(
                                title: Text(
                                  'Package ID :  ${package.packageId.toString()}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  'Name: ${package.name}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              );
            } catch (error) {
              print("Error: $error");
              return Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'An error occurred',
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          var bool = await logout();
                          if (bool && context.mounted) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                              (route) => false,
                            );
                          }
                        },
                        child: const Text('Logout'),
                      ),
                    ],
                  ),
                ),
              );
            }
          }
        });
  }

  void showPackageOverlay(
    BuildContext context,
    PackageData package,
    SessionData session,
    VoidCallback fetchPackagesCallback,
  ) {
    void handleDeliveredButtonPress(PackageData package) async {
      if (session.role!.roleName! == "Local Driver") {
        await submitPackage(package.packageId!, 5, context);
        fetchPackagesCallback();
      } else {
        showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text('Choose Warehouse'),
              content: const Text('Which warehouse do you want to deliver to?'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Thai Warehouse'),
                  onPressed: () async {
                    Navigator.of(dialogContext).pop(); // Close the dialog
                    await submitPackage(package.packageId!, 1, context);
                    fetchPackagesCallback();
                  },
                ),
                TextButton(
                  child: const Text('Myanmar Warehouse'),
                  onPressed: () async {
                    Navigator.of(dialogContext).pop(); // Close the dialog
                    await submitPackage(package.packageId!, 3, context);
                    fetchPackagesCallback();
                  },
                ),
              ],
            );
          },
        );
      }
    }

    void handleCanceledButtonPress(PackageData package) async {
      await submitPackage(package.packageId!, 6, context);
      fetchPackagesCallback();
    }

    void handleRescheduledButtonPress(PackageData package) async {
      await submitPackage(package.packageId!, 7, context);
      fetchPackagesCallback();
    }

    void handleMistakeButtonPress(PackageData package) async {
      await revertPackage(package.packageId!, context);
      fetchPackagesCallback();
    }

    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(16.0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10.0,
                spreadRadius: 5.0,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          Text(
                            'Package ID : ${package.packageId!}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {
                              handleMistakeButtonPress(package);
                            },
                            icon: const Icon(
                              Icons.clear,
                              size: 20,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildInfoRow(
                        'Name:', package.name, 'Phone:', package.phone),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Address:",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  package.address,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildInfoRow('Township:', package.townshipName ?? 'N/A',
                        'City:', package.cityName ?? 'N/A'),
                    _buildInfoRow(
                      'State:',
                      package.stateName ?? 'N/A',
                      'Country:',
                      package.countryName ?? 'N/A',
                    ),
                  ],
                ),
              ),
              const Spacer(),
              session.role!.roleName! == "Local Driver"
                  ? Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              handleDeliveredButtonPress(package);
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              padding: const EdgeInsets.all(16.0),
                              textStyle: const TextStyle(fontSize: 13),
                            ),
                            child: const Text('Deliver'),
                          ),
                        ),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              handleCanceledButtonPress(package);
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              padding: const EdgeInsets.all(16.0),
                              textStyle: const TextStyle(fontSize: 13),
                            ),
                            child: const Text('Cancel'),
                          ),
                        ),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              handleRescheduledButtonPress(package);
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber,
                              padding: const EdgeInsets.all(16.0),
                              textStyle: const TextStyle(fontSize: 13),
                            ),
                            child: const Text('Reschedule'),
                          ),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              handleDeliveredButtonPress(package);
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              padding: const EdgeInsets.all(16.0),
                              textStyle: const TextStyle(fontSize: 13),
                            ),
                            child: const Text('Deliver To Arrival Warehouse'),
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(
      String label1, String value1, String label2, String value2) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label1,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  value1,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label2,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  value2,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

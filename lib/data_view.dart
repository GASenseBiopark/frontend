import 'package:flutter/material.dart';
import 'package:gasense/constants/constants.dart';
import 'package:gasense/widgets/sensor_card.dart';

class DataViewPage extends StatefulWidget {
  const DataViewPage({super.key});

  @override
  State<DataViewPage> createState() => _DataViewPageState();
}

class _DataViewPageState extends State<DataViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('Dispositivo x'),
        centerTitle: true,
        backgroundColor: AppColors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 1.25,
          ),
          itemCount: 4,
          itemBuilder: (context, index) {
            switch (index) {
              case 0:
                return sensorCard(
                  'Monóxido de Carbono',
                  'Sensor CO',
                  50,
                  25,
                  AppColors.green,
                );
              case 1:
                return sensorCard(
                  'Metano',
                  'Sensor CH4',
                  2500,
                  75,
                  AppColors.orange,
                );
              case 2:
                return sensorCard(
                  'Dióxido de Carbono',
                  'Sensor CO2',
                  800,
                  40,
                  AppColors.blue,
                );
              case 3:
                return sensorCard(
                  'Amônia',
                  'Sensor NH3',
                  150,
                  90,
                  AppColors.red,
                );
              default:
                return Container();
            }
          },
        ),
      ),
    );
  }
}

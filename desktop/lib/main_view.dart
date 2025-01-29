import 'package:flutter/material.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;
        bool isSmallScreen = width < 800;

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            backgroundColor: Colors.white,
            body: Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Row(
                children: [
                  if (width >= 800)
                    Expanded(flex: 2, child: Container(color: Colors.white)),
                  Expanded(
                    flex: width < 800 ? 9 : 10,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 16.0),
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Colors.white70),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const Text('Username',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                                const Text('Phone',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                                if (!isSmallScreen)
                                  const Text('Created',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                if (!isSmallScreen)
                                  const Text('Updated',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                const Text('Type',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: List.generate(
                                  10,
                                  (index) => CustomListItem(
                                    index: index,
                                    isSmallScreen: isSmallScreen,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (width >= 750)
                    Expanded(flex: 2, child: Container(color: Colors.white)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class CustomListItem extends StatefulWidget {
  final int index;
  final bool isSmallScreen;
  const CustomListItem(
      {required this.index, required this.isSmallScreen, super.key});

  @override
  _CustomListItemState createState() => _CustomListItemState();
}

class _CustomListItemState extends State<CustomListItem> {
  String selectedType = 'FREE';

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 65, 65, 65),
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.white,
            blurRadius: 10.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text('User ${widget.index}',
              style: const TextStyle(color: Colors.white)),
          const Text('123456789', style: TextStyle(color: Colors.white)),
          if (!widget.isSmallScreen)
            const Text('2023-01-01', style: TextStyle(color: Colors.white)),
          if (!widget.isSmallScreen)
            const Text('2023-01-02', style: TextStyle(color: Colors.white)),
          DropdownButton<String>(
            dropdownColor: Colors.black,
            value: selectedType,
            items: ['ADMINISTRADOR', 'FREE', 'PREMIUM']
                .map((String type) => DropdownMenuItem(
                      value: type,
                      child: Text(type,
                          style: const TextStyle(color: Colors.white)),
                    ))
                .toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  selectedType = newValue;
                });
                print('Se ha cambiado a $newValue');
              }
            },
          ),
        ],
      ),
    );
  }
}

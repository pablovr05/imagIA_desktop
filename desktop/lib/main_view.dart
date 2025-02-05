import 'package:desktop/userlist_view.dart';
import 'package:flutter/material.dart';
import 'login_view.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  bool showUserManagement = true;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isSmallScreen = constraints.maxWidth < 800;

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            backgroundColor: Colors.white,
            appBar: isSmallScreen
                ? AppBar(
                    backgroundColor: Colors.black,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'ADMIN DASHBOARD',
                          style: TextStyle(color: Colors.white),
                        ),
                        ElevatedButton(
                          onPressed: _refreshPage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.all(8),
                            shape: const CircleBorder(),
                          ),
                          child: const Icon(Icons.refresh, color: Colors.black),
                        ),
                      ],
                    ),
                    leading: Builder(
                      builder: (context) => IconButton(
                        icon: const Icon(Icons.menu, color: Colors.white),
                        onPressed: () => Scaffold.of(context).openDrawer(),
                      ),
                    ),
                  )
                : null,
            drawer: isSmallScreen
                ? Drawer(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        const DrawerHeader(
                          decoration: BoxDecoration(color: Colors.black),
                          child: Text(
                            'ADMIN DASHBOARD',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                        ),
                        ListTile(
                          title: const Text('Usuarios'),
                          onTap: () {
                            setState(() {
                              showUserManagement = true;
                            });
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          title: const Text('Historial'),
                          onTap: () {
                            setState(() {
                              showUserManagement = true;
                            });
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          title: const Text('Estadisticas'),
                          onTap: () {
                            setState(() {
                              showUserManagement = true;
                            });
                            Navigator.pop(context);
                          },
                        ),
                        const SizedBox(height: 400),
                        ListTile(
                          leading:
                              const Icon(Icons.logout, color: Colors.black),
                          title: const Text('Desconectarse'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()),
                            );
                          },
                        ),
                      ],
                    ),
                  )
                : null,
            body: Row(
              children: [
                if (!isSmallScreen)
                  Container(
                    width: constraints.maxWidth * 0.2,
                    color: Colors.white,
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'ADMIN DASHBOARD',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                            fontSize: 28,
                            decoration: TextDecoration.underline,
                            decorationThickness: 2.0,
                          ),
                        ),
                        const SizedBox(height: 150),
                        Expanded(
                          child: ListView(
                            children: [
                              ListTile(
                                title: const Text('Usuarios',
                                    style: TextStyle(color: Colors.black)),
                                tileColor: Colors.white,
                                onTap: () {
                                  setState(() {
                                    showUserManagement = true;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()),
                            );
                          },
                          icon: const Icon(Icons.logout, color: Colors.black),
                          label: const Text('Desconectarse',
                              style: TextStyle(color: Colors.black)),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: showUserManagement
                      ? UserManagementScreen()
                      : const Center(
                          child: Text('Contenido Principal'),
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _refreshPage() {
    setState(() {});
  }
}

import 'package:flutter/material.dart';

class Navbar extends StatelessWidget implements PreferredSizeWidget {
  const Navbar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(
          Icons.menu,
          size: 40,
        ),
        onPressed: () => (Scaffold.of(context).openDrawer()),
      ),
      actions: [
        Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: Icon(
                Icons.account_circle,
                size: 40,
              ),
              onPressed: () => (_showUserInfoModal(context)),
            ))
      ],
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.0))),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}

// Modal con la información del usuario y botón de logout
void _showUserInfoModal(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return Stack(
        children: [
          Positioned(
              top: 20,
              right: 0,
              child: Material(
                  color: Colors.transparent,
                  child: Dialog(
                    child: Container(
                      height: 250,
                      width: 300,
                      padding: EdgeInsets.all(16.0),
                      child: Column(children: [
                        SizedBox(height: 20),
                        Title(
                          color: Colors.black,
                          child: Text("Perfil de estudiante"),
                        ),
                        SizedBox(height: 20),
                        Row(mainAxisSize: MainAxisSize.min, children: [
                          Image.asset(
                            "assets/images/user-1.jpg",
                            width: 80,
                          ),
                          SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                'Santiago Doria',
                                textAlign: TextAlign.left,
                              ),
                              Text('johndoe@example.com',
                                  textAlign: TextAlign.left),
                            ],
                          ),
                        ]),
                        SizedBox(height: 20),
                        ElevatedButton(
                          style: ButtonStyle(
                            side: WidgetStatePropertyAll(BorderSide(
                                color: Color(0xFF79a341), width: 2.0)),
                            shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero)),
                          ),
                          onPressed: () {
                            // Acción de logout
                            Navigator.pop(context); // Cerrar el modal
                          },
                          child: Text('Cerrar sesión'),
                        ),
                      ]),
                    ),
                  )))
        ],
      );
    },
  );
}

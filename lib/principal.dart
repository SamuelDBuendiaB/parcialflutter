import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'subir.dart';
import 'signin.dart';

class principal extends StatefulWidget {
  @override
  _MainActivityState createState() => _MainActivityState();
}
//declaracion de variables, para la lista, el adaptador de texto de firebase a la app, la lista de firebase, y si se abre o noi la carta
class _MainActivityState extends State<principal> {
  late TextEditingController searchContro;
  late List<ItemData> mList;
  late TextAdapter adapter;
  late List<ItemData> filteredMList;
  bool _buttonPressed = false;

  @override
  void initState() {
    super.initState();
    searchContro = TextEditingController();
    mList = [];
    filteredMList = [];
    adapter = TextAdapter(mList: mList);
    fetchDataFromFirebase();
  }

  Future<void> fetchDataFromFirebase() async {
    //Traer informacion de firebase
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('images').get();
      setState(() {
        mList = querySnapshot.docs
            .map((doc) => ItemData(
                  title: doc['title'],
                  logo: doc['img'],
                  desc: doc['description'],
                  seabre: false,
                ))
            .toList();
        filteredMList = List.from(mList); // copia de la lista para filtrar
        adapter = TextAdapter(mList: mList);
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }
// poner datos en los campos de la app
  void _filterList(String query) {
    setState(() {
      filteredMList = mList.where((item) {
        final title = item.title.toLowerCase();
        final desc = item.desc.toLowerCase();
        final searchLower = query.toLowerCase();

        return title.contains(searchLower) || desc.contains(searchLower);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dogo search'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // llama para salir de sesion
              signout(context);
            },
          ),
        ],
      ),
      // Todos los estilos y contoladores para el buscador
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                margin: EdgeInsets.all(16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                elevation: 12.0,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    controller: searchContro,
                    decoration: InputDecoration(
                      hintText: 'Search here...',
                      border: InputBorder.none,
                    ),
                    onChanged: (query) {
                      _filterList(query);
                    },
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredMList.length,
                  itemBuilder: (context, index) {
                    return buildListItem(filteredMList[index]);
                  },
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: GestureDetector(
              onTapDown: (_) {
                setState(() {
                  _buttonPressed = true;
                });
              },
              onTapUp: (_) {
                setState(() {
                  _buttonPressed = false;
                });
                showPopupMenu(context);
              },
              // animacion
              child: Transform.rotate(
                angle: _buttonPressed ? -0.3 : 0.0,
                child: Container(
                  width: 50.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                    color: _buttonPressed ? Color.fromARGB(255, 255, 0, 0) : Colors.blue,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Icon(
                    Icons.upload,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
//informacion en lista de firebase
  Widget buildListItem(ItemData item) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 12.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(item.logo),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                Text(
                  item.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            if (item.seabre)
              Text(
                item.desc,
                style: TextStyle(fontSize: 20.0),
              ),
            InkWell(
              onTap: () {
                setState(() {
                  item.seabre = !item.seabre;
                });
              },
              child: Text(
                item.seabre ? 'Menos' : 'Mas',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
//salir sesion
  void signout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut(); //salir
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ResUsuario()),
      );
    } catch (e) {
      print("Erros at Sign out");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error Singning out'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }
// menu para subir imagenes
void showPopupMenu(BuildContext context) {
  final RenderBox button = context.findRenderObject() as RenderBox;

  final Offset position = button.localToGlobal(Offset.zero);

  final RelativeRect positionPopup =
      RelativeRect.fromLTRB(position.dx, position.dy + button.size.height,
          position.dx + button.size.width, position.dy + button.size.height + 10.0);
// mostrar menu
  showMenu<String>(
    context: context,
    position: positionPopup,
    items: [
      PopupMenuItem(
        child: Text('Upload'),
        value: 'upload',
      ),
    ],
  ).then((value) {
    if (value == 'upload') {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Subir()));
    }
  });
}
}

class ItemData {
  final String title;
  final String logo;
  final String desc;
  bool seabre;

  ItemData({
    required this.title,
    required this.logo,
    required this.desc,
    this.seabre = false,
  });
}

class TextAdapter extends StatelessWidget {
  final List<ItemData> mList;

  TextAdapter({required this.mList});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}





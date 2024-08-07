import 'dart:io';

import 'package:elite_jersey/agregar_jersey.dart';
import 'package:elite_jersey/jersey_detalle.dart';
import 'package:flutter/material.dart';

import 'Base de datos/db_helper.dart';
import 'Base de datos/jersey.dart';

class PantallaPrincipal extends StatefulWidget {
  @override
  _PantallaPrincipalState createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  List<Jersey> _jerseys = [];

  @override
  void initState() {
    super.initState();
    _loadJerseys();
  }

  Future<void> _loadJerseys() async {
    try {
      await DBHelper
          .initDB(); // Asegúrate de que la base de datos esté inicializada
      List<Jersey> jerseys = await DBHelper.query();
      setState(() {
        _jerseys = jerseys;
      });
    } catch (e) {
      // Manejar el error apropiadamente
      print('Error al cargar los jerseys: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Elite Jerseys',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 39, 50, 64), // Color del AppBar
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AgregarJersey()),
              ).then((_) =>
                  _loadJerseys()); // Recargar la lista de jerseys después de agregar uno nuevo
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Fondo degradado
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 39, 50, 64),
                  Colors.white, // Color de abajo
                ],
              ),
            ),
          ),
          // Contenido desplazable
          CustomScrollView(
            slivers: [
              // Imagen en la parte superior
              SliverToBoxAdapter(
                child: Image.asset(
                  'assets/elite_jersey.png', // Ruta a tu imagen en el proyecto
                  fit: BoxFit.cover,
                  width: double.infinity, // Ocupa todo el ancho del contenedor
                ),
              ),
              // Lista de elementos
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    final jersey = _jerseys[index];
                    return InkWell(
                      onTap: () {
                        // Acción cuando se toca el elemento
                        // Por ejemplo, puedes navegar a una nueva página con los detalles del jersey
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => JerseyDetalle(jersey: jersey),
                          ),
                        ).then((value) => _loadJerseys());
                      },
                      child: ListTile(
                        title:
                            Text(jersey.nombreJersey ?? 'Nombre desconocido'),
                        subtitle: Text(
                          'Temporada: ${jersey.anio}\nEquipación: ${jersey.numeroEquipacion}\nCantidad: ${jersey.cantidades?.reduce((a, b) => a + b) ?? 0}',
                        ),
                        leading: jersey.imagen != null
                            ? Image.file(
                                File(jersey.imagen!),
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              )
                            : Icon(Icons.image_not_supported),
                        isThreeLine: true,
                      ),
                    );
                  },
                  childCount: _jerseys.length,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

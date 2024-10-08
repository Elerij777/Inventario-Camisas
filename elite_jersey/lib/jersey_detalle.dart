import 'package:elite_jersey/editar_jersey.dart';
import 'package:flutter/material.dart';

import 'Base de datos/jersey.dart';
import 'Dart:io';

class JerseyDetalle extends StatefulWidget {
  final Jersey jersey;

  JerseyDetalle({required this.jersey});

  @override
  _JerseyDetalleState createState() => _JerseyDetalleState();
}

class _JerseyDetalleState extends State<JerseyDetalle> {
  late TextEditingController _nombreController;
  late TextEditingController _anioController;
  late TextEditingController _numeroEquipacionController;
  late TextEditingController _precioController;
  Map<int, int> _cantidades = {};
  final List<String> _tallas = [
    'XXS',
    'XS',
    'S',
    'M',
    'L',
    'XL',
    'XXL',
    'XXXL',
    'XXXXL'
  ];

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.jersey.nombreJersey);
    _anioController =
        TextEditingController(text: widget.jersey.anio?.toString());
    _numeroEquipacionController =
        TextEditingController(text: widget.jersey.numeroEquipacion?.toString());
    _precioController =
        TextEditingController(text: widget.jersey.precio?.toString());

    for (var i = 0; i < widget.jersey.cantidades!.length; i++) {
      _cantidades[i] = widget.jersey.cantidades![i];
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _anioController.dispose();
    _numeroEquipacionController.dispose();
    _precioController.dispose();
    super.dispose();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Éxito'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle del Jersey'),
        backgroundColor: Color.fromARGB(255, 39, 50, 64),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditarJersey(jersey: widget.jersey)),
              ).then((_) => Navigator.pop(context));
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
                  Colors.white,
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Imagen del jersey
                  widget.jersey.imagen != null
                      ? Image.file(
                          File(widget.jersey.imagen!),
                          width: double.infinity,
                          height: 400,
                          fit: BoxFit
                              .contain, // Ajuste para mantener la proporción
                        )
                      : Icon(
                          Icons.image_not_supported,
                          size: 200,
                        ),

                  SizedBox(height: 10.0),
                  // Información del jersey
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Equipo: ${_nombreController.text}',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Año: ${_anioController.text}',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Número de Equipación: ${_numeroEquipacionController.text}',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Precio: ${_precioController.text}',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),

                  SizedBox(height: 16.0),
                  Column(
                    children: List.generate(_cantidades.length, (index) {
                      return Row(
                        children: [
                          Text(_tallas[index]),
                          Spacer(),
                          Text('${_cantidades[index]}'),
                        ],
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

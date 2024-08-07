import 'package:flutter/material.dart';

import 'Base de datos/db_helper.dart';
import 'Base de datos/jersey.dart';
import 'Dart:io';

class EditarJersey extends StatefulWidget {
  final Jersey jersey;

  EditarJersey({required this.jersey});

  @override
  _EditarJerseyState createState() => _EditarJerseyState();
}

class _EditarJerseyState extends State<EditarJersey> {
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

  Future<void> _updateJersey() async {
    final nombre = _nombreController.text;
    final anio = int.tryParse(_anioController.text);
    final numeroEquipacion = int.tryParse(_numeroEquipacionController.text);
    final precio = double.tryParse(_precioController.text);

    // Validar los datos
    if (nombre.isEmpty ||
        anio == null ||
        numeroEquipacion == null ||
        precio == null) {
      _showErrorDialog('Por favor, rellena todos los campos');
      return;
    }

    // Verificar que las cantidades no sean negativas
    bool cantidadesValidas =
        _cantidades.values.every((cantidad) => cantidad >= 0);
    if (!cantidadesValidas) {
      _showErrorDialog('Las cantidades no pueden ser negativas');
      return;
    }

    // Actualizar la instancia de Jersey
    Jersey updatedJersey = Jersey(
      id: widget.jersey.id,
      nombreJersey: nombre,
      anio: anio,
      numeroEquipacion: numeroEquipacion,
      cantidades: _cantidades.values.toList(),
      imagen: widget.jersey.imagen,
      precio: precio,
    );

    // Guardar en la base de datos
    try {
      await DBHelper.updateJersey(updatedJersey);
      _showSuccessDialog('Jersey actualizado exitosamente');
      Navigator.pop(context); // Volver a la pantalla anterior
    } catch (e) {
      _showErrorDialog('Error: ${e.toString()}');
    }
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
        actions: [],
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

                  // Información del jersey
                  TextField(
                    controller: _nombreController,
                    decoration: InputDecoration(
                      labelText: 'Equipo',
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                  TextField(
                    controller: _anioController,
                    decoration: InputDecoration(
                      labelText: 'Año',
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: _numeroEquipacionController,
                    decoration: InputDecoration(
                      labelText: 'Número de Equipación',
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: _precioController,
                    decoration: InputDecoration(
                      labelText: 'Precio',
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                  ),
                  SizedBox(height: 16.0),
                  Column(
                    children: List.generate(_cantidades.length, (index) {
                      return Row(
                        children: [
                          Text(_tallas[index]),
                          Spacer(),
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () {
                              setState(() {
                                _cantidades[index] = (_cantidades[index]! - 1)
                                    .clamp(0, double.infinity)
                                    .toInt();
                              });
                            },
                          ),
                          Text('${_cantidades[index]}'),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              setState(() {
                                _cantidades[index] = _cantidades[index]! + 1;
                              });
                            },
                          ),
                        ],
                      );
                    }),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _updateJersey,
                    child: Text('Actualizar Jersey'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 39, 50, 64),
                      foregroundColor: Colors.white,
                    ),
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

import 'dart:io';

import 'package:elite_jersey/Base de datos/db_helper.dart';
import 'package:elite_jersey/Base de datos/jersey.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AgregarJersey extends StatefulWidget {
  @override
  _AgregarJerseyState createState() => _AgregarJerseyState();
}

class _AgregarJerseyState extends State<AgregarJersey> {
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _anioController = TextEditingController();
  final TextEditingController _numeroEquipacionController =
      TextEditingController();
  final TextEditingController _precioController = TextEditingController();
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
  final Map<String, int> _cantidades = {
    'XXS': 0,
    'XS': 0,
    'S': 0,
    'M': 0,
    'L': 0,
    'XL': 0,
    'XXL': 0,
    'XXXL': 0,
    'XXXXL': 0,
  };

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
    }
  }

  Future<void> _addJersey() async {
    // Obtener los datos ingresados
    final nombre = _nombreController.text;
    final anio = int.tryParse(_anioController.text);
    final numeroEquipacion = int.tryParse(_numeroEquipacionController.text);
    final precio = double.tryParse(_precioController.text);
    final imagen = _imageFile?.path;

    // Validar los datos
    if (nombre.isEmpty ||
        anio == null ||
        numeroEquipacion == null ||
        precio == null ||
        imagen == null) {
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

    // Crear una instancia de Jersey
    Jersey nuevoJersey = Jersey(
      nombreJersey: nombre,
      anio: anio,
      numeroEquipacion: numeroEquipacion,
      cantidades: _cantidades.values.toList(),
      imagen: imagen,
      precio: precio,
    );

    // Guardar en la base de datos
    try {
      int result = await DBHelper.insertJersey(nuevoJersey);
      if (result > 0) {
        // Mostrar mensaje de éxito
        _showSuccessDialog('Jersey agregado exitosamente');
      } else {
        // Mostrar mensaje de error
        _showErrorDialog('Error al agregar el jersey');
      }
    } catch (e) {
      _showErrorDialog('Error: ${e.toString()}');
    }
    Navigator.pop(context);
  }

// Método para mostrar un cuadro de diálogo de error
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

// Método para mostrar un cuadro de diálogo de éxito
  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Éxito'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void dispose() {
    _nombreController.dispose();
    _anioController.dispose();
    _numeroEquipacionController.dispose();
    _precioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Jersey'),
        backgroundColor: Color.fromARGB(255, 39, 50, 64), // Color del AppBar
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 39, 50, 64), // Color superior del degradado
              Colors.white, // Color inferior del degradado
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Nombre del Jersey',
                  border: OutlineInputBorder(),
                ),
                controller: _nombreController,
              ),
              SizedBox(height: 16.0),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Año',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                controller: _anioController,
              ),
              SizedBox(height: 16.0),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Número de Equipación',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                controller: _numeroEquipacionController,
              ),
              SizedBox(height: 16.0),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Precio',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                controller: _precioController,
              ),
              SizedBox(height: 16.0),
              Text('Selecciona la cantidad por talla'),
              ..._tallas.map(
                (talla) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(talla),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () {
                              setState(() {
                                // Asegúrate de que el valor de la talla no sea nulo
                                if (_cantidades[talla] != null &&
                                    _cantidades[talla]! > 0) {
                                  _cantidades[talla] = _cantidades[talla]! - 1;
                                }
                              });
                            },
                          ),
                          SizedBox(
                            width: 50.0,
                            child: TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 8.0),
                              ),
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              controller: TextEditingController(
                                text: _cantidades[talla].toString(),
                              ),
                              onChanged: (value) {
                                final newValue = int.tryParse(value);
                                if (newValue != null && newValue >= 0) {
                                  setState(() {
                                    _cantidades[talla] = newValue;
                                  });
                                }
                              },
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              setState(() {
                                // Asegúrate de que el valor de la talla no sea nulo y lo incrementa
                                if (_cantidades[talla] != null) {
                                  _cantidades[talla] = _cantidades[talla]! + 1;
                                } else {
                                  _cantidades[talla] =
                                      1; // Establece un valor inicial si es null
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Center(
                child: Column(
                  children: [
                    // Botón para seleccionar imagen
                    ElevatedButton(
                      onPressed: _pickImage,
                      child: Row(
                        mainAxisSize: MainAxisSize
                            .min, // Hacer que el botón sea lo más pequeño posible
                        mainAxisAlignment: MainAxisAlignment
                            .center, // Centrar el contenido del botón
                        children: [
                          Text(
                            'Seleccionar Imagen',
                            style: TextStyle(
                                color: Colors.white), // Color del texto
                          ),
                          SizedBox(
                              width: 8.0), // Espacio entre el texto y el ícono
                          Icon(
                            Icons.add_a_photo,
                            color: Colors.white, // Color del ícono
                          ),
                        ],
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Color.fromARGB(
                                255, 39, 50, 64)), // Color de fondo del botón
                        foregroundColor: MaterialStateProperty.all(
                            Colors.white), // Color del texto y del ícono
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            EdgeInsets.symmetric(
                                horizontal: 12.0,
                                vertical:
                                    8.0)), // Ajustar el padding para hacerlo pequeño
                      ),
                    ),

                    SizedBox(height: 16.0),
                    // Mostrar la imagen seleccionada
                    if (_imageFile != null)
                      Image.file(
                        File(_imageFile!.path),
                        height: 200.0,
                        fit: BoxFit.cover,
                      ),

                    SizedBox(height: 16.0),
                    // Botón para agregar jersey
                    ElevatedButton(
                      onPressed: _addJersey,
                      child: Row(
                        mainAxisSize: MainAxisSize
                            .min, // Hacer que el botón sea lo más pequeño posible
                        mainAxisAlignment: MainAxisAlignment
                            .center, // Centrar el contenido del botón
                        children: [
                          Text(
                            'Agregar Jersey',
                            style: TextStyle(
                                color: Colors.white), // Color del texto
                          ),
                          SizedBox(
                              width: 8.0), // Espacio entre el texto y el ícono
                          Icon(
                            Icons.add,
                            color: Colors.white, // Color del ícono
                          ),
                        ],
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Color.fromARGB(
                                255, 39, 50, 64)), // Color de fondo del botón
                        foregroundColor: MaterialStateProperty.all(
                            Colors.white), // Color del texto y del ícono
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            EdgeInsets.symmetric(
                                horizontal: 12.0,
                                vertical:
                                    8.0)), // Ajustar el padding para hacerlo pequeño
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:elite_jersey/Base%20de%20datos/jersey.dart';
import 'package:elite_jersey/agregar_jersey.dart';
import 'package:elite_jersey/editar_jersey.dart';
import 'package:elite_jersey/jersey_detalle.dart';
import 'package:elite_jersey/pantalla_principal.dart';
import 'package:elite_jersey/routes.dart';
import 'package:flutter/material.dart';

final Map<String, Widget Function(BuildContext)> routes = {
  MyRoutes.Main.name: (context) => PantallaPrincipal(),
  MyRoutes.Agregar.name: (context) => AgregarJersey(),
  MyRoutes.JerseyDetalle.name: (context) => JerseyDetalle(
        jersey: Jersey(),
      ),
  MyRoutes.EditarJersey.name: (context) => EditarJersey(
        jersey: Jersey(),
      ),
};

class Venta {
  int? id;
  int jerseyId;
  int cantidad;
  double precio;
  DateTime fecha;

  Venta({
    this.id,
    required this.jerseyId,
    required this.cantidad,
    required this.precio,
    required this.fecha,
  });

  // Constructor para crear una instancia de Venta a partir de un JSON
  Venta.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        jerseyId = json['jerseyId'],
        cantidad = json['cantidad'],
        precio = json['precio'],
        fecha = DateTime.parse(json['fecha']);

  // Método para convertir la instancia de Venta a JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['jerseyId'] = jerseyId;
    data['cantidad'] = cantidad;
    data['precio'] = precio;
    data['fecha'] = fecha.toIso8601String();
    return data;
  }
}

class Jersey {
  int? id; // Campo de identificación único
  String? nombreJersey;
  int? anio;
  int? numeroEquipacion;
  List<int>? cantidades;
  String? imagen;
  double? precio;

  Jersey({
    this.id,
    this.nombreJersey,
    this.anio,
    this.numeroEquipacion,
    this.cantidades,
    this.imagen,
    this.precio,
  });

  // Constructor para crear una instancia de Jersey a partir de un JSON
  Jersey.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nombreJersey = json['nombreJersey'];
    anio = json['anio'];
    numeroEquipacion = json['numeroEquipacion'];
    cantidades = json['cantidades'] != null
        ? (json['cantidades'] as String)
            .split(',')
            .map((e) => int.parse(e))
            .toList()
        : [];
    imagen = json['imagen'];
    precio = json['precio'];
  }

  // Método para convertir la instancia de Jersey a JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nombreJersey'] = nombreJersey;
    data['anio'] = anio;
    data['numeroEquipacion'] = numeroEquipacion;
    data['cantidades'] =
        cantidades?.join(','); // Convertir lista de cantidades a String
    data['imagen'] = imagen;
    data['precio'] = precio;
    return data;
  }
}

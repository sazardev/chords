/// Tipo de bloque declarado detectado por el escáner.
enum DeclarationKind {
  /// Clase (incluye abstractas, base, final, sealed o interface).
  classType('class'),

  /// Mixin.
  mixinType('mixin'),

  /// Enum.
  enumType('enum'),

  /// Extensión.
  extensionType('extension'),

  /// Typedef.
  typedefType('typedef'),

  /// Función de nivel superior.
  function('function'),

  /// Método dentro de un tipo.
  method('method'),

  /// Constructor.
  constructor('constructor'),

  /// Getter o setter.
  accessor('accessor');

  /// Crea un tipo de declaración con su etiqueta.
  const DeclarationKind(this.label);

  /// Etiqueta legible del tipo.
  final String label;
}

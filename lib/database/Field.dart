class Field {
  Field(this.name);
  String name;
  String _type = '';
  String _tableName = '';
  String _referenceFieldName = '';
  bool _isPrimaryKey = false;
  bool _canBeNull = false;
  bool _isUnique = false;
  bool _isForeign = false;
  var _defaultValue;

  Field text() {
    _type = 'TEXT';
    return this;
  }

  Field integer() {
    _type = 'INTEGER';
    return this;
  }

  Field numberic() {
    _type = 'NUMERIC';
    return this;
  }

  Field real() {
    _type = 'REAL';
    return this;
  }

  Field boolean() {
    _type = 'BOOLEAN';
    return this;
  }

  Field blob() {
    _type = 'BLOB';
    return this;
  }

  Field nullable() {
    _canBeNull = true;
    return this;
  }

  Field primaryKey() {
    _isPrimaryKey = true;
    return this;
  }

  Field unique() {
    _isUnique = true;
    return this;
  }

  Field foreign() {
    _isForeign = true;
    return this;
  }

  Field references(String fieldName) {
    _referenceFieldName = fieldName;
    return this;
  }

  Field on(String tableName) {
    _tableName = tableName;
    return this;
  }

  Field setDefaultValue(var value) {
    _defaultValue = value;
    return this;
  }

  String build() {
    if (_isForeign) {
      return 'FOREIGN KEY ($name) REFERENCES $_tableName ($_referenceFieldName) ';
    }
    return '$name $_type ' +
        (_isPrimaryKey ? "PRIMARY KEY " : " ") +
        (_isUnique ? " UNIQUE " : "") +
        (_canBeNull ? "" : " NOT NULL ") +
        (_defaultValue != null ? "DEFAULT " + _defaultValue : "") +
        "";
  }
}

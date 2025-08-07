// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $GpsDevicesTable extends GpsDevices
    with TableInfo<$GpsDevicesTable, GpsDevice> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GpsDevicesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idGpsMeta = const VerificationMeta('idGps');
  @override
  late final GeneratedColumn<int> idGps = GeneratedColumn<int>(
    'id_gps',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _modelMeta = const VerificationMeta('model');
  @override
  late final GeneratedColumn<String> model = GeneratedColumn<String>(
    'model',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _serialNumberMeta = const VerificationMeta(
    'serialNumber',
  );
  @override
  late final GeneratedColumn<String> serialNumber = GeneratedColumn<String>(
    'serial_number',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _installedAtMeta = const VerificationMeta(
    'installedAt',
  );
  @override
  late final GeneratedColumn<DateTime> installedAt = GeneratedColumn<DateTime>(
    'installed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    idGps,
    model,
    serialNumber,
    installedAt,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'gps_devices';
  @override
  VerificationContext validateIntegrity(
    Insertable<GpsDevice> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id_gps')) {
      context.handle(
        _idGpsMeta,
        idGps.isAcceptableOrUnknown(data['id_gps']!, _idGpsMeta),
      );
    }
    if (data.containsKey('model')) {
      context.handle(
        _modelMeta,
        model.isAcceptableOrUnknown(data['model']!, _modelMeta),
      );
    }
    if (data.containsKey('serial_number')) {
      context.handle(
        _serialNumberMeta,
        serialNumber.isAcceptableOrUnknown(
          data['serial_number']!,
          _serialNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_serialNumberMeta);
    }
    if (data.containsKey('installed_at')) {
      context.handle(
        _installedAtMeta,
        installedAt.isAcceptableOrUnknown(
          data['installed_at']!,
          _installedAtMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {idGps};
  @override
  GpsDevice map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GpsDevice(
      idGps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id_gps'],
      )!,
      model: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model'],
      ),
      serialNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}serial_number'],
      )!,
      installedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}installed_at'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $GpsDevicesTable createAlias(String alias) {
    return $GpsDevicesTable(attachedDatabase, alias);
  }
}

class GpsDevice extends DataClass implements Insertable<GpsDevice> {
  final int idGps;
  final String? model;
  final String serialNumber;
  final DateTime? installedAt;
  final bool isActive;
  const GpsDevice({
    required this.idGps,
    this.model,
    required this.serialNumber,
    this.installedAt,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id_gps'] = Variable<int>(idGps);
    if (!nullToAbsent || model != null) {
      map['model'] = Variable<String>(model);
    }
    map['serial_number'] = Variable<String>(serialNumber);
    if (!nullToAbsent || installedAt != null) {
      map['installed_at'] = Variable<DateTime>(installedAt);
    }
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  GpsDevicesCompanion toCompanion(bool nullToAbsent) {
    return GpsDevicesCompanion(
      idGps: Value(idGps),
      model: model == null && nullToAbsent
          ? const Value.absent()
          : Value(model),
      serialNumber: Value(serialNumber),
      installedAt: installedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(installedAt),
      isActive: Value(isActive),
    );
  }

  factory GpsDevice.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GpsDevice(
      idGps: serializer.fromJson<int>(json['idGps']),
      model: serializer.fromJson<String?>(json['model']),
      serialNumber: serializer.fromJson<String>(json['serialNumber']),
      installedAt: serializer.fromJson<DateTime?>(json['installedAt']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'idGps': serializer.toJson<int>(idGps),
      'model': serializer.toJson<String?>(model),
      'serialNumber': serializer.toJson<String>(serialNumber),
      'installedAt': serializer.toJson<DateTime?>(installedAt),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  GpsDevice copyWith({
    int? idGps,
    Value<String?> model = const Value.absent(),
    String? serialNumber,
    Value<DateTime?> installedAt = const Value.absent(),
    bool? isActive,
  }) => GpsDevice(
    idGps: idGps ?? this.idGps,
    model: model.present ? model.value : this.model,
    serialNumber: serialNumber ?? this.serialNumber,
    installedAt: installedAt.present ? installedAt.value : this.installedAt,
    isActive: isActive ?? this.isActive,
  );
  GpsDevice copyWithCompanion(GpsDevicesCompanion data) {
    return GpsDevice(
      idGps: data.idGps.present ? data.idGps.value : this.idGps,
      model: data.model.present ? data.model.value : this.model,
      serialNumber: data.serialNumber.present
          ? data.serialNumber.value
          : this.serialNumber,
      installedAt: data.installedAt.present
          ? data.installedAt.value
          : this.installedAt,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GpsDevice(')
          ..write('idGps: $idGps, ')
          ..write('model: $model, ')
          ..write('serialNumber: $serialNumber, ')
          ..write('installedAt: $installedAt, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(idGps, model, serialNumber, installedAt, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GpsDevice &&
          other.idGps == this.idGps &&
          other.model == this.model &&
          other.serialNumber == this.serialNumber &&
          other.installedAt == this.installedAt &&
          other.isActive == this.isActive);
}

class GpsDevicesCompanion extends UpdateCompanion<GpsDevice> {
  final Value<int> idGps;
  final Value<String?> model;
  final Value<String> serialNumber;
  final Value<DateTime?> installedAt;
  final Value<bool> isActive;
  const GpsDevicesCompanion({
    this.idGps = const Value.absent(),
    this.model = const Value.absent(),
    this.serialNumber = const Value.absent(),
    this.installedAt = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  GpsDevicesCompanion.insert({
    this.idGps = const Value.absent(),
    this.model = const Value.absent(),
    required String serialNumber,
    this.installedAt = const Value.absent(),
    this.isActive = const Value.absent(),
  }) : serialNumber = Value(serialNumber);
  static Insertable<GpsDevice> custom({
    Expression<int>? idGps,
    Expression<String>? model,
    Expression<String>? serialNumber,
    Expression<DateTime>? installedAt,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (idGps != null) 'id_gps': idGps,
      if (model != null) 'model': model,
      if (serialNumber != null) 'serial_number': serialNumber,
      if (installedAt != null) 'installed_at': installedAt,
      if (isActive != null) 'is_active': isActive,
    });
  }

  GpsDevicesCompanion copyWith({
    Value<int>? idGps,
    Value<String?>? model,
    Value<String>? serialNumber,
    Value<DateTime?>? installedAt,
    Value<bool>? isActive,
  }) {
    return GpsDevicesCompanion(
      idGps: idGps ?? this.idGps,
      model: model ?? this.model,
      serialNumber: serialNumber ?? this.serialNumber,
      installedAt: installedAt ?? this.installedAt,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (idGps.present) {
      map['id_gps'] = Variable<int>(idGps.value);
    }
    if (model.present) {
      map['model'] = Variable<String>(model.value);
    }
    if (serialNumber.present) {
      map['serial_number'] = Variable<String>(serialNumber.value);
    }
    if (installedAt.present) {
      map['installed_at'] = Variable<DateTime>(installedAt.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GpsDevicesCompanion(')
          ..write('idGps: $idGps, ')
          ..write('model: $model, ')
          ..write('serialNumber: $serialNumber, ')
          ..write('installedAt: $installedAt, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $ObdDevicesTable extends ObdDevices
    with TableInfo<$ObdDevicesTable, ObdDevice> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ObdDevicesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idObdMeta = const VerificationMeta('idObd');
  @override
  late final GeneratedColumn<int> idObd = GeneratedColumn<int>(
    'id_obd',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _modelMeta = const VerificationMeta('model');
  @override
  late final GeneratedColumn<String> model = GeneratedColumn<String>(
    'model',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _serialNumberMeta = const VerificationMeta(
    'serialNumber',
  );
  @override
  late final GeneratedColumn<String> serialNumber = GeneratedColumn<String>(
    'serial_number',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _installedAtMeta = const VerificationMeta(
    'installedAt',
  );
  @override
  late final GeneratedColumn<DateTime> installedAt = GeneratedColumn<DateTime>(
    'installed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    idObd,
    model,
    serialNumber,
    installedAt,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'obd_devices';
  @override
  VerificationContext validateIntegrity(
    Insertable<ObdDevice> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id_obd')) {
      context.handle(
        _idObdMeta,
        idObd.isAcceptableOrUnknown(data['id_obd']!, _idObdMeta),
      );
    }
    if (data.containsKey('model')) {
      context.handle(
        _modelMeta,
        model.isAcceptableOrUnknown(data['model']!, _modelMeta),
      );
    }
    if (data.containsKey('serial_number')) {
      context.handle(
        _serialNumberMeta,
        serialNumber.isAcceptableOrUnknown(
          data['serial_number']!,
          _serialNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_serialNumberMeta);
    }
    if (data.containsKey('installed_at')) {
      context.handle(
        _installedAtMeta,
        installedAt.isAcceptableOrUnknown(
          data['installed_at']!,
          _installedAtMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {idObd};
  @override
  ObdDevice map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ObdDevice(
      idObd: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id_obd'],
      )!,
      model: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model'],
      ),
      serialNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}serial_number'],
      )!,
      installedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}installed_at'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $ObdDevicesTable createAlias(String alias) {
    return $ObdDevicesTable(attachedDatabase, alias);
  }
}

class ObdDevice extends DataClass implements Insertable<ObdDevice> {
  final int idObd;
  final String? model;
  final String serialNumber;
  final DateTime? installedAt;
  final bool isActive;
  const ObdDevice({
    required this.idObd,
    this.model,
    required this.serialNumber,
    this.installedAt,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id_obd'] = Variable<int>(idObd);
    if (!nullToAbsent || model != null) {
      map['model'] = Variable<String>(model);
    }
    map['serial_number'] = Variable<String>(serialNumber);
    if (!nullToAbsent || installedAt != null) {
      map['installed_at'] = Variable<DateTime>(installedAt);
    }
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  ObdDevicesCompanion toCompanion(bool nullToAbsent) {
    return ObdDevicesCompanion(
      idObd: Value(idObd),
      model: model == null && nullToAbsent
          ? const Value.absent()
          : Value(model),
      serialNumber: Value(serialNumber),
      installedAt: installedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(installedAt),
      isActive: Value(isActive),
    );
  }

  factory ObdDevice.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ObdDevice(
      idObd: serializer.fromJson<int>(json['idObd']),
      model: serializer.fromJson<String?>(json['model']),
      serialNumber: serializer.fromJson<String>(json['serialNumber']),
      installedAt: serializer.fromJson<DateTime?>(json['installedAt']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'idObd': serializer.toJson<int>(idObd),
      'model': serializer.toJson<String?>(model),
      'serialNumber': serializer.toJson<String>(serialNumber),
      'installedAt': serializer.toJson<DateTime?>(installedAt),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  ObdDevice copyWith({
    int? idObd,
    Value<String?> model = const Value.absent(),
    String? serialNumber,
    Value<DateTime?> installedAt = const Value.absent(),
    bool? isActive,
  }) => ObdDevice(
    idObd: idObd ?? this.idObd,
    model: model.present ? model.value : this.model,
    serialNumber: serialNumber ?? this.serialNumber,
    installedAt: installedAt.present ? installedAt.value : this.installedAt,
    isActive: isActive ?? this.isActive,
  );
  ObdDevice copyWithCompanion(ObdDevicesCompanion data) {
    return ObdDevice(
      idObd: data.idObd.present ? data.idObd.value : this.idObd,
      model: data.model.present ? data.model.value : this.model,
      serialNumber: data.serialNumber.present
          ? data.serialNumber.value
          : this.serialNumber,
      installedAt: data.installedAt.present
          ? data.installedAt.value
          : this.installedAt,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ObdDevice(')
          ..write('idObd: $idObd, ')
          ..write('model: $model, ')
          ..write('serialNumber: $serialNumber, ')
          ..write('installedAt: $installedAt, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(idObd, model, serialNumber, installedAt, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ObdDevice &&
          other.idObd == this.idObd &&
          other.model == this.model &&
          other.serialNumber == this.serialNumber &&
          other.installedAt == this.installedAt &&
          other.isActive == this.isActive);
}

class ObdDevicesCompanion extends UpdateCompanion<ObdDevice> {
  final Value<int> idObd;
  final Value<String?> model;
  final Value<String> serialNumber;
  final Value<DateTime?> installedAt;
  final Value<bool> isActive;
  const ObdDevicesCompanion({
    this.idObd = const Value.absent(),
    this.model = const Value.absent(),
    this.serialNumber = const Value.absent(),
    this.installedAt = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  ObdDevicesCompanion.insert({
    this.idObd = const Value.absent(),
    this.model = const Value.absent(),
    required String serialNumber,
    this.installedAt = const Value.absent(),
    this.isActive = const Value.absent(),
  }) : serialNumber = Value(serialNumber);
  static Insertable<ObdDevice> custom({
    Expression<int>? idObd,
    Expression<String>? model,
    Expression<String>? serialNumber,
    Expression<DateTime>? installedAt,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (idObd != null) 'id_obd': idObd,
      if (model != null) 'model': model,
      if (serialNumber != null) 'serial_number': serialNumber,
      if (installedAt != null) 'installed_at': installedAt,
      if (isActive != null) 'is_active': isActive,
    });
  }

  ObdDevicesCompanion copyWith({
    Value<int>? idObd,
    Value<String?>? model,
    Value<String>? serialNumber,
    Value<DateTime?>? installedAt,
    Value<bool>? isActive,
  }) {
    return ObdDevicesCompanion(
      idObd: idObd ?? this.idObd,
      model: model ?? this.model,
      serialNumber: serialNumber ?? this.serialNumber,
      installedAt: installedAt ?? this.installedAt,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (idObd.present) {
      map['id_obd'] = Variable<int>(idObd.value);
    }
    if (model.present) {
      map['model'] = Variable<String>(model.value);
    }
    if (serialNumber.present) {
      map['serial_number'] = Variable<String>(serialNumber.value);
    }
    if (installedAt.present) {
      map['installed_at'] = Variable<DateTime>(installedAt.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ObdDevicesCompanion(')
          ..write('idObd: $idObd, ')
          ..write('model: $model, ')
          ..write('serialNumber: $serialNumber, ')
          ..write('installedAt: $installedAt, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $DriversTable extends Drivers with TableInfo<$DriversTable, Driver> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DriversTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idDriverMeta = const VerificationMeta(
    'idDriver',
  );
  @override
  late final GeneratedColumn<int> idDriver = GeneratedColumn<int>(
    'id_driver',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _firstNameMeta = const VerificationMeta(
    'firstName',
  );
  @override
  late final GeneratedColumn<String> firstName = GeneratedColumn<String>(
    'first_name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastNameMeta = const VerificationMeta(
    'lastName',
  );
  @override
  late final GeneratedColumn<String> lastName = GeneratedColumn<String>(
    'last_name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _idNumberMeta = const VerificationMeta(
    'idNumber',
  );
  @override
  late final GeneratedColumn<String> idNumber = GeneratedColumn<String>(
    'id_number',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 15,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    idDriver,
    firstName,
    lastName,
    idNumber,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'drivers';
  @override
  VerificationContext validateIntegrity(
    Insertable<Driver> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id_driver')) {
      context.handle(
        _idDriverMeta,
        idDriver.isAcceptableOrUnknown(data['id_driver']!, _idDriverMeta),
      );
    }
    if (data.containsKey('first_name')) {
      context.handle(
        _firstNameMeta,
        firstName.isAcceptableOrUnknown(data['first_name']!, _firstNameMeta),
      );
    } else if (isInserting) {
      context.missing(_firstNameMeta);
    }
    if (data.containsKey('last_name')) {
      context.handle(
        _lastNameMeta,
        lastName.isAcceptableOrUnknown(data['last_name']!, _lastNameMeta),
      );
    } else if (isInserting) {
      context.missing(_lastNameMeta);
    }
    if (data.containsKey('id_number')) {
      context.handle(
        _idNumberMeta,
        idNumber.isAcceptableOrUnknown(data['id_number']!, _idNumberMeta),
      );
    } else if (isInserting) {
      context.missing(_idNumberMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {idDriver};
  @override
  Driver map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Driver(
      idDriver: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id_driver'],
      )!,
      firstName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}first_name'],
      )!,
      lastName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_name'],
      )!,
      idNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id_number'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $DriversTable createAlias(String alias) {
    return $DriversTable(attachedDatabase, alias);
  }
}

class Driver extends DataClass implements Insertable<Driver> {
  final int idDriver;
  final String firstName;
  final String lastName;
  final String idNumber;
  final bool isActive;
  const Driver({
    required this.idDriver,
    required this.firstName,
    required this.lastName,
    required this.idNumber,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id_driver'] = Variable<int>(idDriver);
    map['first_name'] = Variable<String>(firstName);
    map['last_name'] = Variable<String>(lastName);
    map['id_number'] = Variable<String>(idNumber);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  DriversCompanion toCompanion(bool nullToAbsent) {
    return DriversCompanion(
      idDriver: Value(idDriver),
      firstName: Value(firstName),
      lastName: Value(lastName),
      idNumber: Value(idNumber),
      isActive: Value(isActive),
    );
  }

  factory Driver.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Driver(
      idDriver: serializer.fromJson<int>(json['idDriver']),
      firstName: serializer.fromJson<String>(json['firstName']),
      lastName: serializer.fromJson<String>(json['lastName']),
      idNumber: serializer.fromJson<String>(json['idNumber']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'idDriver': serializer.toJson<int>(idDriver),
      'firstName': serializer.toJson<String>(firstName),
      'lastName': serializer.toJson<String>(lastName),
      'idNumber': serializer.toJson<String>(idNumber),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  Driver copyWith({
    int? idDriver,
    String? firstName,
    String? lastName,
    String? idNumber,
    bool? isActive,
  }) => Driver(
    idDriver: idDriver ?? this.idDriver,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    idNumber: idNumber ?? this.idNumber,
    isActive: isActive ?? this.isActive,
  );
  Driver copyWithCompanion(DriversCompanion data) {
    return Driver(
      idDriver: data.idDriver.present ? data.idDriver.value : this.idDriver,
      firstName: data.firstName.present ? data.firstName.value : this.firstName,
      lastName: data.lastName.present ? data.lastName.value : this.lastName,
      idNumber: data.idNumber.present ? data.idNumber.value : this.idNumber,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Driver(')
          ..write('idDriver: $idDriver, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('idNumber: $idNumber, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(idDriver, firstName, lastName, idNumber, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Driver &&
          other.idDriver == this.idDriver &&
          other.firstName == this.firstName &&
          other.lastName == this.lastName &&
          other.idNumber == this.idNumber &&
          other.isActive == this.isActive);
}

class DriversCompanion extends UpdateCompanion<Driver> {
  final Value<int> idDriver;
  final Value<String> firstName;
  final Value<String> lastName;
  final Value<String> idNumber;
  final Value<bool> isActive;
  const DriversCompanion({
    this.idDriver = const Value.absent(),
    this.firstName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.idNumber = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  DriversCompanion.insert({
    this.idDriver = const Value.absent(),
    required String firstName,
    required String lastName,
    required String idNumber,
    this.isActive = const Value.absent(),
  }) : firstName = Value(firstName),
       lastName = Value(lastName),
       idNumber = Value(idNumber);
  static Insertable<Driver> custom({
    Expression<int>? idDriver,
    Expression<String>? firstName,
    Expression<String>? lastName,
    Expression<String>? idNumber,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (idDriver != null) 'id_driver': idDriver,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (idNumber != null) 'id_number': idNumber,
      if (isActive != null) 'is_active': isActive,
    });
  }

  DriversCompanion copyWith({
    Value<int>? idDriver,
    Value<String>? firstName,
    Value<String>? lastName,
    Value<String>? idNumber,
    Value<bool>? isActive,
  }) {
    return DriversCompanion(
      idDriver: idDriver ?? this.idDriver,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      idNumber: idNumber ?? this.idNumber,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (idDriver.present) {
      map['id_driver'] = Variable<int>(idDriver.value);
    }
    if (firstName.present) {
      map['first_name'] = Variable<String>(firstName.value);
    }
    if (lastName.present) {
      map['last_name'] = Variable<String>(lastName.value);
    }
    if (idNumber.present) {
      map['id_number'] = Variable<String>(idNumber.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DriversCompanion(')
          ..write('idDriver: $idDriver, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('idNumber: $idNumber, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $VehiclesTable extends Vehicles with TableInfo<$VehiclesTable, Vehicle> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VehiclesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idVehicleMeta = const VerificationMeta(
    'idVehicle',
  );
  @override
  late final GeneratedColumn<int> idVehicle = GeneratedColumn<int>(
    'id_vehicle',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _idDriverMeta = const VerificationMeta(
    'idDriver',
  );
  @override
  late final GeneratedColumn<int> idDriver = GeneratedColumn<int>(
    'id_driver',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NULL REFERENCES drivers(id_driver)',
  );
  static const VerificationMeta _licensePlateMeta = const VerificationMeta(
    'licensePlate',
  );
  @override
  late final GeneratedColumn<String> licensePlate = GeneratedColumn<String>(
    'license_plate',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 10,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _brandMeta = const VerificationMeta('brand');
  @override
  late final GeneratedColumn<String> brand = GeneratedColumn<String>(
    'brand',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modelMeta = const VerificationMeta('model');
  @override
  late final GeneratedColumn<String> model = GeneratedColumn<String>(
    'model',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
    'year',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<VehicleStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('available'),
      ).withConverter<VehicleStatus>($VehiclesTable.$converterstatus);
  static const VerificationMeta _mileageMeta = const VerificationMeta(
    'mileage',
  );
  @override
  late final GeneratedColumn<int> mileage = GeneratedColumn<int>(
    'mileage',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _gpsDeviceIdMeta = const VerificationMeta(
    'gpsDeviceId',
  );
  @override
  late final GeneratedColumn<int> gpsDeviceId = GeneratedColumn<int>(
    'gps_device_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NULL REFERENCES gps_devices(id_gps)',
  );
  static const VerificationMeta _obdDeviceIdMeta = const VerificationMeta(
    'obdDeviceId',
  );
  @override
  late final GeneratedColumn<int> obdDeviceId = GeneratedColumn<int>(
    'obd_device_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NULL REFERENCES obd_devices(id_obd)',
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    idVehicle,
    idDriver,
    licensePlate,
    brand,
    model,
    year,
    status,
    mileage,
    gpsDeviceId,
    obdDeviceId,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vehicles';
  @override
  VerificationContext validateIntegrity(
    Insertable<Vehicle> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id_vehicle')) {
      context.handle(
        _idVehicleMeta,
        idVehicle.isAcceptableOrUnknown(data['id_vehicle']!, _idVehicleMeta),
      );
    }
    if (data.containsKey('id_driver')) {
      context.handle(
        _idDriverMeta,
        idDriver.isAcceptableOrUnknown(data['id_driver']!, _idDriverMeta),
      );
    }
    if (data.containsKey('license_plate')) {
      context.handle(
        _licensePlateMeta,
        licensePlate.isAcceptableOrUnknown(
          data['license_plate']!,
          _licensePlateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_licensePlateMeta);
    }
    if (data.containsKey('brand')) {
      context.handle(
        _brandMeta,
        brand.isAcceptableOrUnknown(data['brand']!, _brandMeta),
      );
    } else if (isInserting) {
      context.missing(_brandMeta);
    }
    if (data.containsKey('model')) {
      context.handle(
        _modelMeta,
        model.isAcceptableOrUnknown(data['model']!, _modelMeta),
      );
    }
    if (data.containsKey('year')) {
      context.handle(
        _yearMeta,
        year.isAcceptableOrUnknown(data['year']!, _yearMeta),
      );
    }
    if (data.containsKey('mileage')) {
      context.handle(
        _mileageMeta,
        mileage.isAcceptableOrUnknown(data['mileage']!, _mileageMeta),
      );
    }
    if (data.containsKey('gps_device_id')) {
      context.handle(
        _gpsDeviceIdMeta,
        gpsDeviceId.isAcceptableOrUnknown(
          data['gps_device_id']!,
          _gpsDeviceIdMeta,
        ),
      );
    }
    if (data.containsKey('obd_device_id')) {
      context.handle(
        _obdDeviceIdMeta,
        obdDeviceId.isAcceptableOrUnknown(
          data['obd_device_id']!,
          _obdDeviceIdMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {idVehicle};
  @override
  Vehicle map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Vehicle(
      idVehicle: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id_vehicle'],
      )!,
      idDriver: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id_driver'],
      ),
      licensePlate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}license_plate'],
      )!,
      brand: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand'],
      )!,
      model: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model'],
      ),
      year: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year'],
      ),
      status: $VehiclesTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      mileage: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}mileage'],
      )!,
      gpsDeviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}gps_device_id'],
      ),
      obdDeviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}obd_device_id'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $VehiclesTable createAlias(String alias) {
    return $VehiclesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<VehicleStatus, String, String> $converterstatus =
      const EnumNameConverter<VehicleStatus>(VehicleStatus.values);
}

class Vehicle extends DataClass implements Insertable<Vehicle> {
  final int idVehicle;
  final int? idDriver;
  final String licensePlate;
  final String brand;
  final String? model;
  final int? year;
  final VehicleStatus status;
  final int mileage;
  final int? gpsDeviceId;
  final int? obdDeviceId;
  final bool isActive;
  const Vehicle({
    required this.idVehicle,
    this.idDriver,
    required this.licensePlate,
    required this.brand,
    this.model,
    this.year,
    required this.status,
    required this.mileage,
    this.gpsDeviceId,
    this.obdDeviceId,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id_vehicle'] = Variable<int>(idVehicle);
    if (!nullToAbsent || idDriver != null) {
      map['id_driver'] = Variable<int>(idDriver);
    }
    map['license_plate'] = Variable<String>(licensePlate);
    map['brand'] = Variable<String>(brand);
    if (!nullToAbsent || model != null) {
      map['model'] = Variable<String>(model);
    }
    if (!nullToAbsent || year != null) {
      map['year'] = Variable<int>(year);
    }
    {
      map['status'] = Variable<String>(
        $VehiclesTable.$converterstatus.toSql(status),
      );
    }
    map['mileage'] = Variable<int>(mileage);
    if (!nullToAbsent || gpsDeviceId != null) {
      map['gps_device_id'] = Variable<int>(gpsDeviceId);
    }
    if (!nullToAbsent || obdDeviceId != null) {
      map['obd_device_id'] = Variable<int>(obdDeviceId);
    }
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  VehiclesCompanion toCompanion(bool nullToAbsent) {
    return VehiclesCompanion(
      idVehicle: Value(idVehicle),
      idDriver: idDriver == null && nullToAbsent
          ? const Value.absent()
          : Value(idDriver),
      licensePlate: Value(licensePlate),
      brand: Value(brand),
      model: model == null && nullToAbsent
          ? const Value.absent()
          : Value(model),
      year: year == null && nullToAbsent ? const Value.absent() : Value(year),
      status: Value(status),
      mileage: Value(mileage),
      gpsDeviceId: gpsDeviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(gpsDeviceId),
      obdDeviceId: obdDeviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(obdDeviceId),
      isActive: Value(isActive),
    );
  }

  factory Vehicle.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Vehicle(
      idVehicle: serializer.fromJson<int>(json['idVehicle']),
      idDriver: serializer.fromJson<int?>(json['idDriver']),
      licensePlate: serializer.fromJson<String>(json['licensePlate']),
      brand: serializer.fromJson<String>(json['brand']),
      model: serializer.fromJson<String?>(json['model']),
      year: serializer.fromJson<int?>(json['year']),
      status: $VehiclesTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      mileage: serializer.fromJson<int>(json['mileage']),
      gpsDeviceId: serializer.fromJson<int?>(json['gpsDeviceId']),
      obdDeviceId: serializer.fromJson<int?>(json['obdDeviceId']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'idVehicle': serializer.toJson<int>(idVehicle),
      'idDriver': serializer.toJson<int?>(idDriver),
      'licensePlate': serializer.toJson<String>(licensePlate),
      'brand': serializer.toJson<String>(brand),
      'model': serializer.toJson<String?>(model),
      'year': serializer.toJson<int?>(year),
      'status': serializer.toJson<String>(
        $VehiclesTable.$converterstatus.toJson(status),
      ),
      'mileage': serializer.toJson<int>(mileage),
      'gpsDeviceId': serializer.toJson<int?>(gpsDeviceId),
      'obdDeviceId': serializer.toJson<int?>(obdDeviceId),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  Vehicle copyWith({
    int? idVehicle,
    Value<int?> idDriver = const Value.absent(),
    String? licensePlate,
    String? brand,
    Value<String?> model = const Value.absent(),
    Value<int?> year = const Value.absent(),
    VehicleStatus? status,
    int? mileage,
    Value<int?> gpsDeviceId = const Value.absent(),
    Value<int?> obdDeviceId = const Value.absent(),
    bool? isActive,
  }) => Vehicle(
    idVehicle: idVehicle ?? this.idVehicle,
    idDriver: idDriver.present ? idDriver.value : this.idDriver,
    licensePlate: licensePlate ?? this.licensePlate,
    brand: brand ?? this.brand,
    model: model.present ? model.value : this.model,
    year: year.present ? year.value : this.year,
    status: status ?? this.status,
    mileage: mileage ?? this.mileage,
    gpsDeviceId: gpsDeviceId.present ? gpsDeviceId.value : this.gpsDeviceId,
    obdDeviceId: obdDeviceId.present ? obdDeviceId.value : this.obdDeviceId,
    isActive: isActive ?? this.isActive,
  );
  Vehicle copyWithCompanion(VehiclesCompanion data) {
    return Vehicle(
      idVehicle: data.idVehicle.present ? data.idVehicle.value : this.idVehicle,
      idDriver: data.idDriver.present ? data.idDriver.value : this.idDriver,
      licensePlate: data.licensePlate.present
          ? data.licensePlate.value
          : this.licensePlate,
      brand: data.brand.present ? data.brand.value : this.brand,
      model: data.model.present ? data.model.value : this.model,
      year: data.year.present ? data.year.value : this.year,
      status: data.status.present ? data.status.value : this.status,
      mileage: data.mileage.present ? data.mileage.value : this.mileage,
      gpsDeviceId: data.gpsDeviceId.present
          ? data.gpsDeviceId.value
          : this.gpsDeviceId,
      obdDeviceId: data.obdDeviceId.present
          ? data.obdDeviceId.value
          : this.obdDeviceId,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Vehicle(')
          ..write('idVehicle: $idVehicle, ')
          ..write('idDriver: $idDriver, ')
          ..write('licensePlate: $licensePlate, ')
          ..write('brand: $brand, ')
          ..write('model: $model, ')
          ..write('year: $year, ')
          ..write('status: $status, ')
          ..write('mileage: $mileage, ')
          ..write('gpsDeviceId: $gpsDeviceId, ')
          ..write('obdDeviceId: $obdDeviceId, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    idVehicle,
    idDriver,
    licensePlate,
    brand,
    model,
    year,
    status,
    mileage,
    gpsDeviceId,
    obdDeviceId,
    isActive,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Vehicle &&
          other.idVehicle == this.idVehicle &&
          other.idDriver == this.idDriver &&
          other.licensePlate == this.licensePlate &&
          other.brand == this.brand &&
          other.model == this.model &&
          other.year == this.year &&
          other.status == this.status &&
          other.mileage == this.mileage &&
          other.gpsDeviceId == this.gpsDeviceId &&
          other.obdDeviceId == this.obdDeviceId &&
          other.isActive == this.isActive);
}

class VehiclesCompanion extends UpdateCompanion<Vehicle> {
  final Value<int> idVehicle;
  final Value<int?> idDriver;
  final Value<String> licensePlate;
  final Value<String> brand;
  final Value<String?> model;
  final Value<int?> year;
  final Value<VehicleStatus> status;
  final Value<int> mileage;
  final Value<int?> gpsDeviceId;
  final Value<int?> obdDeviceId;
  final Value<bool> isActive;
  const VehiclesCompanion({
    this.idVehicle = const Value.absent(),
    this.idDriver = const Value.absent(),
    this.licensePlate = const Value.absent(),
    this.brand = const Value.absent(),
    this.model = const Value.absent(),
    this.year = const Value.absent(),
    this.status = const Value.absent(),
    this.mileage = const Value.absent(),
    this.gpsDeviceId = const Value.absent(),
    this.obdDeviceId = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  VehiclesCompanion.insert({
    this.idVehicle = const Value.absent(),
    this.idDriver = const Value.absent(),
    required String licensePlate,
    required String brand,
    this.model = const Value.absent(),
    this.year = const Value.absent(),
    this.status = const Value.absent(),
    this.mileage = const Value.absent(),
    this.gpsDeviceId = const Value.absent(),
    this.obdDeviceId = const Value.absent(),
    this.isActive = const Value.absent(),
  }) : licensePlate = Value(licensePlate),
       brand = Value(brand);
  static Insertable<Vehicle> custom({
    Expression<int>? idVehicle,
    Expression<int>? idDriver,
    Expression<String>? licensePlate,
    Expression<String>? brand,
    Expression<String>? model,
    Expression<int>? year,
    Expression<String>? status,
    Expression<int>? mileage,
    Expression<int>? gpsDeviceId,
    Expression<int>? obdDeviceId,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (idVehicle != null) 'id_vehicle': idVehicle,
      if (idDriver != null) 'id_driver': idDriver,
      if (licensePlate != null) 'license_plate': licensePlate,
      if (brand != null) 'brand': brand,
      if (model != null) 'model': model,
      if (year != null) 'year': year,
      if (status != null) 'status': status,
      if (mileage != null) 'mileage': mileage,
      if (gpsDeviceId != null) 'gps_device_id': gpsDeviceId,
      if (obdDeviceId != null) 'obd_device_id': obdDeviceId,
      if (isActive != null) 'is_active': isActive,
    });
  }

  VehiclesCompanion copyWith({
    Value<int>? idVehicle,
    Value<int?>? idDriver,
    Value<String>? licensePlate,
    Value<String>? brand,
    Value<String?>? model,
    Value<int?>? year,
    Value<VehicleStatus>? status,
    Value<int>? mileage,
    Value<int?>? gpsDeviceId,
    Value<int?>? obdDeviceId,
    Value<bool>? isActive,
  }) {
    return VehiclesCompanion(
      idVehicle: idVehicle ?? this.idVehicle,
      idDriver: idDriver ?? this.idDriver,
      licensePlate: licensePlate ?? this.licensePlate,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      year: year ?? this.year,
      status: status ?? this.status,
      mileage: mileage ?? this.mileage,
      gpsDeviceId: gpsDeviceId ?? this.gpsDeviceId,
      obdDeviceId: obdDeviceId ?? this.obdDeviceId,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (idVehicle.present) {
      map['id_vehicle'] = Variable<int>(idVehicle.value);
    }
    if (idDriver.present) {
      map['id_driver'] = Variable<int>(idDriver.value);
    }
    if (licensePlate.present) {
      map['license_plate'] = Variable<String>(licensePlate.value);
    }
    if (brand.present) {
      map['brand'] = Variable<String>(brand.value);
    }
    if (model.present) {
      map['model'] = Variable<String>(model.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $VehiclesTable.$converterstatus.toSql(status.value),
      );
    }
    if (mileage.present) {
      map['mileage'] = Variable<int>(mileage.value);
    }
    if (gpsDeviceId.present) {
      map['gps_device_id'] = Variable<int>(gpsDeviceId.value);
    }
    if (obdDeviceId.present) {
      map['obd_device_id'] = Variable<int>(obdDeviceId.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VehiclesCompanion(')
          ..write('idVehicle: $idVehicle, ')
          ..write('idDriver: $idDriver, ')
          ..write('licensePlate: $licensePlate, ')
          ..write('brand: $brand, ')
          ..write('model: $model, ')
          ..write('year: $year, ')
          ..write('status: $status, ')
          ..write('mileage: $mileage, ')
          ..write('gpsDeviceId: $gpsDeviceId, ')
          ..write('obdDeviceId: $obdDeviceId, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $RoutesTable extends Routes with TableInfo<$RoutesTable, Route> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoutesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idRouteMeta = const VerificationMeta(
    'idRoute',
  );
  @override
  late final GeneratedColumn<int> idRoute = GeneratedColumn<int>(
    'id_route',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [idRoute, name, isActive];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'routes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Route> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id_route')) {
      context.handle(
        _idRouteMeta,
        idRoute.isAcceptableOrUnknown(data['id_route']!, _idRouteMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {idRoute};
  @override
  Route map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Route(
      idRoute: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id_route'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $RoutesTable createAlias(String alias) {
    return $RoutesTable(attachedDatabase, alias);
  }
}

class Route extends DataClass implements Insertable<Route> {
  final int idRoute;
  final String name;
  final bool isActive;
  const Route({
    required this.idRoute,
    required this.name,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id_route'] = Variable<int>(idRoute);
    map['name'] = Variable<String>(name);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  RoutesCompanion toCompanion(bool nullToAbsent) {
    return RoutesCompanion(
      idRoute: Value(idRoute),
      name: Value(name),
      isActive: Value(isActive),
    );
  }

  factory Route.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Route(
      idRoute: serializer.fromJson<int>(json['idRoute']),
      name: serializer.fromJson<String>(json['name']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'idRoute': serializer.toJson<int>(idRoute),
      'name': serializer.toJson<String>(name),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  Route copyWith({int? idRoute, String? name, bool? isActive}) => Route(
    idRoute: idRoute ?? this.idRoute,
    name: name ?? this.name,
    isActive: isActive ?? this.isActive,
  );
  Route copyWithCompanion(RoutesCompanion data) {
    return Route(
      idRoute: data.idRoute.present ? data.idRoute.value : this.idRoute,
      name: data.name.present ? data.name.value : this.name,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Route(')
          ..write('idRoute: $idRoute, ')
          ..write('name: $name, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(idRoute, name, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Route &&
          other.idRoute == this.idRoute &&
          other.name == this.name &&
          other.isActive == this.isActive);
}

class RoutesCompanion extends UpdateCompanion<Route> {
  final Value<int> idRoute;
  final Value<String> name;
  final Value<bool> isActive;
  const RoutesCompanion({
    this.idRoute = const Value.absent(),
    this.name = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  RoutesCompanion.insert({
    this.idRoute = const Value.absent(),
    required String name,
    this.isActive = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Route> custom({
    Expression<int>? idRoute,
    Expression<String>? name,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (idRoute != null) 'id_route': idRoute,
      if (name != null) 'name': name,
      if (isActive != null) 'is_active': isActive,
    });
  }

  RoutesCompanion copyWith({
    Value<int>? idRoute,
    Value<String>? name,
    Value<bool>? isActive,
  }) {
    return RoutesCompanion(
      idRoute: idRoute ?? this.idRoute,
      name: name ?? this.name,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (idRoute.present) {
      map['id_route'] = Variable<int>(idRoute.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoutesCompanion(')
          ..write('idRoute: $idRoute, ')
          ..write('name: $name, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $StopsTable extends Stops with TableInfo<$StopsTable, Stop> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StopsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idStopMeta = const VerificationMeta('idStop');
  @override
  late final GeneratedColumn<int> idStop = GeneratedColumn<int>(
    'id_stop',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _idRouteMeta = const VerificationMeta(
    'idRoute',
  );
  @override
  late final GeneratedColumn<int> idRoute = GeneratedColumn<int>(
    'id_route',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES routes(id_route)',
  );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    idStop,
    idRoute,
    latitude,
    longitude,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stops';
  @override
  VerificationContext validateIntegrity(
    Insertable<Stop> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id_stop')) {
      context.handle(
        _idStopMeta,
        idStop.isAcceptableOrUnknown(data['id_stop']!, _idStopMeta),
      );
    }
    if (data.containsKey('id_route')) {
      context.handle(
        _idRouteMeta,
        idRoute.isAcceptableOrUnknown(data['id_route']!, _idRouteMeta),
      );
    } else if (isInserting) {
      context.missing(_idRouteMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {idStop};
  @override
  Stop map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Stop(
      idStop: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id_stop'],
      )!,
      idRoute: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id_route'],
      )!,
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      )!,
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $StopsTable createAlias(String alias) {
    return $StopsTable(attachedDatabase, alias);
  }
}

class Stop extends DataClass implements Insertable<Stop> {
  final int idStop;
  final int idRoute;
  final double latitude;
  final double longitude;
  final bool isActive;
  const Stop({
    required this.idStop,
    required this.idRoute,
    required this.latitude,
    required this.longitude,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id_stop'] = Variable<int>(idStop);
    map['id_route'] = Variable<int>(idRoute);
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  StopsCompanion toCompanion(bool nullToAbsent) {
    return StopsCompanion(
      idStop: Value(idStop),
      idRoute: Value(idRoute),
      latitude: Value(latitude),
      longitude: Value(longitude),
      isActive: Value(isActive),
    );
  }

  factory Stop.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Stop(
      idStop: serializer.fromJson<int>(json['idStop']),
      idRoute: serializer.fromJson<int>(json['idRoute']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'idStop': serializer.toJson<int>(idStop),
      'idRoute': serializer.toJson<int>(idRoute),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  Stop copyWith({
    int? idStop,
    int? idRoute,
    double? latitude,
    double? longitude,
    bool? isActive,
  }) => Stop(
    idStop: idStop ?? this.idStop,
    idRoute: idRoute ?? this.idRoute,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    isActive: isActive ?? this.isActive,
  );
  Stop copyWithCompanion(StopsCompanion data) {
    return Stop(
      idStop: data.idStop.present ? data.idStop.value : this.idStop,
      idRoute: data.idRoute.present ? data.idRoute.value : this.idRoute,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Stop(')
          ..write('idStop: $idStop, ')
          ..write('idRoute: $idRoute, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(idStop, idRoute, latitude, longitude, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Stop &&
          other.idStop == this.idStop &&
          other.idRoute == this.idRoute &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.isActive == this.isActive);
}

class StopsCompanion extends UpdateCompanion<Stop> {
  final Value<int> idStop;
  final Value<int> idRoute;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<bool> isActive;
  const StopsCompanion({
    this.idStop = const Value.absent(),
    this.idRoute = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  StopsCompanion.insert({
    this.idStop = const Value.absent(),
    required int idRoute,
    required double latitude,
    required double longitude,
    this.isActive = const Value.absent(),
  }) : idRoute = Value(idRoute),
       latitude = Value(latitude),
       longitude = Value(longitude);
  static Insertable<Stop> custom({
    Expression<int>? idStop,
    Expression<int>? idRoute,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (idStop != null) 'id_stop': idStop,
      if (idRoute != null) 'id_route': idRoute,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (isActive != null) 'is_active': isActive,
    });
  }

  StopsCompanion copyWith({
    Value<int>? idStop,
    Value<int>? idRoute,
    Value<double>? latitude,
    Value<double>? longitude,
    Value<bool>? isActive,
  }) {
    return StopsCompanion(
      idStop: idStop ?? this.idStop,
      idRoute: idRoute ?? this.idRoute,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (idStop.present) {
      map['id_stop'] = Variable<int>(idStop.value);
    }
    if (idRoute.present) {
      map['id_route'] = Variable<int>(idRoute.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StopsCompanion(')
          ..write('idStop: $idStop, ')
          ..write('idRoute: $idRoute, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $RouteAssignmentsTable extends RouteAssignments
    with TableInfo<$RouteAssignmentsTable, RouteAssignment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RouteAssignmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idAssignmentMeta = const VerificationMeta(
    'idAssignment',
  );
  @override
  late final GeneratedColumn<int> idAssignment = GeneratedColumn<int>(
    'id_assignment',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _idRouteMeta = const VerificationMeta(
    'idRoute',
  );
  @override
  late final GeneratedColumn<int> idRoute = GeneratedColumn<int>(
    'id_route',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES routes(id_route)',
  );
  static const VerificationMeta _idVehicleMeta = const VerificationMeta(
    'idVehicle',
  );
  @override
  late final GeneratedColumn<int> idVehicle = GeneratedColumn<int>(
    'id_vehicle',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES vehicles(id_vehicle)',
  );
  static const VerificationMeta _assignedDateMeta = const VerificationMeta(
    'assignedDate',
  );
  @override
  late final GeneratedColumn<DateTime> assignedDate = GeneratedColumn<DateTime>(
    'assigned_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    idAssignment,
    idRoute,
    idVehicle,
    assignedDate,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'route_assignments';
  @override
  VerificationContext validateIntegrity(
    Insertable<RouteAssignment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id_assignment')) {
      context.handle(
        _idAssignmentMeta,
        idAssignment.isAcceptableOrUnknown(
          data['id_assignment']!,
          _idAssignmentMeta,
        ),
      );
    }
    if (data.containsKey('id_route')) {
      context.handle(
        _idRouteMeta,
        idRoute.isAcceptableOrUnknown(data['id_route']!, _idRouteMeta),
      );
    } else if (isInserting) {
      context.missing(_idRouteMeta);
    }
    if (data.containsKey('id_vehicle')) {
      context.handle(
        _idVehicleMeta,
        idVehicle.isAcceptableOrUnknown(data['id_vehicle']!, _idVehicleMeta),
      );
    } else if (isInserting) {
      context.missing(_idVehicleMeta);
    }
    if (data.containsKey('assigned_date')) {
      context.handle(
        _assignedDateMeta,
        assignedDate.isAcceptableOrUnknown(
          data['assigned_date']!,
          _assignedDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_assignedDateMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {idAssignment};
  @override
  RouteAssignment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RouteAssignment(
      idAssignment: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id_assignment'],
      )!,
      idRoute: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id_route'],
      )!,
      idVehicle: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id_vehicle'],
      )!,
      assignedDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}assigned_date'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $RouteAssignmentsTable createAlias(String alias) {
    return $RouteAssignmentsTable(attachedDatabase, alias);
  }
}

class RouteAssignment extends DataClass implements Insertable<RouteAssignment> {
  final int idAssignment;
  final int idRoute;
  final int idVehicle;
  final DateTime assignedDate;
  final bool isActive;
  const RouteAssignment({
    required this.idAssignment,
    required this.idRoute,
    required this.idVehicle,
    required this.assignedDate,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id_assignment'] = Variable<int>(idAssignment);
    map['id_route'] = Variable<int>(idRoute);
    map['id_vehicle'] = Variable<int>(idVehicle);
    map['assigned_date'] = Variable<DateTime>(assignedDate);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  RouteAssignmentsCompanion toCompanion(bool nullToAbsent) {
    return RouteAssignmentsCompanion(
      idAssignment: Value(idAssignment),
      idRoute: Value(idRoute),
      idVehicle: Value(idVehicle),
      assignedDate: Value(assignedDate),
      isActive: Value(isActive),
    );
  }

  factory RouteAssignment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RouteAssignment(
      idAssignment: serializer.fromJson<int>(json['idAssignment']),
      idRoute: serializer.fromJson<int>(json['idRoute']),
      idVehicle: serializer.fromJson<int>(json['idVehicle']),
      assignedDate: serializer.fromJson<DateTime>(json['assignedDate']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'idAssignment': serializer.toJson<int>(idAssignment),
      'idRoute': serializer.toJson<int>(idRoute),
      'idVehicle': serializer.toJson<int>(idVehicle),
      'assignedDate': serializer.toJson<DateTime>(assignedDate),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  RouteAssignment copyWith({
    int? idAssignment,
    int? idRoute,
    int? idVehicle,
    DateTime? assignedDate,
    bool? isActive,
  }) => RouteAssignment(
    idAssignment: idAssignment ?? this.idAssignment,
    idRoute: idRoute ?? this.idRoute,
    idVehicle: idVehicle ?? this.idVehicle,
    assignedDate: assignedDate ?? this.assignedDate,
    isActive: isActive ?? this.isActive,
  );
  RouteAssignment copyWithCompanion(RouteAssignmentsCompanion data) {
    return RouteAssignment(
      idAssignment: data.idAssignment.present
          ? data.idAssignment.value
          : this.idAssignment,
      idRoute: data.idRoute.present ? data.idRoute.value : this.idRoute,
      idVehicle: data.idVehicle.present ? data.idVehicle.value : this.idVehicle,
      assignedDate: data.assignedDate.present
          ? data.assignedDate.value
          : this.assignedDate,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RouteAssignment(')
          ..write('idAssignment: $idAssignment, ')
          ..write('idRoute: $idRoute, ')
          ..write('idVehicle: $idVehicle, ')
          ..write('assignedDate: $assignedDate, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(idAssignment, idRoute, idVehicle, assignedDate, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RouteAssignment &&
          other.idAssignment == this.idAssignment &&
          other.idRoute == this.idRoute &&
          other.idVehicle == this.idVehicle &&
          other.assignedDate == this.assignedDate &&
          other.isActive == this.isActive);
}

class RouteAssignmentsCompanion extends UpdateCompanion<RouteAssignment> {
  final Value<int> idAssignment;
  final Value<int> idRoute;
  final Value<int> idVehicle;
  final Value<DateTime> assignedDate;
  final Value<bool> isActive;
  const RouteAssignmentsCompanion({
    this.idAssignment = const Value.absent(),
    this.idRoute = const Value.absent(),
    this.idVehicle = const Value.absent(),
    this.assignedDate = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  RouteAssignmentsCompanion.insert({
    this.idAssignment = const Value.absent(),
    required int idRoute,
    required int idVehicle,
    required DateTime assignedDate,
    this.isActive = const Value.absent(),
  }) : idRoute = Value(idRoute),
       idVehicle = Value(idVehicle),
       assignedDate = Value(assignedDate);
  static Insertable<RouteAssignment> custom({
    Expression<int>? idAssignment,
    Expression<int>? idRoute,
    Expression<int>? idVehicle,
    Expression<DateTime>? assignedDate,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (idAssignment != null) 'id_assignment': idAssignment,
      if (idRoute != null) 'id_route': idRoute,
      if (idVehicle != null) 'id_vehicle': idVehicle,
      if (assignedDate != null) 'assigned_date': assignedDate,
      if (isActive != null) 'is_active': isActive,
    });
  }

  RouteAssignmentsCompanion copyWith({
    Value<int>? idAssignment,
    Value<int>? idRoute,
    Value<int>? idVehicle,
    Value<DateTime>? assignedDate,
    Value<bool>? isActive,
  }) {
    return RouteAssignmentsCompanion(
      idAssignment: idAssignment ?? this.idAssignment,
      idRoute: idRoute ?? this.idRoute,
      idVehicle: idVehicle ?? this.idVehicle,
      assignedDate: assignedDate ?? this.assignedDate,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (idAssignment.present) {
      map['id_assignment'] = Variable<int>(idAssignment.value);
    }
    if (idRoute.present) {
      map['id_route'] = Variable<int>(idRoute.value);
    }
    if (idVehicle.present) {
      map['id_vehicle'] = Variable<int>(idVehicle.value);
    }
    if (assignedDate.present) {
      map['assigned_date'] = Variable<DateTime>(assignedDate.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RouteAssignmentsCompanion(')
          ..write('idAssignment: $idAssignment, ')
          ..write('idRoute: $idRoute, ')
          ..write('idVehicle: $idVehicle, ')
          ..write('assignedDate: $assignedDate, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $MaintenancesTable extends Maintenances
    with TableInfo<$MaintenancesTable, Maintenance> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MaintenancesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMaintenanceMeta = const VerificationMeta(
    'idMaintenance',
  );
  @override
  late final GeneratedColumn<int> idMaintenance = GeneratedColumn<int>(
    'id_maintenance',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _idVehicleMeta = const VerificationMeta(
    'idVehicle',
  );
  @override
  late final GeneratedColumn<int> idVehicle = GeneratedColumn<int>(
    'id_vehicle',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES vehicles(id_vehicle)',
  );
  static const VerificationMeta _maintenanceDateMeta = const VerificationMeta(
    'maintenanceDate',
  );
  @override
  late final GeneratedColumn<DateTime> maintenanceDate =
      GeneratedColumn<DateTime>(
        'maintenance_date',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _vehicleMileageMeta = const VerificationMeta(
    'vehicleMileage',
  );
  @override
  late final GeneratedColumn<int> vehicleMileage = GeneratedColumn<int>(
    'vehicle_mileage',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _detailsMeta = const VerificationMeta(
    'details',
  );
  @override
  late final GeneratedColumn<String> details = GeneratedColumn<String>(
    'details',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    idMaintenance,
    idVehicle,
    maintenanceDate,
    vehicleMileage,
    details,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'maintenances';
  @override
  VerificationContext validateIntegrity(
    Insertable<Maintenance> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id_maintenance')) {
      context.handle(
        _idMaintenanceMeta,
        idMaintenance.isAcceptableOrUnknown(
          data['id_maintenance']!,
          _idMaintenanceMeta,
        ),
      );
    }
    if (data.containsKey('id_vehicle')) {
      context.handle(
        _idVehicleMeta,
        idVehicle.isAcceptableOrUnknown(data['id_vehicle']!, _idVehicleMeta),
      );
    } else if (isInserting) {
      context.missing(_idVehicleMeta);
    }
    if (data.containsKey('maintenance_date')) {
      context.handle(
        _maintenanceDateMeta,
        maintenanceDate.isAcceptableOrUnknown(
          data['maintenance_date']!,
          _maintenanceDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_maintenanceDateMeta);
    }
    if (data.containsKey('vehicle_mileage')) {
      context.handle(
        _vehicleMileageMeta,
        vehicleMileage.isAcceptableOrUnknown(
          data['vehicle_mileage']!,
          _vehicleMileageMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_vehicleMileageMeta);
    }
    if (data.containsKey('details')) {
      context.handle(
        _detailsMeta,
        details.isAcceptableOrUnknown(data['details']!, _detailsMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {idMaintenance};
  @override
  Maintenance map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Maintenance(
      idMaintenance: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id_maintenance'],
      )!,
      idVehicle: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id_vehicle'],
      )!,
      maintenanceDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}maintenance_date'],
      )!,
      vehicleMileage: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}vehicle_mileage'],
      )!,
      details: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}details'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $MaintenancesTable createAlias(String alias) {
    return $MaintenancesTable(attachedDatabase, alias);
  }
}

class Maintenance extends DataClass implements Insertable<Maintenance> {
  final int idMaintenance;
  final int idVehicle;
  final DateTime maintenanceDate;
  final int vehicleMileage;
  final String? details;
  final bool isActive;
  const Maintenance({
    required this.idMaintenance,
    required this.idVehicle,
    required this.maintenanceDate,
    required this.vehicleMileage,
    this.details,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id_maintenance'] = Variable<int>(idMaintenance);
    map['id_vehicle'] = Variable<int>(idVehicle);
    map['maintenance_date'] = Variable<DateTime>(maintenanceDate);
    map['vehicle_mileage'] = Variable<int>(vehicleMileage);
    if (!nullToAbsent || details != null) {
      map['details'] = Variable<String>(details);
    }
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  MaintenancesCompanion toCompanion(bool nullToAbsent) {
    return MaintenancesCompanion(
      idMaintenance: Value(idMaintenance),
      idVehicle: Value(idVehicle),
      maintenanceDate: Value(maintenanceDate),
      vehicleMileage: Value(vehicleMileage),
      details: details == null && nullToAbsent
          ? const Value.absent()
          : Value(details),
      isActive: Value(isActive),
    );
  }

  factory Maintenance.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Maintenance(
      idMaintenance: serializer.fromJson<int>(json['idMaintenance']),
      idVehicle: serializer.fromJson<int>(json['idVehicle']),
      maintenanceDate: serializer.fromJson<DateTime>(json['maintenanceDate']),
      vehicleMileage: serializer.fromJson<int>(json['vehicleMileage']),
      details: serializer.fromJson<String?>(json['details']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'idMaintenance': serializer.toJson<int>(idMaintenance),
      'idVehicle': serializer.toJson<int>(idVehicle),
      'maintenanceDate': serializer.toJson<DateTime>(maintenanceDate),
      'vehicleMileage': serializer.toJson<int>(vehicleMileage),
      'details': serializer.toJson<String?>(details),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  Maintenance copyWith({
    int? idMaintenance,
    int? idVehicle,
    DateTime? maintenanceDate,
    int? vehicleMileage,
    Value<String?> details = const Value.absent(),
    bool? isActive,
  }) => Maintenance(
    idMaintenance: idMaintenance ?? this.idMaintenance,
    idVehicle: idVehicle ?? this.idVehicle,
    maintenanceDate: maintenanceDate ?? this.maintenanceDate,
    vehicleMileage: vehicleMileage ?? this.vehicleMileage,
    details: details.present ? details.value : this.details,
    isActive: isActive ?? this.isActive,
  );
  Maintenance copyWithCompanion(MaintenancesCompanion data) {
    return Maintenance(
      idMaintenance: data.idMaintenance.present
          ? data.idMaintenance.value
          : this.idMaintenance,
      idVehicle: data.idVehicle.present ? data.idVehicle.value : this.idVehicle,
      maintenanceDate: data.maintenanceDate.present
          ? data.maintenanceDate.value
          : this.maintenanceDate,
      vehicleMileage: data.vehicleMileage.present
          ? data.vehicleMileage.value
          : this.vehicleMileage,
      details: data.details.present ? data.details.value : this.details,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Maintenance(')
          ..write('idMaintenance: $idMaintenance, ')
          ..write('idVehicle: $idVehicle, ')
          ..write('maintenanceDate: $maintenanceDate, ')
          ..write('vehicleMileage: $vehicleMileage, ')
          ..write('details: $details, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    idMaintenance,
    idVehicle,
    maintenanceDate,
    vehicleMileage,
    details,
    isActive,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Maintenance &&
          other.idMaintenance == this.idMaintenance &&
          other.idVehicle == this.idVehicle &&
          other.maintenanceDate == this.maintenanceDate &&
          other.vehicleMileage == this.vehicleMileage &&
          other.details == this.details &&
          other.isActive == this.isActive);
}

class MaintenancesCompanion extends UpdateCompanion<Maintenance> {
  final Value<int> idMaintenance;
  final Value<int> idVehicle;
  final Value<DateTime> maintenanceDate;
  final Value<int> vehicleMileage;
  final Value<String?> details;
  final Value<bool> isActive;
  const MaintenancesCompanion({
    this.idMaintenance = const Value.absent(),
    this.idVehicle = const Value.absent(),
    this.maintenanceDate = const Value.absent(),
    this.vehicleMileage = const Value.absent(),
    this.details = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  MaintenancesCompanion.insert({
    this.idMaintenance = const Value.absent(),
    required int idVehicle,
    required DateTime maintenanceDate,
    required int vehicleMileage,
    this.details = const Value.absent(),
    this.isActive = const Value.absent(),
  }) : idVehicle = Value(idVehicle),
       maintenanceDate = Value(maintenanceDate),
       vehicleMileage = Value(vehicleMileage);
  static Insertable<Maintenance> custom({
    Expression<int>? idMaintenance,
    Expression<int>? idVehicle,
    Expression<DateTime>? maintenanceDate,
    Expression<int>? vehicleMileage,
    Expression<String>? details,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (idMaintenance != null) 'id_maintenance': idMaintenance,
      if (idVehicle != null) 'id_vehicle': idVehicle,
      if (maintenanceDate != null) 'maintenance_date': maintenanceDate,
      if (vehicleMileage != null) 'vehicle_mileage': vehicleMileage,
      if (details != null) 'details': details,
      if (isActive != null) 'is_active': isActive,
    });
  }

  MaintenancesCompanion copyWith({
    Value<int>? idMaintenance,
    Value<int>? idVehicle,
    Value<DateTime>? maintenanceDate,
    Value<int>? vehicleMileage,
    Value<String?>? details,
    Value<bool>? isActive,
  }) {
    return MaintenancesCompanion(
      idMaintenance: idMaintenance ?? this.idMaintenance,
      idVehicle: idVehicle ?? this.idVehicle,
      maintenanceDate: maintenanceDate ?? this.maintenanceDate,
      vehicleMileage: vehicleMileage ?? this.vehicleMileage,
      details: details ?? this.details,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (idMaintenance.present) {
      map['id_maintenance'] = Variable<int>(idMaintenance.value);
    }
    if (idVehicle.present) {
      map['id_vehicle'] = Variable<int>(idVehicle.value);
    }
    if (maintenanceDate.present) {
      map['maintenance_date'] = Variable<DateTime>(maintenanceDate.value);
    }
    if (vehicleMileage.present) {
      map['vehicle_mileage'] = Variable<int>(vehicleMileage.value);
    }
    if (details.present) {
      map['details'] = Variable<String>(details.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MaintenancesCompanion(')
          ..write('idMaintenance: $idMaintenance, ')
          ..write('idVehicle: $idVehicle, ')
          ..write('maintenanceDate: $maintenanceDate, ')
          ..write('vehicleMileage: $vehicleMileage, ')
          ..write('details: $details, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $MaintenanceDetailsTable extends MaintenanceDetails
    with TableInfo<$MaintenanceDetailsTable, MaintenanceDetail> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MaintenanceDetailsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idDetailMeta = const VerificationMeta(
    'idDetail',
  );
  @override
  late final GeneratedColumn<int> idDetail = GeneratedColumn<int>(
    'id_detail',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _idMaintenanceMeta = const VerificationMeta(
    'idMaintenance',
  );
  @override
  late final GeneratedColumn<int> idMaintenance = GeneratedColumn<int>(
    'id_maintenance',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES maintenances(id_maintenance)',
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _costMeta = const VerificationMeta('cost');
  @override
  late final GeneratedColumn<double> cost = GeneratedColumn<double>(
    'cost',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    idDetail,
    idMaintenance,
    description,
    cost,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'maintenance_details';
  @override
  VerificationContext validateIntegrity(
    Insertable<MaintenanceDetail> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id_detail')) {
      context.handle(
        _idDetailMeta,
        idDetail.isAcceptableOrUnknown(data['id_detail']!, _idDetailMeta),
      );
    }
    if (data.containsKey('id_maintenance')) {
      context.handle(
        _idMaintenanceMeta,
        idMaintenance.isAcceptableOrUnknown(
          data['id_maintenance']!,
          _idMaintenanceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_idMaintenanceMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('cost')) {
      context.handle(
        _costMeta,
        cost.isAcceptableOrUnknown(data['cost']!, _costMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {idDetail};
  @override
  MaintenanceDetail map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MaintenanceDetail(
      idDetail: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id_detail'],
      )!,
      idMaintenance: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id_maintenance'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      cost: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}cost'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $MaintenanceDetailsTable createAlias(String alias) {
    return $MaintenanceDetailsTable(attachedDatabase, alias);
  }
}

class MaintenanceDetail extends DataClass
    implements Insertable<MaintenanceDetail> {
  final int idDetail;
  final int idMaintenance;
  final String description;
  final double cost;
  final bool isActive;
  const MaintenanceDetail({
    required this.idDetail,
    required this.idMaintenance,
    required this.description,
    required this.cost,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id_detail'] = Variable<int>(idDetail);
    map['id_maintenance'] = Variable<int>(idMaintenance);
    map['description'] = Variable<String>(description);
    map['cost'] = Variable<double>(cost);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  MaintenanceDetailsCompanion toCompanion(bool nullToAbsent) {
    return MaintenanceDetailsCompanion(
      idDetail: Value(idDetail),
      idMaintenance: Value(idMaintenance),
      description: Value(description),
      cost: Value(cost),
      isActive: Value(isActive),
    );
  }

  factory MaintenanceDetail.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MaintenanceDetail(
      idDetail: serializer.fromJson<int>(json['idDetail']),
      idMaintenance: serializer.fromJson<int>(json['idMaintenance']),
      description: serializer.fromJson<String>(json['description']),
      cost: serializer.fromJson<double>(json['cost']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'idDetail': serializer.toJson<int>(idDetail),
      'idMaintenance': serializer.toJson<int>(idMaintenance),
      'description': serializer.toJson<String>(description),
      'cost': serializer.toJson<double>(cost),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  MaintenanceDetail copyWith({
    int? idDetail,
    int? idMaintenance,
    String? description,
    double? cost,
    bool? isActive,
  }) => MaintenanceDetail(
    idDetail: idDetail ?? this.idDetail,
    idMaintenance: idMaintenance ?? this.idMaintenance,
    description: description ?? this.description,
    cost: cost ?? this.cost,
    isActive: isActive ?? this.isActive,
  );
  MaintenanceDetail copyWithCompanion(MaintenanceDetailsCompanion data) {
    return MaintenanceDetail(
      idDetail: data.idDetail.present ? data.idDetail.value : this.idDetail,
      idMaintenance: data.idMaintenance.present
          ? data.idMaintenance.value
          : this.idMaintenance,
      description: data.description.present
          ? data.description.value
          : this.description,
      cost: data.cost.present ? data.cost.value : this.cost,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MaintenanceDetail(')
          ..write('idDetail: $idDetail, ')
          ..write('idMaintenance: $idMaintenance, ')
          ..write('description: $description, ')
          ..write('cost: $cost, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(idDetail, idMaintenance, description, cost, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MaintenanceDetail &&
          other.idDetail == this.idDetail &&
          other.idMaintenance == this.idMaintenance &&
          other.description == this.description &&
          other.cost == this.cost &&
          other.isActive == this.isActive);
}

class MaintenanceDetailsCompanion extends UpdateCompanion<MaintenanceDetail> {
  final Value<int> idDetail;
  final Value<int> idMaintenance;
  final Value<String> description;
  final Value<double> cost;
  final Value<bool> isActive;
  const MaintenanceDetailsCompanion({
    this.idDetail = const Value.absent(),
    this.idMaintenance = const Value.absent(),
    this.description = const Value.absent(),
    this.cost = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  MaintenanceDetailsCompanion.insert({
    this.idDetail = const Value.absent(),
    required int idMaintenance,
    required String description,
    this.cost = const Value.absent(),
    this.isActive = const Value.absent(),
  }) : idMaintenance = Value(idMaintenance),
       description = Value(description);
  static Insertable<MaintenanceDetail> custom({
    Expression<int>? idDetail,
    Expression<int>? idMaintenance,
    Expression<String>? description,
    Expression<double>? cost,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (idDetail != null) 'id_detail': idDetail,
      if (idMaintenance != null) 'id_maintenance': idMaintenance,
      if (description != null) 'description': description,
      if (cost != null) 'cost': cost,
      if (isActive != null) 'is_active': isActive,
    });
  }

  MaintenanceDetailsCompanion copyWith({
    Value<int>? idDetail,
    Value<int>? idMaintenance,
    Value<String>? description,
    Value<double>? cost,
    Value<bool>? isActive,
  }) {
    return MaintenanceDetailsCompanion(
      idDetail: idDetail ?? this.idDetail,
      idMaintenance: idMaintenance ?? this.idMaintenance,
      description: description ?? this.description,
      cost: cost ?? this.cost,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (idDetail.present) {
      map['id_detail'] = Variable<int>(idDetail.value);
    }
    if (idMaintenance.present) {
      map['id_maintenance'] = Variable<int>(idMaintenance.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (cost.present) {
      map['cost'] = Variable<double>(cost.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MaintenanceDetailsCompanion(')
          ..write('idDetail: $idDetail, ')
          ..write('idMaintenance: $idMaintenance, ')
          ..write('description: $description, ')
          ..write('cost: $cost, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $GpsDevicesTable gpsDevices = $GpsDevicesTable(this);
  late final $ObdDevicesTable obdDevices = $ObdDevicesTable(this);
  late final $DriversTable drivers = $DriversTable(this);
  late final $VehiclesTable vehicles = $VehiclesTable(this);
  late final $RoutesTable routes = $RoutesTable(this);
  late final $StopsTable stops = $StopsTable(this);
  late final $RouteAssignmentsTable routeAssignments = $RouteAssignmentsTable(
    this,
  );
  late final $MaintenancesTable maintenances = $MaintenancesTable(this);
  late final $MaintenanceDetailsTable maintenanceDetails =
      $MaintenanceDetailsTable(this);
  late final GpsDevicesDao gpsDevicesDao = GpsDevicesDao(this as AppDatabase);
  late final ObdDevicesDao obdDevicesDao = ObdDevicesDao(this as AppDatabase);
  late final VehiclesDao vehiclesDao = VehiclesDao(this as AppDatabase);
  late final DriversDao driversDao = DriversDao(this as AppDatabase);
  late final StopsDao stopsDao = StopsDao(this as AppDatabase);
  late final RoutesDao routesDao = RoutesDao(this as AppDatabase);
  late final RouteAssignmentsDao routeAssignmentsDao = RouteAssignmentsDao(
    this as AppDatabase,
  );
  late final MaintenancesDao maintenancesDao = MaintenancesDao(
    this as AppDatabase,
  );
  late final MaintenanceDetailsDao maintenanceDetailsDao =
      MaintenanceDetailsDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    gpsDevices,
    obdDevices,
    drivers,
    vehicles,
    routes,
    stops,
    routeAssignments,
    maintenances,
    maintenanceDetails,
  ];
}

typedef $$GpsDevicesTableCreateCompanionBuilder =
    GpsDevicesCompanion Function({
      Value<int> idGps,
      Value<String?> model,
      required String serialNumber,
      Value<DateTime?> installedAt,
      Value<bool> isActive,
    });
typedef $$GpsDevicesTableUpdateCompanionBuilder =
    GpsDevicesCompanion Function({
      Value<int> idGps,
      Value<String?> model,
      Value<String> serialNumber,
      Value<DateTime?> installedAt,
      Value<bool> isActive,
    });

final class $$GpsDevicesTableReferences
    extends BaseReferences<_$AppDatabase, $GpsDevicesTable, GpsDevice> {
  $$GpsDevicesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$VehiclesTable, List<Vehicle>> _vehiclesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.vehicles,
    aliasName: $_aliasNameGenerator(
      db.gpsDevices.idGps,
      db.vehicles.gpsDeviceId,
    ),
  );

  $$VehiclesTableProcessedTableManager get vehiclesRefs {
    final manager = $$VehiclesTableTableManager($_db, $_db.vehicles).filter(
      (f) => f.gpsDeviceId.idGps.sqlEquals($_itemColumn<int>('id_gps')!),
    );

    final cache = $_typedResult.readTableOrNull(_vehiclesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$GpsDevicesTableFilterComposer
    extends Composer<_$AppDatabase, $GpsDevicesTable> {
  $$GpsDevicesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get idGps => $composableBuilder(
    column: $table.idGps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serialNumber => $composableBuilder(
    column: $table.serialNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get installedAt => $composableBuilder(
    column: $table.installedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> vehiclesRefs(
    Expression<bool> Function($$VehiclesTableFilterComposer f) f,
  ) {
    final $$VehiclesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idGps,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.gpsDeviceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableFilterComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GpsDevicesTableOrderingComposer
    extends Composer<_$AppDatabase, $GpsDevicesTable> {
  $$GpsDevicesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get idGps => $composableBuilder(
    column: $table.idGps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serialNumber => $composableBuilder(
    column: $table.serialNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get installedAt => $composableBuilder(
    column: $table.installedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GpsDevicesTableAnnotationComposer
    extends Composer<_$AppDatabase, $GpsDevicesTable> {
  $$GpsDevicesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get idGps =>
      $composableBuilder(column: $table.idGps, builder: (column) => column);

  GeneratedColumn<String> get model =>
      $composableBuilder(column: $table.model, builder: (column) => column);

  GeneratedColumn<String> get serialNumber => $composableBuilder(
    column: $table.serialNumber,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get installedAt => $composableBuilder(
    column: $table.installedAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  Expression<T> vehiclesRefs<T extends Object>(
    Expression<T> Function($$VehiclesTableAnnotationComposer a) f,
  ) {
    final $$VehiclesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idGps,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.gpsDeviceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableAnnotationComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GpsDevicesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GpsDevicesTable,
          GpsDevice,
          $$GpsDevicesTableFilterComposer,
          $$GpsDevicesTableOrderingComposer,
          $$GpsDevicesTableAnnotationComposer,
          $$GpsDevicesTableCreateCompanionBuilder,
          $$GpsDevicesTableUpdateCompanionBuilder,
          (GpsDevice, $$GpsDevicesTableReferences),
          GpsDevice,
          PrefetchHooks Function({bool vehiclesRefs})
        > {
  $$GpsDevicesTableTableManager(_$AppDatabase db, $GpsDevicesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GpsDevicesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GpsDevicesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GpsDevicesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> idGps = const Value.absent(),
                Value<String?> model = const Value.absent(),
                Value<String> serialNumber = const Value.absent(),
                Value<DateTime?> installedAt = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => GpsDevicesCompanion(
                idGps: idGps,
                model: model,
                serialNumber: serialNumber,
                installedAt: installedAt,
                isActive: isActive,
              ),
          createCompanionCallback:
              ({
                Value<int> idGps = const Value.absent(),
                Value<String?> model = const Value.absent(),
                required String serialNumber,
                Value<DateTime?> installedAt = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => GpsDevicesCompanion.insert(
                idGps: idGps,
                model: model,
                serialNumber: serialNumber,
                installedAt: installedAt,
                isActive: isActive,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$GpsDevicesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({vehiclesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (vehiclesRefs) db.vehicles],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (vehiclesRefs)
                    await $_getPrefetchedData<
                      GpsDevice,
                      $GpsDevicesTable,
                      Vehicle
                    >(
                      currentTable: table,
                      referencedTable: $$GpsDevicesTableReferences
                          ._vehiclesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$GpsDevicesTableReferences(
                            db,
                            table,
                            p0,
                          ).vehiclesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.gpsDeviceId == item.idGps,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$GpsDevicesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GpsDevicesTable,
      GpsDevice,
      $$GpsDevicesTableFilterComposer,
      $$GpsDevicesTableOrderingComposer,
      $$GpsDevicesTableAnnotationComposer,
      $$GpsDevicesTableCreateCompanionBuilder,
      $$GpsDevicesTableUpdateCompanionBuilder,
      (GpsDevice, $$GpsDevicesTableReferences),
      GpsDevice,
      PrefetchHooks Function({bool vehiclesRefs})
    >;
typedef $$ObdDevicesTableCreateCompanionBuilder =
    ObdDevicesCompanion Function({
      Value<int> idObd,
      Value<String?> model,
      required String serialNumber,
      Value<DateTime?> installedAt,
      Value<bool> isActive,
    });
typedef $$ObdDevicesTableUpdateCompanionBuilder =
    ObdDevicesCompanion Function({
      Value<int> idObd,
      Value<String?> model,
      Value<String> serialNumber,
      Value<DateTime?> installedAt,
      Value<bool> isActive,
    });

final class $$ObdDevicesTableReferences
    extends BaseReferences<_$AppDatabase, $ObdDevicesTable, ObdDevice> {
  $$ObdDevicesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$VehiclesTable, List<Vehicle>> _vehiclesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.vehicles,
    aliasName: $_aliasNameGenerator(
      db.obdDevices.idObd,
      db.vehicles.obdDeviceId,
    ),
  );

  $$VehiclesTableProcessedTableManager get vehiclesRefs {
    final manager = $$VehiclesTableTableManager($_db, $_db.vehicles).filter(
      (f) => f.obdDeviceId.idObd.sqlEquals($_itemColumn<int>('id_obd')!),
    );

    final cache = $_typedResult.readTableOrNull(_vehiclesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ObdDevicesTableFilterComposer
    extends Composer<_$AppDatabase, $ObdDevicesTable> {
  $$ObdDevicesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get idObd => $composableBuilder(
    column: $table.idObd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serialNumber => $composableBuilder(
    column: $table.serialNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get installedAt => $composableBuilder(
    column: $table.installedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> vehiclesRefs(
    Expression<bool> Function($$VehiclesTableFilterComposer f) f,
  ) {
    final $$VehiclesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idObd,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.obdDeviceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableFilterComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ObdDevicesTableOrderingComposer
    extends Composer<_$AppDatabase, $ObdDevicesTable> {
  $$ObdDevicesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get idObd => $composableBuilder(
    column: $table.idObd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serialNumber => $composableBuilder(
    column: $table.serialNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get installedAt => $composableBuilder(
    column: $table.installedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ObdDevicesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ObdDevicesTable> {
  $$ObdDevicesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get idObd =>
      $composableBuilder(column: $table.idObd, builder: (column) => column);

  GeneratedColumn<String> get model =>
      $composableBuilder(column: $table.model, builder: (column) => column);

  GeneratedColumn<String> get serialNumber => $composableBuilder(
    column: $table.serialNumber,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get installedAt => $composableBuilder(
    column: $table.installedAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  Expression<T> vehiclesRefs<T extends Object>(
    Expression<T> Function($$VehiclesTableAnnotationComposer a) f,
  ) {
    final $$VehiclesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idObd,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.obdDeviceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableAnnotationComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ObdDevicesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ObdDevicesTable,
          ObdDevice,
          $$ObdDevicesTableFilterComposer,
          $$ObdDevicesTableOrderingComposer,
          $$ObdDevicesTableAnnotationComposer,
          $$ObdDevicesTableCreateCompanionBuilder,
          $$ObdDevicesTableUpdateCompanionBuilder,
          (ObdDevice, $$ObdDevicesTableReferences),
          ObdDevice,
          PrefetchHooks Function({bool vehiclesRefs})
        > {
  $$ObdDevicesTableTableManager(_$AppDatabase db, $ObdDevicesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ObdDevicesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ObdDevicesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ObdDevicesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> idObd = const Value.absent(),
                Value<String?> model = const Value.absent(),
                Value<String> serialNumber = const Value.absent(),
                Value<DateTime?> installedAt = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => ObdDevicesCompanion(
                idObd: idObd,
                model: model,
                serialNumber: serialNumber,
                installedAt: installedAt,
                isActive: isActive,
              ),
          createCompanionCallback:
              ({
                Value<int> idObd = const Value.absent(),
                Value<String?> model = const Value.absent(),
                required String serialNumber,
                Value<DateTime?> installedAt = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => ObdDevicesCompanion.insert(
                idObd: idObd,
                model: model,
                serialNumber: serialNumber,
                installedAt: installedAt,
                isActive: isActive,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ObdDevicesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({vehiclesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (vehiclesRefs) db.vehicles],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (vehiclesRefs)
                    await $_getPrefetchedData<
                      ObdDevice,
                      $ObdDevicesTable,
                      Vehicle
                    >(
                      currentTable: table,
                      referencedTable: $$ObdDevicesTableReferences
                          ._vehiclesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ObdDevicesTableReferences(
                            db,
                            table,
                            p0,
                          ).vehiclesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.obdDeviceId == item.idObd,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ObdDevicesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ObdDevicesTable,
      ObdDevice,
      $$ObdDevicesTableFilterComposer,
      $$ObdDevicesTableOrderingComposer,
      $$ObdDevicesTableAnnotationComposer,
      $$ObdDevicesTableCreateCompanionBuilder,
      $$ObdDevicesTableUpdateCompanionBuilder,
      (ObdDevice, $$ObdDevicesTableReferences),
      ObdDevice,
      PrefetchHooks Function({bool vehiclesRefs})
    >;
typedef $$DriversTableCreateCompanionBuilder =
    DriversCompanion Function({
      Value<int> idDriver,
      required String firstName,
      required String lastName,
      required String idNumber,
      Value<bool> isActive,
    });
typedef $$DriversTableUpdateCompanionBuilder =
    DriversCompanion Function({
      Value<int> idDriver,
      Value<String> firstName,
      Value<String> lastName,
      Value<String> idNumber,
      Value<bool> isActive,
    });

final class $$DriversTableReferences
    extends BaseReferences<_$AppDatabase, $DriversTable, Driver> {
  $$DriversTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$VehiclesTable, List<Vehicle>> _vehiclesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.vehicles,
    aliasName: $_aliasNameGenerator(db.drivers.idDriver, db.vehicles.idDriver),
  );

  $$VehiclesTableProcessedTableManager get vehiclesRefs {
    final manager = $$VehiclesTableTableManager($_db, $_db.vehicles).filter(
      (f) => f.idDriver.idDriver.sqlEquals($_itemColumn<int>('id_driver')!),
    );

    final cache = $_typedResult.readTableOrNull(_vehiclesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$DriversTableFilterComposer
    extends Composer<_$AppDatabase, $DriversTable> {
  $$DriversTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get idDriver => $composableBuilder(
    column: $table.idDriver,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastName => $composableBuilder(
    column: $table.lastName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get idNumber => $composableBuilder(
    column: $table.idNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> vehiclesRefs(
    Expression<bool> Function($$VehiclesTableFilterComposer f) f,
  ) {
    final $$VehiclesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idDriver,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.idDriver,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableFilterComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DriversTableOrderingComposer
    extends Composer<_$AppDatabase, $DriversTable> {
  $$DriversTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get idDriver => $composableBuilder(
    column: $table.idDriver,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastName => $composableBuilder(
    column: $table.lastName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get idNumber => $composableBuilder(
    column: $table.idNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DriversTableAnnotationComposer
    extends Composer<_$AppDatabase, $DriversTable> {
  $$DriversTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get idDriver =>
      $composableBuilder(column: $table.idDriver, builder: (column) => column);

  GeneratedColumn<String> get firstName =>
      $composableBuilder(column: $table.firstName, builder: (column) => column);

  GeneratedColumn<String> get lastName =>
      $composableBuilder(column: $table.lastName, builder: (column) => column);

  GeneratedColumn<String> get idNumber =>
      $composableBuilder(column: $table.idNumber, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  Expression<T> vehiclesRefs<T extends Object>(
    Expression<T> Function($$VehiclesTableAnnotationComposer a) f,
  ) {
    final $$VehiclesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idDriver,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.idDriver,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableAnnotationComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DriversTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DriversTable,
          Driver,
          $$DriversTableFilterComposer,
          $$DriversTableOrderingComposer,
          $$DriversTableAnnotationComposer,
          $$DriversTableCreateCompanionBuilder,
          $$DriversTableUpdateCompanionBuilder,
          (Driver, $$DriversTableReferences),
          Driver,
          PrefetchHooks Function({bool vehiclesRefs})
        > {
  $$DriversTableTableManager(_$AppDatabase db, $DriversTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DriversTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DriversTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DriversTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> idDriver = const Value.absent(),
                Value<String> firstName = const Value.absent(),
                Value<String> lastName = const Value.absent(),
                Value<String> idNumber = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => DriversCompanion(
                idDriver: idDriver,
                firstName: firstName,
                lastName: lastName,
                idNumber: idNumber,
                isActive: isActive,
              ),
          createCompanionCallback:
              ({
                Value<int> idDriver = const Value.absent(),
                required String firstName,
                required String lastName,
                required String idNumber,
                Value<bool> isActive = const Value.absent(),
              }) => DriversCompanion.insert(
                idDriver: idDriver,
                firstName: firstName,
                lastName: lastName,
                idNumber: idNumber,
                isActive: isActive,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DriversTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({vehiclesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (vehiclesRefs) db.vehicles],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (vehiclesRefs)
                    await $_getPrefetchedData<Driver, $DriversTable, Vehicle>(
                      currentTable: table,
                      referencedTable: $$DriversTableReferences
                          ._vehiclesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$DriversTableReferences(db, table, p0).vehiclesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.idDriver == item.idDriver,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$DriversTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DriversTable,
      Driver,
      $$DriversTableFilterComposer,
      $$DriversTableOrderingComposer,
      $$DriversTableAnnotationComposer,
      $$DriversTableCreateCompanionBuilder,
      $$DriversTableUpdateCompanionBuilder,
      (Driver, $$DriversTableReferences),
      Driver,
      PrefetchHooks Function({bool vehiclesRefs})
    >;
typedef $$VehiclesTableCreateCompanionBuilder =
    VehiclesCompanion Function({
      Value<int> idVehicle,
      Value<int?> idDriver,
      required String licensePlate,
      required String brand,
      Value<String?> model,
      Value<int?> year,
      Value<VehicleStatus> status,
      Value<int> mileage,
      Value<int?> gpsDeviceId,
      Value<int?> obdDeviceId,
      Value<bool> isActive,
    });
typedef $$VehiclesTableUpdateCompanionBuilder =
    VehiclesCompanion Function({
      Value<int> idVehicle,
      Value<int?> idDriver,
      Value<String> licensePlate,
      Value<String> brand,
      Value<String?> model,
      Value<int?> year,
      Value<VehicleStatus> status,
      Value<int> mileage,
      Value<int?> gpsDeviceId,
      Value<int?> obdDeviceId,
      Value<bool> isActive,
    });

final class $$VehiclesTableReferences
    extends BaseReferences<_$AppDatabase, $VehiclesTable, Vehicle> {
  $$VehiclesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DriversTable _idDriverTable(_$AppDatabase db) =>
      db.drivers.createAlias(
        $_aliasNameGenerator(db.vehicles.idDriver, db.drivers.idDriver),
      );

  $$DriversTableProcessedTableManager? get idDriver {
    final $_column = $_itemColumn<int>('id_driver');
    if ($_column == null) return null;
    final manager = $$DriversTableTableManager(
      $_db,
      $_db.drivers,
    ).filter((f) => f.idDriver.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_idDriverTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $GpsDevicesTable _gpsDeviceIdTable(_$AppDatabase db) =>
      db.gpsDevices.createAlias(
        $_aliasNameGenerator(db.vehicles.gpsDeviceId, db.gpsDevices.idGps),
      );

  $$GpsDevicesTableProcessedTableManager? get gpsDeviceId {
    final $_column = $_itemColumn<int>('gps_device_id');
    if ($_column == null) return null;
    final manager = $$GpsDevicesTableTableManager(
      $_db,
      $_db.gpsDevices,
    ).filter((f) => f.idGps.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_gpsDeviceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ObdDevicesTable _obdDeviceIdTable(_$AppDatabase db) =>
      db.obdDevices.createAlias(
        $_aliasNameGenerator(db.vehicles.obdDeviceId, db.obdDevices.idObd),
      );

  $$ObdDevicesTableProcessedTableManager? get obdDeviceId {
    final $_column = $_itemColumn<int>('obd_device_id');
    if ($_column == null) return null;
    final manager = $$ObdDevicesTableTableManager(
      $_db,
      $_db.obdDevices,
    ).filter((f) => f.idObd.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_obdDeviceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$RouteAssignmentsTable, List<RouteAssignment>>
  _routeAssignmentsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.routeAssignments,
    aliasName: $_aliasNameGenerator(
      db.vehicles.idVehicle,
      db.routeAssignments.idVehicle,
    ),
  );

  $$RouteAssignmentsTableProcessedTableManager get routeAssignmentsRefs {
    final manager =
        $$RouteAssignmentsTableTableManager($_db, $_db.routeAssignments).filter(
          (f) =>
              f.idVehicle.idVehicle.sqlEquals($_itemColumn<int>('id_vehicle')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _routeAssignmentsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MaintenancesTable, List<Maintenance>>
  _maintenancesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.maintenances,
    aliasName: $_aliasNameGenerator(
      db.vehicles.idVehicle,
      db.maintenances.idVehicle,
    ),
  );

  $$MaintenancesTableProcessedTableManager get maintenancesRefs {
    final manager = $$MaintenancesTableTableManager($_db, $_db.maintenances)
        .filter(
          (f) =>
              f.idVehicle.idVehicle.sqlEquals($_itemColumn<int>('id_vehicle')!),
        );

    final cache = $_typedResult.readTableOrNull(_maintenancesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$VehiclesTableFilterComposer
    extends Composer<_$AppDatabase, $VehiclesTable> {
  $$VehiclesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get idVehicle => $composableBuilder(
    column: $table.idVehicle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get licensePlate => $composableBuilder(
    column: $table.licensePlate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<VehicleStatus, VehicleStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get mileage => $composableBuilder(
    column: $table.mileage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  $$DriversTableFilterComposer get idDriver {
    final $$DriversTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idDriver,
      referencedTable: $db.drivers,
      getReferencedColumn: (t) => t.idDriver,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DriversTableFilterComposer(
            $db: $db,
            $table: $db.drivers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$GpsDevicesTableFilterComposer get gpsDeviceId {
    final $$GpsDevicesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gpsDeviceId,
      referencedTable: $db.gpsDevices,
      getReferencedColumn: (t) => t.idGps,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GpsDevicesTableFilterComposer(
            $db: $db,
            $table: $db.gpsDevices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ObdDevicesTableFilterComposer get obdDeviceId {
    final $$ObdDevicesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.obdDeviceId,
      referencedTable: $db.obdDevices,
      getReferencedColumn: (t) => t.idObd,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ObdDevicesTableFilterComposer(
            $db: $db,
            $table: $db.obdDevices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> routeAssignmentsRefs(
    Expression<bool> Function($$RouteAssignmentsTableFilterComposer f) f,
  ) {
    final $$RouteAssignmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idVehicle,
      referencedTable: $db.routeAssignments,
      getReferencedColumn: (t) => t.idVehicle,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RouteAssignmentsTableFilterComposer(
            $db: $db,
            $table: $db.routeAssignments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> maintenancesRefs(
    Expression<bool> Function($$MaintenancesTableFilterComposer f) f,
  ) {
    final $$MaintenancesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idVehicle,
      referencedTable: $db.maintenances,
      getReferencedColumn: (t) => t.idVehicle,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MaintenancesTableFilterComposer(
            $db: $db,
            $table: $db.maintenances,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$VehiclesTableOrderingComposer
    extends Composer<_$AppDatabase, $VehiclesTable> {
  $$VehiclesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get idVehicle => $composableBuilder(
    column: $table.idVehicle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get licensePlate => $composableBuilder(
    column: $table.licensePlate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get mileage => $composableBuilder(
    column: $table.mileage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  $$DriversTableOrderingComposer get idDriver {
    final $$DriversTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idDriver,
      referencedTable: $db.drivers,
      getReferencedColumn: (t) => t.idDriver,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DriversTableOrderingComposer(
            $db: $db,
            $table: $db.drivers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$GpsDevicesTableOrderingComposer get gpsDeviceId {
    final $$GpsDevicesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gpsDeviceId,
      referencedTable: $db.gpsDevices,
      getReferencedColumn: (t) => t.idGps,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GpsDevicesTableOrderingComposer(
            $db: $db,
            $table: $db.gpsDevices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ObdDevicesTableOrderingComposer get obdDeviceId {
    final $$ObdDevicesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.obdDeviceId,
      referencedTable: $db.obdDevices,
      getReferencedColumn: (t) => t.idObd,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ObdDevicesTableOrderingComposer(
            $db: $db,
            $table: $db.obdDevices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VehiclesTableAnnotationComposer
    extends Composer<_$AppDatabase, $VehiclesTable> {
  $$VehiclesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get idVehicle =>
      $composableBuilder(column: $table.idVehicle, builder: (column) => column);

  GeneratedColumn<String> get licensePlate => $composableBuilder(
    column: $table.licensePlate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get brand =>
      $composableBuilder(column: $table.brand, builder: (column) => column);

  GeneratedColumn<String> get model =>
      $composableBuilder(column: $table.model, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumnWithTypeConverter<VehicleStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get mileage =>
      $composableBuilder(column: $table.mileage, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  $$DriversTableAnnotationComposer get idDriver {
    final $$DriversTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idDriver,
      referencedTable: $db.drivers,
      getReferencedColumn: (t) => t.idDriver,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DriversTableAnnotationComposer(
            $db: $db,
            $table: $db.drivers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$GpsDevicesTableAnnotationComposer get gpsDeviceId {
    final $$GpsDevicesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gpsDeviceId,
      referencedTable: $db.gpsDevices,
      getReferencedColumn: (t) => t.idGps,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GpsDevicesTableAnnotationComposer(
            $db: $db,
            $table: $db.gpsDevices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ObdDevicesTableAnnotationComposer get obdDeviceId {
    final $$ObdDevicesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.obdDeviceId,
      referencedTable: $db.obdDevices,
      getReferencedColumn: (t) => t.idObd,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ObdDevicesTableAnnotationComposer(
            $db: $db,
            $table: $db.obdDevices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> routeAssignmentsRefs<T extends Object>(
    Expression<T> Function($$RouteAssignmentsTableAnnotationComposer a) f,
  ) {
    final $$RouteAssignmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idVehicle,
      referencedTable: $db.routeAssignments,
      getReferencedColumn: (t) => t.idVehicle,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RouteAssignmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.routeAssignments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> maintenancesRefs<T extends Object>(
    Expression<T> Function($$MaintenancesTableAnnotationComposer a) f,
  ) {
    final $$MaintenancesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idVehicle,
      referencedTable: $db.maintenances,
      getReferencedColumn: (t) => t.idVehicle,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MaintenancesTableAnnotationComposer(
            $db: $db,
            $table: $db.maintenances,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$VehiclesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VehiclesTable,
          Vehicle,
          $$VehiclesTableFilterComposer,
          $$VehiclesTableOrderingComposer,
          $$VehiclesTableAnnotationComposer,
          $$VehiclesTableCreateCompanionBuilder,
          $$VehiclesTableUpdateCompanionBuilder,
          (Vehicle, $$VehiclesTableReferences),
          Vehicle,
          PrefetchHooks Function({
            bool idDriver,
            bool gpsDeviceId,
            bool obdDeviceId,
            bool routeAssignmentsRefs,
            bool maintenancesRefs,
          })
        > {
  $$VehiclesTableTableManager(_$AppDatabase db, $VehiclesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VehiclesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VehiclesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VehiclesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> idVehicle = const Value.absent(),
                Value<int?> idDriver = const Value.absent(),
                Value<String> licensePlate = const Value.absent(),
                Value<String> brand = const Value.absent(),
                Value<String?> model = const Value.absent(),
                Value<int?> year = const Value.absent(),
                Value<VehicleStatus> status = const Value.absent(),
                Value<int> mileage = const Value.absent(),
                Value<int?> gpsDeviceId = const Value.absent(),
                Value<int?> obdDeviceId = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => VehiclesCompanion(
                idVehicle: idVehicle,
                idDriver: idDriver,
                licensePlate: licensePlate,
                brand: brand,
                model: model,
                year: year,
                status: status,
                mileage: mileage,
                gpsDeviceId: gpsDeviceId,
                obdDeviceId: obdDeviceId,
                isActive: isActive,
              ),
          createCompanionCallback:
              ({
                Value<int> idVehicle = const Value.absent(),
                Value<int?> idDriver = const Value.absent(),
                required String licensePlate,
                required String brand,
                Value<String?> model = const Value.absent(),
                Value<int?> year = const Value.absent(),
                Value<VehicleStatus> status = const Value.absent(),
                Value<int> mileage = const Value.absent(),
                Value<int?> gpsDeviceId = const Value.absent(),
                Value<int?> obdDeviceId = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => VehiclesCompanion.insert(
                idVehicle: idVehicle,
                idDriver: idDriver,
                licensePlate: licensePlate,
                brand: brand,
                model: model,
                year: year,
                status: status,
                mileage: mileage,
                gpsDeviceId: gpsDeviceId,
                obdDeviceId: obdDeviceId,
                isActive: isActive,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$VehiclesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                idDriver = false,
                gpsDeviceId = false,
                obdDeviceId = false,
                routeAssignmentsRefs = false,
                maintenancesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (routeAssignmentsRefs) db.routeAssignments,
                    if (maintenancesRefs) db.maintenances,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (idDriver) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.idDriver,
                                    referencedTable: $$VehiclesTableReferences
                                        ._idDriverTable(db),
                                    referencedColumn: $$VehiclesTableReferences
                                        ._idDriverTable(db)
                                        .idDriver,
                                  )
                                  as T;
                        }
                        if (gpsDeviceId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.gpsDeviceId,
                                    referencedTable: $$VehiclesTableReferences
                                        ._gpsDeviceIdTable(db),
                                    referencedColumn: $$VehiclesTableReferences
                                        ._gpsDeviceIdTable(db)
                                        .idGps,
                                  )
                                  as T;
                        }
                        if (obdDeviceId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.obdDeviceId,
                                    referencedTable: $$VehiclesTableReferences
                                        ._obdDeviceIdTable(db),
                                    referencedColumn: $$VehiclesTableReferences
                                        ._obdDeviceIdTable(db)
                                        .idObd,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (routeAssignmentsRefs)
                        await $_getPrefetchedData<
                          Vehicle,
                          $VehiclesTable,
                          RouteAssignment
                        >(
                          currentTable: table,
                          referencedTable: $$VehiclesTableReferences
                              ._routeAssignmentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$VehiclesTableReferences(
                                db,
                                table,
                                p0,
                              ).routeAssignmentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.idVehicle == item.idVehicle,
                              ),
                          typedResults: items,
                        ),
                      if (maintenancesRefs)
                        await $_getPrefetchedData<
                          Vehicle,
                          $VehiclesTable,
                          Maintenance
                        >(
                          currentTable: table,
                          referencedTable: $$VehiclesTableReferences
                              ._maintenancesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$VehiclesTableReferences(
                                db,
                                table,
                                p0,
                              ).maintenancesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.idVehicle == item.idVehicle,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$VehiclesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VehiclesTable,
      Vehicle,
      $$VehiclesTableFilterComposer,
      $$VehiclesTableOrderingComposer,
      $$VehiclesTableAnnotationComposer,
      $$VehiclesTableCreateCompanionBuilder,
      $$VehiclesTableUpdateCompanionBuilder,
      (Vehicle, $$VehiclesTableReferences),
      Vehicle,
      PrefetchHooks Function({
        bool idDriver,
        bool gpsDeviceId,
        bool obdDeviceId,
        bool routeAssignmentsRefs,
        bool maintenancesRefs,
      })
    >;
typedef $$RoutesTableCreateCompanionBuilder =
    RoutesCompanion Function({
      Value<int> idRoute,
      required String name,
      Value<bool> isActive,
    });
typedef $$RoutesTableUpdateCompanionBuilder =
    RoutesCompanion Function({
      Value<int> idRoute,
      Value<String> name,
      Value<bool> isActive,
    });

final class $$RoutesTableReferences
    extends BaseReferences<_$AppDatabase, $RoutesTable, Route> {
  $$RoutesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$StopsTable, List<Stop>> _stopsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.stops,
    aliasName: $_aliasNameGenerator(db.routes.idRoute, db.stops.idRoute),
  );

  $$StopsTableProcessedTableManager get stopsRefs {
    final manager = $$StopsTableTableManager($_db, $_db.stops).filter(
      (f) => f.idRoute.idRoute.sqlEquals($_itemColumn<int>('id_route')!),
    );

    final cache = $_typedResult.readTableOrNull(_stopsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RouteAssignmentsTable, List<RouteAssignment>>
  _routeAssignmentsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.routeAssignments,
    aliasName: $_aliasNameGenerator(
      db.routes.idRoute,
      db.routeAssignments.idRoute,
    ),
  );

  $$RouteAssignmentsTableProcessedTableManager get routeAssignmentsRefs {
    final manager =
        $$RouteAssignmentsTableTableManager($_db, $_db.routeAssignments).filter(
          (f) => f.idRoute.idRoute.sqlEquals($_itemColumn<int>('id_route')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _routeAssignmentsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RoutesTableFilterComposer
    extends Composer<_$AppDatabase, $RoutesTable> {
  $$RoutesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get idRoute => $composableBuilder(
    column: $table.idRoute,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> stopsRefs(
    Expression<bool> Function($$StopsTableFilterComposer f) f,
  ) {
    final $$StopsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idRoute,
      referencedTable: $db.stops,
      getReferencedColumn: (t) => t.idRoute,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StopsTableFilterComposer(
            $db: $db,
            $table: $db.stops,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> routeAssignmentsRefs(
    Expression<bool> Function($$RouteAssignmentsTableFilterComposer f) f,
  ) {
    final $$RouteAssignmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idRoute,
      referencedTable: $db.routeAssignments,
      getReferencedColumn: (t) => t.idRoute,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RouteAssignmentsTableFilterComposer(
            $db: $db,
            $table: $db.routeAssignments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RoutesTableOrderingComposer
    extends Composer<_$AppDatabase, $RoutesTable> {
  $$RoutesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get idRoute => $composableBuilder(
    column: $table.idRoute,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RoutesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoutesTable> {
  $$RoutesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get idRoute =>
      $composableBuilder(column: $table.idRoute, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  Expression<T> stopsRefs<T extends Object>(
    Expression<T> Function($$StopsTableAnnotationComposer a) f,
  ) {
    final $$StopsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idRoute,
      referencedTable: $db.stops,
      getReferencedColumn: (t) => t.idRoute,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StopsTableAnnotationComposer(
            $db: $db,
            $table: $db.stops,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> routeAssignmentsRefs<T extends Object>(
    Expression<T> Function($$RouteAssignmentsTableAnnotationComposer a) f,
  ) {
    final $$RouteAssignmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idRoute,
      referencedTable: $db.routeAssignments,
      getReferencedColumn: (t) => t.idRoute,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RouteAssignmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.routeAssignments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RoutesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RoutesTable,
          Route,
          $$RoutesTableFilterComposer,
          $$RoutesTableOrderingComposer,
          $$RoutesTableAnnotationComposer,
          $$RoutesTableCreateCompanionBuilder,
          $$RoutesTableUpdateCompanionBuilder,
          (Route, $$RoutesTableReferences),
          Route,
          PrefetchHooks Function({bool stopsRefs, bool routeAssignmentsRefs})
        > {
  $$RoutesTableTableManager(_$AppDatabase db, $RoutesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoutesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoutesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoutesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> idRoute = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => RoutesCompanion(
                idRoute: idRoute,
                name: name,
                isActive: isActive,
              ),
          createCompanionCallback:
              ({
                Value<int> idRoute = const Value.absent(),
                required String name,
                Value<bool> isActive = const Value.absent(),
              }) => RoutesCompanion.insert(
                idRoute: idRoute,
                name: name,
                isActive: isActive,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$RoutesTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({stopsRefs = false, routeAssignmentsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (stopsRefs) db.stops,
                    if (routeAssignmentsRefs) db.routeAssignments,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (stopsRefs)
                        await $_getPrefetchedData<Route, $RoutesTable, Stop>(
                          currentTable: table,
                          referencedTable: $$RoutesTableReferences
                              ._stopsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RoutesTableReferences(db, table, p0).stopsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.idRoute == item.idRoute,
                              ),
                          typedResults: items,
                        ),
                      if (routeAssignmentsRefs)
                        await $_getPrefetchedData<
                          Route,
                          $RoutesTable,
                          RouteAssignment
                        >(
                          currentTable: table,
                          referencedTable: $$RoutesTableReferences
                              ._routeAssignmentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RoutesTableReferences(
                                db,
                                table,
                                p0,
                              ).routeAssignmentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.idRoute == item.idRoute,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$RoutesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RoutesTable,
      Route,
      $$RoutesTableFilterComposer,
      $$RoutesTableOrderingComposer,
      $$RoutesTableAnnotationComposer,
      $$RoutesTableCreateCompanionBuilder,
      $$RoutesTableUpdateCompanionBuilder,
      (Route, $$RoutesTableReferences),
      Route,
      PrefetchHooks Function({bool stopsRefs, bool routeAssignmentsRefs})
    >;
typedef $$StopsTableCreateCompanionBuilder =
    StopsCompanion Function({
      Value<int> idStop,
      required int idRoute,
      required double latitude,
      required double longitude,
      Value<bool> isActive,
    });
typedef $$StopsTableUpdateCompanionBuilder =
    StopsCompanion Function({
      Value<int> idStop,
      Value<int> idRoute,
      Value<double> latitude,
      Value<double> longitude,
      Value<bool> isActive,
    });

final class $$StopsTableReferences
    extends BaseReferences<_$AppDatabase, $StopsTable, Stop> {
  $$StopsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $RoutesTable _idRouteTable(_$AppDatabase db) => db.routes.createAlias(
    $_aliasNameGenerator(db.stops.idRoute, db.routes.idRoute),
  );

  $$RoutesTableProcessedTableManager get idRoute {
    final $_column = $_itemColumn<int>('id_route')!;

    final manager = $$RoutesTableTableManager(
      $_db,
      $_db.routes,
    ).filter((f) => f.idRoute.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_idRouteTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$StopsTableFilterComposer extends Composer<_$AppDatabase, $StopsTable> {
  $$StopsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get idStop => $composableBuilder(
    column: $table.idStop,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  $$RoutesTableFilterComposer get idRoute {
    final $$RoutesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idRoute,
      referencedTable: $db.routes,
      getReferencedColumn: (t) => t.idRoute,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutesTableFilterComposer(
            $db: $db,
            $table: $db.routes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StopsTableOrderingComposer
    extends Composer<_$AppDatabase, $StopsTable> {
  $$StopsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get idStop => $composableBuilder(
    column: $table.idStop,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  $$RoutesTableOrderingComposer get idRoute {
    final $$RoutesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idRoute,
      referencedTable: $db.routes,
      getReferencedColumn: (t) => t.idRoute,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutesTableOrderingComposer(
            $db: $db,
            $table: $db.routes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StopsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StopsTable> {
  $$StopsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get idStop =>
      $composableBuilder(column: $table.idStop, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  $$RoutesTableAnnotationComposer get idRoute {
    final $$RoutesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idRoute,
      referencedTable: $db.routes,
      getReferencedColumn: (t) => t.idRoute,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutesTableAnnotationComposer(
            $db: $db,
            $table: $db.routes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StopsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StopsTable,
          Stop,
          $$StopsTableFilterComposer,
          $$StopsTableOrderingComposer,
          $$StopsTableAnnotationComposer,
          $$StopsTableCreateCompanionBuilder,
          $$StopsTableUpdateCompanionBuilder,
          (Stop, $$StopsTableReferences),
          Stop,
          PrefetchHooks Function({bool idRoute})
        > {
  $$StopsTableTableManager(_$AppDatabase db, $StopsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StopsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StopsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StopsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> idStop = const Value.absent(),
                Value<int> idRoute = const Value.absent(),
                Value<double> latitude = const Value.absent(),
                Value<double> longitude = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => StopsCompanion(
                idStop: idStop,
                idRoute: idRoute,
                latitude: latitude,
                longitude: longitude,
                isActive: isActive,
              ),
          createCompanionCallback:
              ({
                Value<int> idStop = const Value.absent(),
                required int idRoute,
                required double latitude,
                required double longitude,
                Value<bool> isActive = const Value.absent(),
              }) => StopsCompanion.insert(
                idStop: idStop,
                idRoute: idRoute,
                latitude: latitude,
                longitude: longitude,
                isActive: isActive,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$StopsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({idRoute = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (idRoute) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.idRoute,
                                referencedTable: $$StopsTableReferences
                                    ._idRouteTable(db),
                                referencedColumn: $$StopsTableReferences
                                    ._idRouteTable(db)
                                    .idRoute,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$StopsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StopsTable,
      Stop,
      $$StopsTableFilterComposer,
      $$StopsTableOrderingComposer,
      $$StopsTableAnnotationComposer,
      $$StopsTableCreateCompanionBuilder,
      $$StopsTableUpdateCompanionBuilder,
      (Stop, $$StopsTableReferences),
      Stop,
      PrefetchHooks Function({bool idRoute})
    >;
typedef $$RouteAssignmentsTableCreateCompanionBuilder =
    RouteAssignmentsCompanion Function({
      Value<int> idAssignment,
      required int idRoute,
      required int idVehicle,
      required DateTime assignedDate,
      Value<bool> isActive,
    });
typedef $$RouteAssignmentsTableUpdateCompanionBuilder =
    RouteAssignmentsCompanion Function({
      Value<int> idAssignment,
      Value<int> idRoute,
      Value<int> idVehicle,
      Value<DateTime> assignedDate,
      Value<bool> isActive,
    });

final class $$RouteAssignmentsTableReferences
    extends
        BaseReferences<_$AppDatabase, $RouteAssignmentsTable, RouteAssignment> {
  $$RouteAssignmentsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $RoutesTable _idRouteTable(_$AppDatabase db) => db.routes.createAlias(
    $_aliasNameGenerator(db.routeAssignments.idRoute, db.routes.idRoute),
  );

  $$RoutesTableProcessedTableManager get idRoute {
    final $_column = $_itemColumn<int>('id_route')!;

    final manager = $$RoutesTableTableManager(
      $_db,
      $_db.routes,
    ).filter((f) => f.idRoute.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_idRouteTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $VehiclesTable _idVehicleTable(_$AppDatabase db) =>
      db.vehicles.createAlias(
        $_aliasNameGenerator(
          db.routeAssignments.idVehicle,
          db.vehicles.idVehicle,
        ),
      );

  $$VehiclesTableProcessedTableManager get idVehicle {
    final $_column = $_itemColumn<int>('id_vehicle')!;

    final manager = $$VehiclesTableTableManager(
      $_db,
      $_db.vehicles,
    ).filter((f) => f.idVehicle.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_idVehicleTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RouteAssignmentsTableFilterComposer
    extends Composer<_$AppDatabase, $RouteAssignmentsTable> {
  $$RouteAssignmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get idAssignment => $composableBuilder(
    column: $table.idAssignment,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get assignedDate => $composableBuilder(
    column: $table.assignedDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  $$RoutesTableFilterComposer get idRoute {
    final $$RoutesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idRoute,
      referencedTable: $db.routes,
      getReferencedColumn: (t) => t.idRoute,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutesTableFilterComposer(
            $db: $db,
            $table: $db.routes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$VehiclesTableFilterComposer get idVehicle {
    final $$VehiclesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idVehicle,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.idVehicle,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableFilterComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RouteAssignmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $RouteAssignmentsTable> {
  $$RouteAssignmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get idAssignment => $composableBuilder(
    column: $table.idAssignment,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get assignedDate => $composableBuilder(
    column: $table.assignedDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  $$RoutesTableOrderingComposer get idRoute {
    final $$RoutesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idRoute,
      referencedTable: $db.routes,
      getReferencedColumn: (t) => t.idRoute,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutesTableOrderingComposer(
            $db: $db,
            $table: $db.routes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$VehiclesTableOrderingComposer get idVehicle {
    final $$VehiclesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idVehicle,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.idVehicle,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableOrderingComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RouteAssignmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RouteAssignmentsTable> {
  $$RouteAssignmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get idAssignment => $composableBuilder(
    column: $table.idAssignment,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get assignedDate => $composableBuilder(
    column: $table.assignedDate,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  $$RoutesTableAnnotationComposer get idRoute {
    final $$RoutesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idRoute,
      referencedTable: $db.routes,
      getReferencedColumn: (t) => t.idRoute,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutesTableAnnotationComposer(
            $db: $db,
            $table: $db.routes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$VehiclesTableAnnotationComposer get idVehicle {
    final $$VehiclesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idVehicle,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.idVehicle,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableAnnotationComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RouteAssignmentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RouteAssignmentsTable,
          RouteAssignment,
          $$RouteAssignmentsTableFilterComposer,
          $$RouteAssignmentsTableOrderingComposer,
          $$RouteAssignmentsTableAnnotationComposer,
          $$RouteAssignmentsTableCreateCompanionBuilder,
          $$RouteAssignmentsTableUpdateCompanionBuilder,
          (RouteAssignment, $$RouteAssignmentsTableReferences),
          RouteAssignment,
          PrefetchHooks Function({bool idRoute, bool idVehicle})
        > {
  $$RouteAssignmentsTableTableManager(
    _$AppDatabase db,
    $RouteAssignmentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RouteAssignmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RouteAssignmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RouteAssignmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> idAssignment = const Value.absent(),
                Value<int> idRoute = const Value.absent(),
                Value<int> idVehicle = const Value.absent(),
                Value<DateTime> assignedDate = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => RouteAssignmentsCompanion(
                idAssignment: idAssignment,
                idRoute: idRoute,
                idVehicle: idVehicle,
                assignedDate: assignedDate,
                isActive: isActive,
              ),
          createCompanionCallback:
              ({
                Value<int> idAssignment = const Value.absent(),
                required int idRoute,
                required int idVehicle,
                required DateTime assignedDate,
                Value<bool> isActive = const Value.absent(),
              }) => RouteAssignmentsCompanion.insert(
                idAssignment: idAssignment,
                idRoute: idRoute,
                idVehicle: idVehicle,
                assignedDate: assignedDate,
                isActive: isActive,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RouteAssignmentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({idRoute = false, idVehicle = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (idRoute) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.idRoute,
                                referencedTable:
                                    $$RouteAssignmentsTableReferences
                                        ._idRouteTable(db),
                                referencedColumn:
                                    $$RouteAssignmentsTableReferences
                                        ._idRouteTable(db)
                                        .idRoute,
                              )
                              as T;
                    }
                    if (idVehicle) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.idVehicle,
                                referencedTable:
                                    $$RouteAssignmentsTableReferences
                                        ._idVehicleTable(db),
                                referencedColumn:
                                    $$RouteAssignmentsTableReferences
                                        ._idVehicleTable(db)
                                        .idVehicle,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RouteAssignmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RouteAssignmentsTable,
      RouteAssignment,
      $$RouteAssignmentsTableFilterComposer,
      $$RouteAssignmentsTableOrderingComposer,
      $$RouteAssignmentsTableAnnotationComposer,
      $$RouteAssignmentsTableCreateCompanionBuilder,
      $$RouteAssignmentsTableUpdateCompanionBuilder,
      (RouteAssignment, $$RouteAssignmentsTableReferences),
      RouteAssignment,
      PrefetchHooks Function({bool idRoute, bool idVehicle})
    >;
typedef $$MaintenancesTableCreateCompanionBuilder =
    MaintenancesCompanion Function({
      Value<int> idMaintenance,
      required int idVehicle,
      required DateTime maintenanceDate,
      required int vehicleMileage,
      Value<String?> details,
      Value<bool> isActive,
    });
typedef $$MaintenancesTableUpdateCompanionBuilder =
    MaintenancesCompanion Function({
      Value<int> idMaintenance,
      Value<int> idVehicle,
      Value<DateTime> maintenanceDate,
      Value<int> vehicleMileage,
      Value<String?> details,
      Value<bool> isActive,
    });

final class $$MaintenancesTableReferences
    extends BaseReferences<_$AppDatabase, $MaintenancesTable, Maintenance> {
  $$MaintenancesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $VehiclesTable _idVehicleTable(_$AppDatabase db) =>
      db.vehicles.createAlias(
        $_aliasNameGenerator(db.maintenances.idVehicle, db.vehicles.idVehicle),
      );

  $$VehiclesTableProcessedTableManager get idVehicle {
    final $_column = $_itemColumn<int>('id_vehicle')!;

    final manager = $$VehiclesTableTableManager(
      $_db,
      $_db.vehicles,
    ).filter((f) => f.idVehicle.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_idVehicleTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$MaintenanceDetailsTable, List<MaintenanceDetail>>
  _maintenanceDetailsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.maintenanceDetails,
        aliasName: $_aliasNameGenerator(
          db.maintenances.idMaintenance,
          db.maintenanceDetails.idMaintenance,
        ),
      );

  $$MaintenanceDetailsTableProcessedTableManager get maintenanceDetailsRefs {
    final manager =
        $$MaintenanceDetailsTableTableManager(
          $_db,
          $_db.maintenanceDetails,
        ).filter(
          (f) => f.idMaintenance.idMaintenance.sqlEquals(
            $_itemColumn<int>('id_maintenance')!,
          ),
        );

    final cache = $_typedResult.readTableOrNull(
      _maintenanceDetailsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MaintenancesTableFilterComposer
    extends Composer<_$AppDatabase, $MaintenancesTable> {
  $$MaintenancesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get idMaintenance => $composableBuilder(
    column: $table.idMaintenance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get maintenanceDate => $composableBuilder(
    column: $table.maintenanceDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get vehicleMileage => $composableBuilder(
    column: $table.vehicleMileage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get details => $composableBuilder(
    column: $table.details,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  $$VehiclesTableFilterComposer get idVehicle {
    final $$VehiclesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idVehicle,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.idVehicle,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableFilterComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> maintenanceDetailsRefs(
    Expression<bool> Function($$MaintenanceDetailsTableFilterComposer f) f,
  ) {
    final $$MaintenanceDetailsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idMaintenance,
      referencedTable: $db.maintenanceDetails,
      getReferencedColumn: (t) => t.idMaintenance,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MaintenanceDetailsTableFilterComposer(
            $db: $db,
            $table: $db.maintenanceDetails,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MaintenancesTableOrderingComposer
    extends Composer<_$AppDatabase, $MaintenancesTable> {
  $$MaintenancesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get idMaintenance => $composableBuilder(
    column: $table.idMaintenance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get maintenanceDate => $composableBuilder(
    column: $table.maintenanceDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get vehicleMileage => $composableBuilder(
    column: $table.vehicleMileage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get details => $composableBuilder(
    column: $table.details,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  $$VehiclesTableOrderingComposer get idVehicle {
    final $$VehiclesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idVehicle,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.idVehicle,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableOrderingComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MaintenancesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MaintenancesTable> {
  $$MaintenancesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get idMaintenance => $composableBuilder(
    column: $table.idMaintenance,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get maintenanceDate => $composableBuilder(
    column: $table.maintenanceDate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get vehicleMileage => $composableBuilder(
    column: $table.vehicleMileage,
    builder: (column) => column,
  );

  GeneratedColumn<String> get details =>
      $composableBuilder(column: $table.details, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  $$VehiclesTableAnnotationComposer get idVehicle {
    final $$VehiclesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idVehicle,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.idVehicle,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableAnnotationComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> maintenanceDetailsRefs<T extends Object>(
    Expression<T> Function($$MaintenanceDetailsTableAnnotationComposer a) f,
  ) {
    final $$MaintenanceDetailsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.idMaintenance,
          referencedTable: $db.maintenanceDetails,
          getReferencedColumn: (t) => t.idMaintenance,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MaintenanceDetailsTableAnnotationComposer(
                $db: $db,
                $table: $db.maintenanceDetails,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$MaintenancesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MaintenancesTable,
          Maintenance,
          $$MaintenancesTableFilterComposer,
          $$MaintenancesTableOrderingComposer,
          $$MaintenancesTableAnnotationComposer,
          $$MaintenancesTableCreateCompanionBuilder,
          $$MaintenancesTableUpdateCompanionBuilder,
          (Maintenance, $$MaintenancesTableReferences),
          Maintenance,
          PrefetchHooks Function({bool idVehicle, bool maintenanceDetailsRefs})
        > {
  $$MaintenancesTableTableManager(_$AppDatabase db, $MaintenancesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MaintenancesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MaintenancesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MaintenancesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> idMaintenance = const Value.absent(),
                Value<int> idVehicle = const Value.absent(),
                Value<DateTime> maintenanceDate = const Value.absent(),
                Value<int> vehicleMileage = const Value.absent(),
                Value<String?> details = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => MaintenancesCompanion(
                idMaintenance: idMaintenance,
                idVehicle: idVehicle,
                maintenanceDate: maintenanceDate,
                vehicleMileage: vehicleMileage,
                details: details,
                isActive: isActive,
              ),
          createCompanionCallback:
              ({
                Value<int> idMaintenance = const Value.absent(),
                required int idVehicle,
                required DateTime maintenanceDate,
                required int vehicleMileage,
                Value<String?> details = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => MaintenancesCompanion.insert(
                idMaintenance: idMaintenance,
                idVehicle: idVehicle,
                maintenanceDate: maintenanceDate,
                vehicleMileage: vehicleMileage,
                details: details,
                isActive: isActive,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MaintenancesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({idVehicle = false, maintenanceDetailsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (maintenanceDetailsRefs) db.maintenanceDetails,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (idVehicle) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.idVehicle,
                                    referencedTable:
                                        $$MaintenancesTableReferences
                                            ._idVehicleTable(db),
                                    referencedColumn:
                                        $$MaintenancesTableReferences
                                            ._idVehicleTable(db)
                                            .idVehicle,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (maintenanceDetailsRefs)
                        await $_getPrefetchedData<
                          Maintenance,
                          $MaintenancesTable,
                          MaintenanceDetail
                        >(
                          currentTable: table,
                          referencedTable: $$MaintenancesTableReferences
                              ._maintenanceDetailsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MaintenancesTableReferences(
                                db,
                                table,
                                p0,
                              ).maintenanceDetailsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.idMaintenance == item.idMaintenance,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$MaintenancesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MaintenancesTable,
      Maintenance,
      $$MaintenancesTableFilterComposer,
      $$MaintenancesTableOrderingComposer,
      $$MaintenancesTableAnnotationComposer,
      $$MaintenancesTableCreateCompanionBuilder,
      $$MaintenancesTableUpdateCompanionBuilder,
      (Maintenance, $$MaintenancesTableReferences),
      Maintenance,
      PrefetchHooks Function({bool idVehicle, bool maintenanceDetailsRefs})
    >;
typedef $$MaintenanceDetailsTableCreateCompanionBuilder =
    MaintenanceDetailsCompanion Function({
      Value<int> idDetail,
      required int idMaintenance,
      required String description,
      Value<double> cost,
      Value<bool> isActive,
    });
typedef $$MaintenanceDetailsTableUpdateCompanionBuilder =
    MaintenanceDetailsCompanion Function({
      Value<int> idDetail,
      Value<int> idMaintenance,
      Value<String> description,
      Value<double> cost,
      Value<bool> isActive,
    });

final class $$MaintenanceDetailsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $MaintenanceDetailsTable,
          MaintenanceDetail
        > {
  $$MaintenanceDetailsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MaintenancesTable _idMaintenanceTable(_$AppDatabase db) =>
      db.maintenances.createAlias(
        $_aliasNameGenerator(
          db.maintenanceDetails.idMaintenance,
          db.maintenances.idMaintenance,
        ),
      );

  $$MaintenancesTableProcessedTableManager get idMaintenance {
    final $_column = $_itemColumn<int>('id_maintenance')!;

    final manager = $$MaintenancesTableTableManager(
      $_db,
      $_db.maintenances,
    ).filter((f) => f.idMaintenance.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_idMaintenanceTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MaintenanceDetailsTableFilterComposer
    extends Composer<_$AppDatabase, $MaintenanceDetailsTable> {
  $$MaintenanceDetailsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get idDetail => $composableBuilder(
    column: $table.idDetail,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get cost => $composableBuilder(
    column: $table.cost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  $$MaintenancesTableFilterComposer get idMaintenance {
    final $$MaintenancesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idMaintenance,
      referencedTable: $db.maintenances,
      getReferencedColumn: (t) => t.idMaintenance,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MaintenancesTableFilterComposer(
            $db: $db,
            $table: $db.maintenances,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MaintenanceDetailsTableOrderingComposer
    extends Composer<_$AppDatabase, $MaintenanceDetailsTable> {
  $$MaintenanceDetailsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get idDetail => $composableBuilder(
    column: $table.idDetail,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get cost => $composableBuilder(
    column: $table.cost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  $$MaintenancesTableOrderingComposer get idMaintenance {
    final $$MaintenancesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idMaintenance,
      referencedTable: $db.maintenances,
      getReferencedColumn: (t) => t.idMaintenance,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MaintenancesTableOrderingComposer(
            $db: $db,
            $table: $db.maintenances,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MaintenanceDetailsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MaintenanceDetailsTable> {
  $$MaintenanceDetailsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get idDetail =>
      $composableBuilder(column: $table.idDetail, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<double> get cost =>
      $composableBuilder(column: $table.cost, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  $$MaintenancesTableAnnotationComposer get idMaintenance {
    final $$MaintenancesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idMaintenance,
      referencedTable: $db.maintenances,
      getReferencedColumn: (t) => t.idMaintenance,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MaintenancesTableAnnotationComposer(
            $db: $db,
            $table: $db.maintenances,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MaintenanceDetailsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MaintenanceDetailsTable,
          MaintenanceDetail,
          $$MaintenanceDetailsTableFilterComposer,
          $$MaintenanceDetailsTableOrderingComposer,
          $$MaintenanceDetailsTableAnnotationComposer,
          $$MaintenanceDetailsTableCreateCompanionBuilder,
          $$MaintenanceDetailsTableUpdateCompanionBuilder,
          (MaintenanceDetail, $$MaintenanceDetailsTableReferences),
          MaintenanceDetail,
          PrefetchHooks Function({bool idMaintenance})
        > {
  $$MaintenanceDetailsTableTableManager(
    _$AppDatabase db,
    $MaintenanceDetailsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MaintenanceDetailsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MaintenanceDetailsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MaintenanceDetailsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> idDetail = const Value.absent(),
                Value<int> idMaintenance = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<double> cost = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => MaintenanceDetailsCompanion(
                idDetail: idDetail,
                idMaintenance: idMaintenance,
                description: description,
                cost: cost,
                isActive: isActive,
              ),
          createCompanionCallback:
              ({
                Value<int> idDetail = const Value.absent(),
                required int idMaintenance,
                required String description,
                Value<double> cost = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => MaintenanceDetailsCompanion.insert(
                idDetail: idDetail,
                idMaintenance: idMaintenance,
                description: description,
                cost: cost,
                isActive: isActive,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MaintenanceDetailsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({idMaintenance = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (idMaintenance) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.idMaintenance,
                                referencedTable:
                                    $$MaintenanceDetailsTableReferences
                                        ._idMaintenanceTable(db),
                                referencedColumn:
                                    $$MaintenanceDetailsTableReferences
                                        ._idMaintenanceTable(db)
                                        .idMaintenance,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MaintenanceDetailsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MaintenanceDetailsTable,
      MaintenanceDetail,
      $$MaintenanceDetailsTableFilterComposer,
      $$MaintenanceDetailsTableOrderingComposer,
      $$MaintenanceDetailsTableAnnotationComposer,
      $$MaintenanceDetailsTableCreateCompanionBuilder,
      $$MaintenanceDetailsTableUpdateCompanionBuilder,
      (MaintenanceDetail, $$MaintenanceDetailsTableReferences),
      MaintenanceDetail,
      PrefetchHooks Function({bool idMaintenance})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$GpsDevicesTableTableManager get gpsDevices =>
      $$GpsDevicesTableTableManager(_db, _db.gpsDevices);
  $$ObdDevicesTableTableManager get obdDevices =>
      $$ObdDevicesTableTableManager(_db, _db.obdDevices);
  $$DriversTableTableManager get drivers =>
      $$DriversTableTableManager(_db, _db.drivers);
  $$VehiclesTableTableManager get vehicles =>
      $$VehiclesTableTableManager(_db, _db.vehicles);
  $$RoutesTableTableManager get routes =>
      $$RoutesTableTableManager(_db, _db.routes);
  $$StopsTableTableManager get stops =>
      $$StopsTableTableManager(_db, _db.stops);
  $$RouteAssignmentsTableTableManager get routeAssignments =>
      $$RouteAssignmentsTableTableManager(_db, _db.routeAssignments);
  $$MaintenancesTableTableManager get maintenances =>
      $$MaintenancesTableTableManager(_db, _db.maintenances);
  $$MaintenanceDetailsTableTableManager get maintenanceDetails =>
      $$MaintenanceDetailsTableTableManager(_db, _db.maintenanceDetails);
}

// lib/data/local_repository/drift/mappers.dart

import '../../domain/entities/domain_entities.dart' as d;
import '../../domain/enums.dart';
import 'database.dart';
import 'package:drift/drift.dart';

// --- GpsDevices ---
extension GpsDeviceDataX on GpsDevice {
  d.GpsDevice toDomain() => d.GpsDevice(
    id: idGps,
    model: model,
    serialNumber: serialNumber,
    installedAt: installedAt,
    isActive: isActive,
  );
}
extension GpsDeviceDomainX on d.GpsDevice {
  GpsDevicesCompanion toCompanionInsert() => GpsDevicesCompanion.insert(
    model: Value(model),
    serialNumber: serialNumber,
    installedAt: Value(installedAt),
    isActive: Value(isActive),
  );
  GpsDevicesCompanion toCompanionUpdate() => GpsDevicesCompanion(
    idGps: Value(id),
    model: Value(model),
    serialNumber: Value(serialNumber),
    installedAt: Value(installedAt),
    isActive: Value(isActive),
  );
}

// --- ObdDevices ---
extension ObdDeviceDataX on ObdDevice {
  d.ObdDevice toDomain() => d.ObdDevice(
    id: idObd,
    model: model,
    serialNumber: serialNumber,
    installedAt: installedAt,
    isActive: isActive,
  );
}
extension ObdDeviceDomainX on d.ObdDevice {
  ObdDevicesCompanion toCompanionInsert() => ObdDevicesCompanion.insert(
    model: Value(model),
    serialNumber: serialNumber,
    installedAt: Value(installedAt),
    isActive: Value(isActive),
  );
  ObdDevicesCompanion toCompanionUpdate() => ObdDevicesCompanion(
    idObd: Value(id),
    model: Value(model),
    serialNumber: Value(serialNumber),
    installedAt: Value(installedAt),
    isActive: Value(isActive),
  );
}

// --- Drivers ---
extension DriverDataX on Driver {
  d.Driver toDomain() => d.Driver(
    id: idDriver,
    firstName: firstName,
    lastName: lastName,
    idNumber: idNumber,
    isActive: isActive,
  );
}
extension DriverDomainX on d.Driver {
  DriversCompanion toCompanionInsert() => DriversCompanion.insert(
    firstName: firstName,
    lastName: lastName,
    idNumber: idNumber,
    isActive: Value(isActive),
  );
  DriversCompanion toCompanionUpdate() => DriversCompanion(
    idDriver: Value(id),
    firstName: Value(firstName),
    lastName: Value(lastName),
    idNumber: Value(idNumber),
    isActive: Value(isActive),
  );
}

// --- Vehicles ---
extension VehicleDataX on Vehicle {
  d.Vehicle toDomain() => d.Vehicle(
    id: idVehicle,
    driverId: idDriver,
    licensePlate: licensePlate,
    brand: brand,
    model: model,
    year: year,
    status: VehicleStatus.values.byName(status.name),
    mileage: mileage,
    gpsDeviceId: gpsDeviceId,
    obdDeviceId: obdDeviceId,
    isActive: isActive,
  );
}
extension VehicleDomainX on d.Vehicle {
  VehiclesCompanion toCompanionInsert() => VehiclesCompanion.insert(
    idDriver: Value(driverId),
    licensePlate: licensePlate,
    brand: brand,
    model: Value(model),
    year: Value(year),
    status: Value(status),
    mileage: Value(mileage),
    gpsDeviceId: Value(gpsDeviceId),
    obdDeviceId: Value(obdDeviceId),
    isActive: Value(isActive),
  );
  VehiclesCompanion toCompanionUpdate() => VehiclesCompanion(
    idVehicle: Value(id),
    idDriver: Value(driverId),
    licensePlate: Value(licensePlate),
    brand: Value(brand),
    model: Value(model),
    year: Value(year),
    status: Value(status),
    mileage: Value(mileage),
    gpsDeviceId: Value(gpsDeviceId),
    obdDeviceId: Value(obdDeviceId),
    isActive: Value(isActive),
  );
}

// --- Routes ---
extension RouteDataX on Route {
  d.Route toDomain() => d.Route(
    id: idRoute,
    name: name,
    isActive: isActive,
  );
}
extension RouteDomainX on d.Route {
  RoutesCompanion toCompanionInsert() => RoutesCompanion.insert(
    name: name,
    isActive: Value(isActive),
  );
  RoutesCompanion toCompanionUpdate() => RoutesCompanion(
    idRoute: Value(id),
    name: Value(name),
    isActive: Value(isActive),
  );
}

// --- RouteAssignments ---
extension RouteAssignmentDataX on RouteAssignment {
  d.RouteAssignment toDomain() => d.RouteAssignment(
    id: idAssignment,
    routeId: idRoute,
    vehicleId: idVehicle,
    assignedDate: assignedDate,
    isActive: isActive,
  );
}
extension RouteAssignmentDomainX on d.RouteAssignment {
  RouteAssignmentsCompanion toCompanionInsert() => RouteAssignmentsCompanion.insert(
    idRoute: routeId,
    idVehicle: vehicleId,
    assignedDate: assignedDate,
    isActive: Value(isActive),
  );
  RouteAssignmentsCompanion toCompanionUpdate() => RouteAssignmentsCompanion(
    idAssignment: Value(id),
    idRoute: Value(routeId),
    idVehicle: Value(vehicleId),
    assignedDate: Value(assignedDate),
    isActive: Value(isActive),
  );
}

// --- Stops ---
extension StopDataX on Stop {
  d.Stop toDomain() => d.Stop(
    id: idStop,
    routeId: idRoute,
    latitude: latitude,
    longitude: longitude,
    isActive: isActive,
  );
}
extension StopDomainX on d.Stop {
  StopsCompanion toCompanionInsert() => StopsCompanion.insert(
    idRoute: routeId,
    latitude: latitude,
    longitude: longitude,
    isActive: Value(isActive),
  );
  StopsCompanion toCompanionUpdate() => StopsCompanion(
    idStop: Value(id),
    idRoute: Value(routeId),
    latitude: Value(latitude),
    longitude: Value(longitude),
    isActive: Value(isActive),
  );
}

// --- Maintenances ---
extension MaintenanceDataX on Maintenance {
  d.Maintenance toDomain() => d.Maintenance(
    id: idMaintenance,
    vehicleId: idVehicle,
    maintenanceDate: maintenanceDate,
    vehicleMileage: vehicleMileage,
    details: details,
    isActive: isActive,
  );
}
extension MaintenanceDomainX on d.Maintenance {
  MaintenancesCompanion toCompanionInsert() => MaintenancesCompanion.insert(
    idVehicle: vehicleId,
    maintenanceDate: maintenanceDate,
    vehicleMileage: vehicleMileage,
    details: Value(details),
    isActive: Value(isActive),
  );
  MaintenancesCompanion toCompanionUpdate() => MaintenancesCompanion(
    idMaintenance: Value(id),
    idVehicle: Value(vehicleId),
    maintenanceDate: Value(maintenanceDate),
    vehicleMileage: Value(vehicleMileage),
    details: Value(details),
    isActive: Value(isActive),
  );
}

// --- MaintenanceDetails ---
extension MaintenanceDetailDataX on MaintenanceDetail {
  d.MaintenanceDetail toDomain() => d.MaintenanceDetail(
    id: idDetail,
    maintenanceId: idMaintenance,
    description: description,
    cost: cost,
    isActive: isActive,
  );
}
extension MaintenanceDetailDomainX on d.MaintenanceDetail {
  MaintenanceDetailsCompanion toCompanionInsert() => MaintenanceDetailsCompanion.insert(
    idMaintenance: maintenanceId,
    description: description,
    cost: Value(cost),
    isActive: Value(isActive),
  );
  MaintenanceDetailsCompanion toCompanionUpdate() => MaintenanceDetailsCompanion(
    idDetail: Value(id),
    idMaintenance: Value(maintenanceId),
    description: Value(description),
    cost: Value(cost),
    isActive: Value(isActive),
  );
}

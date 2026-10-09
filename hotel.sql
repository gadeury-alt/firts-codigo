
CREATE DATABASE IF NOT EXISTS hotel;
USE hotel;

-- ---------- Huesped ----------
CREATE TABLE huesped (
    id_huesped INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(80) NOT NULL,
    apellido VARCHAR(80) NOT NULL,
    documento VARCHAR(30) UNIQUE,
    nacionalidad VARCHAR(60),
    telefono VARCHAR(20),
    correo VARCHAR(100)
);

-- ---------- Tipo de habitacion ----------
CREATE TABLE tipo_habitacion (
    id_tipo INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(255),
    capacidad INT NOT NULL,
    precio_noche DECIMAL(10,2) NOT NULL
);

-- ---------- Habitacion ----------
CREATE TABLE habitacion (
    id_habitacion INT AUTO_INCREMENT PRIMARY KEY,
    numero VARCHAR(10) NOT NULL UNIQUE,
    piso INT,
    id_tipo INT NOT NULL,
    estado VARCHAR(20) NOT NULL DEFAULT 'disponible',
    FOREIGN KEY (id_tipo) REFERENCES tipo_habitacion(id_tipo)
);

-- ---------- Empleado ----------
CREATE TABLE empleado (
    id_empleado INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(80) NOT NULL,
    apellido VARCHAR(80) NOT NULL,
    cargo VARCHAR(60),
    telefono VARCHAR(20),
    correo VARCHAR(100)
);

-- ---------- Reserva ----------
CREATE TABLE reserva (
    id_reserva INT AUTO_INCREMENT PRIMARY KEY,
    id_huesped INT NOT NULL,
    id_habitacion INT NOT NULL,
    id_empleado INT,
    fecha_reserva DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_entrada DATE NOT NULL,
    fecha_salida DATE NOT NULL,
    num_personas INT NOT NULL DEFAULT 1,
    estado VARCHAR(20) NOT NULL DEFAULT 'confirmada',
    FOREIGN KEY (id_huesped) REFERENCES huesped(id_huesped),
    FOREIGN KEY (id_habitacion) REFERENCES habitacion(id_habitacion),
    FOREIGN KEY (id_empleado) REFERENCES empleado(id_empleado)
);

-- ---------- Servicio ----------
CREATE TABLE servicio (
    id_servicio INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(80) NOT NULL,
    precio DECIMAL(10,2) NOT NULL
);

-- ---------- Consumo de servicios ----------
CREATE TABLE consumo_servicio (
    id_consumo INT AUTO_INCREMENT PRIMARY KEY,
    id_reserva INT NOT NULL,
    id_servicio INT NOT NULL,
    cantidad INT NOT NULL DEFAULT 1,
    fecha DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_reserva) REFERENCES reserva(id_reserva),
    FOREIGN KEY (id_servicio) REFERENCES servicio(id_servicio)
);

-- ---------- Metodo de pago ----------
CREATE TABLE metodo_pago (
    id_metodo_pago INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);

-- ---------- Pago ----------
CREATE TABLE pago (
    id_pago INT AUTO_INCREMENT PRIMARY KEY,
    id_reserva INT NOT NULL,
    id_metodo_pago INT NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    fecha DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    estado VARCHAR(20),
    FOREIGN KEY (id_reserva) REFERENCES reserva(id_reserva),
    FOREIGN KEY (id_metodo_pago) REFERENCES metodo_pago(id_metodo_pago)
);

-- =====================================
-- DATOS DE PRUEBA
-- =====================================
INSERT INTO huesped (nombre, apellido, documento, nacionalidad, telefono, correo) VALUES
('Ana', 'Perez', '001-0000001-1', 'Dominicana', '809-555-0101', 'ana@correo.com'),
('John', 'Smith', 'P-9988776', 'Estadounidense', '+1-555-0199', 'john@correo.com');

INSERT INTO tipo_habitacion (nombre, descripcion, capacidad, precio_noche) VALUES
('Sencilla', 'Una cama individual', 1, 60.00),
('Doble', 'Dos camas o una cama king', 2, 95.00),
('Suite', 'Sala y habitacion con vista al mar', 4, 220.00);

INSERT INTO habitacion (numero, piso, id_tipo, estado) VALUES
('101', 1, 1, 'disponible'),
('201', 2, 2, 'ocupada'),
('301', 3, 3, 'disponible');

INSERT INTO empleado (nombre, apellido, cargo, telefono, correo) VALUES
('Maria', 'Lopez', 'Recepcionista', '809-555-0601', 'maria@hotel.com');

INSERT INTO reserva (id_huesped, id_habitacion, id_empleado, fecha_entrada, fecha_salida, num_personas, estado) VALUES
(1, 2, 1, '2026-10-04', '2026-10-07', 2, 'en curso'),
(2, 3, 1, '2026-10-10', '2026-10-15', 3, 'confirmada');

INSERT INTO servicio (nombre, precio) VALUES
('Desayuno buffet', 12.00),
('Lavanderia', 8.50),
('Spa', 45.00);

INSERT INTO consumo_servicio (id_reserva, id_servicio, cantidad) VALUES
(1, 1, 2),
(1, 2, 1);

INSERT INTO metodo_pago (nombre) VALUES ('Efectivo'), ('Tarjeta'), ('Transferencia');

INSERT INTO pago (id_reserva, id_metodo_pago, monto, estado) VALUES
(1, 2, 100.00, 'abono');

-- =====================================
-- CONSULTA DE PRUEBA
-- =====================================
SELECT r.id_reserva,
       CONCAT(h.nombre, ' ', h.apellido) AS huesped,
       hab.numero AS habitacion,
       t.nombre AS tipo,
       r.fecha_entrada,
       r.fecha_salida,
       DATEDIFF(r.fecha_salida, r.fecha_entrada) * t.precio_noche AS total_hospedaje
FROM reserva r
JOIN huesped h ON r.id_huesped = h.id_huesped
JOIN habitacion hab ON r.id_habitacion = hab.id_habitacion
JOIN tipo_habitacion t ON hab.id_tipo = t.id_tipo;
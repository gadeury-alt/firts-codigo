CREATE DATABASE IF NOT EXISTS hospital;
USE hospital;

-- ---------- Especialidad ----------
CREATE TABLE especialidad (
    id_especialidad INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(80) NOT NULL,
    descripcion VARCHAR(255)
);

-- ---------- Medico ----------
CREATE TABLE medico (
    id_medico INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(80) NOT NULL,
    apellido VARCHAR(80) NOT NULL,
    telefono VARCHAR(20),
    correo VARCHAR(100),
    exequatur VARCHAR(30) UNIQUE,
    id_especialidad INT NOT NULL,
    FOREIGN KEY (id_especialidad) REFERENCES especialidad(id_especialidad)
);

-- ---------- Paciente ----------
CREATE TABLE paciente (
    id_paciente INT AUTO_INCREMENT PRIMARY KEY,
    cedula VARCHAR(20) UNIQUE,
    nombre VARCHAR(80) NOT NULL,
    apellido VARCHAR(80) NOT NULL,
    fecha_nacimiento DATE,
    sexo CHAR(1),
    telefono VARCHAR(20),
    direccion VARCHAR(200),
    tipo_sangre VARCHAR(5)
);

-- ---------- Habitacion ----------
CREATE TABLE habitacion (
    id_habitacion INT AUTO_INCREMENT PRIMARY KEY,
    numero VARCHAR(10) NOT NULL UNIQUE,
    tipo VARCHAR(30),
    piso INT,
    estado VARCHAR(20) NOT NULL DEFAULT 'disponible'
);

-- ---------- Cita ----------
CREATE TABLE cita (
    id_cita INT AUTO_INCREMENT PRIMARY KEY,
    id_paciente INT NOT NULL,
    id_medico INT NOT NULL,
    fecha_hora DATETIME NOT NULL,
    motivo VARCHAR(255),
    estado VARCHAR(20) NOT NULL DEFAULT 'programada',
    FOREIGN KEY (id_paciente) REFERENCES paciente(id_paciente),
    FOREIGN KEY (id_medico) REFERENCES medico(id_medico)
);

-- ---------- Consulta (resultado de una cita) ----------
CREATE TABLE consulta (
    id_consulta INT AUTO_INCREMENT PRIMARY KEY,
    id_cita INT NOT NULL UNIQUE,
    diagnostico VARCHAR(255),
    observaciones TEXT,
    FOREIGN KEY (id_cita) REFERENCES cita(id_cita)
);

-- ---------- Medicamento ----------
CREATE TABLE medicamento (
    id_medicamento INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(255),
    stock INT NOT NULL DEFAULT 0,
    precio DECIMAL(10,2)
);

-- ---------- Receta ----------
CREATE TABLE receta (
    id_receta INT AUTO_INCREMENT PRIMARY KEY,
    id_consulta INT NOT NULL,
    id_medicamento INT NOT NULL,
    dosis VARCHAR(50),
    frecuencia VARCHAR(50),
    duracion_dias INT,
    FOREIGN KEY (id_consulta) REFERENCES consulta(id_consulta),
    FOREIGN KEY (id_medicamento) REFERENCES medicamento(id_medicamento)
);

-- ---------- Ingreso (hospitalizacion) ----------
CREATE TABLE ingreso (
    id_ingreso INT AUTO_INCREMENT PRIMARY KEY,
    id_paciente INT NOT NULL,
    id_habitacion INT NOT NULL,
    id_medico INT NOT NULL,
    fecha_ingreso DATETIME NOT NULL,
    fecha_alta DATETIME,
    motivo VARCHAR(255),
    FOREIGN KEY (id_paciente) REFERENCES paciente(id_paciente),
    FOREIGN KEY (id_habitacion) REFERENCES habitacion(id_habitacion),
    FOREIGN KEY (id_medico) REFERENCES medico(id_medico)
);

-- ---------- Factura ----------
CREATE TABLE factura (
    id_factura INT AUTO_INCREMENT PRIMARY KEY,
    id_paciente INT NOT NULL,
    fecha DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    total DECIMAL(10,2) NOT NULL,
    estado VARCHAR(20) NOT NULL DEFAULT 'pendiente',
    FOREIGN KEY (id_paciente) REFERENCES paciente(id_paciente)
);

-- =====================================
-- DATOS DE PRUEBA
-- =====================================
INSERT INTO especialidad (nombre, descripcion) VALUES
('Cardiologia', 'Enfermedades del corazon'),
('Pediatria', 'Atencion medica de ninos');

INSERT INTO medico (nombre, apellido, telefono, correo, exequatur, id_especialidad) VALUES
('Carlos', 'Ramirez', '809-555-0501', 'carlos@hospital.com', 'EX-1001', 1),
('Laura', 'Santos', '809-555-0502', 'laura@hospital.com', 'EX-1002', 2);

INSERT INTO paciente (cedula, nombre, apellido, fecha_nacimiento, sexo, telefono, direccion, tipo_sangre) VALUES
('001-0000001-1', 'Ana', 'Perez', '1990-05-12', 'F', '809-555-0101', 'Calle Duarte 15, La Vega', 'O+'),
('001-0000002-2', 'Luis', 'Gomez', '2015-09-30', 'M', '809-555-0102', 'Calle Mella 7, La Vega', 'A+');

INSERT INTO habitacion (numero, tipo, piso, estado) VALUES
('101', 'Individual', 1, 'ocupada'),
('102', 'Doble', 1, 'disponible');

INSERT INTO cita (id_paciente, id_medico, fecha_hora, motivo, estado) VALUES
(1, 1, '2026-10-05 09:00:00', 'Dolor en el pecho', 'completada'),
(2, 2, '2026-10-06 10:30:00', 'Control de rutina', 'programada');

INSERT INTO consulta (id_cita, diagnostico, observaciones) VALUES
(1, 'Hipertension leve', 'Se recomienda dieta baja en sal y control en 30 dias.');

INSERT INTO medicamento (nombre, descripcion, stock, precio) VALUES
('Losartan 50mg', 'Antihipertensivo', 200, 12.50),
('Paracetamol 500mg', 'Analgesico', 500, 3.00);

INSERT INTO receta (id_consulta, id_medicamento, dosis, frecuencia, duracion_dias) VALUES
(1, 1, '1 tableta', 'Cada 24 horas', 30);

INSERT INTO ingreso (id_paciente, id_habitacion, id_medico, fecha_ingreso, fecha_alta, motivo) VALUES
(1, 1, 1, '2026-10-05 12:00:00', NULL, 'Observacion cardiaca');

INSERT INTO factura (id_paciente, total, estado) VALUES
(1, 2500.00, 'pendiente');

-- =====================================
-- CONSULTA DE PRUEBA
-- =====================================
SELECT c.id_cita,
       CONCAT(p.nombre, ' ', p.apellido) AS paciente,
       CONCAT(m.nombre, ' ', m.apellido) AS medico,
       e.nombre AS especialidad,
       c.fecha_hora,
       c.estado
FROM cita c
JOIN paciente p ON c.id_paciente = p.id_paciente
JOIN medico m ON c.id_medico = m.id_medico
JOIN especialidad e ON m.id_especialidad = e.id_especialidad;
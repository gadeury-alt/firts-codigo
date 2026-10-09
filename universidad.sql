CREATE DATABASE IF NOT EXISTS universidad;
USE universidad;

-- ---------- Facultad ----------
CREATE TABLE facultad (
    id_facultad INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    decano VARCHAR(100)
);

-- ---------- Carrera ----------
CREATE TABLE carrera (
    id_carrera INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    id_facultad INT NOT NULL,
    duracion_semestres INT,
    total_creditos INT,
    FOREIGN KEY (id_facultad) REFERENCES facultad(id_facultad)
);

-- ---------- Estudiante ----------
CREATE TABLE estudiante (
    matricula VARCHAR(20) PRIMARY KEY,
    nombre VARCHAR(80) NOT NULL,
    apellido VARCHAR(80) NOT NULL,
    correo VARCHAR(100) UNIQUE,
    telefono VARCHAR(20),
    fecha_ingreso DATE,
    id_carrera INT NOT NULL,
    FOREIGN KEY (id_carrera) REFERENCES carrera(id_carrera)
);

-- ---------- Profesor ----------
CREATE TABLE profesor (
    id_profesor INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(80) NOT NULL,
    apellido VARCHAR(80) NOT NULL,
    correo VARCHAR(100),
    titulo VARCHAR(80),
    id_facultad INT NOT NULL,
    FOREIGN KEY (id_facultad) REFERENCES facultad(id_facultad)
);

-- ---------- Asignatura ----------
CREATE TABLE asignatura (
    id_asignatura INT AUTO_INCREMENT PRIMARY KEY,
    codigo VARCHAR(15) NOT NULL UNIQUE,
    nombre VARCHAR(100) NOT NULL,
    creditos INT NOT NULL,
    id_carrera INT NOT NULL,
    FOREIGN KEY (id_carrera) REFERENCES carrera(id_carrera)
);

-- ---------- Periodo academico ----------
CREATE TABLE periodo (
    id_periodo INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(30) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL
);

-- ---------- Seccion (una asignatura dada por un profesor en un periodo) ----------
CREATE TABLE seccion (
    id_seccion INT AUTO_INCREMENT PRIMARY KEY,
    id_asignatura INT NOT NULL,
    id_profesor INT NOT NULL,
    id_periodo INT NOT NULL,
    aula VARCHAR(20),
    horario VARCHAR(50),
    cupo INT NOT NULL DEFAULT 30,
    FOREIGN KEY (id_asignatura) REFERENCES asignatura(id_asignatura),
    FOREIGN KEY (id_profesor) REFERENCES profesor(id_profesor),
    FOREIGN KEY (id_periodo) REFERENCES periodo(id_periodo)
);

-- ---------- Inscripcion (un estudiante en una seccion) ----------
CREATE TABLE inscripcion (
    id_inscripcion INT AUTO_INCREMENT PRIMARY KEY,
    matricula VARCHAR(20) NOT NULL,
    id_seccion INT NOT NULL,
    fecha_inscripcion DATE NOT NULL,
    nota_final DECIMAL(5,2),
    estado VARCHAR(20) NOT NULL DEFAULT 'cursando',
    UNIQUE (matricula, id_seccion),
    FOREIGN KEY (matricula) REFERENCES estudiante(matricula),
    FOREIGN KEY (id_seccion) REFERENCES seccion(id_seccion)
);

-- ---------- Pago ----------
CREATE TABLE pago (
    id_pago INT AUTO_INCREMENT PRIMARY KEY,
    matricula VARCHAR(20) NOT NULL,
    id_periodo INT NOT NULL,
    concepto VARCHAR(80) NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    fecha DATE NOT NULL,
    FOREIGN KEY (matricula) REFERENCES estudiante(matricula),
    FOREIGN KEY (id_periodo) REFERENCES periodo(id_periodo)
);

-- =====================================
-- DATOS DE PRUEBA
-- =====================================
INSERT INTO facultad (nombre, decano) VALUES
('Ciencias y Tecnologia', 'Dr. Roberto Mena'),
('Ciencias Economicas', 'Dra. Patricia Vega');

INSERT INTO carrera (nombre, id_facultad, duracion_semestres, total_creditos) VALUES
('Ingenieria en Sistemas', 1, 10, 200),
('Contabilidad', 2, 8, 160);

INSERT INTO estudiante (matricula, nombre, apellido, correo, telefono, fecha_ingreso, id_carrera) VALUES
('2024-0001', 'Ana', 'Perez', 'ana@uni.edu', '809-555-0101', '2024-08-15', 1),
('2024-0002', 'Luis', 'Gomez', 'luis@uni.edu', '809-555-0102', '2024-08-15', 2);

INSERT INTO profesor (nombre, apellido, correo, titulo, id_facultad) VALUES
('Carlos', 'Ramirez', 'carlos@uni.edu', 'Maestria en Informatica', 1),
('Laura', 'Santos', 'laura@uni.edu', 'Maestria en Finanzas', 2);

INSERT INTO asignatura (codigo, nombre, creditos, id_carrera) VALUES
('INF-101', 'Bases de Datos I', 4, 1),
('CON-101', 'Contabilidad General', 3, 2);

INSERT INTO periodo (nombre, fecha_inicio, fecha_fin) VALUES
('2026-2', '2026-08-17', '2026-12-18');

INSERT INTO seccion (id_asignatura, id_profesor, id_periodo, aula, horario, cupo) VALUES
(1, 1, 1, 'A-201', 'Lun y Mie 8:00-10:00', 30),
(2, 2, 1, 'B-105', 'Mar y Jue 10:00-12:00', 35);

INSERT INTO inscripcion (matricula, id_seccion, fecha_inscripcion, nota_final, estado) VALUES
('2024-0001', 1, '2026-08-10', NULL, 'cursando'),
('2024-0002', 2, '2026-08-10', NULL, 'cursando');

INSERT INTO pago (matricula, id_periodo, concepto, monto, fecha) VALUES
('2024-0001', 1, 'Inscripcion', 3500.00, '2026-08-10'),
('2024-0002', 1, 'Inscripcion', 3000.00, '2026-08-10');

-- =====================================
-- CONSULTA DE PRUEBA
-- =====================================
SELECT CONCAT(e.nombre, ' ', e.apellido) AS estudiante,
       c.nombre AS carrera,
       a.codigo,
       a.nombre AS asignatura,
       CONCAT(p.nombre, ' ', p.apellido) AS profesor,
       pe.nombre AS periodo,
       i.estado
FROM inscripcion i
JOIN estudiante e ON i.matricula = e.matricula
JOIN carrera c ON e.id_carrera = c.id_carrera
JOIN seccion s ON i.id_seccion = s.id_seccion
JOIN asignatura a ON s.id_asignatura = a.id_asignatura
JOIN profesor p ON s.id_profesor = p.id_profesor
JOIN periodo pe ON s.id_periodo = pe.id_periodo;
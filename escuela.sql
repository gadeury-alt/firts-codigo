CREATE DATABASE IF NOT EXISTS escuela;
USE escuela;

-- ---------- Grado ----------
CREATE TABLE grado (
    id_grado INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    nivel VARCHAR(30)
);

-- ---------- Seccion ----------
CREATE TABLE seccion (
    id_seccion INT AUTO_INCREMENT PRIMARY KEY,
    id_grado INT NOT NULL,
    nombre VARCHAR(10) NOT NULL,
    anio_escolar VARCHAR(9) NOT NULL,
    FOREIGN KEY (id_grado) REFERENCES grado(id_grado)
);

-- ---------- Estudiante ----------
CREATE TABLE estudiante (
    matricula VARCHAR(20) PRIMARY KEY,
    nombre VARCHAR(80) NOT NULL,
    apellido VARCHAR(80) NOT NULL,
    fecha_nacimiento DATE,
    sexo CHAR(1),
    direccion VARCHAR(200),
    id_seccion INT NOT NULL,
    FOREIGN KEY (id_seccion) REFERENCES seccion(id_seccion)
);

-- ---------- Tutor ----------
CREATE TABLE tutor (
    id_tutor INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(80) NOT NULL,
    apellido VARCHAR(80) NOT NULL,
    telefono VARCHAR(20),
    correo VARCHAR(100)
);

-- ---------- Estudiante - Tutor (un estudiante puede tener varios tutores) ----------
CREATE TABLE estudiante_tutor (
    matricula VARCHAR(20) NOT NULL,
    id_tutor INT NOT NULL,
    parentesco VARCHAR(30),
    PRIMARY KEY (matricula, id_tutor),
    FOREIGN KEY (matricula) REFERENCES estudiante(matricula),
    FOREIGN KEY (id_tutor) REFERENCES tutor(id_tutor)
);

-- ---------- Profesor ----------
CREATE TABLE profesor (
    id_profesor INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(80) NOT NULL,
    apellido VARCHAR(80) NOT NULL,
    telefono VARCHAR(20),
    correo VARCHAR(100),
    especialidad VARCHAR(80)
);

-- ---------- Materia ----------
CREATE TABLE materia (
    id_materia INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(80) NOT NULL,
    horas_semanales INT
);

-- ---------- Asignacion (que profesor da que materia en que seccion) ----------
CREATE TABLE asignacion (
    id_asignacion INT AUTO_INCREMENT PRIMARY KEY,
    id_profesor INT NOT NULL,
    id_materia INT NOT NULL,
    id_seccion INT NOT NULL,
    FOREIGN KEY (id_profesor) REFERENCES profesor(id_profesor),
    FOREIGN KEY (id_materia) REFERENCES materia(id_materia),
    FOREIGN KEY (id_seccion) REFERENCES seccion(id_seccion)
);

-- ---------- Calificacion ----------
CREATE TABLE calificacion (
    id_calificacion INT AUTO_INCREMENT PRIMARY KEY,
    matricula VARCHAR(20) NOT NULL,
    id_materia INT NOT NULL,
    periodo VARCHAR(20) NOT NULL,
    nota DECIMAL(5,2) NOT NULL,
    fecha DATE,
    FOREIGN KEY (matricula) REFERENCES estudiante(matricula),
    FOREIGN KEY (id_materia) REFERENCES materia(id_materia)
);

-- ---------- Asistencia ----------
CREATE TABLE asistencia (
    id_asistencia INT AUTO_INCREMENT PRIMARY KEY,
    matricula VARCHAR(20) NOT NULL,
    fecha DATE NOT NULL,
    estado VARCHAR(20) NOT NULL,
    FOREIGN KEY (matricula) REFERENCES estudiante(matricula)
);

-- =====================================
-- DATOS DE PRUEBA
-- =====================================
INSERT INTO grado (nombre, nivel) VALUES
('Primero', 'Primaria'),
('Segundo', 'Primaria');

INSERT INTO seccion (id_grado, nombre, anio_escolar) VALUES
(1, 'A', '2026-2027'),
(2, 'A', '2026-2027');

INSERT INTO estudiante (matricula, nombre, apellido, fecha_nacimiento, sexo, direccion, id_seccion) VALUES
('E-0001', 'Ana', 'Perez', '2019-03-10', 'F', 'Calle Duarte 15, La Vega', 1),
('E-0002', 'Luis', 'Gomez', '2018-07-22', 'M', 'Calle Mella 7, La Vega', 2);

INSERT INTO tutor (nombre, apellido, telefono, correo) VALUES
('Carmen', 'Perez', '809-555-0301', 'carmen@correo.com'),
('Pedro', 'Gomez', '809-555-0302', 'pedro@correo.com');

INSERT INTO estudiante_tutor (matricula, id_tutor, parentesco) VALUES
('E-0001', 1, 'Madre'),
('E-0002', 2, 'Padre');

INSERT INTO profesor (nombre, apellido, telefono, correo, especialidad) VALUES
('Maria', 'Lopez', '809-555-0401', 'maria@escuela.com', 'Matematicas'),
('Jose', 'Diaz', '809-555-0402', 'jose@escuela.com', 'Lengua Espanola');

INSERT INTO materia (nombre, horas_semanales) VALUES
('Matematicas', 5),
('Lengua Espanola', 5);

INSERT INTO asignacion (id_profesor, id_materia, id_seccion) VALUES
(1, 1, 1),
(2, 2, 1),
(1, 1, 2);

INSERT INTO calificacion (matricula, id_materia, periodo, nota, fecha) VALUES
('E-0001', 1, 'Periodo 1', 92.50, '2026-10-01'),
('E-0001', 2, 'Periodo 1', 88.00, '2026-10-01'),
('E-0002', 1, 'Periodo 1', 75.00, '2026-10-01');

INSERT INTO asistencia (matricula, fecha, estado) VALUES
('E-0001', '2026-10-01', 'Presente'),
('E-0002', '2026-10-01', 'Ausente');

-- =====================================
-- CONSULTA DE PRUEBA
-- =====================================
SELECT CONCAT(e.nombre, ' ', e.apellido) AS estudiante,
       g.nombre AS grado,
       s.nombre AS seccion,
       m.nombre AS materia,
       c.periodo,
       c.nota
FROM calificacion c
JOIN estudiante e ON c.matricula = e.matricula
JOIN seccion s ON e.id_seccion = s.id_seccion
JOIN grado g ON s.id_grado = g.id_grado
JOIN materia m ON c.id_materia = m.id_materia;
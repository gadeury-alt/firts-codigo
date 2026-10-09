CREATE DATABASE IF NOT EXISTS biblioteca;
USE biblioteca;

-- ---------- Tabla: Categoria ----------
CREATE TABLE categoria (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nombre_categoria VARCHAR(100) NOT NULL,
    descripcion VARCHAR(255)
);

-- ---------- Tabla: Libro ----------
CREATE TABLE libro (
    id_libro INT AUTO_INCREMENT PRIMARY KEY,
    id_categoria INT NOT NULL,
    titulo VARCHAR(150) NOT NULL,
    anio_publicado YEAR,
    cantidad_disponible INT NOT NULL DEFAULT 0,
    FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria)
);

-- ---------- Tabla: Estudiante ----------
CREATE TABLE estudiante (
    matricula VARCHAR(20) PRIMARY KEY,
    nombre VARCHAR(80) NOT NULL,
    apellido VARCHAR(80) NOT NULL,
    carrera VARCHAR(100),
    seccion VARCHAR(20)
);

-- ---------- Tabla: Bibliotecario ----------
CREATE TABLE bibliotecario (
    id_bibliotecario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(80) NOT NULL,
    apellido VARCHAR(80) NOT NULL,
    telefono VARCHAR(20)
);

-- ---------- Tabla: Prestamo ----------
CREATE TABLE prestamo (
    id_prestamo INT AUTO_INCREMENT PRIMARY KEY,
    id_bibliotecario INT NOT NULL,
    id_libro INT NOT NULL,
    matricula VARCHAR(20) NOT NULL,
    estado_libro VARCHAR(50),
    fecha_prestamo DATE NOT NULL,
    fecha_devolucion DATE,
    FOREIGN KEY (id_bibliotecario) REFERENCES bibliotecario(id_bibliotecario),
    FOREIGN KEY (id_libro) REFERENCES libro(id_libro),
    FOREIGN KEY (matricula) REFERENCES estudiante(matricula)
);

-- =====================================
-- DATOS DE PRUEBA
-- =====================================
INSERT INTO categoria (nombre_categoria, descripcion) VALUES
('Programacion', 'Libros de desarrollo de software'),
('Matematicas', 'Algebra, calculo y estadistica');

INSERT INTO libro (id_categoria, titulo, anio_publicado, cantidad_disponible) VALUES
(1, 'Aprendiendo SQL', 2020, 5),
(2, 'Calculo Basico', 2018, 3);

INSERT INTO estudiante (matricula, nombre, apellido, carrera, seccion) VALUES
('2024-0001', 'Ana', 'Perez', 'Informatica', 'A'),
('2024-0002', 'Luis', 'Gomez', 'Ingenieria', 'B');

INSERT INTO bibliotecario (nombre, apellido, telefono) VALUES
('Maria', 'Lopez', '809-555-0101');

INSERT INTO prestamo (id_bibliotecario, id_libro, matricula, estado_libro, fecha_prestamo, fecha_devolucion) VALUES
(1, 1, '2024-0001', 'Bueno', '2026-10-01', '2026-10-08'),
(1, 2, '2024-0001', 'Bueno', '2026-10-02', NULL);

-- =====================================
-- CONSULTA DE PRUEBA (une todas las tablas)
-- =====================================
SELECT p.id_prestamo,
       e.nombre AS estudiante,
       l.titulo AS libro,
       c.nombre_categoria AS categoria,
       b.nombre AS bibliotecario,
       p.fecha_prestamo,
       p.fecha_devolucion
FROM prestamo p
JOIN estudiante e ON p.matricula = e.matricula
JOIN libro l ON p.id_libro = l.id_libro
JOIN categoria c ON l.id_categoria = c.id_categoria
JOIN bibliotecario b ON p.id_bibliotecario = b.id_bibliotecario;
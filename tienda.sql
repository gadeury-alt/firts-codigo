CREATE DATABASE IF NOT EXISTS tienda;
USE tienda;

-- ---------- Cliente ----------
CREATE TABLE cliente (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(80) NOT NULL,
    apellido VARCHAR(80) NOT NULL,
    correo VARCHAR(100) UNIQUE,
    telefono VARCHAR(20),
    fecha_registro DATE NOT NULL
);

-- ---------- Direccion ----------
CREATE TABLE direccion (
    id_direccion INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    calle VARCHAR(150) NOT NULL,
    ciudad VARCHAR(80),
    provincia VARCHAR(80),
    codigo_postal VARCHAR(15),
    pais VARCHAR(60),
    tipo VARCHAR(30),
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
);

-- ---------- Categoria ----------
CREATE TABLE categoria (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(255)
);

-- ---------- Proveedor ----------
CREATE TABLE proveedor (
    id_proveedor INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    contacto VARCHAR(100),
    telefono VARCHAR(20),
    correo VARCHAR(100),
    direccion VARCHAR(200)
);

-- ---------- Producto ----------
CREATE TABLE producto (
    id_producto INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(255),
    precio DECIMAL(10,2) NOT NULL,
    costo DECIMAL(10,2),
    id_categoria INT NOT NULL,
    id_proveedor INT NOT NULL,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria),
    FOREIGN KEY (id_proveedor) REFERENCES proveedor(id_proveedor)
);

-- ---------- Inventario ----------
CREATE TABLE inventario (
    id_inventario INT AUTO_INCREMENT PRIMARY KEY,
    id_producto INT NOT NULL UNIQUE,
    cantidad_disponible INT NOT NULL DEFAULT 0,
    stock_minimo INT NOT NULL DEFAULT 0,
    ubicacion VARCHAR(100),
    fecha_actualizacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
);

-- ---------- Empleado ----------
CREATE TABLE empleado (
    id_empleado INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(80) NOT NULL,
    apellido VARCHAR(80) NOT NULL,
    cargo VARCHAR(80),
    correo VARCHAR(100),
    fecha_contratacion DATE
);

-- ---------- Metodo de pago ----------
CREATE TABLE metodo_pago (
    id_metodo_pago INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);

-- ---------- Pedido ----------
CREATE TABLE pedido (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_empleado INT,
    fecha DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    estado VARCHAR(30) NOT NULL DEFAULT 'pendiente',
    total DECIMAL(10,2) NOT NULL DEFAULT 0,
    id_direccion_envio INT NOT NULL,
    id_metodo_pago INT,
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
    FOREIGN KEY (id_empleado) REFERENCES empleado(id_empleado),
    FOREIGN KEY (id_direccion_envio) REFERENCES direccion(id_direccion),
    FOREIGN KEY (id_metodo_pago) REFERENCES metodo_pago(id_metodo_pago)
);

-- ---------- Detalle del pedido ----------
CREATE TABLE detalle_pedido (
    id_detalle INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    descuento DECIMAL(10,2) NOT NULL DEFAULT 0,
    FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido),
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
);

-- ---------- Pago ----------
CREATE TABLE pago (
    id_pago INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT NOT NULL,
    id_metodo_pago INT NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    fecha DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    estado VARCHAR(30),
    referencia VARCHAR(100),
    FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido),
    FOREIGN KEY (id_metodo_pago) REFERENCES metodo_pago(id_metodo_pago)
);

-- ---------- Envio ----------
CREATE TABLE envio (
    id_envio INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT NOT NULL,
    transportista VARCHAR(80),
    numero_seguimiento VARCHAR(60),
    fecha_envio DATE,
    fecha_entrega DATE,
    estado VARCHAR(30),
    FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido)
);

-- =====================================
-- DATOS DE PRUEBA
-- =====================================
INSERT INTO cliente (nombre, apellido, correo, telefono, fecha_registro) VALUES
('Ana', 'Perez', 'ana@correo.com', '809-555-0101', '2026-09-01'),
('Luis', 'Gomez', 'luis@correo.com', '809-555-0102', '2026-09-05');

INSERT INTO direccion (id_cliente, calle, ciudad, provincia, codigo_postal, pais, tipo) VALUES
(1, 'Calle Duarte 15', 'La Vega', 'La Vega', '41000', 'Republica Dominicana', 'casa'),
(1, 'Av. Independencia 80', 'Santo Domingo', 'Distrito Nacional', '10101', 'Republica Dominicana', 'trabajo'),
(2, 'Calle Mella 7', 'Santiago', 'Santiago', '51000', 'Republica Dominicana', 'casa');

INSERT INTO categoria (nombre, descripcion) VALUES
('Tecnologia', 'Computadoras y accesorios'),
('Hogar', 'Articulos para el hogar');

INSERT INTO proveedor (nombre, contacto, telefono, correo, direccion) VALUES
('TecnoSuministros', 'Carlos Diaz', '809-555-0200', 'ventas@tecno.com', 'Zona Industrial, Santiago');

INSERT INTO producto (nombre, descripcion, precio, costo, id_categoria, id_proveedor, activo) VALUES
('Laptop', 'Laptop 15 pulgadas', 750.00, 600.00, 1, 1, TRUE),
('Mouse', 'Mouse inalambrico', 15.50, 8.00, 1, 1, TRUE);

INSERT INTO inventario (id_producto, cantidad_disponible, stock_minimo, ubicacion) VALUES
(1, 10, 3, 'Almacen A'),
(2, 50, 10, 'Almacen B');

INSERT INTO empleado (nombre, apellido, cargo, correo, fecha_contratacion) VALUES
('Maria', 'Lopez', 'Vendedora', 'maria@tienda.com', '2025-01-15');

INSERT INTO metodo_pago (nombre) VALUES ('Efectivo'), ('Tarjeta'), ('Transferencia');

INSERT INTO pedido (id_cliente, id_empleado, estado, total, id_direccion_envio, id_metodo_pago) VALUES
(1, 1, 'pagado', 781.00, 1, 2);

INSERT INTO detalle_pedido (id_pedido, id_producto, cantidad, precio_unitario, descuento) VALUES
(1, 1, 1, 750.00, 0),
(1, 2, 2, 15.50, 0);

INSERT INTO pago (id_pedido, id_metodo_pago, monto, estado, referencia) VALUES
(1, 2, 781.00, 'aprobado', 'REF-0001');

INSERT INTO envio (id_pedido, transportista, numero_seguimiento, fecha_envio, fecha_entrega, estado) VALUES
(1, 'EnviaRD', 'TRK-12345', '2026-10-02', NULL, 'en camino');

-- =====================================
-- CONSULTA DE PRUEBA
-- =====================================
SELECT p.id_pedido,
       CONCAT(c.nombre, ' ', c.apellido) AS cliente,
       pr.nombre AS producto,
       d.cantidad,
       d.precio_unitario,
       p.total,
       p.estado
FROM pedido p
JOIN cliente c ON p.id_cliente = c.id_cliente
JOIN detalle_pedido d ON p.id_pedido = d.id_pedido
JOIN producto pr ON d.id_producto = pr.id_producto;
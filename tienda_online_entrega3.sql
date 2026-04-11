-- ============================================================
-- ARCHIVO: tienda_online_entrega3.sql
-- BASE DE DATOS: TIENDA EN LÍNEA
-- Motor: MySQL 8.0+
-- Autor: Natalia Puñal
-- Fecha: 2026
-- Descripción: Entrega 3 - Esquema completo, SP, Funciones,
--              Triggers y datos de prueba
-- ============================================================

DROP DATABASE IF EXISTS tienda_online;
CREATE DATABASE tienda_online
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;

USE tienda_online;

-- ============================================================
-- 1. TABLAS
-- ============================================================

-- Tabla 1
CREATE TABLE categorias (
  cat_id             INT UNSIGNED  NOT NULL AUTO_INCREMENT,
  cat_nombre         VARCHAR(100)  NOT NULL,
  cat_descripcion    TEXT          NULL,
  cat_activa         TINYINT(1)    NOT NULL DEFAULT 1,
  cat_fecha_creacion DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT pk_categorias PRIMARY KEY (cat_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabla 2
CREATE TABLE productos (
  prod_id             INT UNSIGNED  NOT NULL AUTO_INCREMENT,
  cat_id              INT UNSIGNED  NOT NULL,
  prod_nombre         VARCHAR(150)  NOT NULL,
  prod_descripcion    TEXT          NULL,
  prod_precio         DECIMAL(10,2) NOT NULL,
  prod_imagen         VARCHAR(255)  NULL,
  prod_activo         TINYINT(1)    NOT NULL DEFAULT 1,
  prod_fecha_registro DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT pk_productos PRIMARY KEY (prod_id),
  CONSTRAINT fk_prod_cat  FOREIGN KEY (cat_id)
    REFERENCES categorias(cat_id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  INDEX idx_prod_categoria (cat_id),
  INDEX idx_prod_nombre    (prod_nombre)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabla 3
CREATE TABLE inventario (
  inv_id                   INT UNSIGNED NOT NULL AUTO_INCREMENT,
  prod_id                  INT UNSIGNED NOT NULL,
  inv_stock                INT UNSIGNED NOT NULL DEFAULT 0,
  inv_stock_minimo         INT UNSIGNED NOT NULL DEFAULT 5,
  inv_ultima_actualizacion DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP
                                        ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT pk_inventario PRIMARY KEY (inv_id),
  CONSTRAINT uq_inv_prod   UNIQUE (prod_id),
  CONSTRAINT fk_inv_prod   FOREIGN KEY (prod_id)
    REFERENCES productos(prod_id)
    ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabla 4
CREATE TABLE clientes (
  cli_id             INT UNSIGNED  NOT NULL AUTO_INCREMENT,
  cli_nombre         VARCHAR(100)  NOT NULL,
  cli_apellido       VARCHAR(100)  NOT NULL,
  cli_email          VARCHAR(150)  NOT NULL,
  cli_telefono       VARCHAR(20)   NULL,
  cli_password       VARCHAR(255)  NOT NULL,
  cli_activo         TINYINT(1)    NOT NULL DEFAULT 1,
  cli_fecha_registro DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT pk_clientes  PRIMARY KEY (cli_id),
  CONSTRAINT uq_cli_email UNIQUE (cli_email),
  INDEX idx_cli_email (cli_email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabla 5
CREATE TABLE direcciones (
  dir_id             INT UNSIGNED  NOT NULL AUTO_INCREMENT,
  cli_id             INT UNSIGNED  NOT NULL,
  dir_calle          VARCHAR(200)  NOT NULL,
  dir_ciudad         VARCHAR(100)  NOT NULL,
  dir_estado         VARCHAR(100)  NOT NULL,
  dir_codigo_postal  VARCHAR(10)   NOT NULL,
  dir_pais           VARCHAR(80)   NOT NULL,
  dir_predeterminada TINYINT(1)    NOT NULL DEFAULT 0,
  CONSTRAINT pk_direcciones PRIMARY KEY (dir_id),
  CONSTRAINT fk_dir_cli     FOREIGN KEY (cli_id)
    REFERENCES clientes(cli_id)
    ON UPDATE CASCADE ON DELETE CASCADE,
  INDEX idx_dir_cliente (cli_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabla 6
CREATE TABLE cupones (
  cup_id                INT UNSIGNED  NOT NULL AUTO_INCREMENT,
  cup_codigo            VARCHAR(50)   NOT NULL,
  cup_descripcion       VARCHAR(200)  NULL,
  cup_descuento_pct     DECIMAL(5,2)  NOT NULL,
  cup_monto_minimo      DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  cup_fecha_inicio      DATE          NOT NULL,
  cup_fecha_vencimiento DATE          NOT NULL,
  cup_activo            TINYINT(1)    NOT NULL DEFAULT 1,
  CONSTRAINT pk_cupones    PRIMARY KEY (cup_id),
  CONSTRAINT uq_cup_codigo UNIQUE (cup_codigo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabla 7
CREATE TABLE pedidos (
  ped_id     INT UNSIGNED  NOT NULL AUTO_INCREMENT,
  cli_id     INT UNSIGNED  NOT NULL,
  dir_id     INT UNSIGNED  NOT NULL,
  ped_fecha  DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ped_estado ENUM('pendiente','procesando','enviado','entregado','cancelado')
             NOT NULL DEFAULT 'pendiente',
  ped_total  DECIMAL(10,2) NOT NULL,
  ped_notas  TEXT          NULL,
  CONSTRAINT pk_pedidos PRIMARY KEY (ped_id),
  CONSTRAINT fk_ped_cli FOREIGN KEY (cli_id)
    REFERENCES clientes(cli_id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_ped_dir FOREIGN KEY (dir_id)
    REFERENCES direcciones(dir_id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  INDEX idx_ped_cliente (cli_id),
  INDEX idx_ped_estado  (ped_estado),
  INDEX idx_ped_fecha   (ped_fecha)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabla 8
CREATE TABLE detalle_pedidos (
  det_id              INT UNSIGNED  NOT NULL AUTO_INCREMENT,
  ped_id              INT UNSIGNED  NOT NULL,
  prod_id             INT UNSIGNED  NOT NULL,
  det_cantidad        INT UNSIGNED  NOT NULL,
  det_precio_unitario DECIMAL(10,2) NOT NULL,
  det_subtotal        DECIMAL(10,2) NOT NULL,
  CONSTRAINT pk_detalle      PRIMARY KEY (det_id),
  CONSTRAINT fk_det_pedido   FOREIGN KEY (ped_id)
    REFERENCES pedidos(ped_id)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_det_producto FOREIGN KEY (prod_id)
    REFERENCES productos(prod_id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  INDEX idx_det_pedido   (ped_id),
  INDEX idx_det_producto (prod_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabla 9
CREATE TABLE metodos_pago (
  mp_id          INT UNSIGNED  NOT NULL AUTO_INCREMENT,
  mp_nombre      VARCHAR(80)   NOT NULL,
  mp_descripcion VARCHAR(200)  NULL,
  mp_activo      TINYINT(1)    NOT NULL DEFAULT 1,
  CONSTRAINT pk_metodos_pago PRIMARY KEY (mp_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabla 10
CREATE TABLE pagos (
  pag_id         INT UNSIGNED  NOT NULL AUTO_INCREMENT,
  ped_id         INT UNSIGNED  NOT NULL,
  mp_id          INT UNSIGNED  NOT NULL,
  pag_monto      DECIMAL(10,2) NOT NULL,
  pag_fecha      DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  pag_referencia VARCHAR(100)  NULL,
  pag_estado     ENUM('pendiente','completado','fallido','reembolsado')
                 NOT NULL DEFAULT 'pendiente',
  CONSTRAINT pk_pagos      PRIMARY KEY (pag_id),
  CONSTRAINT fk_pag_pedido FOREIGN KEY (ped_id)
    REFERENCES pedidos(ped_id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_pag_metodo FOREIGN KEY (mp_id)
    REFERENCES metodos_pago(mp_id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  INDEX idx_pag_pedido (ped_id),
  INDEX idx_pag_estado (pag_estado)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabla 11
CREATE TABLE envios (
  env_id             INT UNSIGNED NOT NULL AUTO_INCREMENT,
  ped_id             INT UNSIGNED NOT NULL,
  env_transportista  VARCHAR(100) NOT NULL,
  env_numero_guia    VARCHAR(100) NULL,
  env_fecha_envio    DATETIME     NULL,
  env_fecha_estimada DATE         NULL,
  env_fecha_entrega  DATETIME     NULL,
  env_estado         ENUM('preparando','en_camino','entregado','devuelto')
                     NOT NULL DEFAULT 'preparando',
  CONSTRAINT pk_envios     PRIMARY KEY (env_id),
  CONSTRAINT uq_env_pedido UNIQUE (ped_id),
  CONSTRAINT fk_env_pedido FOREIGN KEY (ped_id)
    REFERENCES pedidos(ped_id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  INDEX idx_env_estado (env_estado)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabla 12
CREATE TABLE resenas (
  res_id           INT UNSIGNED NOT NULL AUTO_INCREMENT,
  prod_id          INT UNSIGNED NOT NULL,
  cli_id           INT UNSIGNED NOT NULL,
  res_calificacion TINYINT      NOT NULL COMMENT 'Valor del 1 al 5',
  res_comentario   TEXT         NULL,
  res_fecha        DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  res_activa       TINYINT(1)   NOT NULL DEFAULT 1,
  CONSTRAINT pk_resenas  PRIMARY KEY (res_id),
  CONSTRAINT fk_res_prod FOREIGN KEY (prod_id)
    REFERENCES productos(prod_id)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_res_cli  FOREIGN KEY (cli_id)
    REFERENCES clientes(cli_id)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT chk_calificacion CHECK (res_calificacion BETWEEN 1 AND 5),
  INDEX idx_res_producto (prod_id),
  INDEX idx_res_cliente  (cli_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabla 13
CREATE TABLE pedidos_cupones (
  pc_id                 INT UNSIGNED  NOT NULL AUTO_INCREMENT,
  ped_id                INT UNSIGNED  NOT NULL,
  cup_id                INT UNSIGNED  NOT NULL,
  pc_descuento_aplicado DECIMAL(10,2) NOT NULL,
  CONSTRAINT pk_ped_cup   PRIMARY KEY (pc_id),
  CONSTRAINT uq_ped_cup   UNIQUE (ped_id, cup_id),
  CONSTRAINT fk_pc_pedido FOREIGN KEY (ped_id)
    REFERENCES pedidos(ped_id)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_pc_cupon  FOREIGN KEY (cup_id)
    REFERENCES cupones(cup_id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  INDEX idx_pc_pedido (ped_id),
  INDEX idx_pc_cupon  (cup_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabla 14
CREATE TABLE devoluciones (
  dev_id     INT UNSIGNED  NOT NULL AUTO_INCREMENT,
  ped_id     INT UNSIGNED  NOT NULL,
  dev_motivo TEXT          NOT NULL,
  dev_estado ENUM('solicitada','aprobada','rechazada','completada')
             NOT NULL DEFAULT 'solicitada',
  dev_monto  DECIMAL(10,2) NULL,
  dev_fecha  DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT pk_devoluciones PRIMARY KEY (dev_id),
  CONSTRAINT fk_dev_pedido   FOREIGN KEY (ped_id)
    REFERENCES pedidos(ped_id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  INDEX idx_dev_pedido (ped_id),
  INDEX idx_dev_estado (dev_estado)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabla 15
CREATE TABLE auditoria_stock (
  aud_id             INT UNSIGNED  NOT NULL AUTO_INCREMENT,
  prod_id            INT UNSIGNED  NOT NULL,
  aud_stock_anterior INT           NOT NULL,
  aud_stock_nuevo    INT           NOT NULL,
  aud_motivo         VARCHAR(100)  NOT NULL,
  aud_fecha          DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT pk_auditoria PRIMARY KEY (aud_id),
  CONSTRAINT fk_aud_prod  FOREIGN KEY (prod_id)
    REFERENCES productos(prod_id)
    ON UPDATE CASCADE ON DELETE CASCADE,
  INDEX idx_aud_prod (prod_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- ============================================================
-- 2. VISTAS
-- ============================================================

CREATE OR REPLACE VIEW vw_productos_catalogo AS
  SELECT p.prod_id, p.prod_nombre, p.prod_precio,
         c.cat_nombre, i.inv_stock
  FROM productos p
  INNER JOIN categorias c ON p.cat_id  = c.cat_id
  LEFT  JOIN inventario i ON p.prod_id = i.prod_id
  WHERE p.prod_activo = 1;

CREATE OR REPLACE VIEW vw_pedidos_detalle AS
  SELECT pe.ped_id, pe.ped_fecha, pe.ped_estado, pe.ped_total,
         CONCAT(cl.cli_nombre, ' ', cl.cli_apellido) AS cliente_nombre,
         cl.cli_email, di.dir_ciudad, di.dir_pais
  FROM pedidos pe
  INNER JOIN clientes    cl ON pe.cli_id = cl.cli_id
  INNER JOIN direcciones di ON pe.dir_id = di.dir_id;

CREATE OR REPLACE VIEW vw_ventas_por_producto AS
  SELECT p.prod_id, p.prod_nombre,
         SUM(dp.det_cantidad) AS total_unidades_vendidas,
         SUM(dp.det_subtotal) AS ingreso_total
  FROM detalle_pedidos dp
  INNER JOIN productos p ON dp.prod_id = p.prod_id
  GROUP BY p.prod_id, p.prod_nombre;

CREATE OR REPLACE VIEW vw_pagos_completados AS
  SELECT pg.pag_id, pg.ped_id, pg.pag_monto,
         pg.pag_fecha, pg.pag_referencia, mp.mp_nombre
  FROM pagos pg
  INNER JOIN metodos_pago mp ON pg.mp_id = mp.mp_id
  WHERE pg.pag_estado = 'completado';

CREATE OR REPLACE VIEW vw_stock_bajo AS
  SELECT p.prod_id, p.prod_nombre,
         i.inv_stock, i.inv_stock_minimo,
         (i.inv_stock - i.inv_stock_minimo) AS diferencia
  FROM inventario i
  INNER JOIN productos p ON i.prod_id = p.prod_id
  WHERE i.inv_stock <= i.inv_stock_minimo;

CREATE OR REPLACE VIEW vw_resenas_productos AS
  SELECT p.prod_id, p.prod_nombre,
         ROUND(AVG(r.res_calificacion), 2) AS calificacion_promedio,
         COUNT(r.res_id)                   AS total_resenas
  FROM resenas r
  INNER JOIN productos p ON r.prod_id = p.prod_id
  WHERE r.res_activa = 1
  GROUP BY p.prod_id, p.prod_nombre;

CREATE OR REPLACE VIEW vw_devoluciones_pendientes AS
  SELECT d.dev_id, d.ped_id, d.dev_motivo, d.dev_estado,
         d.dev_monto, d.dev_fecha,
         CONCAT(cl.cli_nombre, ' ', cl.cli_apellido) AS cliente_nombre
  FROM devoluciones d
  INNER JOIN pedidos  pe ON d.ped_id  = pe.ped_id
  INNER JOIN clientes cl ON pe.cli_id = cl.cli_id
  WHERE d.dev_estado IN ('solicitada', 'aprobada');


-- ============================================================
-- 3. FUNCIONES
-- ============================================================

DELIMITER $$

CREATE FUNCTION fn_calcular_total_pedido(p_ped_id INT UNSIGNED)
RETURNS DECIMAL(10,2)
READS SQL DATA
DETERMINISTIC
BEGIN
  DECLARE v_total DECIMAL(10,2) DEFAULT 0;
  SELECT COALESCE(SUM(det_subtotal), 0)
    INTO v_total
    FROM detalle_pedidos
   WHERE ped_id = p_ped_id;
  RETURN v_total;
END$$

CREATE FUNCTION fn_total_compras_cliente(p_cli_id INT UNSIGNED)
RETURNS DECIMAL(10,2)
READS SQL DATA
DETERMINISTIC
BEGIN
  DECLARE v_total DECIMAL(10,2) DEFAULT 0;
  SELECT COALESCE(SUM(pg.pag_monto), 0)
    INTO v_total
    FROM pagos pg
   INNER JOIN pedidos pe ON pg.ped_id = pe.ped_id
   WHERE pe.cli_id     = p_cli_id
     AND pg.pag_estado = 'completado';
  RETURN v_total;
END$$

CREATE FUNCTION fn_stock_disponible(p_prod_id INT UNSIGNED)
RETURNS INT UNSIGNED
READS SQL DATA
DETERMINISTIC
BEGIN
  DECLARE v_stock INT UNSIGNED DEFAULT 0;
  SELECT COALESCE(inv_stock, 0)
    INTO v_stock
    FROM inventario
   WHERE prod_id = p_prod_id;
  RETURN v_stock;
END$$

CREATE FUNCTION fn_nombre_completo_cliente(p_cli_id INT UNSIGNED)
RETURNS VARCHAR(205)
READS SQL DATA
DETERMINISTIC
BEGIN
  DECLARE v_nombre VARCHAR(205) DEFAULT '';
  SELECT CONCAT(cli_nombre, ' ', cli_apellido)
    INTO v_nombre
    FROM clientes
   WHERE cli_id = p_cli_id;
  RETURN v_nombre;
END$$

DELIMITER ;


-- ============================================================
-- 4. STORED PROCEDURES
-- ============================================================

DELIMITER $$

CREATE PROCEDURE sp_crear_pedido(
  IN p_cli_id   INT UNSIGNED,
  IN p_dir_id   INT UNSIGNED,
  IN p_prod_id  INT UNSIGNED,
  IN p_cantidad INT UNSIGNED
)
BEGIN
  DECLARE v_precio   DECIMAL(10,2);
  DECLARE v_subtotal DECIMAL(10,2);
  DECLARE v_stock    INT UNSIGNED;
  DECLARE v_ped_id   INT UNSIGNED;

  SELECT inv_stock INTO v_stock
    FROM inventario WHERE prod_id = p_prod_id;

  IF v_stock < p_cantidad THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Stock insuficiente para el producto solicitado';
  END IF;

  SELECT prod_precio INTO v_precio
    FROM productos WHERE prod_id = p_prod_id;

  SET v_subtotal = v_precio * p_cantidad;

  INSERT INTO pedidos (cli_id, dir_id, ped_estado, ped_total)
  VALUES (p_cli_id, p_dir_id, 'pendiente', v_subtotal);

  SET v_ped_id = LAST_INSERT_ID();

  INSERT INTO detalle_pedidos
    (ped_id, prod_id, det_cantidad, det_precio_unitario, det_subtotal)
  VALUES
    (v_ped_id, p_prod_id, p_cantidad, v_precio, v_subtotal);

  SELECT v_ped_id AS pedido_creado, v_subtotal AS total;
END$$

CREATE PROCEDURE sp_registrar_pago(
  IN p_ped_id     INT UNSIGNED,
  IN p_mp_id      INT UNSIGNED,
  IN p_monto      DECIMAL(10,2),
  IN p_referencia VARCHAR(100)
)
BEGIN
  INSERT INTO pagos (ped_id, mp_id, pag_monto, pag_referencia, pag_estado)
  VALUES (p_ped_id, p_mp_id, p_monto, p_referencia, 'completado');

  UPDATE pedidos
     SET ped_estado = 'procesando'
   WHERE ped_id     = p_ped_id
     AND ped_estado = 'pendiente';

  SELECT 'Pago registrado correctamente' AS resultado;
END$$

CREATE PROCEDURE sp_registrar_envio(
  IN p_ped_id         INT UNSIGNED,
  IN p_transportista  VARCHAR(100),
  IN p_guia           VARCHAR(100),
  IN p_fecha_estimada DATE
)
BEGIN
  INSERT INTO envios
    (ped_id, env_transportista, env_numero_guia,
     env_fecha_envio, env_fecha_estimada, env_estado)
  VALUES
    (p_ped_id, p_transportista, p_guia,
     NOW(), p_fecha_estimada, 'en_camino');

  UPDATE pedidos
     SET ped_estado = 'enviado'
   WHERE ped_id = p_ped_id;

  SELECT 'Envío registrado correctamente' AS resultado;
END$$

CREATE PROCEDURE sp_aplicar_cupon(
  IN p_ped_id      INT UNSIGNED,
  IN p_cup_codigo  VARCHAR(50)
)
BEGIN
  DECLARE v_cup_id          INT UNSIGNED;
  DECLARE v_descuento_pct   DECIMAL(5,2);
  DECLARE v_monto_minimo    DECIMAL(10,2);
  DECLARE v_ped_total       DECIMAL(10,2);
  DECLARE v_descuento_monto DECIMAL(10,2);
  DECLARE v_nuevo_total     DECIMAL(10,2);

  SELECT cup_id, cup_descuento_pct, cup_monto_minimo
    INTO v_cup_id, v_descuento_pct, v_monto_minimo
    FROM cupones
   WHERE cup_codigo = p_cup_codigo
     AND cup_activo = 1
     AND CURDATE() BETWEEN cup_fecha_inicio AND cup_fecha_vencimiento;

  IF v_cup_id IS NULL THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Cupón inválido o vencido';
  END IF;

  SELECT ped_total INTO v_ped_total
    FROM pedidos WHERE ped_id = p_ped_id;

  IF v_ped_total < v_monto_minimo THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'El pedido no alcanza el monto mínimo para este cupón';
  END IF;

  SET v_descuento_monto = ROUND(v_ped_total * (v_descuento_pct / 100), 2);
  SET v_nuevo_total     = v_ped_total - v_descuento_monto;

  UPDATE pedidos
     SET ped_total = v_nuevo_total
   WHERE ped_id = p_ped_id;

  INSERT INTO pedidos_cupones (ped_id, cup_id, pc_descuento_aplicado)
  VALUES (p_ped_id, v_cup_id, v_descuento_monto);

  SELECT v_descuento_monto AS descuento_aplicado,
         v_nuevo_total     AS nuevo_total;
END$$

CREATE PROCEDURE sp_reporte_ventas_periodo(
  IN p_fecha_inicio DATETIME,
  IN p_fecha_fin    DATETIME
)
BEGIN
  SELECT p.prod_id, p.prod_nombre,
         SUM(dp.det_cantidad) AS unidades_vendidas,
         SUM(dp.det_subtotal) AS ingreso_total
  FROM detalle_pedidos dp
  INNER JOIN productos p  ON dp.prod_id = p.prod_id
  INNER JOIN pedidos   pe ON dp.ped_id  = pe.ped_id
  WHERE pe.ped_fecha BETWEEN p_fecha_inicio AND p_fecha_fin
    AND pe.ped_estado != 'cancelado'
  GROUP BY p.prod_id, p.prod_nombre
  ORDER BY ingreso_total DESC;
END$$

DELIMITER ;


-- ============================================================
-- 5. TRIGGERS
-- ============================================================

DELIMITER $$

CREATE TRIGGER trg_descontar_stock
AFTER INSERT ON detalle_pedidos
FOR EACH ROW
BEGIN
  UPDATE inventario
     SET inv_stock = inv_stock - NEW.det_cantidad
   WHERE prod_id   = NEW.prod_id;
END$$

CREATE TRIGGER trg_auditoria_stock
AFTER UPDATE ON inventario
FOR EACH ROW
BEGIN
  IF OLD.inv_stock <> NEW.inv_stock THEN
    INSERT INTO auditoria_stock
      (prod_id, aud_stock_anterior, aud_stock_nuevo, aud_motivo)
    VALUES
      (NEW.prod_id, OLD.inv_stock, NEW.inv_stock, 'Actualización de stock');
  END IF;
END$$

CREATE TRIGGER trg_estado_entregado
AFTER UPDATE ON envios
FOR EACH ROW
BEGIN
  IF NEW.env_estado = 'entregado' AND OLD.env_estado <> 'entregado' THEN
    UPDATE pedidos
       SET ped_estado = 'entregado'
     WHERE ped_id = NEW.ped_id;
  END IF;
END$$

CREATE TRIGGER trg_validar_stock_minimo
BEFORE UPDATE ON inventario
FOR EACH ROW
BEGIN
  IF NEW.inv_stock < 0 THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Error: el stock no puede ser negativo';
  END IF;
END$$

DELIMITER ;


-- ============================================================
-- 6. DATOS DE PRUEBA
-- ============================================================

INSERT INTO categorias (cat_nombre, cat_descripcion) VALUES
  ('Electrónica',  'Dispositivos y gadgets electrónicos'),
  ('Ropa',         'Prendas de vestir para hombre y mujer'),
  ('Hogar',        'Artículos para el hogar y decoración'),
  ('Deportes',     'Equipos y accesorios deportivos'),
  ('Libros',       'Libros físicos y material educativo');

INSERT INTO metodos_pago (mp_nombre, mp_descripcion) VALUES
  ('Tarjeta de Crédito', 'Pago con Visa, MasterCard o Amex'),
  ('Tarjeta de Débito',  'Pago desde cuenta bancaria'),
  ('PayPal',             'Pago mediante cuenta PayPal'),
  ('Transferencia',      'Transferencia bancaria directa');

INSERT INTO productos (cat_id, prod_nombre, prod_precio) VALUES
  (1, 'Audífonos Bluetooth',    799.99),
  (1, 'Teclado Inalámbrico',    450.00),
  (2, 'Playera Deportiva',      250.00),
  (3, 'Lámpara de Escritorio',  380.50),
  (4, 'Balón de Fútbol',        199.00),
  (1, 'Mouse Inalámbrico',      320.00),
  (5, 'Libro de SQL Avanzado',  180.00),
  (2, 'Sudadera con Capucha',   450.00),
  (3, 'Cojín Decorativo',       120.00),
  (4, 'Guantes de Box',         350.00);

INSERT INTO inventario (prod_id, inv_stock, inv_stock_minimo) VALUES
  (1,  50,  5),
  (2,  30,  5),
  (3,  80, 10),
  (4,   4,  5),  -- stock bajo intencional
  (5,  60, 10),
  (6,   3,  5),  -- stock bajo intencional
  (7,  20,  5),
  (8,  15,  5),
  (9,  40, 10),
  (10,  2,  5);  -- stock bajo intencional

INSERT INTO clientes (cli_nombre, cli_apellido, cli_email, cli_password) VALUES
  ('Ana',    'García',    'ana.garcia@email.com', SHA2('pass123', 256)),
  ('Carlos', 'Martínez',  'carlos.m@email.com',   SHA2('pass456', 256)),
  ('Laura',  'Rodríguez', 'laura.rod@email.com',  SHA2('pass789', 256)),
  ('Miguel', 'Torres',    'miguel.t@email.com',   SHA2('pass000', 256)),
  ('Sofía',  'Ramírez',   'sofia.r@email.com',    SHA2('pass111', 256));

INSERT INTO direcciones
  (cli_id, dir_calle, dir_ciudad, dir_estado, dir_codigo_postal, dir_pais, dir_predeterminada)
VALUES
  (1, 'Av. Reforma 123',  'Ciudad de México', 'CDMX',       '06600', 'México', 1),
  (2, 'Calle Roble 456',  'Guadalajara',      'Jalisco',    '44100', 'México', 1),
  (3, 'Blvd. Torres 789', 'Monterrey',        'Nuevo León', '64000', 'México', 1),
  (4, 'Calle Pino 321',   'Puebla',           'Puebla',     '72000', 'México', 1),
  (5, 'Av. Juárez 654',   'Querétaro',        'Querétaro',  '76000', 'México', 1);

-- Cupones con fechas 2026 para que estén vigentes
INSERT INTO cupones
  (cup_codigo, cup_descripcion, cup_descuento_pct, cup_monto_minimo,
   cup_fecha_inicio, cup_fecha_vencimiento, cup_activo)
VALUES
  ('BIENVENIDO10', 'Descuento de bienvenida 10%',  10.00, 200.00, '2026-01-01', '2026-12-31', 1),
  ('VERANO20',     'Promoción de verano 20%',       20.00, 500.00, '2026-01-01', '2026-12-31', 1),
  ('ELECTRO15',    'Descuento en electrónica 15%',  15.00, 300.00, '2026-01-01', '2026-12-31', 1);


-- ============================================================
-- 7. EJECUCIÓN DE STORED PROCEDURES
-- ============================================================

-- Crear pedidos
CALL sp_crear_pedido(1, 1, 1, 2);  -- Ana: 2 Audífonos Bluetooth
CALL sp_crear_pedido(2, 2, 2, 1);  -- Carlos: 1 Teclado Inalámbrico
CALL sp_crear_pedido(3, 3, 3, 3);  -- Laura: 3 Playeras Deportivas
CALL sp_crear_pedido(4, 4, 7, 1);  -- Miguel: 1 Libro de SQL
CALL sp_crear_pedido(5, 5, 8, 1);  -- Sofía: 1 Sudadera

-- Registrar pagos
CALL sp_registrar_pago(1, 1, 1599.98, 'REF-001-2026');
CALL sp_registrar_pago(2, 3,  450.00, 'REF-002-2026');
CALL sp_registrar_pago(3, 2,  750.00, 'REF-003-2026');
CALL sp_registrar_pago(4, 4,  180.00, 'REF-004-2026');
CALL sp_registrar_pago(5, 1,  450.00, 'REF-005-2026');

-- Aplicar cupones
CALL sp_aplicar_cupon(1, 'ELECTRO15');
CALL sp_aplicar_cupon(3, 'BIENVENIDO10');

-- Registrar envíos
CALL sp_registrar_envio(1, 'FedEx',    'FDX111222333', '2026-02-15');
CALL sp_registrar_envio(2, 'DHL',      'DHL444555666', '2026-02-16');
CALL sp_registrar_envio(3, 'Estafeta', 'EST777888999', '2026-02-17');


-- ============================================================
-- 8. PRUEBAS DE TRIGGERS
-- ============================================================

-- Cambiar envío a entregado → actualiza pedido automáticamente
UPDATE envios SET env_estado = 'entregado' WHERE ped_id = 1;
UPDATE envios SET env_estado = 'entregado' WHERE ped_id = 2;

-- Verificar estados actualizados
SELECT ped_id, ped_estado FROM pedidos WHERE ped_id IN (1, 2);

-- Ver auditoría de stock
SELECT * FROM auditoria_stock;


-- ============================================================
-- 9. RESEÑAS Y DEVOLUCIONES
-- ============================================================

INSERT INTO resenas (prod_id, cli_id, res_calificacion, res_comentario) VALUES
  (1, 1, 5, 'Excelente calidad de sonido, muy cómodos'),
  (1, 2, 4, 'Buenos audífonos, la batería dura bastante'),
  (2, 2, 5, 'El teclado es silencioso y muy preciso'),
  (3, 3, 3, 'La tela es buena pero talla pequeño'),
  (7, 4, 5, 'Muy completo, ideal para aprender SQL');

INSERT INTO devoluciones (ped_id, dev_motivo, dev_estado, dev_monto) VALUES
  (3, 'Producto recibido con talla incorrecta', 'solicitada', 250.00),
  (4, 'El libro llegó con páginas dañadas',     'aprobada',   180.00);


-- ============================================================
-- 10. PRUEBAS DE FUNCIONES
-- ============================================================

SELECT fn_calcular_total_pedido(1)   AS total_pedido_1;
SELECT fn_calcular_total_pedido(2)   AS total_pedido_2;
SELECT fn_total_compras_cliente(1)   AS total_gastado_cliente_1;
SELECT fn_total_compras_cliente(2)   AS total_gastado_cliente_2;
SELECT fn_stock_disponible(1)        AS stock_audifonos;
SELECT fn_stock_disponible(4)        AS stock_lampara;
SELECT fn_nombre_completo_cliente(1) AS nombre_cliente_1;
SELECT fn_nombre_completo_cliente(3) AS nombre_cliente_3;


-- ============================================================
-- 11. PRUEBAS DE VISTAS
-- ============================================================

SELECT * FROM vw_productos_catalogo;
SELECT * FROM vw_pedidos_detalle;
SELECT * FROM vw_ventas_por_producto  ORDER BY ingreso_total DESC;
SELECT * FROM vw_pagos_completados;
SELECT * FROM vw_stock_bajo;
SELECT * FROM vw_resenas_productos    ORDER BY calificacion_promedio DESC;
SELECT * FROM vw_devoluciones_pendientes;


-- ============================================================
-- 12. REPORTE FINAL
-- ============================================================

CALL sp_reporte_ventas_periodo('2026-01-01', '2026-12-31');

-- ============================================================
-- FIN DEL ARCHIVO: tienda_online_entrega3.sql
-- ============================================================

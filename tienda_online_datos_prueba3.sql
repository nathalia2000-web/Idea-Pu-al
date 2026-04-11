-- ============================================================
-- ARCHIVO: tienda_online_datos_prueba.sql
-- BASE DE DATOS: TIENDA EN LÍNEA
-- Versión: 2.0 Final
-- Descripción: Inserción de datos de prueba y ejecución
--              de SP, funciones, vistas y triggers
-- ============================================================

USE tienda_online;
-- Limpiar tablas antes de insertar
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE auditoria_stock;
TRUNCATE TABLE devoluciones;
TRUNCATE TABLE pedidos_cupones;
TRUNCATE TABLE resenas;
TRUNCATE TABLE envios;
TRUNCATE TABLE pagos;
TRUNCATE TABLE detalle_pedidos;
TRUNCATE TABLE pedidos;
TRUNCATE TABLE direcciones;
TRUNCATE TABLE inventario;
TRUNCATE TABLE cupones;
TRUNCATE TABLE productos;
TRUNCATE TABLE clientes;
TRUNCATE TABLE metodos_pago;
TRUNCATE TABLE categorias;
SET FOREIGN_KEY_CHECKS = 1;

-- ============================================================
-- DATOS BASE
-- ============================================================

INSERT INTO categorias (cat_nombre, cat_descripcion) VALUES
  ('Electrónica',  'Dispositivos y gadgets electrónicos'),
  ('Ropa',         'Prendas de vestir para hombre y mujer'),
  ('Hogar',        'Artículos para el hogar y decoración'),
  ('Deportes',     'Equipos y accesorios deportivos'),
  ('Libros',       'Libros físicos y material educativo');

-- ============================================================
-- DATOS BASE
-- ============================================================

INSERT INTO categorias (cat_nombre, cat_descripcion) VALUES
  ('Electrónica',  'Dispositivos y gadgets electrónicos'),
  ('Ropa',         'Prendas de vestir para hombre y mujer'),
  ('Hogar',        'Artículos para el hogar y decoración'),
  ('Deportes',     'Equipos y accesorios deportivos'),
  ('Libros',       'Libros físicos y material educativo');

-- ------------------------------------------------------------

INSERT INTO metodos_pago (mp_nombre, mp_descripcion) VALUES
  ('Tarjeta de Crédito', 'Pago con Visa, MasterCard o Amex'),
  ('Tarjeta de Débito',  'Pago desde cuenta bancaria'),
  ('PayPal',             'Pago mediante cuenta PayPal'),
  ('Transferencia',      'Transferencia bancaria directa');

-- ------------------------------------------------------------

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

-- ------------------------------------------------------------

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

-- ------------------------------------------------------------

INSERT INTO clientes
  (cli_nombre, cli_apellido, cli_email, cli_password)
VALUES
  ('Ana',     'García',    'ana.garcia@email.com',  SHA2('pass123', 256)),
  ('Carlos',  'Martínez',  'carlos.m@email.com',    SHA2('pass456', 256)),
  ('Laura',   'Rodríguez', 'laura.rod@email.com',   SHA2('pass789', 256)),
  ('Miguel',  'Torres',    'miguel.t@email.com',    SHA2('pass000', 256)),
  ('Sofía',   'Ramírez',   'sofia.r@email.com',     SHA2('pass111', 256));

-- ------------------------------------------------------------

INSERT INTO direcciones
  (cli_id, dir_calle, dir_ciudad, dir_estado, dir_codigo_postal, dir_pais, dir_predeterminada)
VALUES
  (1, 'Av. Reforma 123',  'Ciudad de México', 'CDMX',       '06600', 'México', 1),
  (2, 'Calle Roble 456',  'Guadalajara',      'Jalisco',    '44100', 'México', 1),
  (3, 'Blvd. Torres 789', 'Monterrey',        'Nuevo León', '64000', 'México', 1),
  (4, 'Calle Pino 321',   'Puebla',           'Puebla',     '72000', 'México', 1),
  (5, 'Av. Juárez 654',   'Querétaro',        'Querétaro',  '76000', 'México', 1);

-- ------------------------------------------------------------

INSERT INTO cupones
  (cup_codigo, cup_descripcion, cup_descuento_pct, cup_monto_minimo,
   cup_fecha_inicio, cup_fecha_vencimiento)
VALUES
  ('BIENVENIDO10', 'Descuento de bienvenida 10%',    10.00, 200.00, '2025-01-01', '2025-12-31'),
  ('VERANO20',     'Promoción de verano 20%',         20.00, 500.00, '2025-06-01', '2025-08-31'),
  ('ELECTRO15',    'Descuento en electrónica 15%',    15.00, 300.00, '2025-01-01', '2025-12-31');


-- ============================================================
-- STORED PROCEDURES — CREAR PEDIDOS Y PAGOS
-- ============================================================

-- Pedido 1: Ana compra 2 Audífonos Bluetooth
CALL sp_crear_pedido(1, 1, 1, 2);

-- Pedido 2: Carlos compra 1 Teclado Inalámbrico
CALL sp_crear_pedido(2, 2, 2, 1);

-- Pedido 3: Laura compra 3 Playeras Deportivas
CALL sp_crear_pedido(3, 3, 3, 3);

-- Pedido 4: Miguel compra 1 Libro de SQL
CALL sp_crear_pedido(4, 4, 7, 1);

-- Pedido 5: Sofía compra 1 Sudadera
CALL sp_crear_pedido(5, 5, 8, 1);

-- Registrar pagos
CALL sp_registrar_pago(1, 1, 1599.98, 'REF-001-2025');
CALL sp_registrar_pago(2, 3,  450.00, 'REF-002-2025');
CALL sp_registrar_pago(3, 2,  750.00, 'REF-003-2025');
CALL sp_registrar_pago(4, 4,  180.00, 'REF-004-2025');
CALL sp_registrar_pago(5, 1,  450.00, 'REF-005-2025');

-- Aplicar cupones
CALL sp_aplicar_cupon(1, 'ELECTRO15');
CALL sp_aplicar_cupon(3, 'BIENVENIDO10');

-- Registrar envíos
CALL sp_registrar_envio(1, 'FedEx',    'FDX111222333', '2025-02-15');
CALL sp_registrar_envio(2, 'DHL',      'DHL444555666', '2025-02-16');
CALL sp_registrar_envio(3, 'Estafeta', 'EST777888999', '2025-02-17');


-- ============================================================
-- TRIGGERS — PRUEBAS
-- ============================================================

-- Trigger trg_estado_entregado:
-- Cambiar envío a entregado → cambia estado pedido automáticamente
UPDATE envios SET env_estado = 'entregado' WHERE ped_id = 1;
UPDATE envios SET env_estado = 'entregado' WHERE ped_id = 2;

-- Verificar estados actualizados
SELECT ped_id, ped_estado FROM pedidos WHERE ped_id IN (1, 2);

-- Ver auditoría de stock generada automáticamente
SELECT * FROM auditoria_stock;


-- ============================================================
-- RESEÑAS Y DEVOLUCIONES — DATOS DE PRUEBA
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
-- FUNCIONES PERSONALIZADAS — PRUEBAS
-- ============================================================

SELECT fn_calcular_total_pedido(1)      AS total_pedido_1;
SELECT fn_calcular_total_pedido(2)      AS total_pedido_2;
SELECT fn_total_compras_cliente(1)      AS total_gastado_cliente_1;
SELECT fn_total_compras_cliente(2)      AS total_gastado_cliente_2;
SELECT fn_stock_disponible(1)           AS stock_audifonos;
SELECT fn_stock_disponible(4)           AS stock_lampara;
SELECT fn_nombre_completo_cliente(1)    AS nombre_cliente_1;
SELECT fn_nombre_completo_cliente(3)    AS nombre_cliente_3;


-- ============================================================
-- VISTAS — PRUEBAS
-- ============================================================

-- Catálogo de productos activos con stock
SELECT * FROM vw_productos_catalogo;

-- Detalle completo de pedidos
SELECT * FROM vw_pedidos_detalle;

-- Ventas agrupadas por producto
SELECT * FROM vw_ventas_por_producto
ORDER BY ingreso_total DESC;

-- Pagos completados
SELECT * FROM vw_pagos_completados;

-- Productos con stock bajo
SELECT * FROM vw_stock_bajo;

-- Calificación promedio por producto
SELECT * FROM vw_resenas_productos
ORDER BY calificacion_promedio DESC;

-- Devoluciones pendientes
SELECT * FROM vw_devoluciones_pendientes;


-- ============================================================
-- STORED PROCEDURES — REPORTE
-- ============================================================

CALL sp_reporte_ventas_periodo('2025-01-01', '2025-12-31');

-- ============================================================
-- FIN DEL ARCHIVO: tienda_online_datos_prueba.sql
-- ============================================================


USE tienda_online;
SELECT * FROM cupones;
SELECT CURDATE();

INSERT INTO cupones
  (cup_codigo, cup_descripcion, cup_descuento_pct, cup_monto_minimo,
   cup_fecha_inicio, cup_fecha_vencimiento)
VALUES
  ('BIENVENIDO10', 'Descuento de bienvenida 10%', 10.00, 200.00, '2025-01-01', '2025-12-31'),
  ('VERANO20',     'Promoción de verano 20%',      20.00, 500.00, '2025-06-01', '2025-08-31'),
  ('ELECTRO15',    'Descuento en electrónica 15%', 15.00, 300.00, '2025-01-01', '2025-12-31');
SELECT * FROM cupones;
CALL sp_aplicar_cupon(1, 'ELECTRO15');
CALL sp_aplicar_cupon(3, 'BIENVENIDO10');

USE tienda_online;

DROP PROCEDURE IF EXISTS sp_aplicar_cupon;

DELIMITER $$

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

  -- Buscar cupón válido
  SELECT cup_id, cup_descuento_pct, cup_monto_minimo
    INTO v_cup_id, v_descuento_pct, v_monto_minimo
    FROM cupones
   WHERE cup_codigo  = p_cup_codigo
     AND cup_activo  = 1
     AND CURDATE() BETWEEN cup_fecha_inicio AND cup_fecha_vencimiento;

  IF v_cup_id IS NULL THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Cupón inválido o vencido';
  END IF;

  -- Validar monto mínimo del pedido
  SELECT ped_total INTO v_ped_total
    FROM pedidos WHERE ped_id = p_ped_id;

  IF v_ped_total < v_monto_minimo THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'El pedido no alcanza el monto mínimo para este cupón';
  END IF;

  -- Calcular descuento
  SET v_descuento_monto = ROUND(v_ped_total * (v_descuento_pct / 100), 2);
  SET v_nuevo_total     = v_ped_total - v_descuento_monto;

  -- Aplicar descuento
  UPDATE pedidos
     SET ped_total = v_nuevo_total
   WHERE ped_id    = p_ped_id;

  -- Registrar relación pedido-cupón
  INSERT INTO pedidos_cupones (ped_id, cup_id, pc_descuento_aplicado)
  VALUES (p_ped_id, v_cup_id, v_descuento_monto);

  SELECT v_descuento_monto AS descuento_aplicado,
         v_nuevo_total     AS nuevo_total;
END$$

DELIMITER ;

DROP PROCEDURE IF EXISTS sp_aplicar_cupon;

CALL sp_aplicar_cupon(1, 'ELECTRO15');

SELECT cup_id, cup_codigo, cup_activo, 
       cup_fecha_inicio, cup_fecha_vencimiento
FROM cupones;
SELECT CURDATE();
SELECT cup_id, cup_descuento_pct, cup_monto_minimo
FROM cupones
WHERE cup_codigo = 'ELECTRO15'
  AND cup_activo = 1
  AND CURDATE() BETWEEN cup_fecha_inicio AND cup_fecha_vencimiento;
  SELECT ped_id, ped_total FROM pedidos WHERE ped_id = 1;
  SELECT cup_id, cup_codigo, cup_activo, 
       cup_fecha_inicio, cup_fecha_vencimiento,
       cup_monto_minimo
FROM cupones
WHERE cup_codigo = 'ELECTRO15';
SELECT 
  cup_codigo,
  cup_activo,
  cup_fecha_inicio,
  cup_fecha_vencimiento,
  CURDATE() AS hoy,
  CURDATE() BETWEEN cup_fecha_inicio AND cup_fecha_vencimiento AS rango_valido
FROM cupones
WHERE cup_codigo = 'ELECTRO15';
SELECT cup_codigo, cup_fecha_inicio, cup_fecha_vencimiento, CURDATE() AS hoy
FROM cupones;

UPDATE cupones SET 
  cup_fecha_inicio     = '2025-01-01',
  cup_fecha_vencimiento = '2025-12-31'
WHERE cup_codigo = 'ELECTRO15';

UPDATE cupones SET 
  cup_fecha_inicio     = '2025-01-01',
  cup_fecha_vencimiento = '2025-12-31'
WHERE cup_codigo = 'BIENVENIDO10';

UPDATE cupones SET 
  cup_fecha_inicio     = '2025-01-01',
  cup_fecha_vencimiento = '2025-12-31'
WHERE cup_codigo = 'VERANO20';
SELECT cup_codigo, cup_activo,
       cup_fecha_inicio, cup_fecha_vencimiento,
       CURDATE() AS hoy,
       CURDATE() BETWEEN cup_fecha_inicio 
       AND cup_fecha_vencimiento AS rango_valido
FROM cupones;
CALL sp_aplicar_cupon(1, 'ELECTRO15');
DESCRIBE cupones;
SELECT COLUMN_NAME, DATA_TYPE, COLUMN_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME   = 'cupones'
  AND TABLE_SCHEMA = 'tienda_online'
  AND COLUMN_NAME IN ('cup_fecha_inicio', 'cup_fecha_vencimiento', 'cup_activo', 'cup_codigo');
  SELECT 
  cup_codigo,
  cup_activo,
  HEX(cup_fecha_inicio)       AS hex_inicio,
  HEX(cup_fecha_vencimiento)  AS hex_vencimiento,
  cup_fecha_inicio,
  cup_fecha_vencimiento
FROM cupones
WHERE cup_codigo = 'ELECTRO15';

SELECT cup_id, cup_codigo, cup_activo,
       cup_fecha_inicio, cup_fecha_vencimiento
FROM cupones
WHERE cup_codigo = 'ELECTRO15'
ORDER BY cup_id;

-- Eliminar duplicados dejando solo el más reciente
DELETE FROM cupones
WHERE cup_codigo = 'ELECTRO15'
  AND cup_id != (
    SELECT MAX(cup_id) FROM (
      SELECT cup_id FROM cupones 
      WHERE cup_codigo = 'ELECTRO15'
    ) AS tmp
  );
  
  SELECT DATABASE();
  SHOW PROCEDURE STATUS WHERE Name = 'sp_aplicar_cupon';
  USE tienda_online;

CALL sp_aplicar_cupon(1, 'ELECTRO15');

USE tienda_online_datos_prueba;

DROP PROCEDURE IF EXISTS sp_aplicar_cupon;
DELIMITER $$

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
   WHERE ped_id    = p_ped_id;

  INSERT INTO pedidos_cupones (ped_id, cup_id, pc_descuento_aplicado)
  VALUES (p_ped_id, v_cup_id, v_descuento_monto);

  SELECT v_descuento_monto AS descuento_aplicado,
         v_nuevo_total     AS nuevo_total;
END$$

DELIMITER ;
CALL sp_aplicar_cupon(1, 'ELECTRO15');

SELECT DATABASE();
SELECT cup_id, cup_codigo, cup_activo,
       cup_fecha_inicio, cup_fecha_vencimiento,
       CURDATE() AS hoy,
       CURDATE() BETWEEN cup_fecha_inicio AND cup_fecha_vencimiento AS rango_valido
FROM cupones
WHERE cup_codigo = 'ELECTRO15';
SELECT COLUMN_NAME, DATA_TYPE, COLUMN_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'tienda_online_datos_prueba'
  AND TABLE_NAME   = 'cupones'
  AND COLUMN_NAME  = 'cup_activo';
  SELECT cup_id, cup_descuento_pct, cup_monto_minimo
FROM cupones
WHERE cup_codigo = 'ELECTRO15'
  AND CURDATE() BETWEEN cup_fecha_inicio AND cup_fecha_vencimiento;
  USE tienda_online_datos_prueba;

UPDATE cupones 
SET cup_fecha_inicio      = '2026-01-01',
    cup_fecha_vencimiento = '2026-12-31';
    SET SQL_SAFE_UPDATES = 0;

UPDATE cupones 
SET cup_fecha_inicio      = '2026-01-01',
    cup_fecha_vencimiento = '2026-12-31';

SET SQL_SAFE_UPDATES = 1;
CALL sp_aplicar_cupon(1, 'ELECTRO15');
USE tienda_online_datos_prueba;
SELECT DATABASE();

SELECT COUNT(*) AS total_cupones FROM cupones;
SELECT * FROM cupones;
USE tienda_online;
SELECT COUNT(*) AS total_cupones FROM cupones;
SELECT * FROM cupones;
USE tienda_online_datos_prueba;

SET SQL_SAFE_UPDATES = 0;

UPDATE cupones SET cup_fecha_inicio = '2026-01-01', cup_fecha_vencimiento = '2026-12-31' WHERE cup_codigo = 'BIENVENIDO10';

UPDATE cupones SET cup_fecha_inicio = '2026-01-01', cup_fecha_vencimiento = '2026-12-31' WHERE cup_codigo = 'VERANO20';

UPDATE cupones SET cup_fecha_inicio = '2026-01-01', cup_fecha_vencimiento = '2026-12-31' WHERE cup_codigo = 'ELECTRO15';

SET SQL_SAFE_UPDATES = 1;
SELECT cup_codigo, cup_fecha_inicio, cup_fecha_vencimiento,
       CURDATE() BETWEEN cup_fecha_inicio AND cup_fecha_vencimiento AS rango_valido
FROM cupones;
CALL sp_aplicar_cupon(1, 'ELECTRO15');
SHOW COLUMNS FROM cupones;
SELECT cup_codigo, 
       LENGTH(cup_codigo) AS longitud,
       CONCAT('[', cup_codigo, ']') AS con_brackets
FROM cupones;
SET SQL_SAFE_UPDATES = 0;

UPDATE cupones 
SET cup_fecha_inicio      = '2026-01-01',
    cup_fecha_vencimiento = '2026-12-31'
WHERE TRIM(cup_codigo) LIKE '%ELECTRO15%';

UPDATE cupones 
SET cup_fecha_inicio      = '2026-01-01',
    cup_fecha_vencimiento = '2026-12-31'
WHERE TRIM(cup_codigo) LIKE '%VERANO20%';

UPDATE cupones 
SET cup_fecha_inicio      = '2026-01-01',
    cup_fecha_vencimiento = '2026-12-31'
WHERE TRIM(cup_codigo) LIKE '%BIENVENIDO10%';

SET SQL_SAFE_UPDATES = 1;
SELECT COLUMN_NAME, DATA_TYPE, ORDINAL_POSITION
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'tienda_online_datos_prueba'
  AND TABLE_NAME   = 'cupones'
ORDER BY ORDINAL_POSITION;
SELECT * FROM cupones LIMIT 5;
SET SQL_SAFE_UPDATES = 0;

UPDATE cupones SET 
    cup_codigo            = 'ELECTRO15',
    cup_fecha_inicio      = '2026-01-01',
    cup_fecha_vencimiento = '2026-12-31'
WHERE cup_codigo LIKE '%electr%';

UPDATE cupones SET 
    cup_codigo            = 'VERANO20',
    cup_fecha_inicio      = '2026-01-01',
    cup_fecha_vencimiento = '2026-12-31'
WHERE cup_codigo LIKE '%verano%';

UPDATE cupones SET 
    cup_codigo            = 'BIENVENIDO10',
    cup_fecha_inicio      = '2026-01-01',
    cup_fecha_vencimiento = '2026-12-31'
WHERE cup_codigo LIKE '%bienven%';

SET SQL_SAFE_UPDATES = 1;
SELECT cup_codigo, cup_fecha_inicio, 
       cup_fecha_vencimiento, cup_activo,
       CURDATE() BETWEEN cup_fecha_inicio 
       
       AND cup_fecha_vencimiento AS rango_valido
       
FROM cupones;
CALL sp_aplicar_cupon(1, 'ELECTRO15');
SELECT cup_id, cup_codigo FROM cupones;
SELECT CONCAT('ID: ', cup_id, ' | Codigo: ', cup_codigo) AS info
FROM cupones
ORDER BY cup_id;
USE tienda_online_datos_prueba;

UPDATE cupones SET 
    cup_codigo            = 'ELECTRO15',
    cup_fecha_inicio      = '2026-01-01',
    cup_fecha_vencimiento = '2026-12-31'
WHERE cup_id = 1;

UPDATE cupones SET 
    cup_codigo            = 'VERANO20',
    cup_fecha_inicio      = '2026-01-01',
    cup_fecha_vencimiento = '2026-12-31'
WHERE cup_id = 2;

UPDATE cupones SET 
    cup_codigo            = 'BIENVENIDO10',
    cup_fecha_inicio      = '2026-01-01',
    cup_fecha_vencimiento = '2026-12-31'
WHERE cup_id = 3;

-- Verificar
SELECT cup_id, cup_codigo, cup_fecha_inicio, 
       cup_fecha_vencimiento, cup_activo,
       CURDATE() BETWEEN cup_fecha_inicio 
       AND cup_fecha_vencimiento AS rango_valido
FROM cupones;

-- Probar SP
CALL sp_aplicar_cupon(1, 'ELECTRO15');
SELECT cup_id, cup_codigo, cup_fecha_inicio, 
       cup_fecha_vencimiento,
       CURDATE() AS hoy,
       CURDATE() BETWEEN cup_fecha_inicio AND cup_fecha_vencimiento AS rango_valido
FROM cupones;
SELECT cup_id, cup_codigo, cup_fecha_inicio, cup_fecha_vencimiento 
FROM cupones;
UPDATE cupones SET cup_fecha_inicio = '2026-01-01', cup_fecha_vencimiento = '2026-12-31' WHERE cup_id = 1;
UPDATE cupones SET cup_fecha_inicio = '2026-01-01', cup_fecha_vencimiento = '2026-12-31' WHERE cup_id = 2;
UPDATE cupones SET cup_fecha_inicio = '2026-01-01', cup_fecha_vencimiento = '2026-12-31' WHERE cup_id = 3;
SELECT ROW_COUNT() AS filas_afectadas;
SHOW CREATE PROCEDURE sp_aplicar_cupon;
CALL sp_aplicar_cupon(1, 'ELECTRO15');
SELECT ROUTINE_DEFINITION 
FROM INFORMATION_SCHEMA.ROUTINES 
WHERE ROUTINE_NAME = 'sp_aplicar_cupon'
  AND ROUTINE_SCHEMA = 'tienda_online_datos_prueba';
  SELECT cup_id, cup_codigo, 
       cup_fecha_inicio, 
       cup_fecha_vencimiento,
       CURDATE() AS hoy,
       CURDATE() BETWEEN cup_fecha_inicio 
       AND cup_fecha_vencimiento AS rango_valido
FROM cupones
ORDER BY cup_id;
USE tienda_online_datos_prueba;

UPDATE cupones SET cup_fecha_inicio = '2026-01-01', cup_fecha_vencimiento = '2026-12-31' WHERE cup_id = 1;
UPDATE cupones SET cup_fecha_inicio = '2026-01-01', cup_fecha_vencimiento = '2026-12-31' WHERE cup_id = 2;

SELECT cup_id, cup_codigo, cup_fecha_vencimiento,
       CURDATE() BETWEEN cup_fecha_inicio AND cup_fecha_vencimiento AS rango_valido
FROM cupones;
SELECT ROUTINE_SCHEMA, ROUTINE_NAME 
FROM INFORMATION_SCHEMA.ROUTINES 
WHERE ROUTINE_NAME LIKE '%cupon%';
SHOW CREATE PROCEDURE tienda_online_datos_prueba.sp_aplicar_cupon\G
SELECT cup_id, cup_codigo, cup_fecha_vencimiento,
       CURDATE() BETWEEN cup_fecha_inicio 
       AND cup_fecha_vencimiento AS rango_valido
FROM cupones;
SELECT ROUTINE_SCHEMA, ROUTINE_NAME, ROUTINE_DEFINITION
FROM INFORMATION_SCHEMA.ROUTINES
WHERE ROUTINE_TYPE = 'PROCEDURE'
DELIMITER //
CREATE PROCEDURE sp_aplicar_cupon(
    IN p_pedido_id INT,
    IN p_cup_codigo VARCHAR(50)
)
BEGIN
    DECLARE v_valido INT DEFAULT 0;
    
    SELECT COUNT(*) INTO v_valido
    FROM cupones
    WHERE cup_codigo = p_cup_codigo
      AND cup_activo = 1
      AND CURDATE() BETWEEN cup_fecha_inicio AND cup_fecha_vencimiento;
    
    IF v_valido = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cupón inválido o vencido';
    ELSE
        SELECT CONCAT('Cupón ', p_cup_codigo, ' aplicado correctamente') AS resultado;
    END IF;
END //
DELIMITER ;
-- Ver cupones en tienda_online
SELECT cup_id, cup_codigo, cup_fecha_inicio, cup_fecha_vencimiento 
FROM tienda_online.cupones;

-- Actualizar fechas en tienda_online
UPDATE tienda_online.cupones SET cup_fecha_inicio = '2026-01-01', cup_fecha_vencimiento = '2026-12-31' WHERE cup_id = 1;
UPDATE tienda_online.cupones SET cup_fecha_inicio = '2026-01-01', cup_fecha_vencimiento = '2026-12-31' WHERE cup_id = 2;
UPDATE tienda_online.cupones SET cup_fecha_inicio = '2026-01-01', cup_fecha_vencimiento = '2026-12-31' WHERE cup_id = 3;

-- Verificar
SELECT cup_id, cup_codigo,
       CURDATE() BETWEEN cup_fecha_inicio AND cup_fecha_vencimiento AS rango_valido
FROM tienda_online.cupones;
USE tienda_online;

CALL sp_aplicar_cupon(1, 'ELECTRO15');
USE tienda_online;

-- Ver pedidos existentes
SELECT ped_id, ped_total, ped_estado 
FROM pedidos 
ORDER BY ped_id;

-- Ver qué cupones ya fueron aplicados
SELECT * FROM pedidos_cupones;
-- Ejemplo con pedido_id diferente (ajusta según resultado anterior)
CALL sp_aplicar_cupon(2, 'ELECTRO15');
USE tienda_online;

-- Ver el descuento aplicado y nuevo total
SELECT ped_id, ped_total, ped_estado 
FROM pedidos 
WHERE ped_id = 2;

-- Ver registro en pedidos_cupones
SELECT pc.ped_id, c.cup_codigo, pc.pc_descuento_aplicado
FROM pedidos_cupones pc
JOIN cupones c ON pc.cup_id = c.cup_id
WHERE pc.ped_id = 2;
-- Ejecuta esto en Workbench para ver las columnas reales
DESCRIBE tienda_online.cupones;
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE, COLUMN_DEFAULT
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'cupones'
  AND TABLE_SCHEMA = 'tienda_online'
ORDER BY ORDINAL_POSITION;
SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, 
       IS_NULLABLE, COLUMN_DEFAULT
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'cupones'
  AND TABLE_SCHEMA = 'tienda_online'
ORDER BY ORDINAL_POSITION;
SHOW CREATE TABLE tienda_online.cupones;
SELECT CONCAT(COLUMN_NAME, ' | ', DATA_TYPE, '(', IFNULL(CHARACTER_MAXIMUM_LENGTH, NUMERIC_PRECISION), ')')  AS columnas
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'cupones'
  AND TABLE_SCHEMA = 'tienda_online'
ORDER BY ORDINAL_POSITION;
-- Buscar en qué schema está la tabla cupones
SELECT TABLE_SCHEMA, TABLE_NAME 
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_NAME = 'cupones';
-- Si está en tienda_online_creacion:
SHOW CREATE TABLE tienda_online_creacion.cupones;
-- Si está en tienda_online_datos_prueba:
SHOW CREATE TABLE tienda_online_datos_prueba.cupones;
SHOW DATABASES;
SELECT TABLE_SCHEMA, TABLE_NAME 
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_NAME = 'cupones';
-- Ver todas las bases de datos
SELECT SCHEMA_NAME AS mis_bases_de_datos
FROM INFORMATION_SCHEMA.SCHEMATA;
-- Ver en qué base está la tabla cupones
SELECT TABLE_SCHEMA, TABLE_NAME 
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_NAME = 'cupones';
USE tienda_online;
SHOW TABLES;
USE tienda_online;
DESCRIBE cupones;
INSERT INTO cupones 
(cup_codigo, cup_descripcion, cup_descuento_pct, cup_monto_minimo, cup_fecha_inicio, cup_fecha_vencimiento, cup_activo) 
VALUES 
('ELECTRO15',  'Descuento 15% en electrónica', 15.00, 500.00, '2026-01-01', '2026-12-31', 1),
('DESCUENTO10', 'Descuento general 10%',        10.00, 300.00, '2026-01-01', '2026-12-31', 1),
('PROMO20',     'Promoción especial 20%',        20.00, 800.00, '2026-01-01', '2026-12-31', 1);
UPDATE cupones 
SET cup_fecha_inicio = '2026-01-01', 
    cup_fecha_vencimiento = '2026-12-31'
WHERE cup_codigo IN ('ELECTRO15', 'DESCUENTO10', 'PROMO20');
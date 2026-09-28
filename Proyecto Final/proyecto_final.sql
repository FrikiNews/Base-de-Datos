/* ==========================================================================================
   PROYECTO FINAL (B) — BASE DE DATOS DE DEPARTAMENTOS Y EMPLEADOS
   Motor: MySQL 8.x / MariaDB 10.x        Codificación: utf8mb4
   ------------------------------------------------------------------------------------------
   CONTENIDO
     PARTE 0 ... Creación de la base de datos
     PARTE I .... 1. Crear ambas tablas
                  2. Insertar 7 registros en Departamento
                  3. Insertar 15 registros en Empleados
     PARTE II ... 1. Agregar un registro más a Departamento
                  2. Agregar las columnas Jefe y NumEmpleados a Departamento
                  3. Llenar esas dos columnas en todos los registros
                  4. Eliminar los empleados con ID 4, 5, 6 y 7
                  5. Agregar las columnas email y telefono a Empleados
                  6. Llenar esas dos columnas en todos los registros
     PARTE III .. 1. Renombrar Nombre por NombreEmpleado en Empleados
                  2. Renombrar Nombre y Jefe por NombreEmpleado y NombreJefe
                  3. Asegurar que ningún campo sea NULL en ambas tablas
                  4. Presupuesto total por departamento, de mayor a menor
/* ================================ PARTE 0: BASE DE DATOS ================================= */
DROP DATABASE IF EXISTS proyecto_final;
CREATE DATABASE proyecto_final
    DEFAULT CHARACTER SET utf8mb4
    DEFAULT COLLATE utf8mb4_unicode_ci;
USE proyecto_final;

SET SQL_SAFE_UPDATES = 0;


/* ==========================================================================================
   PARTE I — PUNTO 1: CREACIÓN DE LAS DOS TABLAS
   La relación es uno a muchos (1:N): un departamento tiene muchos empleados y cada empleado
   pertenece a un solo departamento. Por eso la llave foránea vive en la tabla Empleados.
   ========================================================================================== */

CREATE TABLE Departamento (
    IdDepartamento INT           NOT NULL AUTO_INCREMENT,
    Nombre         VARCHAR(60)   NOT NULL,
    Presupuesto    DECIMAL(12,2) NOT NULL,
    CONSTRAINT pk_departamento    PRIMARY KEY (IdDepartamento),
    CONSTRAINT uq_departamento    UNIQUE (Nombre),
    CONSTRAINT ck_presupuesto     CHECK (Presupuesto > 0)
) ENGINE=InnoDB;

CREATE TABLE Empleados (
    IdEmpleado     INT           NOT NULL AUTO_INCREMENT,
    Nombre         VARCHAR(60)   NOT NULL,
    Apellidos      VARCHAR(80)   NOT NULL,
    IdDepartamento INT           NOT NULL,              -- LLAVE FORÁNEA -> Departamento
    CONSTRAINT pk_empleados       PRIMARY KEY (IdEmpleado),
    CONSTRAINT fk_empleados_depto FOREIGN KEY (IdDepartamento)
        REFERENCES Departamento (IdDepartamento)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

/* Comprobación del punto 1 */
SHOW TABLES;
DESCRIBE Departamento;
DESCRIBE Empleados;


/* ==========================================================================================
   PARTE I — PUNTO 2: SIETE REGISTROS EN DEPARTAMENTO (todos los campos con valor)
   ========================================================================================== */
INSERT INTO Departamento (IdDepartamento, Nombre, Presupuesto) VALUES
 (1,'Dirección General',              950000.00),
 (2,'Recursos Humanos',               420000.00),
 (3,'Finanzas',                       780000.00),
 (4,'Tecnologías de la Información', 1250000.00),
 (5,'Mercadotecnia',                  640000.00),
 (6,'Ventas',                          890000.00),
 (7,'Logística',                       530000.00);

SELECT * FROM Departamento;


/* ==========================================================================================
   PARTE I — PUNTO 3: QUINCE REGISTROS EN EMPLEADOS (todos los campos con valor)
   ========================================================================================== */
INSERT INTO Empleados (IdEmpleado, Nombre, Apellidos, IdDepartamento) VALUES
 ( 1,'Ricardo',  'Salinas Prieto',     1),
 ( 2,'María',    'Ortiz Ruiz',         2),
 ( 3,'Jorge',    'Hernández Salas',    2),
 ( 4,'Ana',      'Ramírez Gil',        3),
 ( 5,'Luis',     'Treviño Cantú',      3),
 ( 6,'Diana',    'Pérez Moreno',       4),
 ( 7,'Carlos',   'Martínez Vela',      4),
 ( 8,'Paulina',  'Guzmán Estrada',     4),
 ( 9,'Miguel',   'Bosque Nava',        5),
 (10,'Regina',   'Alcántara Fuentes',  5),
 (11,'Héctor',   'Vázquez Domínguez',  6),
 (12,'Claudia',  'Ibarra Sánchez',     6),
 (13,'Sergio',   'Domínguez Rojas',    7),
 (14,'Valeria',  'Canul Pech',         7),
 (15,'Emilio',   'Zamora Quintero',    1);

SELECT * FROM Empleados;


/* ==========================================================================================
   PARTE II — PUNTO 1: AGREGAR UN REGISTRO MÁS A LA TABLA DEPARTAMENTO
   ========================================================================================== */
INSERT INTO Departamento (IdDepartamento, Nombre, Presupuesto) VALUES
 (8,'Investigación y Desarrollo', 1100000.00);

SELECT * FROM Departamento ORDER BY IdDepartamento;


/* ==========================================================================================
   PARTE II — PUNTO 2: AGREGAR DOS COLUMNAS A DEPARTAMENTO (Jefe y NumEmpleados)
   Se usa ADD, que es la cláusula de ALTER TABLE que crea columnas nuevas.
   Nacen admitiendo NULL porque la tabla ya tiene registros: si se pidieran NOT NULL sin un
   valor por omisión, MySQL no sabría qué poner en los ocho renglones que ya existen.
   En la PARTE III punto 3 se convierten a NOT NULL, una vez que ya tienen información.
   ========================================================================================== */
ALTER TABLE Departamento
    ADD COLUMN Jefe         VARCHAR(80) NULL AFTER Nombre,
    ADD COLUMN NumEmpleados INT         NULL AFTER Jefe;

DESCRIBE Departamento;


/* ==========================================================================================
   PARTE II — PUNTO 3: AGREGAR INFORMACIÓN A LAS COLUMNAS NUEVAS DE DEPARTAMENTO
   ========================================================================================== */
UPDATE Departamento SET Jefe = 'Ricardo Salinas Prieto'    WHERE IdDepartamento = 1;
UPDATE Departamento SET Jefe = 'María Ortiz Ruiz'          WHERE IdDepartamento = 2;
UPDATE Departamento SET Jefe = 'Ana Ramírez Gil'           WHERE IdDepartamento = 3;
UPDATE Departamento SET Jefe = 'Diana Pérez Moreno'        WHERE IdDepartamento = 4;
UPDATE Departamento SET Jefe = 'Miguel Bosque Nava'        WHERE IdDepartamento = 5;
UPDATE Departamento SET Jefe = 'Héctor Vázquez Domínguez'  WHERE IdDepartamento = 6;
UPDATE Departamento SET Jefe = 'Sergio Domínguez Rojas'    WHERE IdDepartamento = 7;
UPDATE Departamento SET Jefe = 'Fernanda Aguilar Rico'     WHERE IdDepartamento = 8;

/* NumEmpleados se calcula contando los empleados que hay en cada departamento, en lugar de
   escribir el número a mano, para que el dato sea el real. */
UPDATE Departamento d
SET    d.NumEmpleados = (SELECT COUNT(*) FROM Empleados e
                         WHERE e.IdDepartamento = d.IdDepartamento)
WHERE  d.IdDepartamento > 0;   -- el filtro por la llave evita el error 1175 de Workbench

SELECT * FROM Departamento ORDER BY IdDepartamento;


/* ==========================================================================================
   PARTE II — PUNTO 4: ELIMINAR LOS EMPLEADOS CUYO ID SEA 4, 5, 6 Y 7
   DELETE borra renglones concretos según el filtro y conserva la estructura de la tabla.
   ========================================================================================== */
SELECT * FROM Empleados WHERE IdEmpleado IN (4,5,6,7);   -- así se ve lo que se va a borrar

DELETE FROM Empleados
WHERE  IdEmpleado IN (4, 5, 6, 7);

SELECT * FROM Empleados ORDER BY IdEmpleado;             -- quedan 11 empleados


/* ==========================================================================================
   PARTE II — PUNTO 5: AGREGAR DOS COLUMNAS A EMPLEADOS (email y telefono)
   ========================================================================================== */
ALTER TABLE Empleados
    ADD COLUMN email    VARCHAR(80) NULL AFTER Apellidos,
    ADD COLUMN telefono VARCHAR(20) NULL AFTER email;

DESCRIBE Empleados;


/* ==========================================================================================
   PARTE II — PUNTO 6: AGREGAR INFORMACIÓN A LAS COLUMNAS NUEVAS DE EMPLEADOS
   ========================================================================================== */
UPDATE Empleados SET email='ricardo.salinas@empresa.mx', telefono='+52 81 1010 2001' WHERE IdEmpleado= 1;
UPDATE Empleados SET email='maria.ortiz@empresa.mx',     telefono='+52 81 1010 2002' WHERE IdEmpleado= 2;
UPDATE Empleados SET email='jorge.hernandez@empresa.mx', telefono='+52 81 1010 2003' WHERE IdEmpleado= 3;
UPDATE Empleados SET email='paulina.guzman@empresa.mx',  telefono='+52 81 1010 2008' WHERE IdEmpleado= 8;
UPDATE Empleados SET email='miguel.bosque@empresa.mx',   telefono='+52 81 1010 2009' WHERE IdEmpleado= 9;
UPDATE Empleados SET email='regina.alcantara@empresa.mx',telefono='+52 81 1010 2010' WHERE IdEmpleado=10;
UPDATE Empleados SET email='hector.vazquez@empresa.mx',  telefono='+52 81 1010 2011' WHERE IdEmpleado=11;
UPDATE Empleados SET email='claudia.ibarra@empresa.mx',  telefono='+52 81 1010 2012' WHERE IdEmpleado=12;
UPDATE Empleados SET email='sergio.dominguez@empresa.mx',telefono='+52 81 1010 2013' WHERE IdEmpleado=13;
UPDATE Empleados SET email='valeria.canul@empresa.mx',   telefono='+52 81 1010 2014' WHERE IdEmpleado=14;
UPDATE Empleados SET email='emilio.zamora@empresa.mx',   telefono='+52 81 1010 2015' WHERE IdEmpleado=15;

SELECT * FROM Empleados ORDER BY IdEmpleado;


/* ------------------------------------------------------------------------------------------
   PASO ADICIONAL
   El punto 3 llenó NumEmpleados ANTES de que el punto 4 borrara a cuatro empleados, así que
   ese conteo quedó desactualizado. Se vuelve a calcular.
   ------------------------------------------------------------------------------------------ */
UPDATE Departamento d
SET    d.NumEmpleados = (SELECT COUNT(*) FROM Empleados e
                         WHERE e.IdDepartamento = d.IdDepartamento)
WHERE  d.IdDepartamento > 0;   -- el filtro por la llave evita el error 1175 de Workbench

SELECT IdDepartamento, Nombre, Jefe, NumEmpleados FROM Departamento ORDER BY IdDepartamento;


/* ==========================================================================================
   PARTE III — PUNTO 1: CAMBIAR EL NOMBRE DE LA COLUMNA Nombre POR NombreEmpleado
                        EN LA TABLA EMPLEADOS
   Se usa CHANGE, que es la única cláusula de ALTER TABLE que renombra una columna.
   Obliga a repetir la definición completa del tipo de dato, aunque no vaya a cambiar.
   ========================================================================================== */
ALTER TABLE Empleados
    CHANGE COLUMN Nombre NombreEmpleado VARCHAR(60) NOT NULL;

DESCRIBE Empleados;


/* ==========================================================================================
   PARTE III — PUNTO 2: CAMBIAR Nombre Y Jefe POR NombreEmpleado Y NombreJefe
   La columna Nombre de Empleados ya quedó renombrada en el punto anterior; aquí se completa
   el cambio renombrando Jefe, que vive en la tabla Departamento. Se muestran las dos
   instrucciones juntas para dejar constancia del par de cambios.
   ========================================================================================== */

-- Ya aplicada en el punto 1 (se repite comentada para mostrar el par completo):
-- ALTER TABLE Empleados   CHANGE COLUMN Nombre NombreEmpleado VARCHAR(60) NOT NULL;

ALTER TABLE Departamento
    CHANGE COLUMN Jefe NombreJefe VARCHAR(80) NULL;

DESCRIBE Departamento;
DESCRIBE Empleados;


/* ==========================================================================================
   PARTE III — PUNTO 3: ASEGURAR QUE NINGÚN CAMPO SEA NULL EN AMBAS TABLAS
   Las cuatro columnas que se agregaron en la PARTE II nacieron admitiendo NULL. Ahora que
   ya tienen información en todos los renglones, se convierten a NOT NULL con MODIFY, que es
   la cláusula que cambia la definición de una columna sin cambiarle el nombre.
   ========================================================================================== */

/* Primero se comprueba que no haya ningún valor vacío pendiente */
SELECT COUNT(*) AS departamentos_con_nulos
FROM   Departamento
WHERE  Nombre IS NULL OR NombreJefe IS NULL OR NumEmpleados IS NULL OR Presupuesto IS NULL;

SELECT COUNT(*) AS empleados_con_nulos
FROM   Empleados
WHERE  NombreEmpleado IS NULL OR Apellidos IS NULL OR email IS NULL
       OR telefono IS NULL OR IdDepartamento IS NULL;

/* Ahora sí, se bloquea la entrada de nulos a futuro */
ALTER TABLE Departamento
    MODIFY COLUMN NombreJefe   VARCHAR(80) NOT NULL,
    MODIFY COLUMN NumEmpleados INT         NOT NULL;

ALTER TABLE Empleados
    MODIFY COLUMN email    VARCHAR(80) NOT NULL,
    MODIFY COLUMN telefono VARCHAR(20) NOT NULL;

/* Comprobación: la columna Null debe decir NO en todas las filas de ambas tablas */
DESCRIBE Departamento;
DESCRIBE Empleados;


/* ==========================================================================================
   PARTE III — PUNTO 4: PRESUPUESTO TOTAL POR DEPARTAMENTO, DE MAYOR A MENOR
   GROUP BY agrupa los renglones y SUM totaliza dentro de cada grupo; ORDER BY acomoda el
   resultado ya agrupado. El orden obligatorio de las cláusulas es:
   SELECT ... FROM ... WHERE ... GROUP BY ... HAVING ... ORDER BY ... LIMIT
   ========================================================================================== */
SELECT   Nombre                AS Departamento,
         SUM(Presupuesto)      AS PresupuestoTotal
FROM     Departamento
GROUP BY Nombre
ORDER BY PresupuestoTotal DESC;

/* Versión ampliada: además del presupuesto, cuántos empleados tiene cada departamento y
   cuánto presupuesto le corresponde a cada uno.
   OJO: aquí el presupuesto NO se suma. Al unir con Empleados, cada departamento aparece
   repetido una vez por empleado, así que un SUM(Presupuesto) lo multiplicaría por el número
   de empleados. El presupuesto se toma tal cual y lo único que se cuenta son los empleados. */
SELECT   d.Nombre                AS Departamento,
         d.NombreJefe            AS Jefe,
         COUNT(e.IdEmpleado)     AS Empleados,
         d.Presupuesto           AS PresupuestoTotal,
         COALESCE(ROUND(d.Presupuesto / NULLIF(COUNT(e.IdEmpleado),0), 2), 0.00)
                                 AS PresupuestoPorEmpleado
FROM     Departamento d
         LEFT JOIN Empleados e ON e.IdDepartamento = d.IdDepartamento
GROUP BY d.IdDepartamento, d.Nombre, d.NombreJefe, d.Presupuesto
ORDER BY PresupuestoTotal DESC;


/* ==========================================================================================
   RESULTADO FINAL DE AMBAS TABLAS
   ========================================================================================== */
SELECT * FROM Departamento ORDER BY IdDepartamento;
SELECT * FROM Empleados    ORDER BY IdEmpleado;

/* Se restablece el modo de actualización segura de la sesión */
SET SQL_SAFE_UPDATES = 1;

/* ========================================= FIN ========================================== */

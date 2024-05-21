-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 21-05-2024 a las 02:55:03
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `mariscos`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_clientes` (IN `p_id_cliente` INT, IN `p_activo` BOOLEAN, IN `p_nombre` VARCHAR(255), IN `p_telefono` VARCHAR(20))   BEGIN
    SELECT
        c.ID_CLIENTE,
        c.ACTIVO,
        c.FECHA_MODIFICACION, 
        c.ID_USUARIO_MODIFICACION,
        c.FECHA_CREACION,
        c.ID_USUARIO_CREACION,
        c.NOMBRE,
        c.TELEFONO,
        c.DIRECCION
    FROM clientes c
    WHERE (p_id_cliente IS NULL OR c.ID_CLIENTE = p_id_cliente)
    AND (p_activo IS NULL OR c.ACTIVO = p_activo)
    AND (p_nombre IS NULL OR c.NOMBRE LIKE CONCAT('%', p_nombre, '%')) -- Filtrar por nombre
    AND (p_telefono IS NULL OR c.TELEFONO = p_telefono); -- Filtrar por teléfono
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_comidas` (IN `p_id_comida` INT, IN `p_activo` BOOLEAN, IN `p_precio` DECIMAL(10,2), IN `p_codigo` VARCHAR(255))   BEGIN
    SELECT
        c.ID_COMIDA,
        c.ACTIVO,
        c.FECHA_MODIFICACION, 
        c.ID_USUARIO_MODIFICACION,
        c.FECHA_CREACION,
        c.ID_USUARIO_CREACION,
        c.NOMBRE,
        c.CODIGO,
        c.PRECIO,
        c.DESCRIPCION
    FROM comidas c
    WHERE (p_id_comida IS NULL OR c.ID_COMIDA = p_id_comida)
    AND (p_activo IS NULL OR c.ACTIVO = p_activo)
    AND (p_precio IS NULL OR c.PRECIO = p_precio)
    AND (p_codigo IS NULL OR c.CODIGO LIKE CONCAT('%', p_codigo, '%'));
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_detalles_venta` (IN `p_id_venta` INT, IN `p_activo` BOOLEAN)   BEGIN
    SELECT
        dv.ID_DETALLE_VENTA,
        dv.ACTIVO,
        dv.FECHA_MODIFICACION,
        dv.ID_USUARIO_MODIFICACION,
        dv.FECHA_CREACION,
        dv.ID_USUARIO_CREACION,
        dv.ID_VENTA,
        dv.ID_COMIDA,
        dv.DESCRIPCION,
        dv.PRECIO,
        dv.CANTIDAD,
        dv.APLICA_DESC,
        dv.DESCUENTO,
        dv.SUBTOTAL,
dv.ORDEN
    FROM detalles_ventas dv
    WHERE (p_id_venta IS NULL OR dv.ID_VENTA = p_id_venta)
    AND (p_activo IS NULL OR dv.ACTIVO = p_activo);

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_pedidos` (IN `p_id_pedido` INT, IN `p_activo` BOOLEAN, IN `p_id_cliente` INT, IN `p_total_desde` DECIMAL(10,2), IN `p_total_hasta` DECIMAL(10,2), IN `p_id_venta` INT)   BEGIN
    SELECT
        p.ID_PEDIDO,
        p.ACTIVO,
        p.ID_USUARIO_MODIFICACION,
        p.FECHA_MODIFICACION,
        p.ID_USUARIO_CREACION,
        p.FECHA_CREACION,
        p.ID_CLIENTE,
        c.NOMBRE AS NOMBRE_CLIENTE,
        p.ID_VENTA,
        v.TOTAL
    FROM pedidos p
    INNER JOIN clientes c ON c.ID_CLIENTE = p.ID_CLIENTE
    INNER JOIN ventas v ON v.ID_VENTA = p.ID_VENTA
    WHERE (p_id_pedido IS NULL OR p.ID_PEDIDO = p_id_pedido)
    AND (p_activo IS NULL OR p.ACTIVO = p_activo)
    AND (p_id_cliente IS NULL OR p.ID_CLIENTE = p_id_cliente)
    AND (p_total_desde IS NULL OR v.TOTAL >= p_total_desde)
    AND (p_total_hasta IS NULL OR v.TOTAL <= p_total_hasta)
    AND (p_id_venta IS NULL OR p.ID_VENTA = p_id_venta);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_usuarios` (IN `p_id_usuario` INT, IN `p_activo` BOOLEAN, IN `p_nombre` VARCHAR(150), IN `p_correo` VARCHAR(150), IN `p_cuenta_usuario` VARCHAR(150))   BEGIN
    SELECT
        usr.ID_USUARIO,
        usr.ACTIVO,
        usr.FECHA_MODIFICACION,
        usr.ID_USUARIO_MODIFICACION,
        usr.FECHA_CREACION,
        usr.ID_USUARIO_CREACION,
        usr.NOMBRE,
        usr.CORREO,
        usr.CUENTA_USUARIO,
        usr.TELEFONO
    FROM usuarios usr
    WHERE (p_id_usuario IS NULL OR usr.ID_USUARIO = p_id_usuario)
    AND (p_activo IS NULL OR usr.ACTIVO = p_activo)
    AND (p_nombre IS NULL OR usr.NOMBRE LIKE CONCAT('%', p_nombre, '%'))
    AND (p_correo IS NULL OR usr.CORREO LIKE CONCAT('%', p_correo, '%'))
    AND (p_cuenta_usuario IS NULL OR usr.CUENTA_USUARIO LIKE CONCAT('%', p_cuenta_usuario, '%'));
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_ventas` (IN `p_id_venta` INT, IN `p_activo` BOOLEAN, IN `p_fecha_desde` DATETIME, IN `p_fecha_hasta` DATETIME, IN `p_id_cliente` INT, IN `p_total_desde` DECIMAL(10,2), IN `p_total_hasta` DECIMAL(10,2))   BEGIN
    SELECT
        v.ID_VENTA,
        v.ACTIVO,
        v.ID_USUARIO_MODIFICACION,
        v.FECHA_MODIFICACION,
        v.ID_USUARIO_CREACION,
        v.FECHA_CREACION,
        v.ID_CLIENTE,
        c.NOMBRE AS NOMBRE_CLIENTE,
        v.CODIGO_VENTA,
        v.FECHA_VENTA,
        v.TOTAL
    FROM ventas v
    INNER JOIN clientes c
    ON c.ID_CLIENTE = v.ID_CLIENTE
    WHERE (p_id_venta IS NULL OR v.ID_VENTA = p_id_venta)
    AND (p_activo IS NULL OR v.ACTIVO = p_activo)
    AND (p_fecha_desde IS NULL OR v.FECHA_VENTA >= p_fecha_desde)
    AND (p_fecha_hasta IS NULL OR v.FECHA_VENTA <= p_fecha_hasta)
    AND (p_id_cliente IS NULL OR v.ID_CLIENTE = p_id_cliente)
    AND (p_total_desde IS NULL OR v.TOTAL >= p_total_desde)
    AND (p_total_hasta IS NULL OR v.TOTAL <= p_total_hasta);

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_insert_detalle_venta` (IN `p_activo` BOOLEAN, IN `p_id_usuario_modificacion` INT, IN `p_id_venta` INT, IN `p_id_comida` INT, IN `p_descripcion` VARCHAR(300), IN `p_precio` DECIMAL(10,2), IN `p_cantidad` INT, IN `p_aplica_desc` BOOLEAN, IN `p_descuento` INT, IN `p_subtotal` DECIMAL(10,2))   BEGIN

    DECLARE v_ultimo_orden INT;

    SELECT COALESCE(MAX(orden), 0) INTO v_ultimo_orden
    FROM detalles_ventas
    WHERE ID_VENTA = p_id_venta;

    SET v_ultimo_orden = v_ultimo_orden + 1;
    IF p_aplica_desc THEN
        INSERT INTO detalles_ventas(
            ACTIVO, 
            FECHA_CREACION, 
            ID_USUARIO_CREACION, 
            FECHA_MODIFICACION,
            ID_USUARIO_MODIFICACION, 
            ID_VENTA,
            ID_COMIDA,
            DESCRIPCION,
            PRECIO,
            CANTIDAD,
            APLICA_DESC,
            DESCUENTO,
            SUBTOTAL,
ORDEN
        )
        VALUES(
            TRUE,
            CURRENT_TIMESTAMP,
            p_id_usuario_modificacion,
            CURRENT_TIMESTAMP,
            p_id_usuario_modificacion,
            p_id_venta,
            p_id_comida,
            p_descripcion,
            p_precio,
            p_cantidad,
            p_aplica_desc,
            p_descuento,
            p_subtotal,
v_ultimo_orden

        );

    ELSE
    
        INSERT INTO detalles_ventas(
            ACTIVO, 
            FECHA_CREACION, 
            ID_USUARIO_CREACION, 
            FECHA_MODIFICACION,
            ID_USUARIO_MODIFICACION, 
            ID_VENTA,
            ID_COMIDA,
            DESCRIPCION,
            PRECIO,
            CANTIDAD,
            APLICA_DESC,
            DESCUENTO, 
            SUBTOTAL,
ORDEN
        )
        VALUES(
            TRUE,
            CURRENT_TIMESTAMP,
            p_id_usuario_modificacion,
            CURRENT_TIMESTAMP,
            p_id_usuario_modificacion,
            p_id_venta,
            p_id_comida,
            p_descripcion,
            p_precio,
            p_cantidad,
            p_aplica_desc,
            NULL,
            p_subtotal,
v_ultimo_orden
        );

    END IF;

    SELECT 
        TRUE AS Exitoso,
        'El detalle de venta ha sido insertado exitosamente' AS Mensaje,
        NULL AS Id
    ;


END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_insert_pedido` (IN `p_activo` BOOLEAN, IN `p_id_usuario_modificacion` INT, IN `p_id_cliente` INT, IN `p_id_venta` INT)   BEGIN

    INSERT INTO pedidos(
        ACTIVO, 
        FECHA_CREACION, 
        ID_USUARIO_CREACION, 
        FECHA_MODIFICACION,
        ID_USUARIO_MODIFICACION, 
        ID_CLIENTE,
        ID_VENTA
    )
    VALUES(
        TRUE,
        CURRENT_TIMESTAMP,
        p_id_usuario_modificacion,
        CURRENT_TIMESTAMP,
        p_id_usuario_modificacion,
        p_id_cliente,
        p_id_venta
    );

    SELECT 
        TRUE AS Exitoso,
        'El pedido ha sido insertado exitosamente' AS Mensaje,
        LAST_INSERT_ID() AS Id
    ;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_insert_venta` (IN `p_activo` BOOLEAN, IN `p_id_usuario_modificacion` INT, IN `p_id_cliente` INT, IN `p_fecha_venta` DATETIME, IN `p_total` DECIMAL(10,2), IN `p_codigo_venta` VARCHAR(10))   BEGIN
    INSERT INTO ventas(
        ACTIVO, 
        FECHA_CREACION, 
        ID_USUARIO_CREACION, 
        FECHA_MODIFICACION,
        ID_USUARIO_MODIFICACION, 
        ID_CLIENTE,
        CODIGO_VENTA,
        FECHA_VENTA,
        TOTAL
    )
    VALUES(
        TRUE,
        CURRENT_TIMESTAMP,
        p_id_usuario_modificacion,
        CURRENT_TIMESTAMP,
        p_id_usuario_modificacion,
        p_id_cliente,
        p_codigo_venta,
        p_fecha_venta,
        p_total
    );

    SELECT 
        TRUE AS Exitoso,
        'La venta ha sido insertada exitosamente' AS Mensaje,
        LAST_INSERT_ID() AS Id
    ;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_set_cliente` (IN `p_id_cliente` INT, IN `p_activo` BOOLEAN, IN `p_nombre` VARCHAR(150), IN `p_telefono` VARCHAR(20), IN `p_direccion` VARCHAR(300), IN `p_id_usuario_modificacion` INT)   BEGIN
    -- Verificar si existe el permiso usuario
    IF EXISTS(SELECT 1 FROM clientes WHERE ID_CLIENTE = p_id_cliente) THEN
        -- Si existe, actualizamos el registro existente
        UPDATE clientes
        SET 
            ACTIVO = p_activo,
            NOMBRE = p_nombre,
            TELEFONO = p_telefono,
            DIRECCION = p_direccion,
            ID_USUARIO_MODIFICACION = p_id_usuario_modificacion,
            FECHA_MODIFICACION = CURRENT_TIMESTAMP
        WHERE ID_CLIENTE = p_id_cliente;

        SELECT 
            TRUE AS Exitoso,
            'El cliente ha sido actualizado exitosamente' AS Mensaje,
            null AS Id
        ;
    ELSE
        -- Si no existe, insertamos un nuevo registro
        INSERT INTO clientes(
            ACTIVO, 
            FECHA_CREACION, 
            ID_USUARIO_CREACION, 
            FECHA_MODIFICACION,
            ID_USUARIO_MODIFICACION, 
            NOMBRE,
            TELEFONO,
            DIRECCION
        )
        VALUES(
            TRUE,
            CURRENT_TIMESTAMP,
            p_id_usuario_modificacion,
            CURRENT_TIMESTAMP,
            p_id_usuario_modificacion,
            p_nombre,
            p_telefono,
            p_direccion
        );

        SELECT 
            TRUE AS Exitoso,
            'El cliente ha sido insertado exitosamente' AS Mensaje,
            null AS Id
        ;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_set_comida` (IN `p_id_comida` INT, IN `p_activo` BOOLEAN, IN `p_nombre` VARCHAR(150), IN `p_codigo` VARCHAR(150), IN `p_precio` DECIMAL(10,2), IN `p_descripcion` VARCHAR(300), IN `p_id_usuario_modificacion` INT)   BEGIN
     -- Verificar si existe la comida
    IF EXISTS(SELECT 1 FROM comidas WHERE ID_COMIDA = p_id_comida) THEN
        -- Si existe, actualizamos el registro existente
        UPDATE comidas
        SET 
            ACTIVO = p_activo,
            NOMBRE = p_nombre,
            CODIGO = p_codigo,
            PRECIO = p_precio,
            DESCRIPCION = p_descripcion,
            ID_USUARIO_MODIFICACION = p_id_usuario_modificacion,
            FECHA_MODIFICACION = CURRENT_TIMESTAMP
        WHERE ID_COMIDA = p_id_comida;

        SELECT 
            TRUE AS Exitoso,
            'El registro sido actualizado exitosamente' AS Mensaje,
            null AS Id
        ;
    ELSE
        -- Si no existe, insertamos un nuevo registro
        INSERT INTO comidas(
            ACTIVO, 
            FECHA_CREACION, 
            ID_USUARIO_CREACION, 
            FECHA_MODIFICACION,
            ID_USUARIO_MODIFICACION, 
            NOMBRE,
            CODIGO,
            PRECIO,
            DESCRIPCION
        )
        VALUES(
            TRUE,
            CURRENT_TIMESTAMP,
            p_id_usuario_modificacion,
            CURRENT_TIMESTAMP,
            p_id_usuario_modificacion,
            p_nombre,
            p_codigo,
            p_precio,
            p_descripcion
        );

        SELECT 
            TRUE AS Exitoso,
            'El registro ha sido insertado exitosamente' AS Mensaje,
            null AS Id
        ;
    END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_set_permiso_usuario` (IN `p_id_permiso_usuario` INT, IN `p_activo` BOOLEAN, IN `p_id_permiso` VARCHAR(150), IN `p_id_usuario` VARCHAR(150), IN `p_id_usuario_modificacion` VARCHAR(150))   BEGIN
    -- Verificar si existe el permiso usuario
    IF EXISTS(SELECT 1 FROM permisos_usuarios WHERE id_permiso_usuario = p_id_permiso_usuario) THEN
        -- Si existe, actualizamos el registro existente
        UPDATE permisos_usuarios
        SET 
            ACTIVO = p_activo,
            ID_PERMISO = p_id_permiso,
            ID_USUARIO = p_id_usuario,
            ID_USUARIO_MODIFICACION = p_id_usuario_modificacion,
            FECHA_MODIFICACION = CURRENT_TIMESTAMP
        WHERE id_permiso_usuario = p_id_permiso_usuario;

        SELECT 
            TRUE AS Exitoso,
            'El permiso ha sido actualizado exitosamente' AS Mensaje,
            null AS id
        ;
    ELSE
        -- Si no existe, insertamos un nuevo registro
        INSERT INTO permisos_usuarios(
            ACTIVO, 
            FECHA_CREACION, 
            ID_USUARIO_CREACION, 
            FECHA_MODIFICACION,
            ID_USUARIO_MODIFICACION, 
            ID_PERMISO,
            ID_USUARIO
        )
        VALUES(
            TRUE,
            CURRENT_TIMESTAMP,
            p_id_usuario_modificacion,
            CURRENT_TIMESTAMP,
            p_id_usuario_modificacion,
            p_id_permiso,
            p_id_usuario
        );

        SELECT 
            TRUE AS Exitoso,
            'El permiso ha sido insertado exitosamente' AS Mensaje,
            null AS id
        ;
    END IF;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `clientes`
--

CREATE TABLE `clientes` (
  `ID_CLIENTE` int(11) NOT NULL,
  `ACTIVO` tinyint(1) NOT NULL,
  `FECHA_CREACION` datetime NOT NULL,
  `ID_USUARIO_CREACION` int(11) NOT NULL,
  `FECHA_MODIFICACION` datetime NOT NULL,
  `ID_USUARIO_MODIFICACION` int(11) NOT NULL,
  `NOMBRE` varchar(150) NOT NULL,
  `TELEFONO` varchar(20) NOT NULL,
  `DIRECCION` varchar(300) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `clientes`
--

INSERT INTO `clientes` (`ID_CLIENTE`, `ACTIVO`, `FECHA_CREACION`, `ID_USUARIO_CREACION`, `FECHA_MODIFICACION`, `ID_USUARIO_MODIFICACION`, `NOMBRE`, `TELEFONO`, `DIRECCION`) VALUES
(1, 1, '2024-03-07 18:16:20', 1, '2024-04-05 22:21:29', 1, 'CLIENTE 1', '87645342343', 'DIRECCION DE EJEMPLO #279'),
(2, 1, '2024-03-07 14:32:14', 1, '2024-04-05 22:27:27', 1, 'Cliente 2', '86723436754', 'Direccion de ejemplo 2 #459'),
(3, 0, '2024-04-02 21:54:44', 1, '2024-04-02 21:55:11', 1, 'NOMBRE CLIENTE 3', '81234565442', 'DIRECCION 3'),
(4, 0, '2024-04-02 22:46:04', 1, '2024-04-02 22:46:23', 1, 'NOMBRE CLIENTE 98', '81234565448', 'direccion2');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `comidas`
--

CREATE TABLE `comidas` (
  `ID_COMIDA` int(11) NOT NULL,
  `ACTIVO` tinyint(1) NOT NULL,
  `FECHA_CREACION` datetime NOT NULL,
  `ID_USUARIO_CREACION` int(11) NOT NULL,
  `FECHA_MODIFICACION` datetime NOT NULL,
  `ID_USUARIO_MODIFICACION` int(11) NOT NULL,
  `NOMBRE` varchar(150) NOT NULL,
  `CODIGO` varchar(150) NOT NULL,
  `PRECIO` decimal(10,2) NOT NULL,
  `DESCRIPCION` varchar(300) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `comidas`
--

INSERT INTO `comidas` (`ID_COMIDA`, `ACTIVO`, `FECHA_CREACION`, `ID_USUARIO_CREACION`, `FECHA_MODIFICACION`, `ID_USUARIO_MODIFICACION`, `NOMBRE`, `CODIGO`, `PRECIO`, `DESCRIPCION`) VALUES
(1, 1, '2024-03-07 23:58:42', 1, '2024-03-07 18:26:25', 1, 'COMIDA 1', 'CODE_861', 100.56, 'DESCRIPCION 1'),
(2, 1, '2024-03-08 00:00:51', 1, '2024-03-15 17:19:06', 1, 'COMIDA 2', 'CODE_76529', 100.00, 'DESCRIPCION 2'),
(3, 1, '2024-03-07 18:26:18', 1, '2024-04-05 22:21:56', 1, 'COMIDA 3', 'CODE_6528', 123.43, 'Descripcion 3'),
(4, 0, '2024-03-07 18:26:49', 1, '2024-03-07 18:32:54', 1, 'Comida 4', 'CODE_65N2', 150.00, 'DESCRIPCION 4'),
(5, 0, '2024-04-02 21:55:31', 1, '2024-04-02 21:55:54', 1, 'COMIDA 671', 'CODE_7652926', 150.00, 'DESCRIPCION 67'),
(6, 0, '2024-04-02 22:47:07', 1, '2024-04-02 22:47:23', 1, 'COMIDA 6769', 'CODE_76529654', 150.00, 'descripcion');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `configuracion`
--

CREATE TABLE `configuracion` (
  `ID_CONFIGURACION` int(11) NOT NULL,
  `ACTIVO` tinyint(1) NOT NULL,
  `FECHA_CREACION` datetime NOT NULL,
  `ID_USUARIO_CREACION` int(11) NOT NULL,
  `FECHA_MODIFICACION` datetime NOT NULL,
  `ID_USUARIO_MODIFICACION` int(11) NOT NULL,
  `NOMBRE` varchar(150) NOT NULL,
  `TELEFONO` varchar(20) NOT NULL,
  `CORREO` varchar(150) NOT NULL,
  `DIRECCION` varchar(300) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `configuracion`
--

INSERT INTO `configuracion` (`ID_CONFIGURACION`, `ACTIVO`, `FECHA_CREACION`, `ID_USUARIO_CREACION`, `FECHA_MODIFICACION`, `ID_USUARIO_MODIFICACION`, `NOMBRE`, `TELEFONO`, `CORREO`, `DIRECCION`) VALUES
(1, 1, '2024-03-08 22:55:35', 1, '2024-04-05 22:27:07', 1, 'Mariscos \"San Martín\"', '81767654542', 'mariscos_sm@outlook.com', 'Nombre de Colonia, Nombre Calle #74');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalles_ventas`
--

CREATE TABLE `detalles_ventas` (
  `ID_DETALLE_VENTA` int(11) NOT NULL,
  `ACTIVO` tinyint(1) NOT NULL,
  `FECHA_CREACION` datetime NOT NULL,
  `ID_USUARIO_CREACION` int(11) NOT NULL,
  `FECHA_MODIFICACION` datetime NOT NULL,
  `ID_USUARIO_MODIFICACION` int(11) NOT NULL,
  `ID_VENTA` int(11) NOT NULL,
  `ID_COMIDA` int(11) NOT NULL,
  `DESCRIPCION` varchar(300) NOT NULL,
  `PRECIO` decimal(10,2) NOT NULL,
  `CANTIDAD` int(11) NOT NULL,
  `APLICA_DESC` tinyint(1) NOT NULL,
  `DESCUENTO` int(11) DEFAULT NULL,
  `SUBTOTAL` decimal(10,2) NOT NULL,
  `ORDEN` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `detalles_ventas`
--

INSERT INTO `detalles_ventas` (`ID_DETALLE_VENTA`, `ACTIVO`, `FECHA_CREACION`, `ID_USUARIO_CREACION`, `FECHA_MODIFICACION`, `ID_USUARIO_MODIFICACION`, `ID_VENTA`, `ID_COMIDA`, `DESCRIPCION`, `PRECIO`, `CANTIDAD`, `APLICA_DESC`, `DESCUENTO`, `SUBTOTAL`, `ORDEN`) VALUES
(1, 1, '2024-03-21 16:45:42', 1, '2024-03-21 16:45:42', 1, 1, 1, 'DESCRIPCION 1', 100.56, 2, 1, 5, 191.06, 1),
(2, 1, '2024-03-21 16:45:42', 1, '2024-03-21 16:45:42', 1, 1, 2, 'DESCRIPCION 2', 100.00, 1, 0, NULL, 100.00, 2),
(3, 1, '2024-04-02 16:39:36', 1, '2024-04-02 16:39:36', 1, 2, 1, 'DESCRIPCION 1', 100.56, 1, 1, 5, 95.53, 1),
(4, 1, '2024-04-02 16:39:36', 1, '2024-04-02 16:39:36', 1, 2, 3, 'Descripcion 3', 123.43, 1, 0, NULL, 123.43, 2),
(5, 1, '2024-04-02 22:49:13', 1, '2024-04-02 22:49:13', 1, 3, 2, 'DESCRIPCION 2', 100.00, 2, 1, 5, 190.00, 1),
(6, 1, '2024-04-05 22:23:01', 1, '2024-04-05 22:23:01', 1, 4, 2, 'DESCRIPCION 2', 100.00, 1, 1, 5, 95.00, 1),
(7, 1, '2024-04-05 22:26:42', 1, '2024-04-05 22:26:42', 1, 5, 1, 'DESCRIPCION 1', 100.56, 1, 1, 5, 95.53, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pedidos`
--

CREATE TABLE `pedidos` (
  `ID_PEDIDO` int(11) NOT NULL,
  `ACTIVO` tinyint(1) NOT NULL,
  `FECHA_CREACION` datetime NOT NULL,
  `ID_USUARIO_CREACION` int(11) NOT NULL,
  `FECHA_MODIFICACION` datetime NOT NULL,
  `ID_USUARIO_MODIFICACION` int(11) NOT NULL,
  `ID_CLIENTE` int(11) NOT NULL,
  `ID_VENTA` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `pedidos`
--

INSERT INTO `pedidos` (`ID_PEDIDO`, `ACTIVO`, `FECHA_CREACION`, `ID_USUARIO_CREACION`, `FECHA_MODIFICACION`, `ID_USUARIO_MODIFICACION`, `ID_CLIENTE`, `ID_VENTA`) VALUES
(1, 1, '2024-03-21 16:45:42', 1, '2024-03-21 16:45:42', 1, 1, 1),
(2, 1, '2024-04-02 16:39:37', 1, '2024-04-02 16:39:37', 1, 1, 2),
(3, 1, '2024-04-02 22:49:13', 1, '2024-04-02 22:49:13', 1, 1, 3),
(4, 1, '2024-04-05 22:23:01', 1, '2024-04-05 22:23:01', 1, 1, 4),
(5, 1, '2024-04-05 22:26:42', 1, '2024-04-05 22:26:42', 1, 1, 5);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `permisos`
--

CREATE TABLE `permisos` (
  `ID_PERMISO` int(11) NOT NULL,
  `NOMBRE` varchar(150) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `permisos`
--

INSERT INTO `permisos` (`ID_PERMISO`, `NOMBRE`) VALUES
(1, 'Usuarios'),
(2, 'Clientes'),
(3, 'Configuracion'),
(4, 'Comidas'),
(5, 'Ventas'),
(6, 'Pedidos'),
(7, 'Reportes');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `permisos_usuarios`
--

CREATE TABLE `permisos_usuarios` (
  `ID_PERMISO_USUARIO` int(11) NOT NULL,
  `ACTIVO` tinyint(1) NOT NULL,
  `FECHA_CREACION` datetime NOT NULL,
  `ID_USUARIO_CREACION` int(11) NOT NULL,
  `FECHA_MODIFICACION` datetime NOT NULL,
  `ID_USUARIO_MODIFICACION` int(11) NOT NULL,
  `ID_PERMISO` int(11) NOT NULL,
  `ID_USUARIO` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `permisos_usuarios`
--

INSERT INTO `permisos_usuarios` (`ID_PERMISO_USUARIO`, `ACTIVO`, `FECHA_CREACION`, `ID_USUARIO_CREACION`, `FECHA_MODIFICACION`, `ID_USUARIO_MODIFICACION`, `ID_PERMISO`, `ID_USUARIO`) VALUES
(1, 1, '2024-03-07 04:26:32', 1, '2024-03-06 22:57:18', 1, 1, 1),
(12, 1, '2024-03-06 22:59:22', 1, '2024-03-06 23:00:15', 1, 5, 1),
(13, 1, '2024-03-06 22:59:22', 1, '2024-05-19 17:07:30', 1, 4, 1),
(14, 1, '2024-03-06 22:59:29', 1, '2024-03-06 22:59:47', 1, 2, 1),
(15, 1, '2024-03-06 22:59:54', 1, '2024-05-19 21:19:39', 1, 3, 1),
(16, 1, '2024-03-06 23:00:37', 1, '2024-03-06 23:00:37', 1, 1, 2),
(17, 1, '2024-03-06 23:00:37', 1, '2024-03-06 23:00:37', 1, 6, 2),
(18, 1, '2024-04-05 22:21:01', 1, '2024-05-19 21:20:06', 1, 6, 1),
(19, 1, '2024-05-19 17:07:30', 1, '2024-05-19 21:20:05', 1, 7, 1),
(20, 1, '2024-05-19 22:07:48', 1, '2024-05-19 22:07:48', 1, 7, 5);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `ID_USUARIO` int(11) NOT NULL,
  `ACTIVO` tinyint(1) NOT NULL,
  `FECHA_CREACION` datetime NOT NULL,
  `ID_USUARIO_CREACION` int(11) NOT NULL,
  `FECHA_MODIFICACION` datetime NOT NULL,
  `ID_USUARIO_MODIFICACION` int(11) NOT NULL,
  `NOMBRE` varchar(150) NOT NULL,
  `CORREO` varchar(150) NOT NULL,
  `TELEFONO` varchar(20) NOT NULL,
  `CLAVE` varchar(50) NOT NULL,
  `CUENTA_USUARIO` varchar(150) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`ID_USUARIO`, `ACTIVO`, `FECHA_CREACION`, `ID_USUARIO_CREACION`, `FECHA_MODIFICACION`, `ID_USUARIO_MODIFICACION`, `NOMBRE`, `CORREO`, `TELEFONO`, `CLAVE`, `CUENTA_USUARIO`) VALUES
(1, 1, '2024-03-06 00:23:10', 1, '2024-04-05 22:28:16', 1, 'Alejandro Estrada', 'alejandro.estradagrr@uanl.edu.mx', '81234565448', 'MTIz', 'admin'),
(2, 0, '2024-03-07 02:19:21', 1, '2024-03-06 20:26:34', 1, 'Pedro Jimenez', 'pedro@correo.com', '1245643', 'MTIzNA==', 'admin2'),
(3, 0, '2024-03-07 15:18:11', 1, '2024-03-07 15:18:11', 1, 'Paco Garcia', 'paco@correo.com.mx', '81234565482', '12345', 'paco_jx'),
(4, 0, '2024-04-02 23:28:59', 1, '2024-04-02 21:54:11', 1, 'Jorge Garcia', 'jorge@outlook.com', '8176543452', 'MTIzNA==', 'jorge23'),
(5, 1, '2024-04-03 04:44:35', 1, '2024-05-19 22:08:05', 1, 'Juan Garcia', 'juan@outlook.com', '81767654547', 'MTIzNA==', 'user1_juan');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ventas`
--

CREATE TABLE `ventas` (
  `ID_VENTA` int(11) NOT NULL,
  `ACTIVO` tinyint(1) NOT NULL,
  `FECHA_CREACION` datetime NOT NULL,
  `ID_USUARIO_CREACION` int(11) NOT NULL,
  `FECHA_MODIFICACION` datetime NOT NULL,
  `ID_USUARIO_MODIFICACION` int(11) NOT NULL,
  `ID_CLIENTE` int(11) NOT NULL,
  `CODIGO_VENTA` varchar(10) NOT NULL,
  `FECHA_VENTA` datetime NOT NULL,
  `TOTAL` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `ventas`
--

INSERT INTO `ventas` (`ID_VENTA`, `ACTIVO`, `FECHA_CREACION`, `ID_USUARIO_CREACION`, `FECHA_MODIFICACION`, `ID_USUARIO_MODIFICACION`, `ID_CLIENTE`, `CODIGO_VENTA`, `FECHA_VENTA`, `TOTAL`) VALUES
(1, 1, '2024-03-21 16:45:42', 1, '2024-03-21 16:45:42', 1, 1, '9RR8GS20X6', '2024-03-21 22:45:37', 291.06),
(2, 1, '2024-04-02 16:39:36', 1, '2024-04-02 16:39:36', 1, 1, 'RF42QKE5TD', '2024-04-02 22:39:36', 218.96),
(3, 1, '2024-04-02 22:49:13', 1, '2024-04-02 22:49:13', 1, 1, 'QZ93BV5CN4', '2024-04-03 04:49:13', 190.00),
(4, 1, '2024-04-05 22:23:01', 1, '2024-04-05 22:23:01', 1, 1, 'PO7VA9N8ZC', '2024-04-06 04:23:01', 95.00),
(5, 1, '2024-04-05 22:26:41', 1, '2024-04-05 22:26:41', 1, 1, 'YNG383OK8X', '2024-04-06 04:26:41', 95.53);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `clientes`
--
ALTER TABLE `clientes`
  ADD PRIMARY KEY (`ID_CLIENTE`);

--
-- Indices de la tabla `comidas`
--
ALTER TABLE `comidas`
  ADD PRIMARY KEY (`ID_COMIDA`);

--
-- Indices de la tabla `configuracion`
--
ALTER TABLE `configuracion`
  ADD PRIMARY KEY (`ID_CONFIGURACION`);

--
-- Indices de la tabla `detalles_ventas`
--
ALTER TABLE `detalles_ventas`
  ADD PRIMARY KEY (`ID_DETALLE_VENTA`),
  ADD KEY `FK_ID_VENTA_DV` (`ID_VENTA`),
  ADD KEY `FK_ID_COMIDA_DV` (`ID_COMIDA`);

--
-- Indices de la tabla `pedidos`
--
ALTER TABLE `pedidos`
  ADD PRIMARY KEY (`ID_PEDIDO`),
  ADD KEY `FK_ID_CLIENTE_PEDIDOS` (`ID_CLIENTE`),
  ADD KEY `FK_ID_VENTA_PEDIDOS` (`ID_VENTA`);

--
-- Indices de la tabla `permisos`
--
ALTER TABLE `permisos`
  ADD PRIMARY KEY (`ID_PERMISO`);

--
-- Indices de la tabla `permisos_usuarios`
--
ALTER TABLE `permisos_usuarios`
  ADD PRIMARY KEY (`ID_PERMISO_USUARIO`),
  ADD KEY `FK_ID_PERMISO_PU` (`ID_PERMISO`) USING BTREE,
  ADD KEY `FK_ID_USUARIO_PU` (`ID_USUARIO`) USING BTREE;

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`ID_USUARIO`);

--
-- Indices de la tabla `ventas`
--
ALTER TABLE `ventas`
  ADD PRIMARY KEY (`ID_VENTA`),
  ADD KEY `FK_ID_CLIENTE_VENTAS` (`ID_CLIENTE`) USING BTREE;

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `clientes`
--
ALTER TABLE `clientes`
  MODIFY `ID_CLIENTE` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `comidas`
--
ALTER TABLE `comidas`
  MODIFY `ID_COMIDA` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `configuracion`
--
ALTER TABLE `configuracion`
  MODIFY `ID_CONFIGURACION` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `detalles_ventas`
--
ALTER TABLE `detalles_ventas`
  MODIFY `ID_DETALLE_VENTA` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `pedidos`
--
ALTER TABLE `pedidos`
  MODIFY `ID_PEDIDO` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `permisos`
--
ALTER TABLE `permisos`
  MODIFY `ID_PERMISO` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `permisos_usuarios`
--
ALTER TABLE `permisos_usuarios`
  MODIFY `ID_PERMISO_USUARIO` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `ID_USUARIO` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `ventas`
--
ALTER TABLE `ventas`
  MODIFY `ID_VENTA` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `detalles_ventas`
--
ALTER TABLE `detalles_ventas`
  ADD CONSTRAINT `detalles_ventas_ibfk_1` FOREIGN KEY (`ID_VENTA`) REFERENCES `ventas` (`ID_VENTA`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `detalles_ventas_ibfk_2` FOREIGN KEY (`ID_COMIDA`) REFERENCES `comidas` (`ID_COMIDA`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `pedidos`
--
ALTER TABLE `pedidos`
  ADD CONSTRAINT `pedidos_ibfk_1` FOREIGN KEY (`ID_CLIENTE`) REFERENCES `clientes` (`ID_CLIENTE`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `pedidos_ibfk_2` FOREIGN KEY (`ID_VENTA`) REFERENCES `ventas` (`ID_VENTA`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `permisos_usuarios`
--
ALTER TABLE `permisos_usuarios`
  ADD CONSTRAINT `permisos_usuarios_ibfk_1` FOREIGN KEY (`ID_PERMISO`) REFERENCES `permisos` (`ID_PERMISO`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `permisos_usuarios_ibfk_2` FOREIGN KEY (`ID_USUARIO`) REFERENCES `usuarios` (`ID_USUARIO`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `ventas`
--
ALTER TABLE `ventas`
  ADD CONSTRAINT `ventas_ibfk_1` FOREIGN KEY (`ID_CLIENTE`) REFERENCES `clientes` (`ID_CLIENTE`) ON DELETE NO ACTION ON UPDATE NO ACTION;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

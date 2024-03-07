-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 07-03-2024 a las 06:22:23
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
  `NOMBRE` int(150) NOT NULL,
  `TELEFONO` int(20) NOT NULL,
  `DIRECCION` varchar(300) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
  `PRECIO` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `empresa`
--

CREATE TABLE `empresa` (
  `ID_EMPRESA` int(11) NOT NULL,
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
(5, 'Nueva Venta'),
(6, 'Historial de Ventas');

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
(13, 1, '2024-03-06 22:59:22', 1, '2024-03-06 23:00:22', 1, 4, 1),
(14, 1, '2024-03-06 22:59:29', 1, '2024-03-06 22:59:47', 1, 2, 1),
(15, 1, '2024-03-06 22:59:54', 1, '2024-03-06 22:59:54', 1, 3, 1),
(16, 1, '2024-03-06 23:00:37', 1, '2024-03-06 23:00:37', 1, 1, 2),
(17, 1, '2024-03-06 23:00:37', 1, '2024-03-06 23:00:37', 1, 6, 2);

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
(1, 1, '2024-03-06 00:23:10', 1, '2024-03-06 20:26:22', 1, 'Alejandro Estrada', 'alejandro.estradagrr@uanl.edu.mx', '81234565432', 'MTIz', 'admin'),
(2, 1, '2024-03-07 02:19:21', 1, '2024-03-06 20:26:34', 1, 'Pedro Jimenez', 'pedro@correo.com', '1245643', 'MTIzNA==', 'admin2');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `clientes`
--
ALTER TABLE `clientes`
  ADD PRIMARY KEY (`ID_CLIENTE`);

--
-- Indices de la tabla `empresa`
--
ALTER TABLE `empresa`
  ADD PRIMARY KEY (`ID_EMPRESA`);

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
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `clientes`
--
ALTER TABLE `clientes`
  MODIFY `ID_CLIENTE` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `empresa`
--
ALTER TABLE `empresa`
  MODIFY `ID_EMPRESA` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `permisos`
--
ALTER TABLE `permisos`
  MODIFY `ID_PERMISO` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `permisos_usuarios`
--
ALTER TABLE `permisos_usuarios`
  MODIFY `ID_PERMISO_USUARIO` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `ID_USUARIO` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `permisos_usuarios`
--
ALTER TABLE `permisos_usuarios`
  ADD CONSTRAINT `permisos_usuarios_ibfk_1` FOREIGN KEY (`ID_PERMISO`) REFERENCES `permisos` (`ID_PERMISO`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `permisos_usuarios_ibfk_2` FOREIGN KEY (`ID_USUARIO`) REFERENCES `usuarios` (`ID_USUARIO`) ON DELETE NO ACTION ON UPDATE NO ACTION;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

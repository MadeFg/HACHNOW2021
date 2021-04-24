-- phpMyAdmin SQL Dump
-- version 5.1.0
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 24-04-2021 a las 23:27:14
-- Versión del servidor: 10.4.18-MariaDB
-- Versión de PHP: 8.0.3

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `bd_hacknow_2021`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `spCmptCliente` (IN `id_cliente` INT)  BEGIN
	IF EXISTS (SELECT C.id FROM basemuestra C WHERE C.id=id_cliente) THEN
    	SELECT * FROM basemuestra B WHERE B.id=id_cliente;
    ELSE
    	SELECT '0' CLAVE;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spCmptConvenio` (IN `id_con` INT)  BEGIN
	IF EXISTS (SELECT C.id FROM convenios C WHERE C.id=id_con) THEN
    	SELECT * FROM convenios WHERE C.id=id_con;
    ELSE
    	SELECT '0' CLAVE;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spInsConvenio` (IN `id_us` INT, IN `id_cliente` INT, IN `fecha` TIMESTAMP, IN `monto` DOUBLE)  BEGIN
	IF EXISTS(SELECT * FROM usuarios U WHERE U.id_usuario=id_us AND U.id_rol=1) THEN
		IF EXISTS(SELECT * FROM basemuestra BM WHERE BM.id=id_cliente) THEN
    		INSERT INTO convenios VALUES(NULL, id_us, id_cliente, fecha, monto);
    			SELECT '1' CLAVE;
    	ELSE
    		SELECT '0' CLAVE;
    	END IF;
   ELSE
    		SELECT '2' CLAVE;
    	END IF;	
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spInsPago` (IN `id_con` INT, IN `fecha` TIMESTAMP, IN `monto` DOUBLE, IN `estatus` VARCHAR(15) CHARSET utf8mb4)  BEGIN
	IF EXISTS(SELECT * FROM pagos C WHERE C.id_convenio=id_con) THEN
    	INSERT INTO pagos VALUES(NULL, id_con, fecha, monto, estatus);
    	SELECT '1' CLAVE;
    ELSE
    	SELECT '0' CLAVE;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spInsSeguimientos` (IN `id_cliente` INT, IN `descripcion` VARCHAR(500) CHARSET utf8mb4, IN `fecha_prom` TIMESTAMP, IN `monto_prom` DOUBLE, IN `fecha_pago` TIMESTAMP, IN `monto_pago` DOUBLE, IN `id_us` INT, IN `id_conv` INT)  BEGIN
	IF EXISTS(SELECT * FROM basemuestra BM WHERE BM.id=id_cliente) THEN
    	INSERT INTO seguimientos VALUES(NULL, id_cliente, descripcion, fecha_prom, monto_prom, fecha_pago, monto_pago, id_us, id_conv);
    	SELECT '1' CLAVE;
    ELSE
    	SELECT '0' CLAVE;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spSelcConvenios` ()  SELECT * FROM `convenios`$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spSelcDatosClientes` ()  SELECT * FROM `basemuestra`$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spSelcPagosPorConvenio` (IN `id` INT)  BEGIN
	IF EXISTS (SELECT * FROM convenios C WHERE C.id=id) THEN
    	SELECT P.fecha_pago, P.monto_pago, P.status
        FROM pagos P, convenios C
        WHERE C.id=P.id_convenio AND C.id=id;
   ELSE
   		SELECT '0' CLAVE;
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spSelcSeguimientos` ()  SELECT * FROM `seguimientos`$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spUpdADCliente` (IN `id` INT, IN `zona` VARCHAR(30), IN `id_us` INT, IN `status_cuenta` INT, IN `id_ges` INT)  BEGIN
	IF EXISTS(SELECT * FROM usuarios U WHERE U.id_usuario=id_us AND U.id_rol=1) THEN
		IF EXISTS(SELECT * FROM basemuestra BM WHERE BM.id=id) THEN
    		UPDATE basemuestra B SET B.zona_ubicacion=zona, B.id_gestor=id_ges, b.status_cuenta=status_cuenta WHERE B.id=id;
    			SELECT '1' CLAVE;
    	ELSE
    		SELECT '0' CLAVE;
    	END IF;
   ELSE
    		SELECT '2' CLAVE;
    	END IF;	
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spUpdConvenio` (IN `id_us` INT, IN `id_cliente` INT, IN `id_con` INT, IN `fecha` TIMESTAMP, IN `monto` DOUBLE)  BEGIN
	IF EXISTS(SELECT * FROM usuarios U WHERE U.id_usuario=id_us AND U.id_rol=1) THEN
		IF EXISTS(SELECT * FROM basemuestra BM WHERE BM.id=id_cliente) THEN
            UPDATE convenios C SET C.fecha_convenio=fecha, C.monto_total=monto WHERE C.id=id_con;
    			SELECT '1' CLAVE;
    	ELSE
    		SELECT '0' CLAVE;
    	END IF;
   ELSE
    		SELECT '2' CLAVE;
    	END IF;	
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spUpdGESCliente` (IN `id_cliente` INT, IN `id_us` INT, IN `contacto` INT, IN `estatus` INT)  BEGIN
	IF EXISTS(SELECT * FROM basemuestra BM WHERE BM.id=id_cliente) THEN
    	UPDATE basemuestra B SET B.contactos_positivos=contacto, B.status=estatus WHERE B.id=id_cliente;
    	SELECT '1' CLAVE;
    ELSE
    	SELECT '0' CLAVE;
    END IF;	
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spValidarAcceso` (IN `usu` VARCHAR(50) CHARSET utf8mb4, IN `contra` VARCHAR(50) CHARSET utf8mb4)  BEGIN
	IF EXISTS(SELECT * FROM usuarios WHERE nombre_usuario=usu AND contrasena=contra) THEN
   		SELECT '1' CLAVE;
	ELSE
    	SELECT '0' CLAVE;
    END IF;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `basemuestra`
--

CREATE TABLE `basemuestra` (
  `id` int(11) NOT NULL,
  `no_cuenta` varchar(25) DEFAULT NULL,
  `nombre_cliente` varchar(60) DEFAULT NULL,
  `zona_ubicacion` varchar(30) NOT NULL,
  `domicilio` varchar(50) DEFAULT NULL,
  `colonia` varchar(30) DEFAULT NULL,
  `poblacion` varchar(50) DEFAULT NULL,
  `codigo_postal` int(5) DEFAULT NULL,
  `telefono1` varchar(15) DEFAULT NULL,
  `celular` varchar(15) DEFAULT NULL,
  `mail` varchar(25) DEFAULT NULL,
  `telefono2` varchar(15) DEFAULT NULL,
  `contactos_positivos` varchar(15) NOT NULL,
  `saldo` double DEFAULT NULL,
  `d_efectivo` double DEFAULT NULL,
  `ult_pago` timestamp NULL DEFAULT current_timestamp(),
  `fecha_corte` int(5) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `status_cuenta` int(11) NOT NULL DEFAULT 0,
  `id_gestor` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `basemuestra`
--

INSERT INTO `basemuestra` (`id`, `no_cuenta`, `nombre_cliente`, `zona_ubicacion`, `domicilio`, `colonia`, `poblacion`, `codigo_postal`, `telefono1`, `celular`, `mail`, `telefono2`, `contactos_positivos`, `saldo`, `d_efectivo`, `ult_pago`, `fecha_corte`, `status`, `status_cuenta`, `id_gestor`) VALUES
(2, '0000013000029938573', 'ELSA MARIA MORENO GUTIERREZ', '', 'AV INSURGENTES SUR 3493 EDIF 18 DEP 2', 'U HAB VILLA OLIMPICA', 'MEXICO', 14020, '55555555', '0445514175950', 'GABRIELAESDIAZ@GMAIL.COM', '56502055', '', 18, 5, '0000-00-00 00:00:00', 19, '0', 0, 6),
(3, '0000013000030142710', 'VICTOR MANUEL LOZOYA MIER', '', 'C 13 ORIENTE MZ 38 LT 5', 'ISIDRO FABELA', 'MEXICO', 14030, '55852139', '0004721270650', 'CASPER_VERY@HOTMAIL.COM', '55852139', '', 18, 9, '0000-00-00 00:00:00', 12, '0', 0, 6),
(4, '0000013000031042240', 'CESAR FELGUERES CORONADO', '', 'ROSITA ALVIREZ 59', 'BENITO JUAREZ LA AURORA', 'NEZAHUALCOYOTL', 57000, '57326123', '0005517985727', 'omar_hdd@hotmail.com', '56276900', '', 34, 3, '0000-00-00 00:00:00', 26, '0', 0, 6),
(5, '0000013000033196085', 'JULIA LOPEZ RANGEL', '', 'CALLE 26 28', 'ESTADO DE MEXICO', 'NEZAHUALCOYOTL', 57210, '53831054', '0005513355652', 'VRD.ABOGADA2@GMAIL.COM', '53831054', '', 21, 2, '0000-00-00 00:00:00', 24, '0', 0, 6);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cat_roles`
--

CREATE TABLE `cat_roles` (
  `id_rol` int(11) NOT NULL,
  `rol` varchar(20) NOT NULL,
  `descripcion` varchar(25) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `cat_roles`
--

INSERT INTO `cat_roles` (`id_rol`, `rol`, `descripcion`) VALUES
(1, 'Administrador', 'todos los permisos'),
(2, 'Gestor', 'área de seguimientos');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `convenios`
--

CREATE TABLE `convenios` (
  `id` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `id_cliente` int(11) NOT NULL,
  `fecha_convenio` timestamp NOT NULL DEFAULT current_timestamp(),
  `monto_total` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `convenios`
--

INSERT INTO `convenios` (`id`, `id_usuario`, `id_cliente`, `fecha_convenio`, `monto_total`) VALUES
(1, 1, 2, '2021-04-24 18:33:44', 15000),
(2, 1, 3, '2021-04-24 18:34:05', 79950.56),
(3, 1, 4, '2021-04-24 18:40:07', 3548.55),
(4, 1, 5, '2021-04-23 18:44:55', 98760);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pagos`
--

CREATE TABLE `pagos` (
  `id` int(11) NOT NULL,
  `id_convenio` int(11) NOT NULL,
  `fecha_pago` timestamp NOT NULL DEFAULT current_timestamp(),
  `monto_pago` double NOT NULL,
  `status` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `pagos`
--

INSERT INTO `pagos` (`id`, `id_convenio`, `fecha_pago`, `monto_pago`, `status`) VALUES
(1, 1, '2021-05-01 18:41:06', 1000, 'Realizado'),
(2, 2, '2021-05-01 18:41:06', 4700, 'Realizado'),
(3, 2, '2021-05-15 16:37:18', 5000, 'Realizado');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `seguimientos`
--

CREATE TABLE `seguimientos` (
  `id` int(11) NOT NULL,
  `id_cliente` int(11) NOT NULL,
  `descripcion_seguimiento` varchar(500) NOT NULL,
  `fecha_promesa` timestamp NULL DEFAULT NULL,
  `monto_promesa` double DEFAULT NULL,
  `fecha_pago_realizado` timestamp NULL DEFAULT NULL,
  `monto_pago_realizado` double DEFAULT NULL,
  `id_usuario` int(11) NOT NULL,
  `id_convenio` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `seguimientos`
--

INSERT INTO `seguimientos` (`id`, `id_cliente`, `descripcion_seguimiento`, `fecha_promesa`, `monto_promesa`, `fecha_pago_realizado`, `monto_pago_realizado`, `id_usuario`, `id_convenio`) VALUES
(1, 2, 'El cliente comenzará a pagar en mayo', '2021-04-24 18:35:21', 800, '0000-00-00 00:00:00', NULL, 1, 1),
(2, 3, 'El cliente comenzará a pagar en junio', '2021-04-24 18:36:17', 800, NULL, NULL, 1, 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id_usuario` int(11) NOT NULL,
  `id_rol` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `nombre_usuario` varchar(50) NOT NULL,
  `contrasena` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id_usuario`, `id_rol`, `nombre`, `nombre_usuario`, `contrasena`) VALUES
(1, 1, 'Juan Pérez Rosas', 'juan', '123'),
(2, 2, 'Aranza Meneses Juarez', 'lajefalapatrona', 'lapatrona123');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `basemuestra`
--
ALTER TABLE `basemuestra`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `cat_roles`
--
ALTER TABLE `cat_roles`
  ADD PRIMARY KEY (`id_rol`);

--
-- Indices de la tabla `convenios`
--
ALTER TABLE `convenios`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `pagos`
--
ALTER TABLE `pagos`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `seguimientos`
--
ALTER TABLE `seguimientos`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id_usuario`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `basemuestra`
--
ALTER TABLE `basemuestra`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `cat_roles`
--
ALTER TABLE `cat_roles`
  MODIFY `id_rol` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `convenios`
--
ALTER TABLE `convenios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `pagos`
--
ALTER TABLE `pagos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `seguimientos`
--
ALTER TABLE `seguimientos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id_usuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

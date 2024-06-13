-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Хост: localhost
-- Время создания: Июн 12 2024 г., 23:32
-- Версия сервера: 10.4.28-MariaDB
-- Версия PHP: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `space`
--

-- --------------------------------------------------------

--
-- Структура таблицы `NaturalObject`
--

CREATE TABLE `NaturalObject` (
  `id_naturalObject` int(11) NOT NULL,
  `type` varchar(255) DEFAULT NULL,
  `galaxy` varchar(255) DEFAULT NULL,
  `accuracy` float DEFAULT NULL,
  `light_flux` float DEFAULT NULL,
  `related_objects` int(11) DEFAULT NULL,
  `notes` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `Object`
--

CREATE TABLE `Object` (
  `id_object` int(11) NOT NULL,
  `type` varchar(255) DEFAULT NULL,
  `accuracy` float DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL,
  `time` time DEFAULT NULL,
  `date` date DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `date_update` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Триггеры `Object`
--
DELIMITER $$
CREATE TRIGGER `UpdateDateAfterObjectUpdate` AFTER UPDATE ON `Object` FOR EACH ROW BEGIN
    UPDATE Object
    SET NEW.date_update = NOW()
    WHERE id_object = NEW.id_object;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Структура таблицы `Observation`
--

CREATE TABLE `Observation` (
  `id` int(11) NOT NULL,
  `id_object` int(11) NOT NULL,
  `id_sector` int(11) NOT NULL,
  `id_naturalObject` int(11) NOT NULL,
  `id_position` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `Position`
--

CREATE TABLE `Position` (
  `id_position` int(11) NOT NULL,
  `earth_position` varchar(255) DEFAULT NULL,
  `sun_position` varchar(255) DEFAULT NULL,
  `notes` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `Sector`
--

CREATE TABLE `Sector` (
  `id_sector` int(11) NOT NULL,
  `coordinates` varchar(255) DEFAULT NULL,
  `light_intensity` float DEFAULT NULL,
  `foreign_objects` int(11) DEFAULT NULL,
  `star_objects` int(11) DEFAULT NULL,
  `undefined_objects` int(11) DEFAULT NULL,
  `defined_objects` int(11) DEFAULT NULL,
  `notes` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `NaturalObject`
--
ALTER TABLE `NaturalObject`
  ADD PRIMARY KEY (`id_naturalObject`),
  ADD KEY `id_naturalObject` (`id_naturalObject`);

--
-- Индексы таблицы `Object`
--
ALTER TABLE `Object`
  ADD PRIMARY KEY (`id_object`),
  ADD KEY `id_object` (`id_object`);

--
-- Индексы таблицы `Observation`
--
ALTER TABLE `Observation`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_object` (`id_object`,`id_sector`,`id_naturalObject`,`id_position`),
  ADD KEY `id_position` (`id_position`),
  ADD KEY `id_naturalObject` (`id_naturalObject`),
  ADD KEY `id_sector` (`id_sector`);

--
-- Индексы таблицы `Position`
--
ALTER TABLE `Position`
  ADD PRIMARY KEY (`id_position`),
  ADD KEY `id_position` (`id_position`);

--
-- Индексы таблицы `Sector`
--
ALTER TABLE `Sector`
  ADD PRIMARY KEY (`id_sector`),
  ADD KEY `id_sector` (`id_sector`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `NaturalObject`
--
ALTER TABLE `NaturalObject`
  MODIFY `id_naturalObject` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `Object`
--
ALTER TABLE `Object`
  MODIFY `id_object` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `Observation`
--
ALTER TABLE `Observation`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `Position`
--
ALTER TABLE `Position`
  MODIFY `id_position` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `Sector`
--
ALTER TABLE `Sector`
  MODIFY `id_sector` int(11) NOT NULL AUTO_INCREMENT;

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `NaturalObject`
--
ALTER TABLE `NaturalObject`
  ADD CONSTRAINT `naturalobject_ibfk_1` FOREIGN KEY (`id_naturalObject`) REFERENCES `Observation` (`id_naturalObject`);

--
-- Ограничения внешнего ключа таблицы `Object`
--
ALTER TABLE `Object`
  ADD CONSTRAINT `object_ibfk_1` FOREIGN KEY (`id_object`) REFERENCES `Observation` (`id_object`);

--
-- Ограничения внешнего ключа таблицы `Position`
--
ALTER TABLE `Position`
  ADD CONSTRAINT `position_ibfk_1` FOREIGN KEY (`id_position`) REFERENCES `Observation` (`id_position`);

--
-- Ограничения внешнего ключа таблицы `Sector`
--
ALTER TABLE `Sector`
  ADD CONSTRAINT `sector_ibfk_1` FOREIGN KEY (`id_sector`) REFERENCES `Observation` (`id_sector`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

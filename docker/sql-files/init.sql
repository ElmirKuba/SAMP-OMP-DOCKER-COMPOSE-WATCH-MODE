-- phpMyAdmin SQL Dump
-- version 3.5.1
-- http://www.phpmyadmin.net
--
-- Хост: 127.0.0.1
-- Время создания: Апр 20 2024 г., 16:58
-- Версия сервера: 5.5.25
-- Версия PHP: 5.3.13

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- База данных: `tropiki`
--

-- --------------------------------------------------------

--
-- Структура таблицы `accounts`
--

CREATE TABLE IF NOT EXISTS `accounts` (
  `pID` int(11) NOT NULL AUTO_INCREMENT,
  `pName` varchar(24) NOT NULL,
  `pPasswordHash` varchar(64) NOT NULL,
  `pPasswordSalt` varchar(10) NOT NULL,
  `pRegDate` int(11) NOT NULL,
  `pRegIP` varchar(15) NOT NULL,
  `pRating` int(11) NOT NULL DEFAULT '0',
  `pMoney` int(11) NOT NULL DEFAULT '0',
  `pSettings` varchar(64) NOT NULL DEFAULT '',
  `pKills` int(11) NOT NULL DEFAULT '0',
  `pDeaths` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`pID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4 AUTO_INCREMENT=4 ;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
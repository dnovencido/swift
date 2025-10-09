-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 08, 2025 at 09:31 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `swift_client`
--

-- --------------------------------------------------------

--
-- Table structure for table `activity_logs`
--

CREATE TABLE `activity_logs` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `action` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `activity_logs`
--

INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES
(329, NULL, 'dashboard_access', 'Client accessed dashboard', '::1', '2025-10-08 07:21:04'),
(330, NULL, 'dashboard_access', 'Client accessed dashboard', '::1', '2025-10-08 07:29:14');

-- --------------------------------------------------------

--
-- Table structure for table `control_events`
--

CREATE TABLE `control_events` (
  `id` int(11) NOT NULL,
  `device_id` int(11) NOT NULL,
  `event_type` enum('pump_on','pump_off','heat_on','heat_off','mode_change') NOT NULL,
  `trigger_reason` varchar(255) NOT NULL,
  `trigger_value` decimal(8,2) DEFAULT NULL,
  `previous_state` varchar(20) DEFAULT NULL,
  `new_state` varchar(20) NOT NULL,
  `event_timestamp` datetime NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `daily_report`
--

CREATE TABLE `daily_report` (
  `id` int(11) NOT NULL,
  `date` date NOT NULL,
  `device_id` int(11) DEFAULT NULL,
  `temp_min` decimal(5,2) DEFAULT NULL,
  `temp_max` decimal(5,2) DEFAULT NULL,
  `temp_avg` decimal(5,2) DEFAULT NULL,
  `temp_alerts` int(11) DEFAULT NULL,
  `humidity_min` decimal(5,2) DEFAULT NULL,
  `humidity_max` decimal(5,2) DEFAULT NULL,
  `humidity_avg` decimal(5,2) DEFAULT NULL,
  `humidity_alerts` int(11) DEFAULT NULL,
  `ammonia_min` decimal(8,3) DEFAULT NULL,
  `ammonia_max` decimal(8,3) DEFAULT NULL,
  `ammonia_avg` decimal(8,3) DEFAULT NULL,
  `ammonia_alerts` int(11) DEFAULT NULL,
  `pump_on_time` int(11) DEFAULT 0,
  `heat_on_time` int(11) DEFAULT 0,
  `total_alerts` int(11) DEFAULT NULL,
  `system_status` varchar(64) DEFAULT NULL,
  `data_points_count` int(11) DEFAULT 0,
  `data_quality_score` decimal(5,2) DEFAULT NULL,
  `pump_events_count` int(11) DEFAULT 0,
  `heat_events_count` int(11) DEFAULT 0,
  `system_events_count` int(11) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `device_schedules`
--

CREATE TABLE `device_schedules` (
  `id` int(11) NOT NULL,
  `device_type` enum('sprinkler','heat_bulb') NOT NULL,
  `schedule_name` varchar(255) DEFAULT NULL,
  `schedule_date` date NOT NULL,
  `schedule_time` time NOT NULL,
  `repeat_type` enum('once','daily','weekdays','weekends','custom') NOT NULL,
  `custom_days` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'Array of selected days for custom repeat' CHECK (json_valid(`custom_days`)),
  `is_active` tinyint(1) DEFAULT 1,
  `created_by` int(11) DEFAULT NULL COMMENT 'Reference to admin.users table',
  `device_id` int(11) DEFAULT NULL COMMENT 'Reference to admin.devices table',
  `last_executed` datetime DEFAULT NULL,
  `execution_count` int(11) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `raw_sensor_data`
--

CREATE TABLE `raw_sensor_data` (
  `id` bigint(20) NOT NULL,
  `device_id` int(11) DEFAULT NULL COMMENT 'Reference to admin.devices table',
  `temperature` decimal(5,2) NOT NULL,
  `humidity` decimal(5,2) NOT NULL,
  `ammonia` decimal(8,3) NOT NULL,
  `thermal_temp` decimal(5,2) DEFAULT NULL COMMENT 'Thermal camera temperature',
  `timestamp` datetime NOT NULL,
  `water_sprinkler` enum('ON','OFF') DEFAULT NULL COMMENT 'Water sprinkler status (renamed from pump_temp)',
  `sprinkler_trigger` varchar(20) DEFAULT NULL COMMENT 'What triggered the sprinkler (renamed from pump_trigger)',
  `heat` enum('ON','OFF') DEFAULT NULL,
  `mode` enum('AUTO','MANUAL') DEFAULT NULL COMMENT 'Operating mode',
  `offline_sync` tinyint(1) DEFAULT 0 COMMENT '1 if this data was synced from offline storage',
  `source` varchar(50) DEFAULT 'direct_db',
  `data_quality` enum('good','warning','error') DEFAULT 'good',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `pump_temp` varchar(10) DEFAULT NULL,
  `pump_trigger` varchar(20) DEFAULT NULL,
  `device_ip` varchar(15) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `raw_sensor_data`
--

INSERT INTO `raw_sensor_data` (`id`, `device_id`, `temperature`, `humidity`, `ammonia`, `thermal_temp`, `timestamp`, `water_sprinkler`, `sprinkler_trigger`, `heat`, `mode`, `offline_sync`, `source`, `data_quality`, `created_at`, `pump_temp`, `pump_trigger`, `device_ip`) VALUES
(6334, NULL, 33.10, 81.90, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6335, NULL, 33.10, 81.90, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6336, NULL, 33.10, 82.10, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6337, NULL, 33.10, 82.00, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6338, NULL, 33.10, 82.00, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6339, NULL, 33.00, 82.50, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6340, NULL, 33.00, 82.50, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6341, NULL, 33.00, 82.40, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6342, NULL, 33.00, 82.40, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6343, NULL, 33.10, 82.50, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6344, NULL, 33.10, 82.50, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6345, NULL, 33.00, 82.40, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'MANUAL', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6346, NULL, 33.00, 82.40, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6347, NULL, 33.00, 82.40, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6348, NULL, 33.00, 82.40, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6349, NULL, 33.10, 82.40, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6350, NULL, 33.10, 82.40, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6351, NULL, 33.10, 82.40, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6352, NULL, 33.10, 82.40, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6353, NULL, 33.10, 82.40, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6354, NULL, 33.10, 82.40, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6355, NULL, 33.10, 82.50, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6356, NULL, 33.10, 82.50, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6357, NULL, 33.10, 82.60, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6358, NULL, 33.10, 82.60, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6359, NULL, 33.10, 82.50, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6360, NULL, 33.10, 82.50, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6361, NULL, 33.10, 82.40, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6362, NULL, 33.10, 82.40, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6363, NULL, 33.10, 82.60, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6364, NULL, 33.10, 82.60, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6365, NULL, 33.10, 82.20, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6366, NULL, 33.10, 82.20, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6367, NULL, 33.10, 82.40, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6368, NULL, 33.10, 82.40, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6369, NULL, 33.10, 82.50, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6370, NULL, 33.10, 82.50, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6371, NULL, 33.10, 82.60, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6372, NULL, 33.10, 82.60, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6373, NULL, 33.10, 82.50, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6374, NULL, 33.10, 82.60, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6375, NULL, 33.10, 82.60, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6376, NULL, 33.10, 82.80, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6377, NULL, 33.10, 82.80, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6378, NULL, 33.10, 82.50, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6379, NULL, 33.10, 82.50, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6380, NULL, 33.10, 82.50, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6381, NULL, 33.10, 82.50, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6382, NULL, 33.10, 82.50, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6383, NULL, 33.10, 82.60, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6384, NULL, 33.10, 82.60, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6385, NULL, 33.10, 82.50, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6386, NULL, 33.10, 82.50, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6387, NULL, 33.10, 82.60, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6388, NULL, 33.10, 82.60, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6389, NULL, 33.10, 82.50, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6390, NULL, 33.10, 82.50, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6391, NULL, 33.10, 82.30, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6392, NULL, 33.10, 82.30, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6393, NULL, 33.10, 82.60, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6394, NULL, 33.10, 82.60, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6395, NULL, 33.10, 82.70, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6396, NULL, 33.10, 82.70, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6397, NULL, 33.10, 82.60, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6398, NULL, 33.10, 82.60, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6399, NULL, 33.10, 82.60, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6400, NULL, 33.10, 82.60, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6401, NULL, 33.10, 82.50, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6402, NULL, 33.10, 82.50, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6403, NULL, 33.10, 82.70, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6404, NULL, 33.10, 82.70, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6405, NULL, 33.10, 82.50, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6406, NULL, 33.10, 82.50, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6407, NULL, 33.10, 82.50, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6408, NULL, 33.10, 82.30, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6409, NULL, 33.10, 82.30, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6410, NULL, 33.10, 82.40, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6411, NULL, 33.10, 82.40, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6412, NULL, 33.10, 82.40, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6413, NULL, 33.10, 82.40, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6414, NULL, 33.10, 82.30, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6415, NULL, 33.10, 82.40, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6416, NULL, 33.10, 82.40, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6417, NULL, 33.10, 82.40, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6418, NULL, 33.10, 82.40, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6419, NULL, 33.10, 82.10, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6420, NULL, 33.10, 82.10, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6421, NULL, 33.10, 82.10, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6422, NULL, 33.10, 82.10, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6423, NULL, 33.10, 82.30, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6424, NULL, 33.10, 82.30, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6425, NULL, 33.10, 82.30, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6426, NULL, 33.10, 82.30, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6427, NULL, 33.10, 82.30, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6428, NULL, 33.10, 82.30, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6429, NULL, 33.10, 82.10, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6430, NULL, 33.10, 82.10, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6431, NULL, 33.10, 82.40, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6432, NULL, 33.10, 82.40, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6433, NULL, 33.10, 82.30, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6434, NULL, 33.10, 82.30, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6435, NULL, 33.10, 82.30, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6436, NULL, 33.10, 82.30, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6437, NULL, 33.10, 82.00, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6438, NULL, 33.10, 82.20, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6439, NULL, 33.10, 82.00, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6440, NULL, 33.10, 82.00, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6441, NULL, 33.10, 81.90, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6442, NULL, 33.10, 81.90, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6443, NULL, 33.10, 81.80, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6444, NULL, 33.10, 81.80, 0.000, NULL, '2025-10-08 09:24:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:24:18', NULL, NULL, NULL),
(6445, NULL, 33.10, 81.70, 0.000, NULL, '2025-10-08 09:26:09', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:26:09', NULL, NULL, NULL),
(6446, NULL, 33.10, 81.70, 0.000, NULL, '2025-10-08 09:26:09', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:26:09', NULL, NULL, NULL),
(6447, NULL, 33.10, 81.70, 0.000, NULL, '2025-10-08 09:26:09', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:26:09', NULL, NULL, NULL),
(6448, NULL, 33.10, 81.70, 0.000, NULL, '2025-10-08 09:26:09', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:26:09', NULL, NULL, NULL),
(6449, NULL, 33.10, 81.80, 0.000, NULL, '2025-10-08 09:26:09', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:26:09', NULL, NULL, NULL),
(6450, NULL, 33.10, 81.80, 0.000, NULL, '2025-10-08 09:26:09', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:26:09', NULL, NULL, NULL),
(6451, NULL, 33.10, 81.70, 0.000, NULL, '2025-10-08 09:26:09', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:26:09', NULL, NULL, NULL),
(6452, NULL, 33.10, 81.80, 0.000, NULL, '2025-10-08 09:26:09', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:26:09', NULL, NULL, NULL),
(6453, NULL, 33.10, 81.80, 0.000, NULL, '2025-10-08 09:26:09', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:26:09', NULL, NULL, NULL),
(6454, NULL, 33.10, 81.70, 0.000, NULL, '2025-10-08 09:26:09', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:26:09', NULL, NULL, NULL),
(6455, NULL, 33.10, 81.70, 0.000, NULL, '2025-10-08 09:26:09', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:26:09', NULL, NULL, NULL),
(6456, NULL, 33.00, 81.70, 0.000, NULL, '2025-10-08 09:26:09', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:26:09', NULL, NULL, NULL),
(6457, NULL, 33.00, 81.70, 0.000, NULL, '2025-10-08 09:26:09', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:26:09', NULL, NULL, NULL),
(6458, NULL, 33.00, 81.60, 0.000, NULL, '2025-10-08 09:26:09', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:26:09', NULL, NULL, NULL),
(6459, NULL, 33.00, 81.60, 0.000, NULL, '2025-10-08 09:26:09', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:26:09', NULL, NULL, NULL),
(6460, NULL, 33.00, 81.70, 0.000, NULL, '2025-10-08 09:26:09', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:26:09', NULL, NULL, NULL),
(6461, NULL, 33.00, 81.70, 0.000, NULL, '2025-10-08 09:26:09', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:26:09', NULL, NULL, NULL),
(6462, NULL, 33.00, 81.70, 0.000, NULL, '2025-10-08 09:26:09', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:26:09', NULL, NULL, NULL),
(6463, NULL, 33.00, 81.70, 0.000, NULL, '2025-10-08 09:26:09', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:26:09', NULL, NULL, NULL),
(6464, NULL, 33.00, 81.80, 0.000, NULL, '2025-10-08 09:26:09', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:26:09', NULL, NULL, NULL),
(6465, NULL, 33.00, 81.80, 0.000, NULL, '2025-10-08 09:26:09', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:26:09', NULL, NULL, NULL),
(6466, NULL, 33.00, 81.80, 0.000, NULL, '2025-10-08 09:26:09', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:26:09', NULL, NULL, NULL),
(6467, NULL, 33.00, 81.80, 0.000, NULL, '2025-10-08 09:26:09', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:26:09', NULL, NULL, NULL),
(6468, NULL, 33.00, 81.70, 0.000, NULL, '2025-10-08 09:26:09', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:26:09', NULL, NULL, NULL),
(6469, NULL, 33.00, 81.70, 0.000, NULL, '2025-10-08 09:26:09', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:26:09', NULL, NULL, NULL),
(6470, NULL, 33.00, 81.90, 0.000, NULL, '2025-10-08 09:26:09', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:26:09', NULL, NULL, NULL),
(6471, NULL, 33.00, 81.90, 0.000, NULL, '2025-10-08 09:26:09', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:26:09', NULL, NULL, NULL),
(6472, NULL, 33.00, 82.00, 0.000, NULL, '2025-10-08 09:26:09', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:26:09', NULL, NULL, NULL),
(6473, NULL, 33.00, 82.00, 0.000, NULL, '2025-10-08 09:26:09', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:26:09', NULL, NULL, NULL),
(6474, NULL, 33.00, 81.90, 0.000, NULL, '2025-10-08 09:26:09', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:26:09', NULL, NULL, NULL),
(6475, NULL, 33.00, 81.90, 0.000, NULL, '2025-10-08 09:26:09', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:26:09', NULL, NULL, NULL),
(6476, NULL, 33.00, 81.80, 0.000, NULL, '2025-10-08 09:26:09', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:26:09', NULL, NULL, NULL),
(6477, NULL, 33.00, 81.80, 0.000, NULL, '2025-10-08 09:26:09', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:26:09', NULL, NULL, NULL),
(6478, NULL, 33.00, 81.80, 0.000, NULL, '2025-10-08 09:26:09', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:26:09', NULL, NULL, NULL),
(6479, NULL, 33.00, 81.80, 0.000, NULL, '2025-10-08 09:26:09', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:26:09', NULL, NULL, NULL),
(6480, NULL, 33.00, 81.80, 0.000, NULL, '2025-10-08 09:26:09', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:26:09', NULL, NULL, NULL),
(6481, NULL, 33.00, 81.80, 0.000, NULL, '2025-10-08 09:26:09', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:26:09', NULL, NULL, NULL),
(6482, NULL, 33.00, 81.70, 0.000, NULL, '2025-10-08 09:26:09', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:26:09', NULL, NULL, NULL),
(6483, NULL, 33.00, 81.70, 0.000, NULL, '2025-10-08 09:26:09', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-08 07:26:09', NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `weekly_report`
--

CREATE TABLE `weekly_report` (
  `id` int(11) NOT NULL,
  `week_start` date NOT NULL,
  `week_end` date NOT NULL,
  `device_id` int(11) DEFAULT NULL,
  `temp_min` decimal(5,2) DEFAULT NULL,
  `temp_max` decimal(5,2) DEFAULT NULL,
  `temp_avg` decimal(5,2) DEFAULT NULL,
  `humidity_min` decimal(5,2) DEFAULT NULL,
  `humidity_max` decimal(5,2) DEFAULT NULL,
  `humidity_avg` decimal(5,2) DEFAULT NULL,
  `ammonia_min` decimal(8,3) DEFAULT NULL,
  `ammonia_max` decimal(8,3) DEFAULT NULL,
  `ammonia_avg` decimal(8,3) DEFAULT NULL,
  `total_alerts` int(11) DEFAULT NULL,
  `pump_total_time` int(11) DEFAULT 0,
  `heat_total_time` int(11) DEFAULT 0,
  `pump_events_count` int(11) DEFAULT 0,
  `heat_events_count` int(11) DEFAULT 0,
  `system_events_count` int(11) DEFAULT 0,
  `data_points_count` int(11) DEFAULT 0,
  `data_quality_score` decimal(5,2) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `activity_logs`
--
ALTER TABLE `activity_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_action` (`action`),
  ADD KEY `idx_created_at` (`created_at`);

--
-- Indexes for table `control_events`
--
ALTER TABLE `control_events`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_device_id` (`device_id`),
  ADD KEY `idx_event_type` (`event_type`),
  ADD KEY `idx_trigger_reason` (`trigger_reason`),
  ADD KEY `idx_event_timestamp` (`event_timestamp`);

--
-- Indexes for table `daily_report`
--
ALTER TABLE `daily_report`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `date` (`date`),
  ADD KEY `idx_date` (`date`),
  ADD KEY `idx_device_id` (`device_id`),
  ADD KEY `idx_total_alerts` (`total_alerts`),
  ADD KEY `idx_data_points_count` (`data_points_count`),
  ADD KEY `idx_data_quality_score` (`data_quality_score`),
  ADD KEY `idx_pump_events_count` (`pump_events_count`),
  ADD KEY `idx_heat_events_count` (`heat_events_count`);

--
-- Indexes for table `device_schedules`
--
ALTER TABLE `device_schedules`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_device_type` (`device_type`),
  ADD KEY `idx_schedule_date` (`schedule_date`),
  ADD KEY `idx_schedule_time` (`schedule_time`),
  ADD KEY `idx_repeat_type` (`repeat_type`),
  ADD KEY `idx_is_active` (`is_active`),
  ADD KEY `idx_created_by` (`created_by`),
  ADD KEY `idx_device_id` (`device_id`),
  ADD KEY `idx_last_executed` (`last_executed`);

--
-- Indexes for table `raw_sensor_data`
--
ALTER TABLE `raw_sensor_data`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_timestamp` (`timestamp`),
  ADD KEY `idx_device_id` (`device_id`),
  ADD KEY `idx_water_sprinkler` (`water_sprinkler`),
  ADD KEY `idx_sprinkler_trigger` (`sprinkler_trigger`),
  ADD KEY `idx_heat` (`heat`),
  ADD KEY `idx_mode` (`mode`),
  ADD KEY `idx_offline_sync` (`offline_sync`),
  ADD KEY `idx_source` (`source`),
  ADD KEY `idx_data_quality` (`data_quality`),
  ADD KEY `idx_temperature` (`temperature`),
  ADD KEY `idx_humidity` (`humidity`),
  ADD KEY `idx_ammonia` (`ammonia`),
  ADD KEY `idx_thermal_temp` (`thermal_temp`),
  ADD KEY `idx_created_at` (`created_at`);

--
-- Indexes for table `weekly_report`
--
ALTER TABLE `weekly_report`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_week_start` (`week_start`),
  ADD KEY `idx_device_id` (`device_id`),
  ADD KEY `idx_total_alerts` (`total_alerts`),
  ADD KEY `idx_pump_total_time` (`pump_total_time`),
  ADD KEY `idx_heat_total_time` (`heat_total_time`),
  ADD KEY `idx_data_points_count` (`data_points_count`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `activity_logs`
--
ALTER TABLE `activity_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=331;

--
-- AUTO_INCREMENT for table `control_events`
--
ALTER TABLE `control_events`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `daily_report`
--
ALTER TABLE `daily_report`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `device_schedules`
--
ALTER TABLE `device_schedules`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `raw_sensor_data`
--
ALTER TABLE `raw_sensor_data`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6484;

--
-- AUTO_INCREMENT for table `weekly_report`
--
ALTER TABLE `weekly_report`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

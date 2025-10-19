-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 16, 2025 at 10:08 AM
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
(2, NULL, 'dashboard_access', 'Client accessed dashboard', '::1', '2025-10-15 03:28:18'),
(3, NULL, 'dashboard_access', 'Client accessed dashboard', '::1', '2025-10-15 03:43:59'),
(4, NULL, 'dashboard_access', 'Client accessed dashboard', '::1', '2025-10-15 03:51:14'),
(5, NULL, 'dashboard_access', 'Client accessed dashboard', '::1', '2025-10-15 03:52:40'),
(6, NULL, 'dashboard_access', 'Client accessed dashboard', '::1', '2025-10-15 03:52:56'),
(7, NULL, 'dashboard_access', 'Client accessed dashboard', '::1', '2025-10-15 03:53:27'),
(8, NULL, 'dashboard_access', 'Client accessed dashboard', '::1', '2025-10-16 05:07:23'),
(9, NULL, 'dashboard_access', 'Client accessed dashboard', '::1', '2025-10-16 05:19:11'),
(10, NULL, 'dashboard_access', 'Client accessed dashboard', '::1', '2025-10-16 05:19:16'),
(11, NULL, 'dashboard_access', 'Client accessed dashboard', '::1', '2025-10-16 05:19:17'),
(12, NULL, 'dashboard_access', 'Client accessed dashboard', '::1', '2025-10-16 05:20:16'),
(13, NULL, 'dashboard_access', 'Client accessed dashboard', '::1', '2025-10-16 05:26:43'),
(14, NULL, 'dashboard_access', 'Client accessed dashboard', '::1', '2025-10-16 05:28:57'),
(15, NULL, 'dashboard_access', 'Client accessed dashboard', '::1', '2025-10-16 05:36:35'),
(16, NULL, 'dashboard_access', 'Client accessed dashboard', '::1', '2025-10-16 05:37:23'),
(17, NULL, 'dashboard_access', 'Client accessed dashboard', '::1', '2025-10-16 05:44:17'),
(18, NULL, 'dashboard_access', 'Client accessed dashboard', '::1', '2025-10-16 05:46:11'),
(19, NULL, 'dashboard_access', 'Client accessed dashboard', '::1', '2025-10-16 05:47:51'),
(20, NULL, 'dashboard_access', 'Client accessed dashboard', '::1', '2025-10-16 05:48:17'),
(21, NULL, 'dashboard_access', 'Client accessed dashboard', '::1', '2025-10-16 05:50:41'),
(22, NULL, 'dashboard_access', 'Client accessed dashboard', '::1', '2025-10-16 05:50:46'),
(23, NULL, 'dashboard_access', 'Client accessed dashboard', '::1', '2025-10-16 05:50:49'),
(24, NULL, 'dashboard_access', 'Client accessed dashboard', '::1', '2025-10-16 05:50:50'),
(25, NULL, 'dashboard_access', 'Client accessed dashboard', '::1', '2025-10-16 05:50:53'),
(26, NULL, 'dashboard_access', 'Client accessed dashboard', '::1', '2025-10-16 05:53:23'),
(27, NULL, 'dashboard_access', 'Client accessed dashboard', '::1', '2025-10-16 05:55:40'),
(28, NULL, 'dashboard_access', 'Client accessed dashboard', '::1', '2025-10-16 06:02:40'),
(29, NULL, 'dashboard_access', 'Client accessed dashboard', '::1', '2025-10-16 06:37:14'),
(30, NULL, 'dashboard_access', 'Client accessed dashboard', '::1', '2025-10-16 06:38:34'),
(31, NULL, 'dashboard_access', 'Client accessed dashboard', '::1', '2025-10-16 06:38:40'),
(32, NULL, 'dashboard_access', 'Client accessed dashboard', '::1', '2025-10-16 06:52:00'),
(33, NULL, 'dashboard_access', 'Client accessed dashboard', '::1', '2025-10-16 06:53:43'),
(34, NULL, 'dashboard_access', 'Client accessed dashboard', '::1', '2025-10-16 07:01:37'),
(35, NULL, 'dashboard_access', 'Client accessed dashboard', '::1', '2025-10-16 07:05:04'),
(36, NULL, 'dashboard_access', 'Client accessed dashboard', '::1', '2025-10-16 07:06:17'),
(37, NULL, 'dashboard_access', 'Client accessed dashboard', '::1', '2025-10-16 07:06:54'),
(38, NULL, 'dashboard_access', 'Client accessed dashboard', '::1', '2025-10-16 07:07:12'),
(39, NULL, 'dashboard_access', 'Client accessed dashboard', '::1', '2025-10-16 07:08:57'),
(40, NULL, 'dashboard_access', 'Client accessed dashboard', '::1', '2025-10-16 07:10:33'),
(41, NULL, 'dashboard_access', 'Client accessed dashboard', '::1', '2025-10-16 07:11:57'),
(42, NULL, 'dashboard_access', 'Client accessed dashboard', '::1', '2025-10-16 07:12:04'),
(43, NULL, 'dashboard_access', 'Client accessed dashboard', '::1', '2025-10-16 07:12:07'),
(44, NULL, 'dashboard_access', 'Client accessed dashboard', '::1', '2025-10-16 07:12:23'),
(45, NULL, 'dashboard_access', 'Client accessed dashboard', '::1', '2025-10-16 07:58:45'),
(46, NULL, 'dashboard_access', 'Client accessed dashboard', '::1', '2025-10-16 07:59:56'),
(47, NULL, 'dashboard_access', 'Client accessed dashboard', '::1', '2025-10-16 08:01:01');

-- --------------------------------------------------------

--
-- Table structure for table `alerts`
--

CREATE TABLE `alerts` (
  `id` int(11) NOT NULL,
  `device_id` int(11) DEFAULT NULL COMMENT 'Reference to admin.devices table',
  `alert_type` enum('temperature','humidity','ammonia','device_response','system','maintenance') NOT NULL,
  `alert_category` enum('threshold_violation','device_activation','system_event','maintenance_required') NOT NULL,
  `severity` enum('low','warning','critical','emergency') NOT NULL DEFAULT 'warning',
  `parameter_name` varchar(50) NOT NULL COMMENT 'e.g., Temperature, Humidity, Ammonia',
  `current_value` decimal(10,3) DEFAULT NULL COMMENT 'Current sensor reading',
  `threshold_value` decimal(10,3) DEFAULT NULL COMMENT 'Threshold that triggered alert',
  `threshold_type` enum('min','max','range') DEFAULT NULL COMMENT 'Type of threshold violation',
  `alert_message` text NOT NULL COMMENT 'Human-readable alert description',
  `alert_description` text DEFAULT NULL COMMENT 'Detailed technical description',
  `trigger_reason` varchar(255) DEFAULT NULL COMMENT 'What caused the alert',
  `device_response` varchar(255) DEFAULT NULL COMMENT 'Automated device action taken',
  `status` enum('active','acknowledged','resolved','dismissed') NOT NULL DEFAULT 'active',
  `acknowledged_by` int(11) DEFAULT NULL COMMENT 'User who acknowledged the alert',
  `acknowledged_at` datetime DEFAULT NULL,
  `resolved_at` datetime DEFAULT NULL,
  `resolution_notes` text DEFAULT NULL COMMENT 'Notes about how alert was resolved',
  `alert_timestamp` datetime NOT NULL COMMENT 'When the alert occurred',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='System alerts and notifications';

-- --------------------------------------------------------

--
-- Table structure for table `alert_notifications`
--

CREATE TABLE `alert_notifications` (
  `id` int(11) NOT NULL,
  `alert_id` int(11) NOT NULL,
  `notification_type` enum('email','sms','push','dashboard','webhook') NOT NULL,
  `recipient` varchar(255) NOT NULL COMMENT 'Email, phone, or user ID',
  `status` enum('pending','sent','delivered','failed') NOT NULL DEFAULT 'pending',
  `sent_at` datetime DEFAULT NULL,
  `delivered_at` datetime DEFAULT NULL,
  `error_message` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Alert notification delivery tracking';

-- --------------------------------------------------------

--
-- Table structure for table `alert_thresholds`
--

CREATE TABLE `alert_thresholds` (
  `id` int(11) NOT NULL,
  `device_id` int(11) DEFAULT NULL,
  `parameter_name` varchar(50) NOT NULL,
  `parameter_type` enum('temperature','humidity','ammonia','pressure','voltage') NOT NULL,
  `min_threshold` decimal(10,3) DEFAULT NULL COMMENT 'Minimum acceptable value',
  `max_threshold` decimal(10,3) DEFAULT NULL COMMENT 'Maximum acceptable value',
  `warning_min` decimal(10,3) DEFAULT NULL COMMENT 'Warning level minimum',
  `warning_max` decimal(10,3) DEFAULT NULL COMMENT 'Warning level maximum',
  `critical_min` decimal(10,3) DEFAULT NULL COMMENT 'Critical level minimum',
  `critical_max` decimal(10,3) DEFAULT NULL COMMENT 'Critical level maximum',
  `unit` varchar(20) NOT NULL DEFAULT 'unit' COMMENT 'Unit of measurement',
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Alert threshold configurations';

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
  `duration_minutes` int(11) DEFAULT 30,
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
(24856, NULL, 0.00, 0.00, 36.000, NULL, '2025-10-15 00:08:25', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:25:17', NULL, NULL, '192.168.1.11'),
(24857, NULL, 0.00, 0.00, 38.000, NULL, '2025-10-15 00:08:26', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:25:17', NULL, NULL, '192.168.1.11'),
(24858, NULL, 0.00, 0.00, 33.000, NULL, '2025-10-15 00:08:28', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:25:17', NULL, NULL, '192.168.1.11'),
(24859, NULL, 0.00, 0.00, 37.000, NULL, '2025-10-15 00:08:30', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:25:17', NULL, NULL, '192.168.1.11'),
(24860, NULL, 0.00, 0.00, 45.000, NULL, '2025-10-15 00:08:31', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:25:17', NULL, NULL, '192.168.1.11'),
(24861, NULL, 0.00, 0.00, 34.000, NULL, '2025-10-15 00:08:33', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:25:17', NULL, NULL, '192.168.1.11'),
(24862, NULL, 0.00, 0.00, 37.000, NULL, '2025-10-15 00:08:35', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:25:17', NULL, NULL, '192.168.1.11'),
(24863, NULL, 0.00, 0.00, 35.000, NULL, '2025-10-15 00:08:36', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:25:17', NULL, NULL, '192.168.1.11'),
(24864, NULL, 0.00, 0.00, 46.000, NULL, '2025-10-15 00:08:39', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:25:17', NULL, NULL, '192.168.1.11'),
(24865, NULL, 0.00, 0.00, 32.000, NULL, '2025-10-15 00:08:40', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:25:17', NULL, NULL, '192.168.1.11'),
(24866, NULL, 0.00, 0.00, 38.000, NULL, '2025-10-15 00:08:42', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:25:17', NULL, NULL, '192.168.1.11'),
(24867, NULL, 0.00, 0.00, 35.000, NULL, '2025-10-15 00:08:44', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:25:17', NULL, NULL, '192.168.1.11'),
(24868, NULL, 0.00, 0.00, 42.000, NULL, '2025-10-15 00:08:45', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:25:17', NULL, NULL, '192.168.1.11'),
(24869, NULL, 0.00, 0.00, 39.000, NULL, '2025-10-15 00:08:47', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:25:17', NULL, NULL, '192.168.1.11'),
(24870, NULL, 0.00, 0.00, 36.000, NULL, '2025-10-15 00:08:50', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:25:17', NULL, NULL, '192.168.1.11'),
(24871, NULL, 0.00, 0.00, 38.000, NULL, '2025-10-15 00:08:52', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:25:17', NULL, NULL, '192.168.1.11'),
(24872, NULL, 0.00, 0.00, 37.000, NULL, '2025-10-15 00:08:54', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:25:17', NULL, NULL, '192.168.1.11'),
(24873, NULL, 0.00, 0.00, 38.000, NULL, '2025-10-15 00:08:56', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:25:17', NULL, NULL, '192.168.1.11'),
(24874, NULL, 0.00, 0.00, 42.000, NULL, '2025-10-15 00:08:57', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:25:17', NULL, NULL, '192.168.1.11'),
(24875, NULL, 0.00, 0.00, 44.000, NULL, '2025-10-15 00:08:59', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:25:17', NULL, NULL, '192.168.1.11'),
(24876, NULL, 0.00, 0.00, 36.000, NULL, '2025-10-15 00:09:02', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:25:17', NULL, NULL, '192.168.1.11'),
(24877, NULL, 0.00, 0.00, 35.000, NULL, '2025-10-15 00:09:03', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:25:17', NULL, NULL, '192.168.1.11'),
(24878, NULL, 0.00, 0.00, 36.000, NULL, '2025-10-15 00:09:05', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:25:17', NULL, NULL, '192.168.1.11'),
(24879, NULL, 0.00, 0.00, 39.000, NULL, '2025-10-15 00:09:07', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:25:17', NULL, NULL, '192.168.1.11'),
(24880, NULL, 0.00, 0.00, 32.000, NULL, '2025-10-15 00:09:09', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:25:17', NULL, NULL, '192.168.1.11'),
(24881, NULL, 0.00, 0.00, 35.000, NULL, '2025-10-15 00:09:11', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:25:17', NULL, NULL, '192.168.1.11'),
(24882, NULL, 0.00, 0.00, 45.000, NULL, '2025-10-15 00:09:13', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:25:17', NULL, NULL, '192.168.1.11'),
(24883, NULL, 0.00, 0.00, 32.000, NULL, '2025-10-15 00:09:15', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:25:17', NULL, NULL, '192.168.1.11'),
(24884, NULL, 0.00, 0.00, 45.000, NULL, '2025-10-15 00:09:17', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:25:17', NULL, NULL, '192.168.1.11'),
(24885, NULL, 0.00, 0.00, 35.000, NULL, '2025-10-15 00:09:18', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:25:17', NULL, NULL, '192.168.1.11'),
(24886, NULL, 0.00, 0.00, 38.000, NULL, '2025-10-15 00:09:21', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:25:17', NULL, NULL, '192.168.1.11'),
(24887, NULL, 0.00, 0.00, 45.000, NULL, '2025-10-15 00:09:23', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:25:17', NULL, NULL, '192.168.1.11'),
(24888, NULL, 0.00, 0.00, 43.000, NULL, '2025-10-15 00:09:25', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:25:17', NULL, NULL, '192.168.1.11'),
(24889, NULL, 0.00, 0.00, 33.000, NULL, '2025-10-15 00:09:27', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:25:17', NULL, NULL, '192.168.1.11'),
(24890, NULL, 0.00, 0.00, 42.000, NULL, '2025-10-15 00:09:28', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:25:17', NULL, NULL, '192.168.1.11'),
(24891, NULL, 0.00, 0.00, 35.000, NULL, '2025-10-15 00:09:30', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:25:17', NULL, NULL, '192.168.1.11'),
(24892, NULL, 0.00, 0.00, 31.000, NULL, '2025-10-15 00:09:32', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:25:17', NULL, NULL, '192.168.1.11'),
(24893, NULL, 0.00, 0.00, 45.000, NULL, '2025-10-15 00:09:34', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:25:17', NULL, NULL, '192.168.1.11'),
(24894, NULL, 0.00, 0.00, 36.000, NULL, '2025-10-15 00:09:36', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:25:17', NULL, NULL, '192.168.1.11'),
(24895, NULL, 0.00, 0.00, 36.000, NULL, '2025-10-15 00:09:38', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:25:17', NULL, NULL, '192.168.1.11'),
(24896, NULL, 0.00, 0.00, 41.000, NULL, '2025-10-15 00:09:40', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:25:17', NULL, NULL, '192.168.1.11'),
(24897, NULL, 0.00, 0.00, 37.000, NULL, '2025-10-15 00:09:41', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:25:17', NULL, NULL, '192.168.1.11'),
(24898, NULL, 0.00, 0.00, 32.000, NULL, '2025-10-15 00:09:43', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:25:17', NULL, NULL, '192.168.1.11'),
(24899, NULL, 0.00, 0.00, 44.000, NULL, '2025-10-15 00:09:45', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:25:17', NULL, NULL, '192.168.1.11'),
(24900, NULL, 0.00, 0.00, 39.000, NULL, '2025-10-15 00:09:46', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:25:17', NULL, NULL, '192.168.1.11'),
(24901, NULL, 0.00, 0.00, 35.000, NULL, '2025-10-15 00:09:48', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:25:17', NULL, NULL, '192.168.1.11'),
(24902, NULL, 0.00, 0.00, 32.000, NULL, '2025-10-15 00:09:50', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:25:17', NULL, NULL, '192.168.1.11'),
(24903, NULL, 0.00, 0.00, 37.000, NULL, '2025-10-15 00:09:53', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:25:17', NULL, NULL, '192.168.1.11'),
(24904, NULL, 0.00, 0.00, 28.000, NULL, '2025-10-15 00:09:54', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:25:17', NULL, NULL, '192.168.1.11'),
(24905, NULL, 0.00, 0.00, 41.000, NULL, '2025-10-15 00:09:56', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:25:17', NULL, NULL, '192.168.1.11'),
(24906, NULL, 0.00, 0.00, 42.000, NULL, '2025-10-15 00:09:58', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:25:17', NULL, NULL, '192.168.1.11'),
(24907, NULL, 0.00, 0.00, 35.000, NULL, '2025-10-15 00:10:00', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:25:17', NULL, NULL, '192.168.1.11'),
(24908, NULL, 0.00, 0.00, 36.000, NULL, '2025-10-15 00:10:01', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:25:17', NULL, NULL, '192.168.1.11'),
(24909, NULL, 0.00, 0.00, 44.000, NULL, '2025-10-15 00:10:03', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:25:17', NULL, NULL, '192.168.1.11'),
(24910, NULL, 0.00, 0.00, 35.000, NULL, '2025-10-15 00:10:05', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:25:17', NULL, NULL, '192.168.1.11'),
(24911, NULL, 0.00, 0.00, 38.000, NULL, '2025-10-15 00:10:06', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:25:17', NULL, NULL, '192.168.1.11'),
(24912, NULL, 0.00, 0.00, 34.000, NULL, '2025-10-15 00:10:08', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:25:17', NULL, NULL, '192.168.1.11'),
(24913, NULL, 0.00, 0.00, 46.000, NULL, '2025-10-15 00:10:11', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:25:17', NULL, NULL, '192.168.1.11'),
(24914, NULL, 0.00, 0.00, 42.000, NULL, '2025-10-15 00:10:12', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:25:17', NULL, NULL, '192.168.1.11'),
(24915, NULL, 0.00, 0.00, 38.000, NULL, '2025-10-15 00:10:14', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:25:17', NULL, NULL, '192.168.1.11'),
(24916, NULL, 0.00, 0.00, 45.000, NULL, '2025-10-15 00:10:16', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:25:17', NULL, NULL, '192.168.1.11'),
(24917, NULL, 0.00, 0.00, 29.000, NULL, '2025-10-15 00:10:17', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:25:17', NULL, NULL, '192.168.1.11'),
(24918, NULL, 0.00, 0.00, 44.000, NULL, '2025-10-15 00:10:19', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:25:17', NULL, NULL, '192.168.1.11'),
(24919, NULL, 0.00, 0.00, 37.000, NULL, '2025-10-15 00:10:20', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:25:17', NULL, NULL, '192.168.1.11'),
(24920, NULL, 0.00, 0.00, 46.000, NULL, '2025-10-15 00:10:22', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:25:17', NULL, NULL, '192.168.1.11'),
(24921, NULL, 0.00, 0.00, 33.000, NULL, '2025-10-15 00:10:25', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:25:17', NULL, NULL, '192.168.1.11'),
(24922, NULL, 0.00, 0.00, 34.000, NULL, '2025-10-15 00:10:26', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:25:17', NULL, NULL, '192.168.1.11'),
(24923, NULL, 0.00, 0.00, 26.000, NULL, '2025-10-15 00:10:28', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:25:17', NULL, NULL, '192.168.1.11'),
(24924, NULL, 0.00, 0.00, 44.000, NULL, '2025-10-15 00:10:30', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:25:17', NULL, NULL, '192.168.1.11'),
(24925, NULL, 25.50, 60.20, 15.300, NULL, '2025-10-16 07:32:29', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:32:29', '24.8', 'OFF', '192.168.1.100'),
(24926, NULL, 25.50, 60.20, 15.300, NULL, '2025-10-16 07:32:34', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:32:35', '24.8', 'OFF', '192.168.1.100'),
(24927, NULL, 30.60, 90.10, 31.000, NULL, '2025-10-16 13:45:21', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:45:21', NULL, NULL, '192.168.1.100'),
(24928, NULL, 30.60, 89.70, 31.000, NULL, '2025-10-16 13:46:00', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:49:31', NULL, NULL, '192.168.1.100'),
(24929, NULL, 30.60, 89.70, 31.000, NULL, '2025-10-16 13:46:02', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:49:31', NULL, NULL, '192.168.1.100'),
(24930, NULL, 30.60, 89.90, 31.000, NULL, '2025-10-16 13:46:06', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:49:31', NULL, NULL, '192.168.1.100'),
(24931, NULL, 30.60, 89.90, 31.000, NULL, '2025-10-16 13:46:08', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:49:31', NULL, NULL, '192.168.1.100'),
(24932, NULL, 30.70, 90.00, 31.000, NULL, '2025-10-16 13:46:12', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:49:31', NULL, NULL, '192.168.1.100'),
(24933, NULL, 30.70, 90.10, 31.000, NULL, '2025-10-16 13:46:14', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:49:31', NULL, NULL, '192.168.1.100'),
(24934, NULL, 30.70, 90.00, 31.000, NULL, '2025-10-16 13:46:17', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:49:31', NULL, NULL, '192.168.1.100'),
(24935, NULL, 30.70, 90.00, 31.000, NULL, '2025-10-16 13:46:19', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:49:31', NULL, NULL, '192.168.1.100'),
(24936, NULL, 30.70, 90.00, 31.000, NULL, '2025-10-16 13:46:21', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:49:31', NULL, NULL, '192.168.1.100'),
(24937, NULL, 30.70, 90.00, 31.000, NULL, '2025-10-16 13:46:25', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:49:31', NULL, NULL, '192.168.1.100'),
(24938, NULL, 30.70, 90.20, 31.000, NULL, '2025-10-16 13:46:28', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:49:31', NULL, NULL, '192.168.1.100'),
(24939, NULL, 30.70, 90.30, 31.000, NULL, '2025-10-16 13:46:31', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:49:31', NULL, NULL, '192.168.1.100'),
(24940, NULL, 30.70, 90.20, 0.000, NULL, '2025-10-16 13:46:34', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:49:31', NULL, NULL, '192.168.1.100'),
(24941, NULL, 30.70, 90.20, 0.000, NULL, '2025-10-16 13:46:37', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:49:31', NULL, NULL, '192.168.1.100'),
(24942, NULL, 30.70, 90.20, 31.000, NULL, '2025-10-16 13:46:40', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:49:31', NULL, NULL, '192.168.1.100'),
(24943, NULL, 30.70, 90.20, 31.000, NULL, '2025-10-16 13:46:43', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:49:31', NULL, NULL, '192.168.1.100'),
(24944, NULL, 30.70, 90.20, 31.000, NULL, '2025-10-16 13:46:46', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:49:31', NULL, NULL, '192.168.1.100'),
(24945, NULL, 30.70, 90.30, 31.000, NULL, '2025-10-16 13:47:04', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:49:31', NULL, NULL, '192.168.1.100'),
(24946, NULL, 30.70, 89.50, 31.000, NULL, '2025-10-16 13:51:44', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:52:06', NULL, NULL, '192.168.1.100'),
(24947, NULL, 30.70, 89.50, 31.000, NULL, '2025-10-16 13:51:46', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:52:06', NULL, NULL, '192.168.1.100'),
(24948, NULL, 30.70, 89.40, 31.000, NULL, '2025-10-16 13:51:50', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:52:06', NULL, NULL, '192.168.1.100'),
(24949, NULL, 30.80, 89.30, 31.000, NULL, '2025-10-16 13:51:52', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:52:06', NULL, NULL, '192.168.1.100'),
(24950, NULL, 30.80, 89.20, 31.000, NULL, '2025-10-16 13:51:58', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:52:06', NULL, NULL, '192.168.1.100'),
(24951, NULL, 30.80, 89.10, 0.000, NULL, '2025-10-16 13:52:01', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:56:59', NULL, NULL, '192.168.1.100'),
(24952, NULL, 30.80, 89.10, 0.000, NULL, '2025-10-16 13:52:06', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:56:59', NULL, NULL, '192.168.1.100'),
(24953, NULL, 30.80, 89.10, 0.000, NULL, '2025-10-16 13:52:12', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:56:59', NULL, NULL, '192.168.1.100'),
(24954, NULL, 30.80, 89.30, 31.000, NULL, '2025-10-16 13:52:16', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:56:59', NULL, NULL, '192.168.1.100'),
(24955, NULL, 30.80, 89.30, 31.000, NULL, '2025-10-16 13:52:32', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:56:59', NULL, NULL, '192.168.1.100'),
(24956, NULL, 30.80, 89.40, 31.000, NULL, '2025-10-16 13:52:36', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:56:59', NULL, NULL, '192.168.1.100'),
(24957, NULL, 30.80, 89.30, 30.000, NULL, '2025-10-16 13:52:44', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:56:59', NULL, NULL, '192.168.1.100'),
(24958, NULL, 30.80, 89.80, 30.000, NULL, '2025-10-16 13:52:49', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:56:59', NULL, NULL, '192.168.1.100'),
(24959, NULL, 30.80, 90.10, 0.000, NULL, '2025-10-16 13:53:07', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:56:59', NULL, NULL, '192.168.1.100'),
(24960, NULL, 30.80, 89.60, 30.000, NULL, '2025-10-16 13:53:12', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:56:59', NULL, NULL, '192.168.1.100'),
(24961, NULL, 30.80, 89.50, 31.000, NULL, '2025-10-16 13:53:21', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:56:59', NULL, NULL, '192.168.1.100'),
(24962, NULL, 30.80, 90.00, 0.000, NULL, '2025-10-16 13:53:36', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:56:59', NULL, NULL, '192.168.1.100'),
(24963, NULL, 30.80, 90.40, 30.000, NULL, '2025-10-16 13:53:55', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:56:59', NULL, NULL, '192.168.1.100'),
(24964, NULL, 30.80, 90.10, 30.000, NULL, '2025-10-16 13:54:14', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:56:59', NULL, NULL, '192.168.1.100'),
(24965, NULL, 30.80, 89.90, 30.000, NULL, '2025-10-16 13:54:20', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:56:59', NULL, NULL, '192.168.1.100'),
(24966, NULL, 30.80, 89.80, 30.000, NULL, '2025-10-16 13:54:22', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:56:59', NULL, NULL, '192.168.1.100'),
(24967, NULL, 30.80, 89.40, 30.000, NULL, '2025-10-16 13:54:29', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 05:56:59', NULL, NULL, '192.168.1.100'),
(24968, NULL, 30.80, 89.70, 30.000, NULL, '2025-10-16 14:43:06', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:43:14', NULL, NULL, '192.168.1.100'),
(24969, NULL, 30.90, 89.20, 30.000, NULL, '2025-10-16 14:43:26', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:43:40', NULL, NULL, '192.168.1.100'),
(24970, NULL, 30.90, 89.00, 29.000, NULL, '2025-10-16 14:43:32', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:43:40', NULL, NULL, '192.168.1.100'),
(24971, NULL, 30.90, 88.90, 30.000, NULL, '2025-10-16 14:43:41', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:48:40', NULL, NULL, '192.168.1.100'),
(24972, NULL, 30.90, 89.00, 30.000, NULL, '2025-10-16 14:43:48', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:48:40', NULL, NULL, '192.168.1.100'),
(24973, NULL, 30.90, 88.80, 30.000, NULL, '2025-10-16 14:44:03', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:48:40', NULL, NULL, '192.168.1.100'),
(24974, NULL, 30.90, 88.90, 30.000, NULL, '2025-10-16 14:44:06', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:48:40', NULL, NULL, '192.168.1.100'),
(24975, NULL, 30.90, 89.40, 30.000, NULL, '2025-10-16 14:44:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:48:41', NULL, NULL, '192.168.1.100'),
(24976, NULL, 30.90, 89.10, 30.000, NULL, '2025-10-16 14:44:25', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:48:41', NULL, NULL, '192.168.1.100'),
(24977, NULL, 30.90, 89.00, 30.000, NULL, '2025-10-16 14:44:27', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:48:41', NULL, NULL, '192.168.1.100'),
(24978, NULL, 30.90, 88.90, 30.000, NULL, '2025-10-16 14:44:39', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:48:41', NULL, NULL, '192.168.1.100'),
(24979, NULL, 30.90, 86.30, 31.000, NULL, '2025-10-16 14:45:12', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:48:41', NULL, NULL, '192.168.1.100'),
(24980, NULL, 30.90, 88.90, 29.000, NULL, '2025-10-16 14:43:56', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:48:41', NULL, NULL, '192.168.1.100'),
(24981, NULL, 30.90, 88.00, 31.000, NULL, '2025-10-16 14:45:50', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:48:41', NULL, NULL, '192.168.1.100'),
(24982, NULL, 30.90, 88.20, 31.000, NULL, '2025-10-16 14:46:44', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:48:41', NULL, NULL, '192.168.1.100'),
(24983, NULL, 30.90, 88.40, 31.000, NULL, '2025-10-16 14:46:46', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:48:41', NULL, NULL, '192.168.1.100'),
(24984, NULL, 30.90, 88.30, 31.000, NULL, '2025-10-16 14:46:49', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:48:41', NULL, NULL, '192.168.1.100'),
(24985, NULL, 30.90, 88.20, 31.000, NULL, '2025-10-16 14:46:51', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:48:41', NULL, NULL, '192.168.1.100'),
(24986, NULL, 30.90, 88.10, 31.000, NULL, '2025-10-16 14:46:53', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:48:41', NULL, NULL, '192.168.1.100'),
(24987, NULL, 30.90, 88.20, 31.000, NULL, '2025-10-16 14:46:57', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:48:41', NULL, NULL, '192.168.1.100'),
(24988, NULL, 30.90, 88.30, 30.000, NULL, '2025-10-16 14:46:59', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:48:41', NULL, NULL, '192.168.1.100'),
(24989, NULL, 30.90, 88.30, 31.000, NULL, '2025-10-16 14:47:01', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:48:41', NULL, NULL, '192.168.1.100'),
(24990, NULL, 30.90, 88.40, 30.000, NULL, '2025-10-16 14:47:03', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:48:41', NULL, NULL, '192.168.1.100'),
(24991, NULL, 30.90, 88.40, 31.000, NULL, '2025-10-16 14:47:05', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:48:41', NULL, NULL, '192.168.1.100'),
(24992, NULL, 30.90, 88.40, 30.000, NULL, '2025-10-16 14:47:12', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:48:41', NULL, NULL, '192.168.1.100'),
(24993, NULL, 30.90, 88.30, 31.000, NULL, '2025-10-16 14:47:16', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:48:41', NULL, NULL, '192.168.1.100'),
(24994, NULL, 30.90, 88.40, 30.000, NULL, '2025-10-16 14:47:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:48:41', NULL, NULL, '192.168.1.100'),
(24995, NULL, 30.90, 88.40, 30.000, NULL, '2025-10-16 14:47:20', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:48:41', NULL, NULL, '192.168.1.100'),
(24996, NULL, 30.90, 88.20, 30.000, NULL, '2025-10-16 14:47:44', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:48:41', NULL, NULL, '192.168.1.100'),
(24997, NULL, 30.80, 88.80, 30.000, NULL, '2025-10-16 14:48:44', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:52:44', NULL, NULL, '192.168.1.100'),
(24998, NULL, 30.80, 88.60, 30.000, NULL, '2025-10-16 14:48:46', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:52:45', NULL, NULL, '192.168.1.100'),
(24999, NULL, 30.80, 88.80, 30.000, NULL, '2025-10-16 14:48:48', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:52:45', NULL, NULL, '192.168.1.100'),
(25000, NULL, 30.80, 88.80, 30.000, NULL, '2025-10-16 14:48:51', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:52:45', NULL, NULL, '192.168.1.100'),
(25001, NULL, 30.80, 88.80, 30.000, NULL, '2025-10-16 14:48:54', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:52:45', NULL, NULL, '192.168.1.100'),
(25002, NULL, 30.80, 88.80, 30.000, NULL, '2025-10-16 14:49:05', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:52:45', NULL, NULL, '192.168.1.100'),
(25003, NULL, 30.80, 89.20, 30.000, NULL, '2025-10-16 14:49:08', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:52:45', NULL, NULL, '192.168.1.100'),
(25004, NULL, 30.80, 89.10, 30.000, NULL, '2025-10-16 14:49:10', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:52:45', NULL, NULL, '192.168.1.100'),
(25005, NULL, 30.80, 89.10, 30.000, NULL, '2025-10-16 14:49:15', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:52:45', NULL, NULL, '192.168.1.100'),
(25006, NULL, 30.80, 89.20, 30.000, NULL, '2025-10-16 14:49:17', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:52:45', NULL, NULL, '192.168.1.100'),
(25007, NULL, 30.80, 89.30, 30.000, NULL, '2025-10-16 14:49:20', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:52:45', NULL, NULL, '192.168.1.100'),
(25008, NULL, 30.80, 89.20, 30.000, NULL, '2025-10-16 14:49:23', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:52:45', NULL, NULL, '192.168.1.100'),
(25009, NULL, 30.80, 89.20, 30.000, NULL, '2025-10-16 14:49:25', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:52:45', NULL, NULL, '192.168.1.100'),
(25010, NULL, 30.90, 89.10, 30.000, NULL, '2025-10-16 14:49:29', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:52:45', NULL, NULL, '192.168.1.100'),
(25011, NULL, 30.90, 89.20, 30.000, NULL, '2025-10-16 14:49:32', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:52:45', NULL, NULL, '192.168.1.100'),
(25012, NULL, 30.90, 89.50, 30.000, NULL, '2025-10-16 14:49:34', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:52:45', NULL, NULL, '192.168.1.100'),
(25013, NULL, 30.90, 89.50, 30.000, NULL, '2025-10-16 14:49:36', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:52:45', NULL, NULL, '192.168.1.100'),
(25014, NULL, 30.90, 89.60, 30.000, NULL, '2025-10-16 14:49:39', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:52:45', NULL, NULL, '192.168.1.100'),
(25015, NULL, 30.90, 89.50, 30.000, NULL, '2025-10-16 14:49:42', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:52:45', NULL, NULL, '192.168.1.100'),
(25016, NULL, 30.90, 89.50, 30.000, NULL, '2025-10-16 14:49:43', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:52:45', NULL, NULL, '192.168.1.100'),
(25017, NULL, 30.90, 89.50, 30.000, NULL, '2025-10-16 14:49:48', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:52:45', NULL, NULL, '192.168.1.100'),
(25018, NULL, 30.90, 89.40, 30.000, NULL, '2025-10-16 14:49:50', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:52:45', NULL, NULL, '192.168.1.100'),
(25019, NULL, 30.90, 89.30, 30.000, NULL, '2025-10-16 14:49:53', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:52:45', NULL, NULL, '192.168.1.100'),
(25020, NULL, 30.80, 89.20, 30.000, NULL, '2025-10-16 14:49:57', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:52:45', NULL, NULL, '192.168.1.100'),
(25021, NULL, 30.90, 89.10, 30.000, NULL, '2025-10-16 14:49:59', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:52:45', NULL, NULL, '192.168.1.100'),
(25022, NULL, 30.90, 89.10, 30.000, NULL, '2025-10-16 14:50:01', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:52:45', NULL, NULL, '192.168.1.100'),
(25023, NULL, 30.90, 89.00, 30.000, NULL, '2025-10-16 14:50:03', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:52:45', NULL, NULL, '192.168.1.100'),
(25024, NULL, 30.90, 89.00, 30.000, NULL, '2025-10-16 14:50:07', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:52:45', NULL, NULL, '192.168.1.100'),
(25025, NULL, 30.90, 89.30, 30.000, NULL, '2025-10-16 14:50:10', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:52:45', NULL, NULL, '192.168.1.100'),
(25026, NULL, 30.90, 89.30, 30.000, NULL, '2025-10-16 14:50:14', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:52:45', NULL, NULL, '192.168.1.100'),
(25027, NULL, 30.90, 89.30, 30.000, NULL, '2025-10-16 14:50:17', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:52:45', NULL, NULL, '192.168.1.100'),
(25028, NULL, 30.90, 89.30, 30.000, NULL, '2025-10-16 14:50:23', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:52:45', NULL, NULL, '192.168.1.100'),
(25029, NULL, 30.90, 89.10, 30.000, NULL, '2025-10-16 14:50:26', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:52:45', NULL, NULL, '192.168.1.100'),
(25030, NULL, 30.90, 89.00, 30.000, NULL, '2025-10-16 14:50:29', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:52:45', NULL, NULL, '192.168.1.100'),
(25031, NULL, 30.90, 89.00, 30.000, NULL, '2025-10-16 14:50:31', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:52:45', NULL, NULL, '192.168.1.100'),
(25032, NULL, 30.90, 89.00, 30.000, NULL, '2025-10-16 14:50:33', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:52:45', NULL, NULL, '192.168.1.100'),
(25033, NULL, 30.90, 89.00, 30.000, NULL, '2025-10-16 14:50:36', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:52:45', NULL, NULL, '192.168.1.100'),
(25034, NULL, 30.90, 89.00, 30.000, NULL, '2025-10-16 14:50:39', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:52:45', NULL, NULL, '192.168.1.100'),
(25035, NULL, 30.80, 87.00, 30.000, NULL, '2025-10-16 14:51:37', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:52:45', NULL, NULL, '192.168.1.100'),
(25036, NULL, 30.90, 87.10, 30.000, NULL, '2025-10-16 14:51:42', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:52:45', NULL, NULL, '192.168.1.100'),
(25037, NULL, 30.90, 87.30, 30.000, NULL, '2025-10-16 14:51:45', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:52:45', NULL, NULL, '192.168.1.100'),
(25038, NULL, 30.90, 87.60, 30.000, NULL, '2025-10-16 14:51:49', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:52:45', NULL, NULL, '192.168.1.100'),
(25039, NULL, 30.90, 87.70, 30.000, NULL, '2025-10-16 14:51:53', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:52:45', NULL, NULL, '192.168.1.100'),
(25040, NULL, 30.90, 87.60, 30.000, NULL, '2025-10-16 14:51:55', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:52:45', NULL, NULL, '192.168.1.100'),
(25041, NULL, 30.90, 87.30, 30.000, NULL, '2025-10-16 14:51:58', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:52:45', NULL, NULL, '192.168.1.100'),
(25042, NULL, 30.90, 87.20, 30.000, NULL, '2025-10-16 14:52:01', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:52:45', NULL, NULL, '192.168.1.100'),
(25043, NULL, 30.90, 87.50, 30.000, NULL, '2025-10-16 14:52:05', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:52:45', NULL, NULL, '192.168.1.100'),
(25044, NULL, 30.90, 87.70, 30.000, NULL, '2025-10-16 14:52:07', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:52:45', NULL, NULL, '192.168.1.100'),
(25045, NULL, 30.90, 87.90, 30.000, NULL, '2025-10-16 14:52:13', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:52:45', NULL, NULL, '192.168.1.100'),
(25046, NULL, 30.80, 88.00, 30.000, NULL, '2025-10-16 14:52:16', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:52:45', NULL, NULL, '192.168.1.100'),
(25047, NULL, 30.80, 88.20, 30.000, NULL, '2025-10-16 14:52:19', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:52:45', NULL, NULL, '192.168.1.100'),
(25048, NULL, 30.90, 88.10, 30.000, NULL, '2025-10-16 14:52:22', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:52:45', NULL, NULL, '192.168.1.100'),
(25049, NULL, 30.90, 88.00, 30.000, NULL, '2025-10-16 14:52:31', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:52:45', NULL, NULL, '192.168.1.100'),
(25050, NULL, 30.90, 88.20, 30.000, NULL, '2025-10-16 14:52:35', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:52:45', NULL, NULL, '192.168.1.100'),
(25051, NULL, 30.90, 88.20, 30.000, NULL, '2025-10-16 14:52:39', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:52:45', NULL, NULL, '192.168.1.100'),
(25052, NULL, 30.90, 88.00, 30.000, NULL, '2025-10-16 14:52:44', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:58:13', NULL, NULL, '192.168.1.100'),
(25053, NULL, 30.80, 88.20, 30.000, NULL, '2025-10-16 14:53:13', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:58:13', NULL, NULL, '192.168.1.100'),
(25054, NULL, 30.80, 88.20, 30.000, NULL, '2025-10-16 14:53:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:58:13', NULL, NULL, '192.168.1.100'),
(25055, NULL, 30.80, 88.10, 30.000, NULL, '2025-10-16 14:53:22', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:58:13', NULL, NULL, '192.168.1.100'),
(25056, NULL, 30.80, 88.10, 30.000, NULL, '2025-10-16 14:53:25', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:58:13', NULL, NULL, '192.168.1.100'),
(25057, NULL, 30.80, 88.10, 30.000, NULL, '2025-10-16 14:53:41', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:58:13', NULL, NULL, '192.168.1.100'),
(25058, NULL, 30.80, 87.90, 30.000, NULL, '2025-10-16 14:53:44', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:58:13', NULL, NULL, '192.168.1.100'),
(25059, NULL, 30.80, 87.80, 30.000, NULL, '2025-10-16 14:53:47', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:58:13', NULL, NULL, '192.168.1.100'),
(25060, NULL, 30.80, 87.70, 30.000, NULL, '2025-10-16 14:53:50', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:58:13', NULL, NULL, '192.168.1.100'),
(25061, NULL, 30.80, 87.60, 30.000, NULL, '2025-10-16 14:53:54', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:58:13', NULL, NULL, '192.168.1.100'),
(25062, NULL, 30.80, 87.40, 30.000, NULL, '2025-10-16 14:53:56', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:58:13', NULL, NULL, '192.168.1.100'),
(25063, NULL, 30.80, 86.90, 30.000, NULL, '2025-10-16 14:54:00', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:58:13', NULL, NULL, '192.168.1.100'),
(25064, NULL, 30.80, 86.60, 30.000, NULL, '2025-10-16 14:54:03', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:58:13', NULL, NULL, '192.168.1.100'),
(25065, NULL, 30.80, 86.70, 30.000, NULL, '2025-10-16 14:54:07', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:58:13', NULL, NULL, '192.168.1.100'),
(25066, NULL, 30.80, 86.60, 30.000, NULL, '2025-10-16 14:54:09', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:58:13', NULL, NULL, '192.168.1.100'),
(25067, NULL, 30.90, 86.60, 30.000, NULL, '2025-10-16 14:54:12', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:58:13', NULL, NULL, '192.168.1.100'),
(25068, NULL, 30.80, 86.50, 30.000, NULL, '2025-10-16 14:54:23', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:58:13', NULL, NULL, '192.168.1.100'),
(25069, NULL, 30.80, 86.60, 30.000, NULL, '2025-10-16 14:54:26', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:58:13', NULL, NULL, '192.168.1.100'),
(25070, NULL, 30.80, 86.60, 30.000, NULL, '2025-10-16 14:54:30', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:58:13', NULL, NULL, '192.168.1.100'),
(25071, NULL, 30.80, 86.60, 30.000, NULL, '2025-10-16 14:54:33', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:58:13', NULL, NULL, '192.168.1.100'),
(25072, NULL, 30.80, 86.40, 30.000, NULL, '2025-10-16 14:54:36', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:58:13', NULL, NULL, '192.168.1.100'),
(25073, NULL, 30.80, 86.40, 30.000, NULL, '2025-10-16 14:54:39', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:58:13', NULL, NULL, '192.168.1.100'),
(25074, NULL, 30.80, 86.40, 30.000, NULL, '2025-10-16 14:54:42', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:58:13', NULL, NULL, '192.168.1.100'),
(25075, NULL, 30.80, 86.50, 30.000, NULL, '2025-10-16 14:54:44', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:58:13', NULL, NULL, '192.168.1.100'),
(25076, NULL, 30.80, 86.50, 30.000, NULL, '2025-10-16 14:54:49', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:58:13', NULL, NULL, '192.168.1.100'),
(25077, NULL, 30.80, 86.70, 30.000, NULL, '2025-10-16 14:54:53', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:58:13', NULL, NULL, '192.168.1.100'),
(25078, NULL, 30.80, 87.00, 30.000, NULL, '2025-10-16 14:54:56', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:58:13', NULL, NULL, '192.168.1.100'),
(25079, NULL, 30.80, 87.20, 30.000, NULL, '2025-10-16 14:54:58', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:58:13', NULL, NULL, '192.168.1.100'),
(25080, NULL, 30.80, 87.30, 30.000, NULL, '2025-10-16 14:55:04', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:58:13', NULL, NULL, '192.168.1.100'),
(25081, NULL, 30.80, 87.00, 30.000, NULL, '2025-10-16 14:55:08', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:58:13', NULL, NULL, '192.168.1.100'),
(25082, NULL, 30.80, 86.80, 30.000, NULL, '2025-10-16 14:55:10', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:58:13', NULL, NULL, '192.168.1.100'),
(25083, NULL, 30.80, 86.70, 30.000, NULL, '2025-10-16 14:55:14', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:58:13', NULL, NULL, '192.168.1.100'),
(25084, NULL, 30.80, 86.80, 30.000, NULL, '2025-10-16 14:55:17', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:58:13', NULL, NULL, '192.168.1.100'),
(25085, NULL, 30.80, 87.20, 30.000, NULL, '2025-10-16 14:55:20', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:58:13', NULL, NULL, '192.168.1.100'),
(25086, NULL, 30.80, 87.10, 30.000, NULL, '2025-10-16 14:55:22', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:58:13', NULL, NULL, '192.168.1.100'),
(25087, NULL, 30.80, 87.10, 30.000, NULL, '2025-10-16 14:55:33', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:58:13', NULL, NULL, '192.168.1.100'),
(25088, NULL, 30.80, 87.10, 30.000, NULL, '2025-10-16 14:55:35', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:58:13', NULL, NULL, '192.168.1.100'),
(25089, NULL, 30.80, 87.00, 30.000, NULL, '2025-10-16 14:55:38', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:58:13', NULL, NULL, '192.168.1.100'),
(25090, NULL, 30.70, 85.80, 30.000, NULL, '2025-10-16 14:56:44', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:58:13', NULL, NULL, '192.168.1.100'),
(25091, NULL, 30.70, 86.50, 30.000, NULL, '2025-10-16 14:56:50', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:58:13', NULL, NULL, '192.168.1.100'),
(25092, NULL, 30.80, 86.50, 30.000, NULL, '2025-10-16 14:56:58', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:58:13', NULL, NULL, '192.168.1.100'),
(25093, NULL, 30.70, 86.60, 30.000, NULL, '2025-10-16 14:57:02', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 06:58:13', NULL, NULL, '192.168.1.100'),
(25094, NULL, 30.60, 85.50, 33.000, NULL, '2025-10-16 15:07:27', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:07:30', NULL, NULL, '192.168.1.100'),
(25095, NULL, 30.60, 85.90, 33.000, NULL, '2025-10-16 15:07:31', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:12:32', NULL, NULL, '192.168.1.100'),
(25096, NULL, 30.60, 86.00, 33.000, NULL, '2025-10-16 15:07:33', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:12:32', NULL, NULL, '192.168.1.100'),
(25097, NULL, 30.60, 86.60, 33.000, NULL, '2025-10-16 15:07:36', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:12:32', NULL, NULL, '192.168.1.100'),
(25098, NULL, 30.60, 86.90, 33.000, NULL, '2025-10-16 15:07:39', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:12:32', NULL, NULL, '192.168.1.100'),
(25099, NULL, 30.60, 87.50, 33.000, NULL, '2025-10-16 15:08:28', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:12:32', NULL, NULL, '192.168.1.100'),
(25100, NULL, 30.60, 87.60, 33.000, NULL, '2025-10-16 15:08:30', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:12:32', NULL, NULL, '192.168.1.100'),
(25101, NULL, 30.60, 87.70, 33.000, NULL, '2025-10-16 15:08:32', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:12:32', NULL, NULL, '192.168.1.100'),
(25102, NULL, 30.70, 87.50, 33.000, NULL, '2025-10-16 15:08:43', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:12:32', NULL, NULL, '192.168.1.100'),
(25103, NULL, 30.70, 87.30, 33.000, NULL, '2025-10-16 15:08:46', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:12:32', NULL, NULL, '192.168.1.100'),
(25104, NULL, 30.70, 87.20, 33.000, NULL, '2025-10-16 15:08:49', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:12:32', NULL, NULL, '192.168.1.100'),
(25105, NULL, 30.70, 87.10, 33.000, NULL, '2025-10-16 15:08:51', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:12:32', NULL, NULL, '192.168.1.100'),
(25106, NULL, 30.70, 87.00, 33.000, NULL, '2025-10-16 15:08:56', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:12:32', NULL, NULL, '192.168.1.100'),
(25107, NULL, 30.70, 87.30, 33.000, NULL, '2025-10-16 15:08:59', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:12:32', NULL, NULL, '192.168.1.100'),
(25108, NULL, 30.70, 87.30, 33.000, NULL, '2025-10-16 15:09:01', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:12:32', NULL, NULL, '192.168.1.100'),
(25109, NULL, 30.70, 87.50, 33.000, NULL, '2025-10-16 15:09:04', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:12:32', NULL, NULL, '192.168.1.100'),
(25110, NULL, 30.70, 87.60, 32.000, NULL, '2025-10-16 15:09:07', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:12:32', NULL, NULL, '192.168.1.100'),
(25111, NULL, 30.70, 87.60, 33.000, NULL, '2025-10-16 15:09:08', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:12:32', NULL, NULL, '192.168.1.100'),
(25112, NULL, 30.70, 87.60, 32.000, NULL, '2025-10-16 15:09:10', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:12:32', NULL, NULL, '192.168.1.100'),
(25113, NULL, 30.70, 87.70, 33.000, NULL, '2025-10-16 15:09:12', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:12:32', NULL, NULL, '192.168.1.100'),
(25114, NULL, 30.70, 87.70, 32.000, NULL, '2025-10-16 15:09:14', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:12:32', NULL, NULL, '192.168.1.100'),
(25115, NULL, 30.70, 87.60, 32.000, NULL, '2025-10-16 15:09:16', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:12:32', NULL, NULL, '192.168.1.100'),
(25116, NULL, 30.70, 87.80, 32.000, NULL, '2025-10-16 15:09:19', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:12:32', NULL, NULL, '192.168.1.100'),
(25117, NULL, 30.70, 88.00, 32.000, NULL, '2025-10-16 15:09:21', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:12:32', NULL, NULL, '192.168.1.100'),
(25118, NULL, 30.70, 88.00, 32.000, NULL, '2025-10-16 15:09:22', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:12:32', NULL, NULL, '192.168.1.100'),
(25119, NULL, 30.70, 88.10, 32.000, NULL, '2025-10-16 15:09:25', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:12:32', NULL, NULL, '192.168.1.100'),
(25120, NULL, 30.70, 87.90, 32.000, NULL, '2025-10-16 15:09:27', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:12:32', NULL, NULL, '192.168.1.100'),
(25121, NULL, 30.70, 88.00, 32.000, NULL, '2025-10-16 15:09:30', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:12:32', NULL, NULL, '192.168.1.100'),
(25122, NULL, 30.70, 88.10, 32.000, NULL, '2025-10-16 15:09:33', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:12:32', NULL, NULL, '192.168.1.100'),
(25123, NULL, 30.80, 88.30, 32.000, NULL, '2025-10-16 15:09:35', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:12:32', NULL, NULL, '192.168.1.100'),
(25124, NULL, 30.80, 88.30, 32.000, NULL, '2025-10-16 15:09:37', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:12:32', NULL, NULL, '192.168.1.100'),
(25125, NULL, 30.70, 88.20, 32.000, NULL, '2025-10-16 15:09:39', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:12:32', NULL, NULL, '192.168.1.100'),
(25126, NULL, 30.80, 88.40, 32.000, NULL, '2025-10-16 15:09:42', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:12:32', NULL, NULL, '192.168.1.100'),
(25127, NULL, 30.80, 88.40, 32.000, NULL, '2025-10-16 15:09:44', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:12:32', NULL, NULL, '192.168.1.100'),
(25128, NULL, 30.80, 88.40, 32.000, NULL, '2025-10-16 15:09:46', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:12:32', NULL, NULL, '192.168.1.100'),
(25129, NULL, 30.70, 88.40, 32.000, NULL, '2025-10-16 15:09:48', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:12:32', NULL, NULL, '192.168.1.100'),
(25130, NULL, 30.70, 88.40, 32.000, NULL, '2025-10-16 15:09:50', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:12:32', NULL, NULL, '192.168.1.100'),
(25131, NULL, 30.80, 88.30, 32.000, NULL, '2025-10-16 15:09:53', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:12:32', NULL, NULL, '192.168.1.100'),
(25132, NULL, 30.80, 88.30, 32.000, NULL, '2025-10-16 15:09:55', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:12:32', NULL, NULL, '192.168.1.100'),
(25133, NULL, 30.80, 88.30, 32.000, NULL, '2025-10-16 15:09:57', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:12:32', NULL, NULL, '192.168.1.100'),
(25134, NULL, 30.80, 88.30, 32.000, NULL, '2025-10-16 15:09:59', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:12:32', NULL, NULL, '192.168.1.100'),
(25135, NULL, 30.80, 88.30, 32.000, NULL, '2025-10-16 15:10:01', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:12:32', NULL, NULL, '192.168.1.100'),
(25136, NULL, 30.80, 88.30, 32.000, NULL, '2025-10-16 15:10:09', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:12:32', NULL, NULL, '192.168.1.100'),
(25137, NULL, 30.80, 88.10, 32.000, NULL, '2025-10-16 15:10:13', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:12:32', NULL, NULL, '192.168.1.100'),
(25138, NULL, 30.80, 88.00, 32.000, NULL, '2025-10-16 15:10:15', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:12:32', NULL, NULL, '192.168.1.100'),
(25139, NULL, 30.70, 88.10, 31.000, NULL, '2025-10-16 15:10:21', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:12:32', NULL, NULL, '192.168.1.100'),
(25140, NULL, 30.80, 88.10, 31.000, NULL, '2025-10-16 15:10:23', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:12:32', NULL, NULL, '192.168.1.100'),
(25141, NULL, 30.70, 88.10, 31.000, NULL, '2025-10-16 15:10:26', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:12:32', NULL, NULL, '192.168.1.100'),
(25142, NULL, 30.80, 87.60, 31.000, NULL, '2025-10-16 15:10:29', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:12:32', NULL, NULL, '192.168.1.100'),
(25143, NULL, 30.80, 86.70, 31.000, NULL, '2025-10-16 15:10:34', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:12:32', NULL, NULL, '192.168.1.100'),
(25144, NULL, 30.80, 87.10, 31.000, NULL, '2025-10-16 15:10:41', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:12:32', NULL, NULL, '192.168.1.100'),
(25145, NULL, 30.80, 86.80, 31.000, NULL, '2025-10-16 15:10:46', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:12:32', NULL, NULL, '192.168.1.100'),
(25146, NULL, 30.80, 86.10, 32.000, NULL, '2025-10-16 15:10:49', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:12:32', NULL, NULL, '192.168.1.100'),
(25147, NULL, 30.80, 86.00, 31.000, NULL, '2025-10-16 15:10:54', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:12:32', NULL, NULL, '192.168.1.100'),
(25148, NULL, 30.70, 85.90, 31.000, NULL, '2025-10-16 15:11:01', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:12:32', NULL, NULL, '192.168.1.100'),
(25149, NULL, 30.70, 85.90, 32.000, NULL, '2025-10-16 15:11:03', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:12:32', NULL, NULL, '192.168.1.100'),
(25150, NULL, 30.70, 85.40, 32.000, NULL, '2025-10-16 15:11:05', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:12:32', NULL, NULL, '192.168.1.100'),
(25151, NULL, 30.70, 85.60, 32.000, NULL, '2025-10-16 15:11:08', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:12:32', NULL, NULL, '192.168.1.100'),
(25152, NULL, 30.70, 85.60, 32.000, NULL, '2025-10-16 15:11:10', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:12:32', NULL, NULL, '192.168.1.100'),
(25153, NULL, 30.70, 85.70, 32.000, NULL, '2025-10-16 15:11:15', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:12:32', NULL, NULL, '192.168.1.100'),
(25154, NULL, 30.70, 85.80, 32.000, NULL, '2025-10-16 15:11:17', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:12:32', NULL, NULL, '192.168.1.100'),
(25155, NULL, 30.70, 85.80, 32.000, NULL, '2025-10-16 15:11:19', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:12:32', NULL, NULL, '192.168.1.100'),
(25156, NULL, 30.70, 85.70, 32.000, NULL, '2025-10-16 15:11:20', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:12:32', NULL, NULL, '192.168.1.100'),
(25157, NULL, 30.70, 85.70, 32.000, NULL, '2025-10-16 15:11:22', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:12:32', NULL, NULL, '192.168.1.100'),
(25158, NULL, 30.70, 85.70, 32.000, NULL, '2025-10-16 15:11:27', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:12:32', NULL, NULL, '192.168.1.100'),
(25159, NULL, 30.70, 85.70, 32.000, NULL, '2025-10-16 15:11:28', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:12:32', NULL, NULL, '192.168.1.100');
INSERT INTO `raw_sensor_data` (`id`, `device_id`, `temperature`, `humidity`, `ammonia`, `thermal_temp`, `timestamp`, `water_sprinkler`, `sprinkler_trigger`, `heat`, `mode`, `offline_sync`, `source`, `data_quality`, `created_at`, `pump_temp`, `pump_trigger`, `device_ip`) VALUES
(25160, NULL, 30.70, 85.70, 32.000, NULL, '2025-10-16 15:11:30', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:12:32', NULL, NULL, '192.168.1.100'),
(25161, NULL, 30.70, 85.80, 32.000, NULL, '2025-10-16 15:11:35', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:12:32', NULL, NULL, '192.168.1.100'),
(25162, NULL, 30.70, 87.00, 32.000, NULL, '2025-10-16 15:11:38', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:12:32', NULL, NULL, '192.168.1.100'),
(25163, NULL, 30.70, 87.20, 32.000, NULL, '2025-10-16 15:11:41', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:12:32', NULL, NULL, '192.168.1.100'),
(25164, NULL, 30.70, 87.00, 32.000, NULL, '2025-10-16 15:11:43', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:12:32', NULL, NULL, '192.168.1.100'),
(25165, NULL, 30.70, 87.10, 32.000, NULL, '2025-10-16 15:11:46', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:12:32', NULL, NULL, '192.168.1.100'),
(25166, NULL, 30.70, 87.00, 31.000, NULL, '2025-10-16 15:11:50', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:12:32', NULL, NULL, '192.168.1.100'),
(25167, NULL, 30.70, 87.00, 31.000, NULL, '2025-10-16 15:11:52', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:12:32', NULL, NULL, '192.168.1.100'),
(25168, NULL, 30.70, 86.80, 31.000, NULL, '2025-10-16 15:11:54', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:12:32', NULL, NULL, '192.168.1.100'),
(25169, NULL, 30.70, 86.50, 32.000, NULL, '2025-10-16 15:11:56', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:12:32', NULL, NULL, '192.168.1.100'),
(25170, NULL, 30.70, 86.50, 32.000, NULL, '2025-10-16 15:11:57', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:12:32', NULL, NULL, '192.168.1.100'),
(25171, NULL, 30.70, 85.90, 32.000, NULL, '2025-10-16 15:12:05', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:12:32', NULL, NULL, '192.168.1.100'),
(25172, NULL, 30.70, 84.60, 32.000, NULL, '2025-10-16 15:12:08', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:12:32', NULL, NULL, '192.168.1.100'),
(25173, NULL, 30.70, 84.30, 32.000, NULL, '2025-10-16 15:12:11', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:12:32', NULL, NULL, '192.168.1.100'),
(25174, NULL, 30.70, 85.30, 32.000, NULL, '2025-10-16 15:12:21', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:12:32', NULL, NULL, '192.168.1.100'),
(25175, NULL, 30.70, 85.30, 32.000, NULL, '2025-10-16 15:12:23', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:12:32', NULL, NULL, '192.168.1.100'),
(25176, NULL, 30.70, 85.70, 32.000, NULL, '2025-10-16 15:12:25', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:12:32', NULL, NULL, '192.168.1.100'),
(25177, NULL, 30.70, 86.00, 32.000, NULL, '2025-10-16 15:12:29', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:12:32', NULL, NULL, '192.168.1.100'),
(25178, NULL, 30.70, 86.30, 32.000, NULL, '2025-10-16 15:12:31', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:32', NULL, NULL, '192.168.1.100'),
(25179, NULL, 30.70, 86.40, 32.000, NULL, '2025-10-16 15:12:33', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:32', NULL, NULL, '192.168.1.100'),
(25180, NULL, 30.70, 86.40, 32.000, NULL, '2025-10-16 15:12:35', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:32', NULL, NULL, '192.168.1.100'),
(25181, NULL, 30.70, 86.60, 32.000, NULL, '2025-10-16 15:12:37', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:32', NULL, NULL, '192.168.1.100'),
(25182, NULL, 30.70, 86.60, 32.000, NULL, '2025-10-16 15:12:38', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:32', NULL, NULL, '192.168.1.100'),
(25183, NULL, 30.70, 86.70, 32.000, NULL, '2025-10-16 15:12:40', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:32', NULL, NULL, '192.168.1.100'),
(25184, NULL, 30.70, 86.80, 32.000, NULL, '2025-10-16 15:12:42', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:32', NULL, NULL, '192.168.1.100'),
(25185, NULL, 30.70, 86.90, 32.000, NULL, '2025-10-16 15:12:46', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:32', NULL, NULL, '192.168.1.100'),
(25186, NULL, 30.70, 86.10, 32.000, NULL, '2025-10-16 15:13:14', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:32', NULL, NULL, '192.168.1.100'),
(25187, NULL, 30.70, 86.10, 32.000, NULL, '2025-10-16 15:13:16', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:32', NULL, NULL, '192.168.1.100'),
(25188, NULL, 30.70, 86.10, 32.000, NULL, '2025-10-16 15:13:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:32', NULL, NULL, '192.168.1.100'),
(25189, NULL, 30.70, 86.00, 32.000, NULL, '2025-10-16 15:13:20', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:32', NULL, NULL, '192.168.1.100'),
(25190, NULL, 30.70, 86.00, 32.000, NULL, '2025-10-16 15:13:23', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:32', NULL, NULL, '192.168.1.100'),
(25191, NULL, 30.70, 86.00, 32.000, NULL, '2025-10-16 15:13:26', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:32', NULL, NULL, '192.168.1.100'),
(25192, NULL, 30.70, 86.00, 32.000, NULL, '2025-10-16 15:13:28', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:32', NULL, NULL, '192.168.1.100'),
(25193, NULL, 30.70, 85.90, 32.000, NULL, '2025-10-16 15:13:30', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:32', NULL, NULL, '192.168.1.100'),
(25194, NULL, 30.70, 85.90, 33.000, NULL, '2025-10-16 15:13:32', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:32', NULL, NULL, '192.168.1.100'),
(25195, NULL, 30.70, 85.70, 33.000, NULL, '2025-10-16 15:13:34', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:32', NULL, NULL, '192.168.1.100'),
(25196, NULL, 30.70, 85.90, 32.000, NULL, '2025-10-16 15:13:36', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:32', NULL, NULL, '192.168.1.100'),
(25197, NULL, 30.70, 86.10, 32.000, NULL, '2025-10-16 15:13:39', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:32', NULL, NULL, '192.168.1.100'),
(25198, NULL, 30.70, 86.20, 32.000, NULL, '2025-10-16 15:13:41', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:32', NULL, NULL, '192.168.1.100'),
(25199, NULL, 30.70, 86.10, 33.000, NULL, '2025-10-16 15:13:45', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:32', NULL, NULL, '192.168.1.100'),
(25200, NULL, 30.70, 86.10, 32.000, NULL, '2025-10-16 15:13:47', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:32', NULL, NULL, '192.168.1.100'),
(25201, NULL, 30.70, 85.80, 32.000, NULL, '2025-10-16 15:13:51', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:32', NULL, NULL, '192.168.1.100'),
(25202, NULL, 30.70, 86.80, 32.000, NULL, '2025-10-16 15:14:08', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:32', NULL, NULL, '192.168.1.100'),
(25203, NULL, 30.70, 87.20, 32.000, NULL, '2025-10-16 15:14:11', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:32', NULL, NULL, '192.168.1.100'),
(25204, NULL, 30.70, 86.90, 32.000, NULL, '2025-10-16 15:14:14', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:32', NULL, NULL, '192.168.1.100'),
(25205, NULL, 30.70, 86.70, 32.000, NULL, '2025-10-16 15:14:26', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:32', NULL, NULL, '192.168.1.100'),
(25206, NULL, 30.70, 87.00, 32.000, NULL, '2025-10-16 15:14:31', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:32', NULL, NULL, '192.168.1.100'),
(25207, NULL, 30.70, 87.10, 32.000, NULL, '2025-10-16 15:14:33', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:32', NULL, NULL, '192.168.1.100'),
(25208, NULL, 30.70, 87.10, 32.000, NULL, '2025-10-16 15:14:39', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:32', NULL, NULL, '192.168.1.100'),
(25209, NULL, 30.70, 87.40, 32.000, NULL, '2025-10-16 15:14:55', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:32', NULL, NULL, '192.168.1.100'),
(25210, NULL, 30.70, 86.50, 32.000, NULL, '2025-10-16 15:14:58', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:32', NULL, NULL, '192.168.1.100'),
(25211, NULL, 30.70, 86.50, 32.000, NULL, '2025-10-16 15:15:00', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:32', NULL, NULL, '192.168.1.100'),
(25212, NULL, 30.70, 86.30, 32.000, NULL, '2025-10-16 15:15:01', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:32', NULL, NULL, '192.168.1.100'),
(25213, NULL, 30.70, 86.30, 32.000, NULL, '2025-10-16 15:15:04', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:32', NULL, NULL, '192.168.1.100'),
(25214, NULL, 30.70, 86.10, 32.000, NULL, '2025-10-16 15:15:08', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:32', NULL, NULL, '192.168.1.100'),
(25215, NULL, 30.70, 86.00, 32.000, NULL, '2025-10-16 15:15:10', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:32', NULL, NULL, '192.168.1.100'),
(25216, NULL, 30.70, 86.00, 32.000, NULL, '2025-10-16 15:15:12', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:32', NULL, NULL, '192.168.1.100'),
(25217, NULL, 30.70, 86.00, 32.000, NULL, '2025-10-16 15:15:13', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:32', NULL, NULL, '192.168.1.100'),
(25218, NULL, 30.70, 86.00, 32.000, NULL, '2025-10-16 15:15:15', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:33', NULL, NULL, '192.168.1.100'),
(25219, NULL, 30.70, 86.20, 32.000, NULL, '2025-10-16 15:15:17', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:33', NULL, NULL, '192.168.1.100'),
(25220, NULL, 30.70, 86.40, 32.000, NULL, '2025-10-16 15:15:24', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:33', NULL, NULL, '192.168.1.100'),
(25221, NULL, 30.70, 86.40, 32.000, NULL, '2025-10-16 15:15:25', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:33', NULL, NULL, '192.168.1.100'),
(25222, NULL, 30.70, 86.40, 32.000, NULL, '2025-10-16 15:15:27', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:33', NULL, NULL, '192.168.1.100'),
(25223, NULL, 30.70, 85.90, 32.000, NULL, '2025-10-16 15:15:30', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:33', NULL, NULL, '192.168.1.100'),
(25224, NULL, 30.70, 85.70, 32.000, NULL, '2025-10-16 15:15:32', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:33', NULL, NULL, '192.168.1.100'),
(25225, NULL, 30.70, 85.70, 32.000, NULL, '2025-10-16 15:15:34', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:33', NULL, NULL, '192.168.1.100'),
(25226, NULL, 30.70, 85.90, 32.000, NULL, '2025-10-16 15:15:36', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:33', NULL, NULL, '192.168.1.100'),
(25227, NULL, 30.70, 85.90, 32.000, NULL, '2025-10-16 15:15:38', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:33', NULL, NULL, '192.168.1.100'),
(25228, NULL, 30.70, 85.90, 32.000, NULL, '2025-10-16 15:15:40', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:33', NULL, NULL, '192.168.1.100'),
(25229, NULL, 30.70, 85.90, 32.000, NULL, '2025-10-16 15:15:41', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:33', NULL, NULL, '192.168.1.100'),
(25230, NULL, 30.70, 85.90, 32.000, NULL, '2025-10-16 15:15:43', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:33', NULL, NULL, '192.168.1.100'),
(25231, NULL, 30.70, 85.80, 32.000, NULL, '2025-10-16 15:15:45', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:33', NULL, NULL, '192.168.1.100'),
(25232, NULL, 30.70, 85.90, 32.000, NULL, '2025-10-16 15:15:48', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:33', NULL, NULL, '192.168.1.100'),
(25233, NULL, 30.70, 85.90, 32.000, NULL, '2025-10-16 15:15:50', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:33', NULL, NULL, '192.168.1.100'),
(25234, NULL, 30.70, 86.10, 32.000, NULL, '2025-10-16 15:15:52', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:33', NULL, NULL, '192.168.1.100'),
(25235, NULL, 30.70, 86.10, 32.000, NULL, '2025-10-16 15:15:53', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:33', NULL, NULL, '192.168.1.100'),
(25236, NULL, 30.70, 86.10, 32.000, NULL, '2025-10-16 15:15:55', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:33', NULL, NULL, '192.168.1.100'),
(25237, NULL, 30.70, 86.10, 32.000, NULL, '2025-10-16 15:15:57', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:33', NULL, NULL, '192.168.1.100'),
(25238, NULL, 30.70, 86.10, 32.000, NULL, '2025-10-16 15:16:00', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:33', NULL, NULL, '192.168.1.100'),
(25239, NULL, 30.70, 85.80, 32.000, NULL, '2025-10-16 15:16:03', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:33', NULL, NULL, '192.168.1.100'),
(25240, NULL, 30.70, 85.80, 32.000, NULL, '2025-10-16 15:16:05', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:33', NULL, NULL, '192.168.1.100'),
(25241, NULL, 30.70, 85.70, 32.000, NULL, '2025-10-16 15:16:07', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:33', NULL, NULL, '192.168.1.100'),
(25242, NULL, 30.70, 85.70, 32.000, NULL, '2025-10-16 15:16:09', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:33', NULL, NULL, '192.168.1.100'),
(25243, NULL, 30.70, 85.90, 32.000, NULL, '2025-10-16 15:16:11', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:33', NULL, NULL, '192.168.1.100'),
(25244, NULL, 30.70, 85.90, 32.000, NULL, '2025-10-16 15:16:13', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:33', NULL, NULL, '192.168.1.100'),
(25245, NULL, 30.70, 85.90, 32.000, NULL, '2025-10-16 15:16:15', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:33', NULL, NULL, '192.168.1.100'),
(25246, NULL, 30.70, 86.00, 32.000, NULL, '2025-10-16 15:16:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:33', NULL, NULL, '192.168.1.100'),
(25247, NULL, 30.70, 86.10, 32.000, NULL, '2025-10-16 15:16:20', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:33', NULL, NULL, '192.168.1.100'),
(25248, NULL, 30.70, 86.10, 32.000, NULL, '2025-10-16 15:16:24', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:33', NULL, NULL, '192.168.1.100'),
(25249, NULL, 30.70, 86.10, 32.000, NULL, '2025-10-16 15:16:26', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:33', NULL, NULL, '192.168.1.100'),
(25250, NULL, 30.70, 86.00, 32.000, NULL, '2025-10-16 15:16:28', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:33', NULL, NULL, '192.168.1.100'),
(25251, NULL, 30.70, 86.00, 32.000, NULL, '2025-10-16 15:16:29', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:33', NULL, NULL, '192.168.1.100'),
(25252, NULL, 30.70, 86.10, 32.000, NULL, '2025-10-16 15:16:31', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:33', NULL, NULL, '192.168.1.100'),
(25253, NULL, 30.70, 86.10, 32.000, NULL, '2025-10-16 15:16:33', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:33', NULL, NULL, '192.168.1.100'),
(25254, NULL, 30.70, 86.00, 32.000, NULL, '2025-10-16 15:16:37', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:33', NULL, NULL, '192.168.1.100'),
(25255, NULL, 30.70, 86.10, 32.000, NULL, '2025-10-16 15:16:40', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:33', NULL, NULL, '192.168.1.100'),
(25256, NULL, 30.70, 86.10, 32.000, NULL, '2025-10-16 15:16:41', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:33', NULL, NULL, '192.168.1.100'),
(25257, NULL, 30.70, 86.10, 32.000, NULL, '2025-10-16 15:16:43', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:33', NULL, NULL, '192.168.1.100'),
(25258, NULL, 30.70, 86.10, 32.000, NULL, '2025-10-16 15:16:45', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:33', NULL, NULL, '192.168.1.100'),
(25259, NULL, 30.70, 86.20, 32.000, NULL, '2025-10-16 15:16:47', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:33', NULL, NULL, '192.168.1.100'),
(25260, NULL, 30.70, 86.20, 32.000, NULL, '2025-10-16 15:16:49', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:33', NULL, NULL, '192.168.1.100'),
(25261, NULL, 30.70, 86.20, 32.000, NULL, '2025-10-16 15:16:51', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:33', NULL, NULL, '192.168.1.100'),
(25262, NULL, 30.70, 86.50, 32.000, NULL, '2025-10-16 15:16:52', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:33', NULL, NULL, '192.168.1.100'),
(25263, NULL, 30.70, 86.30, 32.000, NULL, '2025-10-16 15:16:55', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:33', NULL, NULL, '192.168.1.100'),
(25264, NULL, 30.70, 86.30, 32.000, NULL, '2025-10-16 15:16:56', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:33', NULL, NULL, '192.168.1.100'),
(25265, NULL, 30.70, 86.10, 32.000, NULL, '2025-10-16 15:16:58', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:33', NULL, NULL, '192.168.1.100'),
(25266, NULL, 30.70, 86.10, 32.000, NULL, '2025-10-16 15:17:01', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:33', NULL, NULL, '192.168.1.100'),
(25267, NULL, 30.70, 86.30, 32.000, NULL, '2025-10-16 15:17:03', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:33', NULL, NULL, '192.168.1.100'),
(25268, NULL, 30.70, 86.30, 32.000, NULL, '2025-10-16 15:17:05', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:33', NULL, NULL, '192.168.1.100'),
(25269, NULL, 30.70, 86.30, 32.000, NULL, '2025-10-16 15:17:08', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:33', NULL, NULL, '192.168.1.100'),
(25270, NULL, 30.70, 86.30, 32.000, NULL, '2025-10-16 15:17:10', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:33', NULL, NULL, '192.168.1.100'),
(25271, NULL, 30.70, 86.40, 32.000, NULL, '2025-10-16 15:17:12', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:33', NULL, NULL, '192.168.1.100'),
(25272, NULL, 30.70, 86.40, 32.000, NULL, '2025-10-16 15:17:14', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:33', NULL, NULL, '192.168.1.100'),
(25273, NULL, 30.70, 86.40, 32.000, NULL, '2025-10-16 15:17:16', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:33', NULL, NULL, '192.168.1.100'),
(25274, NULL, 30.70, 86.30, 32.000, NULL, '2025-10-16 15:17:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:33', NULL, NULL, '192.168.1.100'),
(25275, NULL, 30.70, 86.30, 32.000, NULL, '2025-10-16 15:17:20', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:33', NULL, NULL, '192.168.1.100'),
(25276, NULL, 30.70, 86.40, 32.000, NULL, '2025-10-16 15:17:24', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:33', NULL, NULL, '192.168.1.100'),
(25277, NULL, 30.70, 86.90, 32.000, NULL, '2025-10-16 15:17:26', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:33', NULL, NULL, '192.168.1.100'),
(25278, NULL, 30.70, 86.90, 32.000, NULL, '2025-10-16 15:17:28', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:17:33', NULL, NULL, '192.168.1.100'),
(25279, NULL, 30.70, 87.00, 32.000, NULL, '2025-10-16 15:17:30', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:22:38', NULL, NULL, '192.168.1.100'),
(25280, NULL, 30.70, 87.00, 32.000, NULL, '2025-10-16 15:17:32', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:22:38', NULL, NULL, '192.168.1.100'),
(25281, NULL, 30.70, 87.30, 32.000, NULL, '2025-10-16 15:17:34', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:22:38', NULL, NULL, '192.168.1.100'),
(25282, NULL, 30.70, 87.60, 32.000, NULL, '2025-10-16 15:17:37', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:22:38', NULL, NULL, '192.168.1.100'),
(25283, NULL, 30.70, 87.70, 32.000, NULL, '2025-10-16 15:17:40', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:22:38', NULL, NULL, '192.168.1.100'),
(25284, NULL, 30.70, 87.70, 32.000, NULL, '2025-10-16 15:17:42', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:22:38', NULL, NULL, '192.168.1.100'),
(25285, NULL, 30.70, 87.90, 32.000, NULL, '2025-10-16 15:17:44', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:22:38', NULL, NULL, '192.168.1.100'),
(25286, NULL, 30.70, 87.60, 32.000, NULL, '2025-10-16 15:17:46', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:22:38', NULL, NULL, '192.168.1.100'),
(25287, NULL, 30.70, 87.00, 32.000, NULL, '2025-10-16 15:17:49', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:22:38', NULL, NULL, '192.168.1.100'),
(25288, NULL, 30.70, 86.30, 32.000, NULL, '2025-10-16 15:17:51', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:22:38', NULL, NULL, '192.168.1.100'),
(25289, NULL, 30.70, 86.20, 32.000, NULL, '2025-10-16 15:17:53', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:22:38', NULL, NULL, '192.168.1.100'),
(25290, NULL, 30.70, 86.20, 32.000, NULL, '2025-10-16 15:17:54', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:22:38', NULL, NULL, '192.168.1.100'),
(25291, NULL, 30.70, 86.20, 32.000, NULL, '2025-10-16 15:17:56', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:22:38', NULL, NULL, '192.168.1.100'),
(25292, NULL, 30.70, 86.30, 32.000, NULL, '2025-10-16 15:17:58', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:22:38', NULL, NULL, '192.168.1.100'),
(25293, NULL, 30.70, 86.40, 32.000, NULL, '2025-10-16 15:18:01', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:22:38', NULL, NULL, '192.168.1.100'),
(25294, NULL, 30.70, 86.40, 32.000, NULL, '2025-10-16 15:18:02', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:22:38', NULL, NULL, '192.168.1.100'),
(25295, NULL, 30.70, 86.40, 32.000, NULL, '2025-10-16 15:18:04', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:22:38', NULL, NULL, '192.168.1.100'),
(25296, NULL, 30.70, 86.50, 32.000, NULL, '2025-10-16 15:18:06', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:22:38', NULL, NULL, '192.168.1.100'),
(25297, NULL, 30.70, 86.50, 32.000, NULL, '2025-10-16 15:18:08', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:22:38', NULL, NULL, '192.168.1.100'),
(25298, NULL, 30.70, 86.70, 32.000, NULL, '2025-10-16 15:18:10', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:22:38', NULL, NULL, '192.168.1.100'),
(25299, NULL, 30.70, 86.70, 32.000, NULL, '2025-10-16 15:18:13', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:22:38', NULL, NULL, '192.168.1.100'),
(25300, NULL, 30.70, 86.80, 32.000, NULL, '2025-10-16 15:18:37', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:22:38', NULL, NULL, '192.168.1.100'),
(25301, NULL, 30.70, 86.80, 32.000, NULL, '2025-10-16 15:18:39', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:22:38', NULL, NULL, '192.168.1.100'),
(25302, NULL, 30.70, 86.80, 32.000, NULL, '2025-10-16 15:18:41', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:22:38', NULL, NULL, '192.168.1.100'),
(25303, NULL, 30.70, 86.70, 32.000, NULL, '2025-10-16 15:18:44', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:22:38', NULL, NULL, '192.168.1.100'),
(25304, NULL, 30.70, 86.80, 32.000, NULL, '2025-10-16 15:18:46', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:22:38', NULL, NULL, '192.168.1.100'),
(25305, NULL, 30.70, 86.90, 32.000, NULL, '2025-10-16 15:18:50', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:22:38', NULL, NULL, '192.168.1.100'),
(25306, NULL, 30.70, 87.00, 32.000, NULL, '2025-10-16 15:18:53', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:22:38', NULL, NULL, '192.168.1.100'),
(25307, NULL, 30.70, 87.20, 32.000, NULL, '2025-10-16 15:18:56', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:22:38', NULL, NULL, '192.168.1.100'),
(25308, NULL, 30.70, 87.20, 32.000, NULL, '2025-10-16 15:18:58', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:22:38', NULL, NULL, '192.168.1.100'),
(25309, NULL, 30.70, 87.30, 32.000, NULL, '2025-10-16 15:19:00', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:22:38', NULL, NULL, '192.168.1.100'),
(25310, NULL, 30.70, 87.30, 32.000, NULL, '2025-10-16 15:19:03', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:22:38', NULL, NULL, '192.168.1.100'),
(25311, NULL, 30.70, 87.20, 32.000, NULL, '2025-10-16 15:19:06', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:22:38', NULL, NULL, '192.168.1.100'),
(25312, NULL, 30.70, 87.20, 32.000, NULL, '2025-10-16 15:19:08', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:22:38', NULL, NULL, '192.168.1.100'),
(25313, NULL, 30.70, 87.20, 32.000, NULL, '2025-10-16 15:19:11', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:22:38', NULL, NULL, '192.168.1.100'),
(25314, NULL, 30.70, 87.40, 32.000, NULL, '2025-10-16 15:19:13', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:22:38', NULL, NULL, '192.168.1.100'),
(25315, NULL, 30.70, 87.50, 32.000, NULL, '2025-10-16 15:19:16', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:22:38', NULL, NULL, '192.168.1.100'),
(25316, NULL, 30.70, 87.50, 32.000, NULL, '2025-10-16 15:19:20', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:22:38', NULL, NULL, '192.168.1.100'),
(25317, NULL, 30.70, 87.70, 32.000, NULL, '2025-10-16 15:19:22', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:22:38', NULL, NULL, '192.168.1.100'),
(25318, NULL, 30.70, 87.70, 31.000, NULL, '2025-10-16 15:19:25', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:22:38', NULL, NULL, '192.168.1.100'),
(25319, NULL, 30.70, 87.80, 32.000, NULL, '2025-10-16 15:19:28', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:22:38', NULL, NULL, '192.168.1.100'),
(25320, NULL, 30.70, 87.90, 31.000, NULL, '2025-10-16 15:19:30', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:22:38', NULL, NULL, '192.168.1.100'),
(25321, NULL, 30.70, 87.90, 31.000, NULL, '2025-10-16 15:19:33', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:22:38', NULL, NULL, '192.168.1.100'),
(25322, NULL, 30.70, 87.80, 31.000, NULL, '2025-10-16 15:19:35', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:22:38', NULL, NULL, '192.168.1.100'),
(25323, NULL, 30.70, 87.30, 32.000, NULL, '2025-10-16 15:19:37', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:22:38', NULL, NULL, '192.168.1.100'),
(25324, NULL, 30.70, 87.00, 31.000, NULL, '2025-10-16 15:19:40', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:22:38', NULL, NULL, '192.168.1.100'),
(25325, NULL, 30.70, 87.10, 31.000, NULL, '2025-10-16 15:19:42', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:22:38', NULL, NULL, '192.168.1.100'),
(25326, NULL, 30.70, 87.60, 31.000, NULL, '2025-10-16 15:19:45', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:22:38', NULL, NULL, '192.168.1.100'),
(25327, NULL, 30.70, 87.80, 31.000, NULL, '2025-10-16 15:19:47', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:22:38', NULL, NULL, '192.168.1.100'),
(25328, NULL, 30.70, 87.90, 31.000, NULL, '2025-10-16 15:19:49', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:22:38', NULL, NULL, '192.168.1.100'),
(25329, NULL, 30.70, 88.00, 31.000, NULL, '2025-10-16 15:19:55', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:22:38', NULL, NULL, '192.168.1.100'),
(25330, NULL, 30.70, 87.70, 31.000, NULL, '2025-10-16 15:19:57', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:22:38', NULL, NULL, '192.168.1.100'),
(25331, NULL, 30.80, 87.70, 31.000, NULL, '2025-10-16 15:19:59', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:22:38', NULL, NULL, '192.168.1.100'),
(25332, NULL, 30.80, 87.70, 31.000, NULL, '2025-10-16 15:20:02', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:22:38', NULL, NULL, '192.168.1.100'),
(25333, NULL, 30.70, 87.70, 31.000, NULL, '2025-10-16 15:20:04', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:22:38', NULL, NULL, '192.168.1.100'),
(25334, NULL, 30.80, 87.70, 31.000, NULL, '2025-10-16 15:20:06', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:22:38', NULL, NULL, '192.168.1.100'),
(25335, NULL, 30.80, 87.70, 31.000, NULL, '2025-10-16 15:20:08', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:22:38', NULL, NULL, '192.168.1.100'),
(25336, NULL, 30.80, 87.70, 31.000, NULL, '2025-10-16 15:20:10', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:22:38', NULL, NULL, '192.168.1.100'),
(25337, NULL, 30.80, 87.90, 31.000, NULL, '2025-10-16 15:20:12', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:22:38', NULL, NULL, '192.168.1.100'),
(25338, NULL, 30.80, 87.90, 31.000, NULL, '2025-10-16 15:20:15', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:22:38', NULL, NULL, '192.168.1.100'),
(25339, NULL, 30.70, 88.00, 31.000, NULL, '2025-10-16 15:20:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:22:38', NULL, NULL, '192.168.1.100'),
(25340, NULL, 30.80, 88.00, 31.000, NULL, '2025-10-16 15:20:21', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:22:38', NULL, NULL, '192.168.1.100'),
(25341, NULL, 30.80, 88.20, 31.000, NULL, '2025-10-16 15:20:25', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:22:38', NULL, NULL, '192.168.1.100'),
(25342, NULL, 30.80, 88.20, 31.000, NULL, '2025-10-16 15:20:27', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:22:38', NULL, NULL, '192.168.1.100'),
(25343, NULL, 30.80, 88.20, 31.000, NULL, '2025-10-16 15:20:30', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:22:38', NULL, NULL, '192.168.1.100'),
(25344, NULL, 30.80, 88.20, 31.000, NULL, '2025-10-16 15:20:32', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:22:38', NULL, NULL, '192.168.1.100'),
(25345, NULL, 30.80, 88.00, 31.000, NULL, '2025-10-16 15:20:33', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:22:38', NULL, NULL, '192.168.1.100'),
(25346, NULL, 30.60, 87.90, 32.000, NULL, '2025-10-16 15:22:36', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:22:38', NULL, NULL, '192.168.1.100'),
(25347, NULL, 30.60, 87.90, 32.000, NULL, '2025-10-16 15:22:38', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:39:07', NULL, NULL, '192.168.1.100'),
(25348, NULL, 30.70, 87.90, 32.000, NULL, '2025-10-16 15:22:40', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:39:07', NULL, NULL, '192.168.1.100'),
(25349, NULL, 30.70, 87.90, 32.000, NULL, '2025-10-16 15:22:42', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:39:07', NULL, NULL, '192.168.1.100'),
(25350, NULL, 30.70, 87.90, 32.000, NULL, '2025-10-16 15:22:44', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:39:07', NULL, NULL, '192.168.1.100'),
(25351, NULL, 30.70, 88.00, 32.000, NULL, '2025-10-16 15:22:46', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:39:07', NULL, NULL, '192.168.1.100'),
(25352, NULL, 30.70, 88.10, 32.000, NULL, '2025-10-16 15:22:48', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:39:07', NULL, NULL, '192.168.1.100'),
(25353, NULL, 30.70, 88.10, 32.000, NULL, '2025-10-16 15:22:50', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:39:07', NULL, NULL, '192.168.1.100'),
(25354, NULL, 30.70, 88.20, 32.000, NULL, '2025-10-16 15:22:52', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:39:07', NULL, NULL, '192.168.1.100'),
(25355, NULL, 30.70, 88.20, 32.000, NULL, '2025-10-16 15:22:56', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:39:07', NULL, NULL, '192.168.1.100'),
(25356, NULL, 30.70, 88.20, 31.000, NULL, '2025-10-16 15:22:58', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:39:07', NULL, NULL, '192.168.1.100'),
(25357, NULL, 30.70, 88.10, 31.000, NULL, '2025-10-16 15:23:01', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:39:07', NULL, NULL, '192.168.1.100'),
(25358, NULL, 30.70, 88.10, 31.000, NULL, '2025-10-16 15:23:03', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:39:07', NULL, NULL, '192.168.1.100'),
(25359, NULL, 30.20, 90.60, 35.000, NULL, '2025-10-16 15:39:07', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:39:07', NULL, NULL, '192.168.1.100'),
(25360, NULL, 30.20, 90.60, 35.000, NULL, '2025-10-16 15:44:07', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:44:07', NULL, NULL, '192.168.1.100'),
(25361, NULL, 30.20, 86.60, 36.000, NULL, '2025-10-16 15:39:45', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:44:07', NULL, NULL, '192.168.1.100'),
(25362, NULL, 30.20, 87.00, 36.000, NULL, '2025-10-16 15:39:49', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:44:07', NULL, NULL, '192.168.1.100'),
(25363, NULL, 30.20, 87.80, 36.000, NULL, '2025-10-16 15:40:04', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:44:07', NULL, NULL, '192.168.1.100'),
(25364, NULL, 30.20, 87.20, 37.000, NULL, '2025-10-16 15:40:08', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:44:07', NULL, NULL, '192.168.1.100'),
(25365, NULL, 30.20, 86.90, 37.000, NULL, '2025-10-16 15:40:10', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:44:07', NULL, NULL, '192.168.1.100'),
(25366, NULL, 30.20, 86.90, 37.000, NULL, '2025-10-16 15:40:12', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:44:07', NULL, NULL, '192.168.1.100'),
(25367, NULL, 30.20, 87.00, 37.000, NULL, '2025-10-16 15:40:16', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:44:07', NULL, NULL, '192.168.1.100'),
(25368, NULL, 30.20, 87.10, 37.000, NULL, '2025-10-16 15:40:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:44:07', NULL, NULL, '192.168.1.100'),
(25369, NULL, 30.20, 87.10, 37.000, NULL, '2025-10-16 15:40:20', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:44:07', NULL, NULL, '192.168.1.100'),
(25370, NULL, 30.20, 87.20, 37.000, NULL, '2025-10-16 15:40:22', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:44:07', NULL, NULL, '192.168.1.100'),
(25371, NULL, 30.20, 87.70, 37.000, NULL, '2025-10-16 15:40:25', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:44:07', NULL, NULL, '192.168.1.100'),
(25372, NULL, 30.20, 88.50, 38.000, NULL, '2025-10-16 15:40:45', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:44:07', NULL, NULL, '192.168.1.100'),
(25373, NULL, 30.20, 88.60, 38.000, NULL, '2025-10-16 15:40:48', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:44:07', NULL, NULL, '192.168.1.100'),
(25374, NULL, 30.20, 88.60, 38.000, NULL, '2025-10-16 15:40:50', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:44:07', NULL, NULL, '192.168.1.100'),
(25375, NULL, 30.20, 88.10, 38.000, NULL, '2025-10-16 15:40:52', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:44:07', NULL, NULL, '192.168.1.100'),
(25376, NULL, 30.20, 87.80, 38.000, NULL, '2025-10-16 15:40:54', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:44:07', NULL, NULL, '192.168.1.100'),
(25377, NULL, 30.30, 88.00, 38.000, NULL, '2025-10-16 15:40:57', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:44:07', NULL, NULL, '192.168.1.100'),
(25378, NULL, 30.30, 88.00, 38.000, NULL, '2025-10-16 15:40:59', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:44:07', NULL, NULL, '192.168.1.100'),
(25379, NULL, 30.20, 88.10, 38.000, NULL, '2025-10-16 15:41:01', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:44:07', NULL, NULL, '192.168.1.100'),
(25380, NULL, 30.30, 88.60, 38.000, NULL, '2025-10-16 15:41:03', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:44:07', NULL, NULL, '192.168.1.100'),
(25381, NULL, 30.30, 88.60, 38.000, NULL, '2025-10-16 15:41:05', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:44:07', NULL, NULL, '192.168.1.100'),
(25382, NULL, 30.30, 88.50, 38.000, NULL, '2025-10-16 15:41:09', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:44:07', NULL, NULL, '192.168.1.100'),
(25383, NULL, 30.30, 88.60, 0.000, NULL, '2025-10-16 15:41:11', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:44:07', NULL, NULL, '192.168.1.100'),
(25384, NULL, 30.30, 88.60, 0.000, NULL, '2025-10-16 15:41:13', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:44:07', NULL, NULL, '192.168.1.100'),
(25385, NULL, 30.30, 88.80, 0.000, NULL, '2025-10-16 15:41:16', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:44:07', NULL, NULL, '192.168.1.100'),
(25386, NULL, 30.30, 88.80, 38.000, NULL, '2025-10-16 15:41:17', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:44:07', NULL, NULL, '192.168.1.100'),
(25387, NULL, 30.30, 89.20, 38.000, NULL, '2025-10-16 15:41:20', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:44:07', NULL, NULL, '192.168.1.100'),
(25388, NULL, 30.30, 89.40, 38.000, NULL, '2025-10-16 15:41:25', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:44:07', NULL, NULL, '192.168.1.100'),
(25389, NULL, 30.30, 89.20, 38.000, NULL, '2025-10-16 15:41:28', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:44:07', NULL, NULL, '192.168.1.100'),
(25390, NULL, 30.30, 89.20, 38.000, NULL, '2025-10-16 15:41:30', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:44:07', NULL, NULL, '192.168.1.100'),
(25391, NULL, 30.30, 88.70, 38.000, NULL, '2025-10-16 15:41:36', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:44:07', NULL, NULL, '192.168.1.100'),
(25392, NULL, 30.30, 88.70, 38.000, NULL, '2025-10-16 15:41:38', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:44:07', NULL, NULL, '192.168.1.100'),
(25393, NULL, 30.30, 88.70, 38.000, NULL, '2025-10-16 15:41:40', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:44:07', NULL, NULL, '192.168.1.100'),
(25394, NULL, 30.30, 88.40, 38.000, NULL, '2025-10-16 15:41:42', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:44:07', NULL, NULL, '192.168.1.100'),
(25395, NULL, 30.30, 88.40, 38.000, NULL, '2025-10-16 15:41:44', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:44:07', NULL, NULL, '192.168.1.100'),
(25396, NULL, 30.30, 88.20, 38.000, NULL, '2025-10-16 15:41:49', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:44:07', NULL, NULL, '192.168.1.100'),
(25397, NULL, 30.30, 88.40, 38.000, NULL, '2025-10-16 15:41:51', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:44:07', NULL, NULL, '192.168.1.100'),
(25398, NULL, 30.30, 88.40, 38.000, NULL, '2025-10-16 15:41:55', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:44:07', NULL, NULL, '192.168.1.100'),
(25399, NULL, 30.30, 88.40, 38.000, NULL, '2025-10-16 15:41:57', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:44:07', NULL, NULL, '192.168.1.100'),
(25400, NULL, 30.30, 89.30, 37.000, NULL, '2025-10-16 15:41:59', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:44:07', NULL, NULL, '192.168.1.100'),
(25401, NULL, 30.30, 89.50, 37.000, NULL, '2025-10-16 15:42:01', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:44:07', NULL, NULL, '192.168.1.100'),
(25402, NULL, 30.30, 89.10, 37.000, NULL, '2025-10-16 15:42:04', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:44:07', NULL, NULL, '192.168.1.100'),
(25403, NULL, 30.30, 89.10, 37.000, NULL, '2025-10-16 15:42:06', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:44:07', NULL, NULL, '192.168.1.100'),
(25404, NULL, 30.30, 88.90, 37.000, NULL, '2025-10-16 15:42:07', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:44:07', NULL, NULL, '192.168.1.100'),
(25405, NULL, 30.30, 88.90, 37.000, NULL, '2025-10-16 15:42:09', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:44:07', NULL, NULL, '192.168.1.100'),
(25406, NULL, 30.30, 89.00, 37.000, NULL, '2025-10-16 15:42:11', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:44:07', NULL, NULL, '192.168.1.100'),
(25407, NULL, 30.30, 89.20, 37.000, NULL, '2025-10-16 15:42:13', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:44:07', NULL, NULL, '192.168.1.100'),
(25408, NULL, 30.30, 89.20, 37.000, NULL, '2025-10-16 15:42:15', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:44:07', NULL, NULL, '192.168.1.100'),
(25409, NULL, 30.30, 89.20, 37.000, NULL, '2025-10-16 15:42:20', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:44:07', NULL, NULL, '192.168.1.100'),
(25410, NULL, 30.30, 89.20, 37.000, NULL, '2025-10-16 15:42:22', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:44:07', NULL, NULL, '192.168.1.100'),
(25411, NULL, 30.30, 89.20, 37.000, NULL, '2025-10-16 15:42:24', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:44:07', NULL, NULL, '192.168.1.100'),
(25412, NULL, 30.30, 89.20, 37.000, NULL, '2025-10-16 15:42:26', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:44:07', NULL, NULL, '192.168.1.100'),
(25413, NULL, 30.40, 89.30, 37.000, NULL, '2025-10-16 15:42:29', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:44:07', NULL, NULL, '192.168.1.100'),
(25414, NULL, 30.40, 89.50, 37.000, NULL, '2025-10-16 15:42:30', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:44:07', NULL, NULL, '192.168.1.100'),
(25415, NULL, 30.40, 89.50, 36.000, NULL, '2025-10-16 15:42:33', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:44:07', NULL, NULL, '192.168.1.100'),
(25416, NULL, 30.40, 89.50, 37.000, NULL, '2025-10-16 15:42:34', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:44:07', NULL, NULL, '192.168.1.100'),
(25417, NULL, 30.40, 89.50, 37.000, NULL, '2025-10-16 15:42:41', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:44:07', NULL, NULL, '192.168.1.100'),
(25418, NULL, 30.40, 89.50, 36.000, NULL, '2025-10-16 15:42:43', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:44:07', NULL, NULL, '192.168.1.100'),
(25419, NULL, 30.40, 89.50, 36.000, NULL, '2025-10-16 15:42:45', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:44:07', NULL, NULL, '192.168.1.100'),
(25420, NULL, 30.40, 89.70, 36.000, NULL, '2025-10-16 15:42:47', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:44:07', NULL, NULL, '192.168.1.100'),
(25421, NULL, 30.40, 89.70, 36.000, NULL, '2025-10-16 15:42:49', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:44:07', NULL, NULL, '192.168.1.100'),
(25422, NULL, 30.40, 89.80, 36.000, NULL, '2025-10-16 15:42:54', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:44:07', NULL, NULL, '192.168.1.100'),
(25423, NULL, 30.40, 89.90, 36.000, NULL, '2025-10-16 15:42:56', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:44:07', NULL, NULL, '192.168.1.100'),
(25424, NULL, 30.40, 89.90, 36.000, NULL, '2025-10-16 15:42:58', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:44:07', NULL, NULL, '192.168.1.100'),
(25425, NULL, 30.40, 89.90, 36.000, NULL, '2025-10-16 15:43:01', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:44:07', NULL, NULL, '192.168.1.100'),
(25426, NULL, 30.40, 90.00, 36.000, NULL, '2025-10-16 15:43:03', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:44:07', NULL, NULL, '192.168.1.100'),
(25427, NULL, 30.40, 90.10, 36.000, NULL, '2025-10-16 15:43:07', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:44:07', NULL, NULL, '192.168.1.100'),
(25428, NULL, 30.40, 90.10, 36.000, NULL, '2025-10-16 15:43:10', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:44:07', NULL, NULL, '192.168.1.100'),
(25429, NULL, 30.40, 90.00, 36.000, NULL, '2025-10-16 15:43:12', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:44:07', NULL, NULL, '192.168.1.100'),
(25430, NULL, 30.40, 89.80, 36.000, NULL, '2025-10-16 15:43:15', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:44:07', NULL, NULL, '192.168.1.100'),
(25431, NULL, 30.40, 89.40, 36.000, NULL, '2025-10-16 15:43:20', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:44:07', NULL, NULL, '192.168.1.100'),
(25432, NULL, 30.40, 89.80, 36.000, NULL, '2025-10-16 15:43:50', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:44:07', NULL, NULL, '192.168.1.100'),
(25433, NULL, 30.40, 89.40, 36.000, NULL, '2025-10-16 15:43:54', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:44:07', NULL, NULL, '192.168.1.100'),
(25434, NULL, 30.40, 89.50, 36.000, NULL, '2025-10-16 15:43:57', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:44:07', NULL, NULL, '192.168.1.100'),
(25435, NULL, 30.40, 89.60, 35.000, NULL, '2025-10-16 15:43:59', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:44:07', NULL, NULL, '192.168.1.100'),
(25436, NULL, 30.40, 89.70, 35.000, NULL, '2025-10-16 15:44:03', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:44:07', NULL, NULL, '192.168.1.100'),
(25437, NULL, 30.40, 89.80, 35.000, NULL, '2025-10-16 15:44:06', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25438, NULL, 30.40, 89.70, 35.000, NULL, '2025-10-16 15:44:08', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25439, NULL, 30.40, 89.80, 35.000, NULL, '2025-10-16 15:44:11', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25440, NULL, 30.40, 89.70, 35.000, NULL, '2025-10-16 15:44:16', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25441, NULL, 30.40, 89.40, 35.000, NULL, '2025-10-16 15:44:22', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25442, NULL, 30.40, 89.30, 35.000, NULL, '2025-10-16 15:44:26', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25443, NULL, 30.50, 89.30, 35.000, NULL, '2025-10-16 15:44:29', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25444, NULL, 30.40, 89.40, 35.000, NULL, '2025-10-16 15:44:31', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25445, NULL, 30.50, 89.50, 35.000, NULL, '2025-10-16 15:44:33', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25446, NULL, 30.40, 89.70, 35.000, NULL, '2025-10-16 15:44:36', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25447, NULL, 30.50, 89.90, 35.000, NULL, '2025-10-16 15:44:39', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25448, NULL, 30.50, 90.20, 35.000, NULL, '2025-10-16 15:44:42', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25449, NULL, 30.50, 90.30, 34.000, NULL, '2025-10-16 15:44:45', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25450, NULL, 30.50, 90.30, 34.000, NULL, '2025-10-16 15:44:47', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25451, NULL, 30.50, 90.30, 34.000, NULL, '2025-10-16 15:44:49', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25452, NULL, 30.50, 90.00, 34.000, NULL, '2025-10-16 15:44:51', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25453, NULL, 30.50, 90.00, 34.000, NULL, '2025-10-16 15:44:56', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25454, NULL, 30.50, 90.10, 34.000, NULL, '2025-10-16 15:44:59', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25455, NULL, 30.50, 90.00, 34.000, NULL, '2025-10-16 15:45:01', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25456, NULL, 30.50, 90.00, 34.000, NULL, '2025-10-16 15:45:03', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25457, NULL, 30.50, 90.00, 34.000, NULL, '2025-10-16 15:45:05', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25458, NULL, 30.50, 89.90, 34.000, NULL, '2025-10-16 15:45:10', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25459, NULL, 30.50, 89.90, 34.000, NULL, '2025-10-16 15:45:12', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25460, NULL, 30.50, 89.80, 34.000, NULL, '2025-10-16 15:45:15', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25461, NULL, 30.50, 89.80, 34.000, NULL, '2025-10-16 15:45:16', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25462, NULL, 30.50, 89.80, 34.000, NULL, '2025-10-16 15:45:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100');
INSERT INTO `raw_sensor_data` (`id`, `device_id`, `temperature`, `humidity`, `ammonia`, `thermal_temp`, `timestamp`, `water_sprinkler`, `sprinkler_trigger`, `heat`, `mode`, `offline_sync`, `source`, `data_quality`, `created_at`, `pump_temp`, `pump_trigger`, `device_ip`) VALUES
(25463, NULL, 30.50, 89.10, 34.000, NULL, '2025-10-16 15:45:20', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25464, NULL, 30.50, 88.80, 34.000, NULL, '2025-10-16 15:45:23', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25465, NULL, 30.50, 89.40, 35.000, NULL, '2025-10-16 15:45:26', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25466, NULL, 30.50, 89.80, 34.000, NULL, '2025-10-16 15:45:28', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25467, NULL, 30.50, 89.80, 34.000, NULL, '2025-10-16 15:45:30', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25468, NULL, 30.50, 90.00, 35.000, NULL, '2025-10-16 15:45:32', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25469, NULL, 30.50, 90.10, 34.000, NULL, '2025-10-16 15:45:34', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25470, NULL, 30.50, 90.00, 35.000, NULL, '2025-10-16 15:45:38', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25471, NULL, 30.50, 89.60, 35.000, NULL, '2025-10-16 15:45:40', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25472, NULL, 30.50, 89.60, 35.000, NULL, '2025-10-16 15:45:42', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25473, NULL, 30.50, 89.20, 35.000, NULL, '2025-10-16 15:45:44', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25474, NULL, 30.50, 89.10, 35.000, NULL, '2025-10-16 15:45:46', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25475, NULL, 30.50, 89.30, 35.000, NULL, '2025-10-16 15:45:51', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25476, NULL, 30.50, 89.30, 35.000, NULL, '2025-10-16 15:45:52', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25477, NULL, 30.50, 89.30, 35.000, NULL, '2025-10-16 15:45:54', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25478, NULL, 30.50, 89.20, 35.000, NULL, '2025-10-16 15:45:56', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25479, NULL, 30.50, 88.90, 35.000, NULL, '2025-10-16 15:46:01', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25480, NULL, 30.50, 88.80, 35.000, NULL, '2025-10-16 15:46:03', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25481, NULL, 30.50, 88.90, 35.000, NULL, '2025-10-16 15:46:05', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25482, NULL, 30.50, 88.80, 35.000, NULL, '2025-10-16 15:46:07', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25483, NULL, 30.50, 88.80, 35.000, NULL, '2025-10-16 15:46:09', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25484, NULL, 30.50, 88.30, 35.000, NULL, '2025-10-16 15:46:12', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25485, NULL, 30.50, 88.30, 35.000, NULL, '2025-10-16 15:46:14', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25486, NULL, 30.50, 88.00, 35.000, NULL, '2025-10-16 15:46:16', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25487, NULL, 30.50, 88.00, 35.000, NULL, '2025-10-16 15:46:17', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25488, NULL, 30.50, 88.60, 35.000, NULL, '2025-10-16 15:46:19', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25489, NULL, 30.50, 88.90, 35.000, NULL, '2025-10-16 15:46:21', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25490, NULL, 30.50, 89.00, 35.000, NULL, '2025-10-16 15:46:23', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25491, NULL, 30.50, 88.90, 35.000, NULL, '2025-10-16 15:46:26', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25492, NULL, 30.50, 89.50, 34.000, NULL, '2025-10-16 15:46:42', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25493, NULL, 30.50, 88.20, 35.000, NULL, '2025-10-16 15:46:44', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25494, NULL, 30.50, 87.20, 35.000, NULL, '2025-10-16 15:46:47', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25495, NULL, 30.50, 86.40, 35.000, NULL, '2025-10-16 15:46:49', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25496, NULL, 30.50, 86.00, 35.000, NULL, '2025-10-16 15:46:54', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25497, NULL, 30.50, 85.70, 35.000, NULL, '2025-10-16 15:46:56', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25498, NULL, 30.50, 85.70, 35.000, NULL, '2025-10-16 15:46:57', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25499, NULL, 30.50, 85.60, 35.000, NULL, '2025-10-16 15:46:59', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25500, NULL, 30.50, 85.60, 35.000, NULL, '2025-10-16 15:47:01', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25501, NULL, 30.50, 85.80, 35.000, NULL, '2025-10-16 15:47:03', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25502, NULL, 30.50, 86.80, 35.000, NULL, '2025-10-16 15:47:05', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25503, NULL, 30.40, 87.10, 35.000, NULL, '2025-10-16 15:47:07', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25504, NULL, 30.40, 87.10, 35.000, NULL, '2025-10-16 15:47:09', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25505, NULL, 30.40, 87.20, 35.000, NULL, '2025-10-16 15:47:13', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25506, NULL, 30.40, 87.20, 35.000, NULL, '2025-10-16 15:47:15', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25507, NULL, 30.40, 88.40, 35.000, NULL, '2025-10-16 15:47:17', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25508, NULL, 30.40, 88.40, 35.000, NULL, '2025-10-16 15:47:19', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25509, NULL, 30.40, 88.60, 35.000, NULL, '2025-10-16 15:47:21', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25510, NULL, 30.50, 88.70, 35.000, NULL, '2025-10-16 15:47:22', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25511, NULL, 30.50, 88.70, 35.000, NULL, '2025-10-16 15:47:24', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25512, NULL, 30.40, 88.70, 35.000, NULL, '2025-10-16 15:47:26', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25513, NULL, 30.50, 88.20, 35.000, NULL, '2025-10-16 15:47:28', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25514, NULL, 30.40, 87.70, 35.000, NULL, '2025-10-16 15:47:33', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25515, NULL, 30.50, 87.80, 35.000, NULL, '2025-10-16 15:47:35', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25516, NULL, 30.50, 87.80, 35.000, NULL, '2025-10-16 15:47:37', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25517, NULL, 30.40, 88.00, 35.000, NULL, '2025-10-16 15:47:40', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25518, NULL, 30.40, 88.20, 35.000, NULL, '2025-10-16 15:47:42', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25519, NULL, 30.40, 88.30, 35.000, NULL, '2025-10-16 15:47:45', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25520, NULL, 30.40, 88.30, 33.000, NULL, '2025-10-16 15:47:47', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25521, NULL, 30.40, 88.40, 35.000, NULL, '2025-10-16 15:47:48', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25522, NULL, 30.50, 88.60, 35.000, NULL, '2025-10-16 15:47:52', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25523, NULL, 30.50, 88.70, 35.000, NULL, '2025-10-16 15:47:54', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25524, NULL, 30.50, 88.70, 35.000, NULL, '2025-10-16 15:47:56', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25525, NULL, 30.40, 88.80, 35.000, NULL, '2025-10-16 15:47:58', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25526, NULL, 30.40, 88.80, 35.000, NULL, '2025-10-16 15:47:59', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25527, NULL, 30.50, 88.80, 35.000, NULL, '2025-10-16 15:48:01', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25528, NULL, 30.50, 88.90, 35.000, NULL, '2025-10-16 15:48:04', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25529, NULL, 30.50, 88.90, 35.000, NULL, '2025-10-16 15:48:06', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25530, NULL, 30.40, 88.80, 35.000, NULL, '2025-10-16 15:48:07', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25531, NULL, 30.40, 88.80, 35.000, NULL, '2025-10-16 15:48:09', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25532, NULL, 30.50, 88.80, 35.000, NULL, '2025-10-16 15:48:11', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25533, NULL, 30.50, 88.60, 35.000, NULL, '2025-10-16 15:48:13', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25534, NULL, 30.50, 88.60, 35.000, NULL, '2025-10-16 15:48:15', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25535, NULL, 30.50, 88.70, 35.000, NULL, '2025-10-16 15:48:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25536, NULL, 30.50, 88.70, 35.000, NULL, '2025-10-16 15:48:20', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25537, NULL, 30.50, 88.80, 35.000, NULL, '2025-10-16 15:48:23', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25538, NULL, 30.50, 88.80, 35.000, NULL, '2025-10-16 15:48:25', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25539, NULL, 30.50, 88.70, 34.000, NULL, '2025-10-16 15:48:27', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25540, NULL, 30.50, 88.70, 35.000, NULL, '2025-10-16 15:48:29', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25541, NULL, 30.50, 88.60, 35.000, NULL, '2025-10-16 15:48:32', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25542, NULL, 30.50, 88.60, 34.000, NULL, '2025-10-16 15:48:33', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25543, NULL, 30.50, 88.60, 34.000, NULL, '2025-10-16 15:48:35', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25544, NULL, 30.50, 88.80, 34.000, NULL, '2025-10-16 15:48:38', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25545, NULL, 30.50, 88.80, 34.000, NULL, '2025-10-16 15:48:40', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25546, NULL, 30.50, 88.80, 35.000, NULL, '2025-10-16 15:48:42', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25547, NULL, 30.50, 88.80, 35.000, NULL, '2025-10-16 15:48:44', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25548, NULL, 30.40, 89.30, 34.000, NULL, '2025-10-16 15:49:09', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:49:14', NULL, NULL, '192.168.1.100'),
(25549, NULL, 30.50, 89.30, 34.000, NULL, '2025-10-16 15:49:12', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25550, NULL, 30.50, 89.40, 34.000, NULL, '2025-10-16 15:49:14', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25551, NULL, 30.50, 89.40, 34.000, NULL, '2025-10-16 15:49:16', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25552, NULL, 30.50, 89.50, 34.000, NULL, '2025-10-16 15:49:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25553, NULL, 30.50, 89.40, 34.000, NULL, '2025-10-16 15:49:21', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25554, NULL, 30.50, 89.40, 34.000, NULL, '2025-10-16 15:49:24', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25555, NULL, 30.50, 89.50, 34.000, NULL, '2025-10-16 15:49:26', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25556, NULL, 30.50, 89.50, 34.000, NULL, '2025-10-16 15:49:28', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25557, NULL, 30.50, 89.50, 34.000, NULL, '2025-10-16 15:49:30', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25558, NULL, 30.50, 89.50, 34.000, NULL, '2025-10-16 15:49:33', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25559, NULL, 30.50, 89.50, 34.000, NULL, '2025-10-16 15:49:35', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25560, NULL, 30.50, 89.40, 34.000, NULL, '2025-10-16 15:49:37', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25561, NULL, 30.50, 89.50, 34.000, NULL, '2025-10-16 15:49:40', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25562, NULL, 30.50, 89.30, 34.000, NULL, '2025-10-16 15:49:42', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25563, NULL, 30.50, 89.30, 34.000, NULL, '2025-10-16 15:49:45', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25564, NULL, 30.50, 89.30, 34.000, NULL, '2025-10-16 15:49:47', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25565, NULL, 30.50, 89.20, 34.000, NULL, '2025-10-16 15:49:49', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25566, NULL, 30.60, 89.50, 34.000, NULL, '2025-10-16 15:49:51', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25567, NULL, 30.60, 89.50, 34.000, NULL, '2025-10-16 15:49:53', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25568, NULL, 30.60, 89.60, 34.000, NULL, '2025-10-16 15:49:55', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25569, NULL, 30.60, 89.70, 34.000, NULL, '2025-10-16 15:49:57', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25570, NULL, 30.60, 89.70, 34.000, NULL, '2025-10-16 15:49:59', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25571, NULL, 30.50, 89.80, 34.000, NULL, '2025-10-16 15:50:01', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25572, NULL, 30.50, 89.80, 34.000, NULL, '2025-10-16 15:50:03', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25573, NULL, 30.60, 89.60, 34.000, NULL, '2025-10-16 15:50:05', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25574, NULL, 30.60, 89.60, 34.000, NULL, '2025-10-16 15:50:07', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25575, NULL, 30.50, 89.40, 34.000, NULL, '2025-10-16 15:50:09', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25576, NULL, 30.60, 89.30, 34.000, NULL, '2025-10-16 15:50:12', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25577, NULL, 30.60, 89.00, 34.000, NULL, '2025-10-16 15:50:16', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25578, NULL, 30.60, 88.80, 33.000, NULL, '2025-10-16 15:50:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25579, NULL, 30.60, 89.00, 34.000, NULL, '2025-10-16 15:50:21', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25580, NULL, 30.60, 89.00, 34.000, NULL, '2025-10-16 15:50:23', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25581, NULL, 30.60, 88.40, 34.000, NULL, '2025-10-16 15:50:25', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25582, NULL, 30.60, 88.40, 34.000, NULL, '2025-10-16 15:50:27', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25583, NULL, 30.60, 88.40, 34.000, NULL, '2025-10-16 15:50:28', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25584, NULL, 30.60, 88.30, 34.000, NULL, '2025-10-16 15:50:30', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25585, NULL, 30.60, 88.20, 34.000, NULL, '2025-10-16 15:50:33', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25586, NULL, 30.60, 88.20, 34.000, NULL, '2025-10-16 15:50:34', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25587, NULL, 30.60, 88.30, 34.000, NULL, '2025-10-16 15:50:36', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25588, NULL, 30.60, 88.70, 34.000, NULL, '2025-10-16 15:50:38', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25589, NULL, 30.60, 88.70, 34.000, NULL, '2025-10-16 15:50:40', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25590, NULL, 30.60, 88.80, 34.000, NULL, '2025-10-16 15:50:42', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25591, NULL, 30.60, 89.00, 34.000, NULL, '2025-10-16 15:50:46', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25592, NULL, 30.60, 89.00, 34.000, NULL, '2025-10-16 15:50:47', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25593, NULL, 30.60, 89.20, 34.000, NULL, '2025-10-16 15:50:49', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25594, NULL, 30.60, 89.20, 34.000, NULL, '2025-10-16 15:50:51', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25595, NULL, 30.60, 89.00, 34.000, NULL, '2025-10-16 15:50:53', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25596, NULL, 30.60, 88.80, 34.000, NULL, '2025-10-16 15:50:55', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25597, NULL, 30.60, 88.90, 34.000, NULL, '2025-10-16 15:50:57', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25598, NULL, 30.60, 88.90, 34.000, NULL, '2025-10-16 15:50:59', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25599, NULL, 30.60, 89.00, 34.000, NULL, '2025-10-16 15:51:01', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25600, NULL, 30.60, 89.30, 34.000, NULL, '2025-10-16 15:51:03', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25601, NULL, 30.60, 89.30, 34.000, NULL, '2025-10-16 15:51:05', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25602, NULL, 30.60, 89.40, 34.000, NULL, '2025-10-16 15:51:06', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25603, NULL, 30.60, 89.10, 34.000, NULL, '2025-10-16 15:51:08', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25604, NULL, 30.60, 89.10, 34.000, NULL, '2025-10-16 15:51:10', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25605, NULL, 30.60, 89.20, 34.000, NULL, '2025-10-16 15:51:12', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25606, NULL, 30.60, 89.20, 34.000, NULL, '2025-10-16 15:51:14', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25607, NULL, 30.60, 89.40, 34.000, NULL, '2025-10-16 15:51:16', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25608, NULL, 30.60, 89.10, 34.000, NULL, '2025-10-16 15:51:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25609, NULL, 30.60, 89.30, 34.000, NULL, '2025-10-16 15:51:21', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25610, NULL, 30.60, 89.30, 34.000, NULL, '2025-10-16 15:51:22', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25611, NULL, 30.60, 89.20, 34.000, NULL, '2025-10-16 15:51:24', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25612, NULL, 30.60, 89.20, 34.000, NULL, '2025-10-16 15:51:26', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25613, NULL, 30.60, 89.30, 34.000, NULL, '2025-10-16 15:51:28', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25614, NULL, 30.60, 89.40, 34.000, NULL, '2025-10-16 15:51:29', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25615, NULL, 30.50, 89.40, 34.000, NULL, '2025-10-16 15:51:33', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25616, NULL, 30.50, 89.40, 34.000, NULL, '2025-10-16 15:51:34', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25617, NULL, 30.60, 89.50, 34.000, NULL, '2025-10-16 15:51:36', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25618, NULL, 30.60, 89.50, 34.000, NULL, '2025-10-16 15:51:38', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25619, NULL, 30.60, 89.60, 34.000, NULL, '2025-10-16 15:51:40', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25620, NULL, 30.50, 89.70, 34.000, NULL, '2025-10-16 15:51:42', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25621, NULL, 30.60, 89.80, 34.000, NULL, '2025-10-16 15:51:44', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25622, NULL, 30.60, 89.80, 34.000, NULL, '2025-10-16 15:51:46', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25623, NULL, 30.60, 90.00, 34.000, NULL, '2025-10-16 15:51:49', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25624, NULL, 30.60, 90.00, 34.000, NULL, '2025-10-16 15:51:51', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25625, NULL, 30.60, 89.90, 34.000, NULL, '2025-10-16 15:51:53', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25626, NULL, 30.60, 89.90, 34.000, NULL, '2025-10-16 15:51:56', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25627, NULL, 30.60, 89.90, 34.000, NULL, '2025-10-16 15:51:58', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25628, NULL, 30.60, 89.90, 34.000, NULL, '2025-10-16 15:51:59', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25629, NULL, 30.60, 89.90, 34.000, NULL, '2025-10-16 15:52:01', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25630, NULL, 30.50, 89.90, 34.000, NULL, '2025-10-16 15:52:03', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25631, NULL, 30.50, 89.90, 34.000, NULL, '2025-10-16 15:52:05', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25632, NULL, 30.60, 89.90, 34.000, NULL, '2025-10-16 15:52:08', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25633, NULL, 30.60, 90.00, 34.000, NULL, '2025-10-16 15:52:12', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25634, NULL, 30.60, 90.00, 34.000, NULL, '2025-10-16 15:52:14', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25635, NULL, 30.60, 90.00, 34.000, NULL, '2025-10-16 15:52:16', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25636, NULL, 30.60, 89.90, 34.000, NULL, '2025-10-16 15:52:19', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25637, NULL, 30.60, 89.90, 34.000, NULL, '2025-10-16 15:52:22', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25638, NULL, 30.60, 89.90, 34.000, NULL, '2025-10-16 15:52:24', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25639, NULL, 30.60, 89.80, 34.000, NULL, '2025-10-16 15:52:26', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25640, NULL, 30.60, 89.60, 34.000, NULL, '2025-10-16 15:52:28', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25641, NULL, 30.60, 89.60, 34.000, NULL, '2025-10-16 15:52:31', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25642, NULL, 30.60, 89.30, 34.000, NULL, '2025-10-16 15:52:35', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25643, NULL, 30.60, 89.30, 34.000, NULL, '2025-10-16 15:52:36', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25644, NULL, 30.60, 89.30, 34.000, NULL, '2025-10-16 15:52:38', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25645, NULL, 30.60, 89.10, 34.000, NULL, '2025-10-16 15:52:40', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25646, NULL, 30.60, 89.20, 34.000, NULL, '2025-10-16 15:52:43', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25647, NULL, 30.60, 89.20, 34.000, NULL, '2025-10-16 15:52:45', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25648, NULL, 30.60, 89.30, 34.000, NULL, '2025-10-16 15:52:48', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25649, NULL, 30.60, 89.60, 34.000, NULL, '2025-10-16 15:52:50', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25650, NULL, 30.60, 89.60, 34.000, NULL, '2025-10-16 15:52:52', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25651, NULL, 30.60, 89.60, 34.000, NULL, '2025-10-16 15:52:56', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25652, NULL, 30.60, 89.60, 34.000, NULL, '2025-10-16 15:52:58', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25653, NULL, 30.60, 89.90, 34.000, NULL, '2025-10-16 15:52:59', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25654, NULL, 30.60, 89.90, 34.000, NULL, '2025-10-16 15:53:01', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25655, NULL, 30.60, 89.90, 34.000, NULL, '2025-10-16 15:53:03', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25656, NULL, 30.60, 89.90, 34.000, NULL, '2025-10-16 15:53:05', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25657, NULL, 30.60, 89.90, 32.000, NULL, '2025-10-16 15:53:07', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25658, NULL, 30.60, 89.90, 34.000, NULL, '2025-10-16 15:53:09', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25659, NULL, 30.60, 89.80, 34.000, NULL, '2025-10-16 15:53:11', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25660, NULL, 30.60, 89.80, 34.000, NULL, '2025-10-16 15:53:13', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25661, NULL, 30.60, 89.70, 34.000, NULL, '2025-10-16 15:53:15', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25662, NULL, 30.60, 89.70, 34.000, NULL, '2025-10-16 15:53:16', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25663, NULL, 30.60, 89.30, 34.000, NULL, '2025-10-16 15:53:19', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25664, NULL, 30.60, 89.30, 34.000, NULL, '2025-10-16 15:53:21', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25665, NULL, 30.60, 88.70, 34.000, NULL, '2025-10-16 15:53:23', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25666, NULL, 30.60, 88.20, 34.000, NULL, '2025-10-16 15:53:26', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25667, NULL, 30.60, 88.20, 34.000, NULL, '2025-10-16 15:53:28', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25668, NULL, 30.60, 88.20, 34.000, NULL, '2025-10-16 15:53:31', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25669, NULL, 30.60, 88.20, 34.000, NULL, '2025-10-16 15:53:33', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25670, NULL, 30.60, 88.20, 34.000, NULL, '2025-10-16 15:53:34', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25671, NULL, 30.60, 88.20, 34.000, NULL, '2025-10-16 15:53:36', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25672, NULL, 30.50, 88.50, 34.000, NULL, '2025-10-16 15:53:38', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25673, NULL, 30.60, 88.60, 34.000, NULL, '2025-10-16 15:53:40', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25674, NULL, 30.60, 88.80, 34.000, NULL, '2025-10-16 15:53:42', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25675, NULL, 30.60, 88.50, 34.000, NULL, '2025-10-16 15:53:44', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25676, NULL, 30.60, 88.50, 34.000, NULL, '2025-10-16 15:53:46', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25677, NULL, 30.60, 88.50, 34.000, NULL, '2025-10-16 15:53:48', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25678, NULL, 30.60, 88.70, 34.000, NULL, '2025-10-16 15:53:50', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:37', NULL, NULL, '192.168.1.100'),
(25679, NULL, 30.60, 88.70, 34.000, NULL, '2025-10-16 15:53:51', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:38', NULL, NULL, '192.168.1.100'),
(25680, NULL, 30.60, 88.40, 34.000, NULL, '2025-10-16 15:53:54', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:38', NULL, NULL, '192.168.1.100'),
(25681, NULL, 30.60, 87.90, 34.000, NULL, '2025-10-16 15:53:58', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:38', NULL, NULL, '192.168.1.100'),
(25682, NULL, 30.60, 87.90, 34.000, NULL, '2025-10-16 15:54:00', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:38', NULL, NULL, '192.168.1.100'),
(25683, NULL, 30.60, 87.80, 34.000, NULL, '2025-10-16 15:54:02', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:38', NULL, NULL, '192.168.1.100'),
(25684, NULL, 30.60, 87.60, 34.000, NULL, '2025-10-16 15:54:04', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:38', NULL, NULL, '192.168.1.100'),
(25685, NULL, 30.60, 87.70, 34.000, NULL, '2025-10-16 15:54:06', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:38', NULL, NULL, '192.168.1.100'),
(25686, NULL, 30.50, 88.80, 34.000, NULL, '2025-10-16 15:54:31', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:54:38', NULL, NULL, '192.168.1.100'),
(25687, NULL, 30.50, 88.90, 34.000, NULL, '2025-10-16 15:54:34', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:59:32', NULL, NULL, '192.168.1.100'),
(25688, NULL, 30.50, 88.90, 34.000, NULL, '2025-10-16 15:54:35', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:59:32', NULL, NULL, '192.168.1.100'),
(25689, NULL, 30.50, 89.00, 34.000, NULL, '2025-10-16 15:54:37', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:59:32', NULL, NULL, '192.168.1.100'),
(25690, NULL, 30.50, 89.00, 34.000, NULL, '2025-10-16 15:54:39', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:59:32', NULL, NULL, '192.168.1.100'),
(25691, NULL, 30.50, 89.20, 34.000, NULL, '2025-10-16 15:54:41', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:59:32', NULL, NULL, '192.168.1.100'),
(25692, NULL, 30.50, 89.30, 34.000, NULL, '2025-10-16 15:54:43', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:59:32', NULL, NULL, '192.168.1.100'),
(25693, NULL, 30.50, 89.30, 34.000, NULL, '2025-10-16 15:54:45', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:59:32', NULL, NULL, '192.168.1.100'),
(25694, NULL, 30.50, 89.30, 34.000, NULL, '2025-10-16 15:54:47', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:59:32', NULL, NULL, '192.168.1.100'),
(25695, NULL, 30.50, 89.30, 34.000, NULL, '2025-10-16 15:54:48', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:59:32', NULL, NULL, '192.168.1.100'),
(25696, NULL, 30.50, 89.40, 33.000, NULL, '2025-10-16 15:54:50', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:59:32', NULL, NULL, '192.168.1.100'),
(25697, NULL, 30.60, 89.40, 34.000, NULL, '2025-10-16 15:54:52', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:59:32', NULL, NULL, '192.168.1.100'),
(25698, NULL, 30.60, 89.30, 34.000, NULL, '2025-10-16 15:54:55', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:59:32', NULL, NULL, '192.168.1.100'),
(25699, NULL, 30.60, 89.30, 34.000, NULL, '2025-10-16 15:54:56', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:59:32', NULL, NULL, '192.168.1.100'),
(25700, NULL, 30.60, 89.10, 34.000, NULL, '2025-10-16 15:54:58', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:59:32', NULL, NULL, '192.168.1.100'),
(25701, NULL, 30.60, 88.60, 34.000, NULL, '2025-10-16 15:55:02', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:59:32', NULL, NULL, '192.168.1.100'),
(25702, NULL, 30.60, 88.60, 34.000, NULL, '2025-10-16 15:55:03', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:59:32', NULL, NULL, '192.168.1.100'),
(25703, NULL, 30.60, 88.60, 34.000, NULL, '2025-10-16 15:55:06', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:59:32', NULL, NULL, '192.168.1.100'),
(25704, NULL, 30.60, 88.60, 34.000, NULL, '2025-10-16 15:55:07', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:59:32', NULL, NULL, '192.168.1.100'),
(25705, NULL, 30.60, 88.60, 34.000, NULL, '2025-10-16 15:55:09', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:59:32', NULL, NULL, '192.168.1.100'),
(25706, NULL, 30.60, 88.30, 34.000, NULL, '2025-10-16 15:55:11', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:59:32', NULL, NULL, '192.168.1.100'),
(25707, NULL, 30.60, 88.30, 34.000, NULL, '2025-10-16 15:55:13', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:59:32', NULL, NULL, '192.168.1.100'),
(25708, NULL, 30.60, 88.30, 34.000, NULL, '2025-10-16 15:55:14', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:59:32', NULL, NULL, '192.168.1.100'),
(25709, NULL, 30.60, 88.20, 34.000, NULL, '2025-10-16 15:55:17', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:59:32', NULL, NULL, '192.168.1.100'),
(25710, NULL, 30.60, 88.20, 34.000, NULL, '2025-10-16 15:55:19', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:59:32', NULL, NULL, '192.168.1.100'),
(25711, NULL, 30.60, 88.20, 34.000, NULL, '2025-10-16 15:55:20', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:59:32', NULL, NULL, '192.168.1.100'),
(25712, NULL, 30.60, 88.20, 34.000, NULL, '2025-10-16 15:55:22', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:59:32', NULL, NULL, '192.168.1.100'),
(25713, NULL, 30.60, 88.10, 34.000, NULL, '2025-10-16 15:55:24', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:59:32', NULL, NULL, '192.168.1.100'),
(25714, NULL, 30.60, 87.90, 34.000, NULL, '2025-10-16 15:55:26', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:59:32', NULL, NULL, '192.168.1.100'),
(25715, NULL, 30.60, 87.90, 34.000, NULL, '2025-10-16 15:55:29', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:59:32', NULL, NULL, '192.168.1.100'),
(25716, NULL, 30.60, 88.20, 34.000, NULL, '2025-10-16 15:55:36', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:59:32', NULL, NULL, '192.168.1.100'),
(25717, NULL, 30.60, 88.20, 34.000, NULL, '2025-10-16 15:55:38', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:59:32', NULL, NULL, '192.168.1.100'),
(25718, NULL, 30.60, 88.20, 34.000, NULL, '2025-10-16 15:55:44', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:59:32', NULL, NULL, '192.168.1.100'),
(25719, NULL, 30.50, 88.70, 34.000, NULL, '2025-10-16 15:55:46', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:59:32', NULL, NULL, '192.168.1.100'),
(25720, NULL, 30.50, 88.70, 34.000, NULL, '2025-10-16 15:55:49', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:59:32', NULL, NULL, '192.168.1.100'),
(25721, NULL, 30.50, 88.70, 34.000, NULL, '2025-10-16 15:55:51', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:59:32', NULL, NULL, '192.168.1.100'),
(25722, NULL, 30.50, 88.60, 34.000, NULL, '2025-10-16 15:55:53', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:59:32', NULL, NULL, '192.168.1.100'),
(25723, NULL, 30.50, 86.90, 34.000, NULL, '2025-10-16 15:55:56', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:59:32', NULL, NULL, '192.168.1.100'),
(25724, NULL, 30.50, 86.90, 34.000, NULL, '2025-10-16 15:55:57', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:59:32', NULL, NULL, '192.168.1.100'),
(25725, NULL, 30.50, 86.60, 34.000, NULL, '2025-10-16 15:56:01', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:59:32', NULL, NULL, '192.168.1.100'),
(25726, NULL, 30.50, 86.60, 34.000, NULL, '2025-10-16 15:56:03', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:59:32', NULL, NULL, '192.168.1.100'),
(25727, NULL, 30.50, 85.50, 34.000, NULL, '2025-10-16 15:56:06', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:59:32', NULL, NULL, '192.168.1.100'),
(25728, NULL, 30.50, 85.50, 34.000, NULL, '2025-10-16 15:56:09', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:59:32', NULL, NULL, '192.168.1.100'),
(25729, NULL, 30.50, 85.50, 34.000, NULL, '2025-10-16 15:56:11', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:59:32', NULL, NULL, '192.168.1.100'),
(25730, NULL, 30.50, 86.30, 34.000, NULL, '2025-10-16 15:56:13', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:59:32', NULL, NULL, '192.168.1.100'),
(25731, NULL, 30.50, 86.30, 34.000, NULL, '2025-10-16 15:56:15', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:59:32', NULL, NULL, '192.168.1.100'),
(25732, NULL, 30.50, 87.00, 34.000, NULL, '2025-10-16 15:56:17', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:59:32', NULL, NULL, '192.168.1.100'),
(25733, NULL, 30.50, 87.40, 34.000, NULL, '2025-10-16 15:56:19', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:59:32', NULL, NULL, '192.168.1.100'),
(25734, NULL, 30.50, 87.60, 34.000, NULL, '2025-10-16 15:56:21', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:59:32', NULL, NULL, '192.168.1.100'),
(25735, NULL, 30.50, 87.60, 34.000, NULL, '2025-10-16 15:56:23', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:59:32', NULL, NULL, '192.168.1.100'),
(25736, NULL, 30.50, 87.20, 34.000, NULL, '2025-10-16 15:56:25', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:59:32', NULL, NULL, '192.168.1.100'),
(25737, NULL, 30.50, 87.20, 34.000, NULL, '2025-10-16 15:56:26', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:59:32', NULL, NULL, '192.168.1.100'),
(25738, NULL, 30.50, 87.50, 34.000, NULL, '2025-10-16 15:56:28', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:59:32', NULL, NULL, '192.168.1.100'),
(25739, NULL, 30.50, 87.80, 34.000, NULL, '2025-10-16 15:56:30', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:59:32', NULL, NULL, '192.168.1.100'),
(25740, NULL, 30.40, 86.80, 35.000, NULL, '2025-10-16 15:57:42', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:59:32', NULL, NULL, '192.168.1.100'),
(25741, NULL, 30.40, 86.40, 35.000, NULL, '2025-10-16 15:57:44', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:59:32', NULL, NULL, '192.168.1.100'),
(25742, NULL, 30.40, 86.40, 35.000, NULL, '2025-10-16 15:57:46', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:59:32', NULL, NULL, '192.168.1.100'),
(25743, NULL, 30.40, 86.10, 35.000, NULL, '2025-10-16 15:57:47', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:59:32', NULL, NULL, '192.168.1.100'),
(25744, NULL, 30.40, 86.20, 35.000, NULL, '2025-10-16 15:57:50', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:59:32', NULL, NULL, '192.168.1.100'),
(25745, NULL, 30.40, 86.50, 35.000, NULL, '2025-10-16 15:57:53', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:59:32', NULL, NULL, '192.168.1.100'),
(25746, NULL, 30.40, 86.50, 34.000, NULL, '2025-10-16 15:57:55', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 07:59:32', NULL, NULL, '192.168.1.100'),
(25747, NULL, 30.40, 87.80, 35.000, NULL, '2025-10-16 15:59:38', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25748, NULL, 30.40, 87.80, 35.000, NULL, '2025-10-16 15:59:39', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25749, NULL, 30.40, 88.00, 35.000, NULL, '2025-10-16 15:59:42', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25750, NULL, 30.40, 88.50, 35.000, NULL, '2025-10-16 15:59:44', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25751, NULL, 30.40, 88.70, 35.000, NULL, '2025-10-16 15:59:46', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25752, NULL, 30.50, 88.80, 35.000, NULL, '2025-10-16 15:59:50', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25753, NULL, 30.50, 88.80, 35.000, NULL, '2025-10-16 15:59:51', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25754, NULL, 30.50, 88.30, 35.000, NULL, '2025-10-16 15:59:53', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25755, NULL, 30.50, 88.30, 35.000, NULL, '2025-10-16 15:59:55', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25756, NULL, 30.40, 88.00, 35.000, NULL, '2025-10-16 15:59:57', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25757, NULL, 30.40, 87.90, 35.000, NULL, '2025-10-16 15:59:58', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25758, NULL, 30.50, 87.90, 35.000, NULL, '2025-10-16 16:00:01', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25759, NULL, 30.50, 87.90, 35.000, NULL, '2025-10-16 16:00:02', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25760, NULL, 30.50, 88.00, 34.000, NULL, '2025-10-16 16:00:04', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25761, NULL, 30.50, 87.90, 34.000, NULL, '2025-10-16 16:00:08', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25762, NULL, 30.50, 87.90, 34.000, NULL, '2025-10-16 16:00:10', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25763, NULL, 30.50, 87.90, 34.000, NULL, '2025-10-16 16:00:13', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25764, NULL, 30.50, 87.90, 34.000, NULL, '2025-10-16 16:00:15', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25765, NULL, 30.50, 88.30, 34.000, NULL, '2025-10-16 16:00:17', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100');
INSERT INTO `raw_sensor_data` (`id`, `device_id`, `temperature`, `humidity`, `ammonia`, `thermal_temp`, `timestamp`, `water_sprinkler`, `sprinkler_trigger`, `heat`, `mode`, `offline_sync`, `source`, `data_quality`, `created_at`, `pump_temp`, `pump_trigger`, `device_ip`) VALUES
(25766, NULL, 30.50, 88.30, 34.000, NULL, '2025-10-16 16:00:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25767, NULL, 30.50, 88.10, 34.000, NULL, '2025-10-16 16:00:20', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25768, NULL, 30.50, 88.00, 34.000, NULL, '2025-10-16 16:00:23', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25769, NULL, 30.50, 88.20, 34.000, NULL, '2025-10-16 16:00:25', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25770, NULL, 30.50, 88.40, 34.000, NULL, '2025-10-16 16:00:27', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25771, NULL, 30.50, 88.40, 34.000, NULL, '2025-10-16 16:00:29', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25772, NULL, 30.50, 88.30, 34.000, NULL, '2025-10-16 16:00:31', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25773, NULL, 30.50, 88.30, 34.000, NULL, '2025-10-16 16:00:33', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25774, NULL, 30.50, 88.40, 34.000, NULL, '2025-10-16 16:00:35', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25775, NULL, 30.50, 88.50, 34.000, NULL, '2025-10-16 16:00:37', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25776, NULL, 30.50, 88.40, 34.000, NULL, '2025-10-16 16:00:40', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25777, NULL, 30.50, 88.40, 34.000, NULL, '2025-10-16 16:00:42', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25778, NULL, 30.50, 88.40, 34.000, NULL, '2025-10-16 16:00:44', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25779, NULL, 30.50, 88.70, 34.000, NULL, '2025-10-16 16:00:46', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25780, NULL, 30.50, 88.80, 34.000, NULL, '2025-10-16 16:00:48', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25781, NULL, 30.50, 88.80, 34.000, NULL, '2025-10-16 16:00:50', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25782, NULL, 30.50, 89.00, 34.000, NULL, '2025-10-16 16:00:52', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25783, NULL, 30.50, 89.00, 34.000, NULL, '2025-10-16 16:00:54', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25784, NULL, 30.50, 88.80, 34.000, NULL, '2025-10-16 16:00:56', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25785, NULL, 30.50, 88.80, 34.000, NULL, '2025-10-16 16:00:58', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25786, NULL, 30.50, 88.80, 33.000, NULL, '2025-10-16 16:01:00', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25787, NULL, 30.50, 88.80, 33.000, NULL, '2025-10-16 16:01:02', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25788, NULL, 30.50, 88.90, 33.000, NULL, '2025-10-16 16:01:04', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25789, NULL, 30.50, 89.10, 33.000, NULL, '2025-10-16 16:01:06', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25790, NULL, 30.50, 89.10, 33.000, NULL, '2025-10-16 16:01:08', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25791, NULL, 30.50, 89.10, 33.000, NULL, '2025-10-16 16:01:11', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25792, NULL, 30.50, 89.30, 33.000, NULL, '2025-10-16 16:01:14', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25793, NULL, 30.50, 89.30, 33.000, NULL, '2025-10-16 16:01:16', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25794, NULL, 30.50, 89.30, 33.000, NULL, '2025-10-16 16:01:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25795, NULL, 30.50, 89.30, 32.000, NULL, '2025-10-16 16:01:21', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25796, NULL, 30.50, 89.40, 33.000, NULL, '2025-10-16 16:01:24', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25797, NULL, 30.50, 90.20, 33.000, NULL, '2025-10-16 16:01:26', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25798, NULL, 30.60, 93.50, 33.000, NULL, '2025-10-16 16:01:28', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25799, NULL, 30.60, 92.30, 33.000, NULL, '2025-10-16 16:01:30', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25800, NULL, 30.60, 91.40, 33.000, NULL, '2025-10-16 16:01:33', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25801, NULL, 30.70, 91.40, 33.000, NULL, '2025-10-16 16:01:36', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25802, NULL, 30.70, 91.40, 33.000, NULL, '2025-10-16 16:01:38', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25803, NULL, 34.10, 82.50, 33.000, NULL, '2025-10-16 16:01:39', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25804, NULL, 35.30, 79.10, 33.000, NULL, '2025-10-16 16:01:41', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25805, NULL, 35.30, 79.10, 33.000, NULL, '2025-10-16 16:01:42', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25806, NULL, 36.30, 74.80, 33.000, NULL, '2025-10-16 16:01:44', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25807, NULL, 37.40, 70.90, 33.000, NULL, '2025-10-16 16:01:49', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25808, NULL, 37.40, 70.90, 33.000, NULL, '2025-10-16 16:01:50', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25809, NULL, 40.10, 63.30, 33.000, NULL, '2025-10-16 16:01:52', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25810, NULL, 40.10, 63.30, 35.000, NULL, '2025-10-16 16:01:54', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25811, NULL, 42.20, 58.80, 33.000, NULL, '2025-10-16 16:01:56', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25812, NULL, 43.70, 55.60, 33.000, NULL, '2025-10-16 16:01:58', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25813, NULL, 0.00, 0.00, 33.000, NULL, '2025-10-16 16:02:00', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25814, NULL, 0.00, 0.00, 33.000, NULL, '2025-10-16 16:02:02', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25815, NULL, 0.00, 0.00, 33.000, NULL, '2025-10-16 16:02:04', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25816, NULL, 0.00, 0.00, 33.000, NULL, '2025-10-16 16:02:06', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25817, NULL, 0.00, 0.00, 33.000, NULL, '2025-10-16 16:02:07', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25818, NULL, 0.00, 0.00, 33.000, NULL, '2025-10-16 16:02:09', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25819, NULL, 0.00, 0.00, 34.000, NULL, '2025-10-16 16:02:12', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25820, NULL, 0.00, 0.00, 33.000, NULL, '2025-10-16 16:02:14', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25821, NULL, 0.00, 0.00, 33.000, NULL, '2025-10-16 16:02:16', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25822, NULL, 0.00, 0.00, 33.000, NULL, '2025-10-16 16:02:19', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25823, NULL, 0.00, 0.00, 33.000, NULL, '2025-10-16 16:02:21', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25824, NULL, 0.00, 0.00, 33.000, NULL, '2025-10-16 16:02:24', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25825, NULL, 0.00, 0.00, 33.000, NULL, '2025-10-16 16:02:25', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25826, NULL, 0.00, 0.00, 33.000, NULL, '2025-10-16 16:02:27', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25827, NULL, 0.00, 0.00, 33.000, NULL, '2025-10-16 16:02:29', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25828, NULL, 0.00, 0.00, 33.000, NULL, '2025-10-16 16:02:31', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25829, NULL, 0.00, 0.00, 33.000, NULL, '2025-10-16 16:02:33', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25830, NULL, 0.00, 0.00, 33.000, NULL, '2025-10-16 16:02:35', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25831, NULL, 0.00, 0.00, 33.000, NULL, '2025-10-16 16:02:37', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25832, NULL, 0.00, 0.00, 33.000, NULL, '2025-10-16 16:02:39', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25833, NULL, 0.00, 0.00, 33.000, NULL, '2025-10-16 16:02:40', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25834, NULL, 0.00, 0.00, 33.000, NULL, '2025-10-16 16:02:42', NULL, NULL, 'ON', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:02:55', NULL, NULL, '192.168.1.100'),
(25835, NULL, 40.70, 58.50, 32.000, NULL, '2025-10-16 16:03:34', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:06:02', NULL, NULL, '192.168.1.100'),
(25836, NULL, 40.70, 58.50, 33.000, NULL, '2025-10-16 16:03:36', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:06:02', NULL, NULL, '192.168.1.100'),
(25837, NULL, 40.50, 58.90, 33.000, NULL, '2025-10-16 16:03:38', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:06:02', NULL, NULL, '192.168.1.100'),
(25838, NULL, 40.30, 59.00, 33.000, NULL, '2025-10-16 16:03:40', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:06:02', NULL, NULL, '192.168.1.100'),
(25839, NULL, 40.10, 59.30, 33.000, NULL, '2025-10-16 16:03:46', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:06:02', NULL, NULL, '192.168.1.100'),
(25840, NULL, 39.90, 59.80, 33.000, NULL, '2025-10-16 16:03:47', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:06:02', NULL, NULL, '192.168.1.100'),
(25841, NULL, 39.90, 59.80, 33.000, NULL, '2025-10-16 16:03:49', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:06:02', NULL, NULL, '192.168.1.100'),
(25842, NULL, 39.70, 60.30, 33.000, NULL, '2025-10-16 16:03:51', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:06:02', NULL, NULL, '192.168.1.100'),
(25843, NULL, 39.50, 60.40, 33.000, NULL, '2025-10-16 16:03:52', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:06:02', NULL, NULL, '192.168.1.100'),
(25844, NULL, 39.50, 60.40, 32.000, NULL, '2025-10-16 16:03:54', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:06:02', NULL, NULL, '192.168.1.100'),
(25845, NULL, 39.40, 60.50, 32.000, NULL, '2025-10-16 16:03:57', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:06:02', NULL, NULL, '192.168.1.100'),
(25846, NULL, 39.30, 60.90, 32.000, NULL, '2025-10-16 16:03:59', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:06:02', NULL, NULL, '192.168.1.100'),
(25847, NULL, 39.30, 60.90, 32.000, NULL, '2025-10-16 16:04:01', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:06:02', NULL, NULL, '192.168.1.100'),
(25848, NULL, 39.10, 61.30, 32.000, NULL, '2025-10-16 16:04:04', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:06:02', NULL, NULL, '192.168.1.100'),
(25849, NULL, 39.10, 61.30, 32.000, NULL, '2025-10-16 16:04:06', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:06:02', NULL, NULL, '192.168.1.100'),
(25850, NULL, 38.80, 61.80, 32.000, NULL, '2025-10-16 16:04:08', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:06:02', NULL, NULL, '192.168.1.100'),
(25851, NULL, 38.80, 61.80, 32.000, NULL, '2025-10-16 16:04:10', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:06:02', NULL, NULL, '192.168.1.100'),
(25852, NULL, 38.60, 62.10, 32.000, NULL, '2025-10-16 16:04:12', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:06:02', NULL, NULL, '192.168.1.100'),
(25853, NULL, 38.40, 62.10, 32.000, NULL, '2025-10-16 16:04:14', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:06:02', NULL, NULL, '192.168.1.100'),
(25854, NULL, 38.40, 62.10, 32.000, NULL, '2025-10-16 16:04:16', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:06:02', NULL, NULL, '192.168.1.100'),
(25855, NULL, 38.30, 62.30, 32.000, NULL, '2025-10-16 16:04:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:06:02', NULL, NULL, '192.168.1.100'),
(25856, NULL, 38.20, 62.60, 32.000, NULL, '2025-10-16 16:04:20', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:06:02', NULL, NULL, '192.168.1.100'),
(25857, NULL, 38.00, 63.10, 32.000, NULL, '2025-10-16 16:04:22', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:06:02', NULL, NULL, '192.168.1.100'),
(25858, NULL, 38.00, 63.10, 32.000, NULL, '2025-10-16 16:04:24', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:06:02', NULL, NULL, '192.168.1.100'),
(25859, NULL, 37.90, 63.40, 32.000, NULL, '2025-10-16 16:04:26', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:06:02', NULL, NULL, '192.168.1.100'),
(25860, NULL, 37.90, 63.40, 32.000, NULL, '2025-10-16 16:04:28', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:06:02', NULL, NULL, '192.168.1.100'),
(25861, NULL, 37.80, 63.60, 32.000, NULL, '2025-10-16 16:04:30', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:06:02', NULL, NULL, '192.168.1.100'),
(25862, NULL, 37.60, 63.90, 33.000, NULL, '2025-10-16 16:04:32', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:06:02', NULL, NULL, '192.168.1.100'),
(25863, NULL, 37.50, 64.10, 33.000, NULL, '2025-10-16 16:04:36', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:06:02', NULL, NULL, '192.168.1.100'),
(25864, NULL, 37.40, 64.30, 33.000, NULL, '2025-10-16 16:04:38', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:06:02', NULL, NULL, '192.168.1.100'),
(25865, NULL, 37.40, 64.30, 33.000, NULL, '2025-10-16 16:04:39', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:06:02', NULL, NULL, '192.168.1.100'),
(25866, NULL, 37.30, 64.50, 33.000, NULL, '2025-10-16 16:04:41', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:06:02', NULL, NULL, '192.168.1.100'),
(25867, NULL, 37.20, 64.80, 32.000, NULL, '2025-10-16 16:04:44', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:06:02', NULL, NULL, '192.168.1.100'),
(25868, NULL, 37.10, 65.10, 33.000, NULL, '2025-10-16 16:04:48', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:06:02', NULL, NULL, '192.168.1.100'),
(25869, NULL, 36.90, 65.80, 33.000, NULL, '2025-10-16 16:04:50', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:06:02', NULL, NULL, '192.168.1.100'),
(25870, NULL, 36.80, 66.10, 33.000, NULL, '2025-10-16 16:04:52', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:06:02', NULL, NULL, '192.168.1.100'),
(25871, NULL, 36.80, 66.00, 32.000, NULL, '2025-10-16 16:04:55', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:06:02', NULL, NULL, '192.168.1.100'),
(25872, NULL, 36.80, 66.00, 33.000, NULL, '2025-10-16 16:04:57', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:06:02', NULL, NULL, '192.168.1.100'),
(25873, NULL, 36.70, 66.30, 33.000, NULL, '2025-10-16 16:04:59', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:06:02', NULL, NULL, '192.168.1.100'),
(25874, NULL, 36.70, 66.30, 33.000, NULL, '2025-10-16 16:05:01', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:06:02', NULL, NULL, '192.168.1.100'),
(25875, NULL, 36.50, 66.50, 33.000, NULL, '2025-10-16 16:05:03', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:06:02', NULL, NULL, '192.168.1.100'),
(25876, NULL, 36.40, 66.60, 33.000, NULL, '2025-10-16 16:05:04', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:06:02', NULL, NULL, '192.168.1.100'),
(25877, NULL, 36.40, 66.80, 33.000, NULL, '2025-10-16 16:05:09', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:06:02', NULL, NULL, '192.168.1.100'),
(25878, NULL, 36.20, 67.50, 33.000, NULL, '2025-10-16 16:05:12', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:06:02', NULL, NULL, '192.168.1.100'),
(25879, NULL, 36.20, 67.50, 33.000, NULL, '2025-10-16 16:05:13', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:06:02', NULL, NULL, '192.168.1.100'),
(25880, NULL, 36.20, 67.90, 33.000, NULL, '2025-10-16 16:05:18', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:06:02', NULL, NULL, '192.168.1.100'),
(25881, NULL, 36.00, 79.60, 32.000, NULL, '2025-10-16 16:05:21', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:06:02', NULL, NULL, '192.168.1.100'),
(25882, NULL, 36.00, 79.60, 33.000, NULL, '2025-10-16 16:05:23', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:06:02', NULL, NULL, '192.168.1.100'),
(25883, NULL, 36.00, 73.20, 33.000, NULL, '2025-10-16 16:05:24', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:06:02', NULL, NULL, '192.168.1.100'),
(25884, NULL, 35.90, 70.70, 33.000, NULL, '2025-10-16 16:05:26', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:06:02', NULL, NULL, '192.168.1.100'),
(25885, NULL, 35.90, 70.70, 33.000, NULL, '2025-10-16 16:05:28', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:06:02', NULL, NULL, '192.168.1.100'),
(25886, NULL, 35.90, 70.00, 33.000, NULL, '2025-10-16 16:05:30', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:06:02', NULL, NULL, '192.168.1.100'),
(25887, NULL, 35.80, 69.70, 33.000, NULL, '2025-10-16 16:05:32', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:06:02', NULL, NULL, '192.168.1.100'),
(25888, NULL, 35.80, 69.70, 33.000, NULL, '2025-10-16 16:05:34', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:06:02', NULL, NULL, '192.168.1.100'),
(25889, NULL, 35.70, 69.70, 33.000, NULL, '2025-10-16 16:05:36', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:06:02', NULL, NULL, '192.168.1.100'),
(25890, NULL, 35.70, 70.00, 33.000, NULL, '2025-10-16 16:05:39', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:06:02', NULL, NULL, '192.168.1.100'),
(25891, NULL, 35.70, 70.00, 33.000, NULL, '2025-10-16 16:05:41', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:06:02', NULL, NULL, '192.168.1.100'),
(25892, NULL, 35.60, 70.10, 33.000, NULL, '2025-10-16 16:05:44', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:06:02', NULL, NULL, '192.168.1.100'),
(25893, NULL, 35.60, 70.10, 33.000, NULL, '2025-10-16 16:05:46', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:06:02', NULL, NULL, '192.168.1.100'),
(25894, NULL, 35.50, 70.20, 33.000, NULL, '2025-10-16 16:05:48', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:06:02', NULL, NULL, '192.168.1.100'),
(25895, NULL, 35.50, 70.20, 33.000, NULL, '2025-10-16 16:05:50', NULL, NULL, 'OFF', 'AUTO', 0, 'buffer', 'good', '2025-10-16 08:06:02', NULL, NULL, '192.168.1.100');

-- --------------------------------------------------------

--
-- Table structure for table `reports`
--

CREATE TABLE `reports` (
  `id` int(11) NOT NULL,
  `device_id` int(11) DEFAULT NULL,
  `report_type` enum('daily','weekly','monthly') NOT NULL,
  `report_date` date NOT NULL,
  `data` longtext NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `schedules`
--

CREATE TABLE `schedules` (
  `id` int(11) NOT NULL,
  `device_id` int(11) NOT NULL,
  `schedule_name` varchar(100) NOT NULL,
  `action` varchar(50) NOT NULL,
  `schedule_time` time NOT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `sensor_data`
--

CREATE TABLE `sensor_data` (
  `id` int(11) NOT NULL,
  `device_id` int(11) NOT NULL,
  `temperature` decimal(5,2) DEFAULT NULL,
  `humidity` decimal(5,2) DEFAULT NULL,
  `ammonia` decimal(8,3) DEFAULT NULL,
  `thermal_data` text DEFAULT NULL,
  `timestamp` datetime NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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

-- --------------------------------------------------------

--
-- Table structure for table `weekly_report_cache`
--

CREATE TABLE `weekly_report_cache` (
  `id` int(11) NOT NULL,
  `week_start` date NOT NULL,
  `week_end` date NOT NULL,
  `temp_min` decimal(10,2) DEFAULT NULL,
  `temp_max` decimal(10,2) DEFAULT NULL,
  `temp_avg` decimal(10,2) DEFAULT NULL,
  `humidity_min` decimal(10,2) DEFAULT NULL,
  `humidity_max` decimal(10,2) DEFAULT NULL,
  `humidity_avg` decimal(10,2) DEFAULT NULL,
  `ammonia_min` decimal(10,2) DEFAULT NULL,
  `ammonia_max` decimal(10,2) DEFAULT NULL,
  `ammonia_avg` decimal(10,2) DEFAULT NULL,
  `pump_total_time` int(11) DEFAULT 0,
  `heat_total_time` int(11) DEFAULT 0,
  `pump_triggers` int(11) DEFAULT 0,
  `heat_triggers` int(11) DEFAULT 0,
  `total_alerts` int(11) DEFAULT 0,
  `temp_alerts` int(11) DEFAULT 0,
  `humidity_alerts` int(11) DEFAULT 0,
  `ammonia_alerts` int(11) DEFAULT 0,
  `data_points_count` int(11) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `weekly_report_generation`
--

CREATE TABLE `weekly_report_generation` (
  `id` int(11) NOT NULL,
  `week_start` date NOT NULL,
  `week_end` date NOT NULL,
  `generation_method` enum('pre_computed','raw_data') NOT NULL DEFAULT 'raw_data',
  `data_points_count` int(11) DEFAULT 0,
  `temperature_min` decimal(10,2) DEFAULT NULL,
  `temperature_max` decimal(10,2) DEFAULT NULL,
  `temperature_avg` decimal(10,2) DEFAULT NULL,
  `humidity_min` decimal(10,2) DEFAULT NULL,
  `humidity_max` decimal(10,2) DEFAULT NULL,
  `humidity_avg` decimal(10,2) DEFAULT NULL,
  `ammonia_min` decimal(10,2) DEFAULT NULL,
  `ammonia_max` decimal(10,2) DEFAULT NULL,
  `ammonia_avg` decimal(10,2) DEFAULT NULL,
  `pump_total_time` int(11) DEFAULT 0,
  `heat_total_time` int(11) DEFAULT 0,
  `pump_triggers` int(11) DEFAULT 0,
  `heat_triggers` int(11) DEFAULT 0,
  `total_alerts` int(11) DEFAULT 0,
  `temp_alerts` int(11) DEFAULT 0,
  `humidity_alerts` int(11) DEFAULT 0,
  `ammonia_alerts` int(11) DEFAULT 0,
  `generation_time` timestamp NOT NULL DEFAULT current_timestamp(),
  `generated_by` varchar(100) DEFAULT NULL,
  `api_endpoint` varchar(255) DEFAULT NULL,
  `processing_time_ms` int(11) DEFAULT NULL,
  `status` enum('success','error','partial') DEFAULT 'success',
  `error_message` text DEFAULT NULL
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
-- Indexes for table `alerts`
--
ALTER TABLE `alerts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_device_id` (`device_id`),
  ADD KEY `idx_alert_type` (`alert_type`),
  ADD KEY `idx_severity` (`severity`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_alert_timestamp` (`alert_timestamp`),
  ADD KEY `idx_created_at` (`created_at`),
  ADD KEY `idx_parameter_name` (`parameter_name`),
  ADD KEY `idx_alert_category` (`alert_category`);

--
-- Indexes for table `alert_notifications`
--
ALTER TABLE `alert_notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_alert_id` (`alert_id`),
  ADD KEY `idx_notification_type` (`notification_type`),
  ADD KEY `idx_status` (`status`);

--
-- Indexes for table `alert_thresholds`
--
ALTER TABLE `alert_thresholds`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_device_parameter` (`device_id`,`parameter_name`),
  ADD KEY `idx_parameter_type` (`parameter_type`),
  ADD KEY `idx_is_active` (`is_active`);

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
-- Indexes for table `reports`
--
ALTER TABLE `reports`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `schedules`
--
ALTER TABLE `schedules`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `sensor_data`
--
ALTER TABLE `sensor_data`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_device_id` (`device_id`),
  ADD KEY `idx_timestamp` (`timestamp`);

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
-- Indexes for table `weekly_report_cache`
--
ALTER TABLE `weekly_report_cache`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_week` (`week_start`,`week_end`),
  ADD KEY `idx_week_start` (`week_start`),
  ADD KEY `idx_week_end` (`week_end`);

--
-- Indexes for table `weekly_report_generation`
--
ALTER TABLE `weekly_report_generation`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_week_start` (`week_start`),
  ADD KEY `idx_week_end` (`week_end`),
  ADD KEY `idx_generation_time` (`generation_time`),
  ADD KEY `idx_status` (`status`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `activity_logs`
--
ALTER TABLE `activity_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=48;

--
-- AUTO_INCREMENT for table `alerts`
--
ALTER TABLE `alerts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `alert_notifications`
--
ALTER TABLE `alert_notifications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `alert_thresholds`
--
ALTER TABLE `alert_thresholds`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `control_events`
--
ALTER TABLE `control_events`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `daily_report`
--
ALTER TABLE `daily_report`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `device_schedules`
--
ALTER TABLE `device_schedules`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=49;

--
-- AUTO_INCREMENT for table `raw_sensor_data`
--
ALTER TABLE `raw_sensor_data`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25896;

--
-- AUTO_INCREMENT for table `reports`
--
ALTER TABLE `reports`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `schedules`
--
ALTER TABLE `schedules`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `sensor_data`
--
ALTER TABLE `sensor_data`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `weekly_report`
--
ALTER TABLE `weekly_report`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `weekly_report_cache`
--
ALTER TABLE `weekly_report_cache`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `weekly_report_generation`
--
ALTER TABLE `weekly_report_generation`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `alert_notifications`
--
ALTER TABLE `alert_notifications`
  ADD CONSTRAINT `alert_notifications_ibfk_1` FOREIGN KEY (`alert_id`) REFERENCES `alerts` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

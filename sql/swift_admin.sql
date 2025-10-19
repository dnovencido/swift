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
-- Database: `swift_admin`
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
  `severity` enum('low','medium','high','critical') DEFAULT 'low',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `activity_logs`
--

INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `severity`, `created_at`) VALUES
(1, 1, 'system_init', 'SWIFT IoT System initialized and database restored', '127.0.0.1', 'low', '2025-10-15 03:12:24'),
(2, 1, 'admin_action', 'Created new user \'Godwin\' (ID: 3)', '::1', 'low', '2025-10-15 03:17:25'),
(3, 1, 'admin_action', 'Updated user \'Godwin\' (ID: 3) (profile)', '::1', 'low', '2025-10-15 03:24:10'),
(4, 1, 'admin_action', 'Created new farm \'Casem Farm\' (ID: 2)', '::1', 'low', '2025-10-15 03:25:55'),
(5, 1, 'admin_action', 'Assigned device \'Casem Device\' (IP: 192.168.1.11) to user \'Godwin\' (Device ID: 2)', '::1', 'low', '2025-10-15 03:27:24'),
(6, 1, 'logout', 'Admin user \'admin\' logged out', '::1', 'low', '2025-10-15 03:28:11'),
(7, 3, 'login', 'Admin user \'Godwin\' logged in', '::1', 'low', '2025-10-15 03:28:18'),
(8, 3, 'logout', 'Admin user \'Godwin\' logged out', '::1', 'low', '2025-10-15 03:32:32'),
(9, 1, 'login', 'Admin user \'admin\' logged in', '::1', 'low', '2025-10-15 03:32:59'),
(10, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-15 03:33:05'),
(11, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-15 03:33:09'),
(12, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-15 03:33:15'),
(13, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-15 03:33:20'),
(14, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-15 03:33:24'),
(15, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-15 03:33:30'),
(16, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-15 03:33:37'),
(17, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-15 03:33:42'),
(18, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-15 03:43:31'),
(19, 1, 'logout', 'Admin user \'admin\' logged out', '::1', 'low', '2025-10-15 03:43:52'),
(20, 3, 'login', 'Admin user \'Godwin\' logged in', '::1', 'low', '2025-10-15 03:43:59'),
(21, 3, 'logout', 'Admin user \'Godwin\' logged out', '::1', 'low', '2025-10-15 03:44:38'),
(22, 3, 'login', 'Admin user \'Godwin\' logged in', '::1', 'low', '2025-10-15 03:51:14'),
(23, 3, 'logout', 'Admin user \'Godwin\' logged out', '::1', 'low', '2025-10-15 03:52:43'),
(24, 3, 'login', 'Admin user \'Godwin\' logged in', '::1', 'low', '2025-10-15 03:52:55'),
(25, 3, 'logout', 'Admin user \'Godwin\' logged out', '::1', 'low', '2025-10-15 03:54:19'),
(27, 1, 'login', 'Admin user \'admin\' logged in', '::1', 'low', '2025-10-16 05:06:42'),
(28, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 05:06:47'),
(29, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 05:06:52'),
(30, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 05:06:57'),
(31, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 05:07:12'),
(32, 1, 'logout', 'Admin user \'admin\' logged out', '::1', 'low', '2025-10-16 05:07:15'),
(33, 3, 'login', 'Admin user \'Godwin\' logged in', '::1', 'low', '2025-10-16 05:07:21'),
(34, 3, 'logout', 'Admin user \'Godwin\' logged out', '::1', 'low', '2025-10-16 05:17:25'),
(35, 1, 'login', 'Admin user \'admin\' logged in', '::1', 'low', '2025-10-16 05:17:31'),
(36, 1, 'admin_action', 'Assigned device \'Casem Farm 2\' (IP: 192.168.1.100) to user \'Godwin\' (Device ID: 3)', '::1', 'low', '2025-10-16 05:18:22'),
(37, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 05:18:30'),
(38, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 05:18:37'),
(39, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 05:18:40'),
(40, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 05:18:47'),
(41, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 05:18:51'),
(42, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 05:18:57'),
(43, 1, 'logout', 'Admin user \'admin\' logged out', '::1', 'low', '2025-10-16 05:19:03'),
(44, 3, 'login', 'Admin user \'Godwin\' logged in', '::1', 'low', '2025-10-16 05:19:11'),
(45, NULL, 'admin_action', 'Unauthorized data transmission attempt from unassigned device IP: 192.168.1.182', '192.168.1.182', 'low', '2025-10-16 05:32:29'),
(46, NULL, 'admin_action', 'Unauthorized data transmission attempt from unassigned device IP: 192.168.1.182', '192.168.1.182', 'low', '2025-10-16 05:32:34'),
(47, NULL, 'admin_action', 'Unauthorized data transmission attempt from unassigned device IP: 192.168.1.182', '192.168.1.182', 'low', '2025-10-16 05:33:50'),
(48, NULL, 'admin_action', 'Unauthorized data transmission attempt from unassigned device IP: 192.168.1.182', '192.168.1.182', 'low', '2025-10-16 05:49:05'),
(49, NULL, 'admin_action', 'Unauthorized data transmission attempt from unassigned device IP: ::1', '::1', 'low', '2025-10-16 05:58:53'),
(50, NULL, 'admin_action', 'Unauthorized data transmission attempt from unassigned device IP: ::1', '::1', 'low', '2025-10-16 06:04:17'),
(51, 3, 'logout', 'Admin user \'Godwin\' logged out', '::1', 'low', '2025-10-16 06:37:20'),
(52, 1, 'login', 'Admin user \'admin\' logged in', '::1', 'low', '2025-10-16 06:37:27'),
(53, 1, 'admin_action', 'Assigned device \'Casem Farm\' (IP: 192.168.1.100) to user \'Godwin\' (Device ID: 4)', '::1', 'low', '2025-10-16 06:38:22'),
(54, 1, 'logout', 'Admin user \'admin\' logged out', '::1', 'low', '2025-10-16 06:38:26'),
(55, 3, 'login', 'Admin user \'Godwin\' logged in', '::1', 'low', '2025-10-16 06:38:34'),
(56, NULL, 'admin_action', 'Unauthorized data transmission attempt from unassigned device IP: 192.168.1.182', '192.168.1.182', 'low', '2025-10-16 06:48:24'),
(57, 3, 'logout', 'Admin user \'Godwin\' logged out', '::1', 'low', '2025-10-16 06:53:13'),
(58, 1, 'login', 'Admin user \'admin\' logged in', '::1', 'low', '2025-10-16 06:53:19'),
(59, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 06:53:24'),
(60, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 06:53:29'),
(61, 1, 'logout', 'Admin user \'admin\' logged out', '::1', 'low', '2025-10-16 06:53:33'),
(62, 3, 'login', 'Admin user \'Godwin\' logged in', '::1', 'low', '2025-10-16 06:53:43'),
(63, 3, 'logout', 'Admin user \'Godwin\' logged out', '::1', 'low', '2025-10-16 07:05:10'),
(64, 1, 'login', 'Admin user \'admin\' logged in', '::1', 'low', '2025-10-16 07:05:16'),
(65, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:05:21'),
(66, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:05:26'),
(67, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:05:37'),
(68, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:05:42'),
(69, NULL, 'admin_action', 'Admin manually checked device \'Casem Farm\' (ID: 4) for status and component health', '::1', 'low', '2025-10-16 07:05:47'),
(70, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:05:47'),
(71, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:05:52'),
(72, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:05:57'),
(73, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:06:02'),
(74, 1, 'logout', 'Admin user \'admin\' logged out', '::1', 'low', '2025-10-16 07:06:04'),
(75, 3, 'login', 'Admin user \'Godwin\' logged in', '::1', 'low', '2025-10-16 07:06:17'),
(76, 3, 'logout', 'Admin user \'Godwin\' logged out', '::1', 'low', '2025-10-16 07:09:05'),
(77, 1, 'login', 'Admin user \'admin\' logged in', '::1', 'low', '2025-10-16 07:09:16'),
(78, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:09:21'),
(79, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:09:26'),
(80, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:09:31'),
(81, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:09:36'),
(82, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:09:41'),
(83, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:09:46'),
(84, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:09:51'),
(85, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:09:57'),
(86, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:10:03'),
(87, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:10:08'),
(88, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:10:14'),
(89, 1, 'logout', 'Admin user \'admin\' logged out', '::1', 'low', '2025-10-16 07:10:27'),
(90, 3, 'login', 'Admin user \'Godwin\' logged in', '::1', 'low', '2025-10-16 07:10:33'),
(91, 3, 'logout', 'Admin user \'Godwin\' logged out', '::1', 'low', '2025-10-16 07:12:32'),
(92, 1, 'login', 'Admin user \'admin\' logged in', '::1', 'low', '2025-10-16 07:12:37'),
(93, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:12:42'),
(94, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:12:47'),
(95, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:12:52'),
(96, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:12:58'),
(97, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:13:03'),
(98, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:13:07'),
(99, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:13:12'),
(100, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:13:17'),
(101, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:13:22'),
(102, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:13:27'),
(103, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:13:32'),
(104, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:13:37'),
(105, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:13:44'),
(106, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:13:47'),
(107, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:13:52'),
(108, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:13:57'),
(109, NULL, 'admin_action', 'Admin manually checked device \'Casem Farm\' (ID: 4) for status and component health', '::1', 'low', '2025-10-16 07:14:02'),
(110, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:14:03'),
(111, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:14:05'),
(112, NULL, 'admin_action', 'Admin manually checked device \'Casem Farm\' (ID: 4) for status and component health', '::1', 'low', '2025-10-16 07:14:07'),
(113, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:14:10'),
(114, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:14:16'),
(115, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:14:18'),
(116, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:14:24'),
(117, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:14:27'),
(118, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:14:33'),
(119, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:14:37'),
(120, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:14:44'),
(121, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:14:48'),
(122, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:14:53'),
(123, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:14:57'),
(124, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:15:02'),
(125, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:15:07'),
(126, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:15:12'),
(127, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:15:17'),
(128, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:15:22'),
(129, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:15:27'),
(130, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:15:32'),
(131, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:15:37'),
(132, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:15:42'),
(133, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:15:47'),
(134, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:15:52'),
(135, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:15:57'),
(136, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:16:02'),
(137, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:16:07'),
(138, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:16:12'),
(139, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:16:17'),
(140, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:16:22'),
(141, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:16:27'),
(142, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:16:32'),
(143, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:16:37'),
(144, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:16:42'),
(145, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:16:47'),
(146, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:16:52'),
(147, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:16:57'),
(148, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:17:02'),
(149, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:17:07'),
(150, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:17:12'),
(151, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:17:17'),
(152, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:17:22'),
(153, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:17:27'),
(154, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:17:32'),
(155, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:17:37'),
(156, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:17:42'),
(157, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:17:47'),
(158, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:17:52'),
(159, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:17:59'),
(160, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:18:04'),
(161, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:18:09'),
(162, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:18:14'),
(163, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:18:19'),
(164, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:18:25'),
(165, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:18:33'),
(166, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:18:40'),
(167, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:18:47'),
(168, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:18:53'),
(169, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:18:58'),
(170, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:19:00'),
(171, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:19:05'),
(172, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:19:12'),
(173, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:19:17'),
(174, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:19:22'),
(175, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:19:28'),
(176, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:19:33'),
(177, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:19:37'),
(178, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:19:42'),
(179, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:19:45'),
(180, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:19:50'),
(181, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:19:55'),
(182, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:20:01'),
(183, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:20:05'),
(184, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:20:10'),
(185, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:20:15'),
(186, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:20:20'),
(187, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:20:25'),
(188, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:20:30'),
(189, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:20:35'),
(190, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:20:40'),
(191, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:20:49'),
(192, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:21:03'),
(193, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:21:08'),
(194, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:21:13'),
(195, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:21:21'),
(196, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:21:27'),
(197, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:21:47'),
(198, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:21:52'),
(199, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:21:57'),
(200, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:22:02'),
(201, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:22:07'),
(202, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:22:17'),
(203, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:22:22'),
(204, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:22:31'),
(205, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:22:36'),
(206, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:22:41'),
(207, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:22:46'),
(208, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:22:51'),
(209, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:22:56'),
(210, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:23:01'),
(211, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:23:06'),
(212, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:23:11'),
(213, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:23:16'),
(214, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:23:21'),
(215, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:23:26'),
(216, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:23:31'),
(217, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:23:36'),
(218, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:23:41'),
(219, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:23:46'),
(220, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:23:51'),
(221, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:23:56'),
(222, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:24:01'),
(223, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:24:06'),
(224, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:24:11'),
(225, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:24:16'),
(226, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:24:21'),
(227, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:24:26'),
(228, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:24:31'),
(229, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:24:36'),
(230, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:24:41'),
(231, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:24:46'),
(232, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:24:51'),
(233, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:24:56'),
(234, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:25:01'),
(235, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:25:06'),
(236, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:25:11'),
(237, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:25:16'),
(238, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:25:21'),
(239, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:25:26'),
(240, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:25:31'),
(241, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:25:36'),
(242, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:25:41'),
(243, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:25:46'),
(244, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:25:51'),
(245, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:25:56'),
(246, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:26:01'),
(247, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:26:06'),
(248, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:26:11'),
(249, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:26:16'),
(250, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:26:21'),
(251, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:26:26'),
(252, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:26:31'),
(253, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:26:36'),
(254, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:26:41'),
(255, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:26:46'),
(256, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:26:51'),
(257, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:26:56'),
(258, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:27:01'),
(259, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:27:06'),
(260, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:27:11'),
(261, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:27:16'),
(262, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:27:21'),
(263, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:27:26'),
(264, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:27:31'),
(265, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:27:36'),
(266, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:27:41'),
(267, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:27:46'),
(268, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:27:51'),
(269, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:27:56'),
(270, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:28:01'),
(271, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:28:06'),
(272, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:28:11'),
(273, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:28:16'),
(274, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:28:21'),
(275, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:28:26'),
(276, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:28:31'),
(277, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:28:36'),
(278, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:28:41'),
(279, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:28:46'),
(280, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:28:51'),
(281, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:28:56'),
(282, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:29:01'),
(283, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:29:06'),
(284, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:29:11'),
(285, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:29:16'),
(286, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:29:21'),
(287, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:29:26'),
(288, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:29:31'),
(289, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:29:36'),
(290, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:29:41'),
(291, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:29:46'),
(292, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:29:51'),
(293, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:29:56'),
(294, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:30:01'),
(295, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:30:06'),
(296, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:30:11'),
(297, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:30:16'),
(298, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:30:21'),
(299, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:30:26'),
(300, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:30:31'),
(301, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:30:36'),
(302, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:30:41'),
(303, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:30:46'),
(304, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:30:51'),
(305, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:30:56'),
(306, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:31:01'),
(307, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:31:06'),
(308, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:31:11'),
(309, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:31:16'),
(310, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:31:21'),
(311, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:31:26'),
(312, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:31:31'),
(313, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:31:36'),
(314, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:31:41'),
(315, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:31:46'),
(316, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:31:51'),
(317, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:31:56'),
(318, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:32:01'),
(319, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:32:06'),
(320, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:32:11'),
(321, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:32:16'),
(322, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:32:21'),
(323, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:32:26'),
(324, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:32:31'),
(325, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:32:36'),
(326, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:32:41'),
(327, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:32:46'),
(328, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:32:51'),
(329, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:32:56'),
(330, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:33:01'),
(331, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:33:06'),
(332, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:33:11'),
(333, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:33:16'),
(334, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:33:21'),
(335, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:33:26'),
(336, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:33:31'),
(337, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:33:36'),
(338, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:33:41'),
(339, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:33:46'),
(340, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:33:51'),
(341, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:33:56'),
(342, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:34:01'),
(343, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:34:06'),
(344, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:34:11'),
(345, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:34:16'),
(346, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:34:21'),
(347, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:34:26'),
(348, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:34:31'),
(349, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:34:36'),
(350, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:34:41'),
(351, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:34:46'),
(352, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:34:51'),
(353, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:34:56'),
(354, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:35:01'),
(355, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:35:06'),
(356, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:35:11'),
(357, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:35:16'),
(358, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:35:21'),
(359, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:35:26'),
(360, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:35:31'),
(361, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:35:36'),
(362, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:35:41'),
(363, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:35:46'),
(364, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:35:51'),
(365, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:35:56'),
(366, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:36:01'),
(367, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:36:06'),
(368, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:36:11'),
(369, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:36:16'),
(370, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:36:21'),
(371, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:36:26'),
(372, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:36:31'),
(373, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:36:36'),
(374, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:36:41'),
(375, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:36:46'),
(376, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:36:51'),
(377, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:36:56'),
(378, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:37:01'),
(379, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:37:06'),
(380, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:37:11'),
(381, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:37:16'),
(382, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:37:21'),
(383, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:37:26'),
(384, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:37:31'),
(385, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:37:36');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `severity`, `created_at`) VALUES
(386, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:37:41'),
(387, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:37:46'),
(388, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:37:51'),
(389, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:37:56'),
(390, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:38:01'),
(391, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:38:06'),
(392, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:38:11'),
(393, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:38:16'),
(394, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:38:21'),
(395, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:38:26'),
(396, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:38:31'),
(397, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:38:38'),
(398, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:38:44'),
(399, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:38:49'),
(400, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:38:53'),
(401, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:38:56'),
(402, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:39:01'),
(403, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:39:06'),
(404, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:39:11'),
(405, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:39:16'),
(406, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:39:21'),
(407, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:39:32'),
(408, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:39:37'),
(409, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:39:43'),
(410, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:39:49'),
(411, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:39:54'),
(412, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:39:59'),
(413, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:40:04'),
(414, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:40:09'),
(415, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:40:14'),
(416, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:40:19'),
(417, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:40:24'),
(418, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:40:29'),
(419, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:40:34'),
(420, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:40:39'),
(421, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:40:44'),
(422, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:40:49'),
(423, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:40:54'),
(424, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:40:59'),
(425, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:41:04'),
(426, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:41:09'),
(427, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:41:14'),
(428, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:41:19'),
(429, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:41:24'),
(430, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:41:29'),
(431, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:41:34'),
(432, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:41:39'),
(433, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:41:44'),
(434, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:41:49'),
(435, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:41:54'),
(436, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:41:59'),
(437, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:42:04'),
(438, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:42:09'),
(439, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:42:14'),
(440, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:42:19'),
(441, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:42:25'),
(442, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:42:29'),
(443, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:42:34'),
(444, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:42:39'),
(445, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:42:44'),
(446, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:42:49'),
(447, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:42:54'),
(448, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:42:59'),
(449, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:43:04'),
(450, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:43:09'),
(451, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:43:42'),
(452, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:44:12'),
(453, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:44:17'),
(454, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:44:23'),
(455, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:44:29'),
(456, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:44:34'),
(457, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:44:39'),
(458, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:44:41'),
(459, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:44:47'),
(460, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:44:49'),
(461, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:44:54'),
(462, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:44:59'),
(463, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:45:04'),
(464, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:45:09'),
(465, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:45:14'),
(466, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:45:19'),
(467, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:45:24'),
(468, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:45:29'),
(469, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:45:34'),
(470, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:45:39'),
(471, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:45:44'),
(472, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:45:49'),
(473, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:45:54'),
(474, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:46:10'),
(475, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:46:17'),
(476, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:46:22'),
(477, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:46:27'),
(478, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:46:32'),
(479, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:46:37'),
(480, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:46:42'),
(481, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:46:49'),
(482, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:46:54'),
(483, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:46:59'),
(484, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:47:04'),
(485, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:47:09'),
(486, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:47:14'),
(487, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:47:19'),
(488, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:47:24'),
(489, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:47:29'),
(490, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:47:34'),
(491, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:47:39'),
(492, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:47:44'),
(493, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:47:49'),
(494, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:47:54'),
(495, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:47:59'),
(496, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:48:04'),
(497, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:48:09'),
(498, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:48:14'),
(499, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:48:19'),
(500, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:48:24'),
(501, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:48:29'),
(502, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:48:34'),
(503, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:48:39'),
(504, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:48:44'),
(505, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:48:49'),
(506, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:48:54'),
(507, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:48:59'),
(508, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:49:42'),
(509, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:50:42'),
(510, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:51:42'),
(511, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:52:43'),
(512, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:53:42'),
(513, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:54:42'),
(514, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:55:42'),
(515, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:56:28'),
(516, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:56:30'),
(517, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:56:36'),
(518, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:56:41'),
(519, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:56:47'),
(520, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:56:53'),
(521, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:56:58'),
(522, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:57:03'),
(523, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:57:28'),
(524, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:57:33'),
(525, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:57:38'),
(526, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:57:43'),
(527, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:57:50'),
(528, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:57:55'),
(529, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:58:00'),
(530, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:58:10'),
(531, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:58:15'),
(532, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:58:20'),
(533, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-16 07:58:25'),
(534, 1, 'logout', 'Admin user \'admin\' logged out', '::1', 'low', '2025-10-16 07:58:29'),
(535, 3, 'login', 'Admin user \'Godwin\' logged in', '::1', 'low', '2025-10-16 07:58:44');

-- --------------------------------------------------------

--
-- Table structure for table `devices`
--

CREATE TABLE `devices` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `farm_id` int(11) DEFAULT NULL,
  `device_name` varchar(191) NOT NULL,
  `device_code` varchar(50) NOT NULL,
  `device_type` enum('sensor','controller') DEFAULT 'sensor',
  `ip_address` varchar(64) NOT NULL,
  `static_ip` tinyint(1) DEFAULT 1,
  `mac_address` varchar(17) DEFAULT NULL,
  `status` enum('up','down','maintenance') DEFAULT 'down',
  `last_seen` datetime DEFAULT NULL,
  `temp_humidity_sensor` enum('active','error','offline') DEFAULT 'offline',
  `ammonia_sensor` enum('active','error','offline') DEFAULT 'offline',
  `thermal_camera` enum('active','error','offline') DEFAULT 'offline',
  `sd_card_module` enum('active','error','offline') DEFAULT 'offline',
  `rtc_module` enum('active','error','offline') DEFAULT 'offline',
  `arduino_timestamp` enum('active','error','offline') DEFAULT 'active' COMMENT 'Arduino built-in timestamp (always active)',
  `component_last_checked` datetime DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `devices`
--

INSERT INTO `devices` (`id`, `user_id`, `farm_id`, `device_name`, `device_code`, `device_type`, `ip_address`, `static_ip`, `mac_address`, `status`, `last_seen`, `temp_humidity_sensor`, `ammonia_sensor`, `thermal_camera`, `sd_card_module`, `rtc_module`, `arduino_timestamp`, `component_last_checked`, `is_active`, `created_at`, `updated_at`) VALUES
(4, 3, 2, 'Casem Farm', 'D002', 'sensor', '192.168.1.100', 1, NULL, 'up', '2025-10-16 16:08:28', 'active', 'active', 'offline', 'offline', 'active', 'active', '2025-10-16 16:08:28', 1, '2025-10-16 06:38:22', '2025-10-16 08:08:28');

-- --------------------------------------------------------

--
-- Table structure for table `farms`
--

CREATE TABLE `farms` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `farm_name` varchar(191) NOT NULL,
  `farm_type` enum('poultry','livestock','greenhouse','mixed') DEFAULT 'mixed',
  `street` varchar(255) DEFAULT NULL,
  `barangay` varchar(255) DEFAULT NULL,
  `city` varchar(191) DEFAULT NULL,
  `province` varchar(191) DEFAULT NULL,
  `postal` varchar(20) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `farms`
--

INSERT INTO `farms` (`id`, `user_id`, `farm_name`, `farm_type`, `street`, `barangay`, `city`, `province`, `postal`, `is_active`, `created_at`, `updated_at`) VALUES
(2, 3, 'Casem Farm', 'mixed', 'Purok 1', 'Santiago Norte', 'San Fernando', 'La Union', '2500', 1, '2025-10-15 03:25:55', '2025-10-15 03:25:55');

-- --------------------------------------------------------

--
-- Table structure for table `system_settings`
--

CREATE TABLE `system_settings` (
  `id` int(11) NOT NULL,
  `setting_key` varchar(100) NOT NULL,
  `setting_value` text DEFAULT NULL,
  `setting_type` enum('string','number','boolean') DEFAULT 'string',
  `description` text DEFAULT NULL,
  `is_public` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `system_settings`
--

INSERT INTO `system_settings` (`id`, `setting_key`, `setting_value`, `setting_type`, `description`, `is_public`, `created_at`, `updated_at`) VALUES
(1, 'system_name', 'SWIFT IoT Smart Swine Farming System', 'string', 'System name', 1, '2025-10-15 03:12:24', '2025-10-15 03:12:24'),
(2, 'system_version', '2.1.0', 'string', 'System version', 1, '2025-10-15 03:12:24', '2025-10-15 03:12:24'),
(3, 'max_temperature', '35.0', 'number', 'Maximum temperature threshold', 1, '2025-10-15 03:12:24', '2025-10-15 03:12:24'),
(4, 'min_temperature', '18.0', 'number', 'Minimum temperature threshold', 1, '2025-10-15 03:12:24', '2025-10-15 03:12:24'),
(5, 'max_humidity', '80.0', 'number', 'Maximum humidity threshold', 1, '2025-10-15 03:12:24', '2025-10-15 03:12:24'),
(6, 'min_humidity', '40.0', 'number', 'Minimum humidity threshold', 1, '2025-10-15 03:12:24', '2025-10-15 03:12:24'),
(7, 'max_ammonia', '25.0', 'number', 'Maximum ammonia threshold', 1, '2025-10-15 03:12:24', '2025-10-15 03:12:24'),
(8, 'data_retention_days', '365', 'number', 'Days to retain sensor data', 0, '2025-10-15 03:12:24', '2025-10-15 03:12:24'),
(9, 'alert_email_enabled', 'true', 'boolean', 'Enable email alerts', 0, '2025-10-15 03:12:24', '2025-10-15 03:12:24'),
(10, 'maintenance_mode', 'false', 'boolean', 'System maintenance mode', 0, '2025-10-15 03:12:24', '2025-10-15 03:12:24');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(64) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role` enum('super_user','user','viewer') NOT NULL DEFAULT 'user',
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `password_hash`, `role`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'admin', '$2y$10$sp1aTD8EpKWY6xtLLut1.e/jWTQrUynrrOi5zDQ01FV.1jlNdLpmm', 'super_user', 1, '2025-10-15 03:12:24', '2025-10-15 03:12:24'),
(3, 'Godwin', '$2y$10$ki/dY5qclOOo8J4vtaquYuS4cmyazSeTsoiGjkw5DTQgCWru6XKUa', 'user', 1, '2025-10-15 03:17:25', '2025-10-15 03:17:25');

-- --------------------------------------------------------

--
-- Table structure for table `user_profiles`
--

CREATE TABLE `user_profiles` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `first_name` varchar(100) DEFAULT NULL,
  `last_name` varchar(100) DEFAULT NULL,
  `middle_name` varchar(100) DEFAULT NULL,
  `email` varchar(191) DEFAULT NULL,
  `addr_street` varchar(255) DEFAULT NULL,
  `addr_barangay` varchar(255) DEFAULT NULL,
  `addr_city` varchar(191) DEFAULT NULL,
  `addr_province` varchar(191) DEFAULT NULL,
  `addr_postal` varchar(20) DEFAULT NULL,
  `mobile` varchar(32) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `user_profiles`
--

INSERT INTO `user_profiles` (`id`, `user_id`, `first_name`, `last_name`, `middle_name`, `email`, `addr_street`, `addr_barangay`, `addr_city`, `addr_province`, `addr_postal`, `mobile`, `created_at`, `updated_at`) VALUES
(1, 1, 'System', 'Administrator', 'System', 'admin@swift.com', 'Admin Street', 'Admin Barangay', 'Admin City', 'Admin Province', '0000', '+63-XXX-XXX-XXXX', '2025-10-15 03:12:24', '2025-10-15 03:22:19'),
(3, 3, 'John Jesus Godwin', 'Quismorio', 'casem', 'jquismorio01282@student.dmmmsu.edu.ph', 'Purok 1', 'Santiago Norte', 'San Fernando', 'La Union', '2500', '09156659104', '2025-10-15 03:17:25', '2025-10-15 03:24:10');

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
  ADD KEY `idx_severity` (`severity`),
  ADD KEY `idx_created_at` (`created_at`);

--
-- Indexes for table `devices`
--
ALTER TABLE `devices`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `device_code` (`device_code`),
  ADD UNIQUE KEY `ip_address` (`ip_address`),
  ADD KEY `fk_devices_user` (`user_id`),
  ADD KEY `fk_devices_farm` (`farm_id`),
  ADD KEY `idx_device_code` (`device_code`),
  ADD KEY `idx_ip_address` (`ip_address`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_last_seen` (`last_seen`),
  ADD KEY `idx_component_last_checked` (`component_last_checked`),
  ADD KEY `idx_is_active` (`is_active`),
  ADD KEY `idx_static_ip` (`static_ip`);

--
-- Indexes for table `farms`
--
ALTER TABLE `farms`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_farm_type` (`farm_type`),
  ADD KEY `idx_is_active` (`is_active`);

--
-- Indexes for table `system_settings`
--
ALTER TABLE `system_settings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `setting_key` (`setting_key`),
  ADD KEY `idx_setting_key` (`setting_key`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD KEY `idx_username` (`username`),
  ADD KEY `idx_role` (`role`),
  ADD KEY `idx_is_active` (`is_active`),
  ADD KEY `idx_created_at` (`created_at`);

--
-- Indexes for table `user_profiles`
--
ALTER TABLE `user_profiles`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_email` (`email`),
  ADD KEY `idx_mobile` (`mobile`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `activity_logs`
--
ALTER TABLE `activity_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=536;

--
-- AUTO_INCREMENT for table `devices`
--
ALTER TABLE `devices`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `farms`
--
ALTER TABLE `farms`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `system_settings`
--
ALTER TABLE `system_settings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `user_profiles`
--
ALTER TABLE `user_profiles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `activity_logs`
--
ALTER TABLE `activity_logs`
  ADD CONSTRAINT `fk_activity_logs_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `devices`
--
ALTER TABLE `devices`
  ADD CONSTRAINT `fk_devices_farm` FOREIGN KEY (`farm_id`) REFERENCES `farms` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_devices_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `farms`
--
ALTER TABLE `farms`
  ADD CONSTRAINT `fk_farms_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `user_profiles`
--
ALTER TABLE `user_profiles`
  ADD CONSTRAINT `fk_profiles_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

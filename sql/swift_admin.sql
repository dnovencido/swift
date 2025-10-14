-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 14, 2025 at 08:45 AM
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
(428, 1, 'login', 'Admin user \'admin\' logged in', 'unknown', 'low', '2025-10-13 17:01:40'),
(429, 1, 'logout', 'Admin user \'admin\' logged out', 'unknown', 'low', '2025-10-13 17:01:40'),
(430, 1, 'login', 'Admin user \'admin\' logged in', 'unknown', 'low', '2025-10-13 17:05:20'),
(431, 1, 'logout', 'Admin user \'admin\' logged out', 'unknown', 'low', '2025-10-13 17:05:20'),
(432, 2, 'login', 'Admin user \'Godwin\' logged in', '::1', 'low', '2025-10-14 03:56:14'),
(433, 2, 'logout', 'Admin user \'Godwin\' logged out', '::1', 'low', '2025-10-14 06:16:45'),
(434, 1, 'login', 'Admin user \'admin\' logged in', '::1', 'low', '2025-10-14 06:16:53'),
(435, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-14 06:16:58'),
(436, 1, 'logout', 'Admin user \'admin\' logged out', '::1', 'low', '2025-10-14 06:19:41'),
(437, 2, 'login', 'Admin user \'Godwin\' logged in', '::1', 'low', '2025-10-14 06:19:48'),
(438, 2, 'logout', 'Admin user \'Godwin\' logged out', '::1', 'low', '2025-10-14 06:30:14'),
(439, 1, 'login', 'Admin user \'admin\' logged in', '::1', 'low', '2025-10-14 06:30:19'),
(440, 1, 'admin_action', 'Created new user \'user\' (ID: 3)', '::1', 'low', '2025-10-14 06:31:20'),
(441, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-14 06:31:29'),
(442, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-14 06:31:34'),
(443, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-14 06:31:39'),
(444, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-14 06:31:44'),
(445, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-14 06:31:49'),
(446, 1, 'logout', 'Admin user \'admin\' logged out', '::1', 'low', '2025-10-14 06:31:51'),
(447, NULL, 'login', 'Admin user \'user\' logged in', '::1', 'low', '2025-10-14 06:31:57'),
(448, NULL, 'logout', 'Admin user \'user\' logged out', '::1', 'low', '2025-10-14 06:42:37'),
(449, 1, 'login', 'Admin user \'admin\' logged in', '::1', 'low', '2025-10-14 06:42:46'),
(450, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-14 06:42:51'),
(451, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-14 06:42:56'),
(452, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-14 06:43:02'),
(453, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-14 06:43:07'),
(454, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-14 06:43:12'),
(455, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-14 06:43:17'),
(456, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-14 06:43:22'),
(457, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-14 06:43:27'),
(458, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-14 06:43:32'),
(459, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-14 06:43:37'),
(460, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-14 06:43:42'),
(461, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-14 06:43:47'),
(462, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-14 06:43:52'),
(463, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-14 06:43:57'),
(464, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-14 06:44:17'),
(465, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-14 06:44:21'),
(466, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-14 06:44:27'),
(467, NULL, 'admin_action', 'Admin manually checked all devices for status and component health', '::1', 'low', '2025-10-14 06:44:32');

-- --------------------------------------------------------

--
-- Table structure for table `devices`
--

CREATE TABLE `devices` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `farm_id` int(11) DEFAULT NULL,
  `device_name` varchar(191) NOT NULL,
  `device_code` varchar(50) DEFAULT NULL,
  `device_type` enum('sensor','controller') DEFAULT 'sensor',
  `ip_address` varchar(64) DEFAULT NULL,
  `status` enum('up','down','maintenance') DEFAULT 'down',
  `last_seen` datetime DEFAULT NULL,
  `temp_humidity_sensor` enum('active','error','offline') DEFAULT 'offline',
  `ammonia_sensor` enum('active','error','offline') DEFAULT 'offline',
  `thermal_camera` enum('active','error','offline') DEFAULT 'offline',
  `sd_card_module` enum('active','error','offline') DEFAULT 'offline',
  `rtc_module` enum('active','error','offline') DEFAULT 'offline',
  `arduino_timestamp` enum('active','error','offline') DEFAULT 'active' COMMENT 'Arduino built-in timestamp (always active)',
  `component_last_checked` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `devices`
--

INSERT INTO `devices` (`id`, `user_id`, `farm_id`, `device_name`, `device_code`, `device_type`, `ip_address`, `status`, `last_seen`, `temp_humidity_sensor`, `ammonia_sensor`, `thermal_camera`, `sd_card_module`, `rtc_module`, `arduino_timestamp`, `component_last_checked`, `created_at`, `updated_at`) VALUES
(3, 2, NULL, 'SWIFT Water Sprinkler Device .11', NULL, 'sensor', '192.168.1.11', 'up', '2025-10-14 14:45:30', 'active', 'active', 'offline', 'offline', 'offline', 'active', '2025-10-14 14:45:30', '2025-10-11 04:30:42', '2025-10-14 06:45:30');

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
(1, 2, 'Casem Farm 1', 'mixed', 'Purok 1', 'Santiago Norte', 'San Fernando', 'La Union', '2500', 1, '2025-10-07 17:32:54', '2025-10-07 17:32:54');

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
(1, 'admin', 'admin123', 'super_user', 1, '2025-10-07 17:12:39', '2025-10-07 17:29:31'),
(2, 'Godwin', '$2y$10$fcQJaaJgPeCHWcbbibIAa.nfMzkIvym9HYcJ/Yrlp4l5HZTb4hX0C', 'user', 1, '2025-10-07 17:31:36', '2025-10-07 17:31:36');

-- --------------------------------------------------------

--
-- Table structure for table `user_profiles`
--

CREATE TABLE `user_profiles` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `first_name` varchar(100) DEFAULT NULL,
  `last_name` varchar(100) DEFAULT NULL,
  `email` varchar(191) DEFAULT NULL,
  `mobile` varchar(32) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `user_profiles`
--

INSERT INTO `user_profiles` (`id`, `user_id`, `first_name`, `last_name`, `email`, `mobile`, `created_at`, `updated_at`) VALUES
(1, 1, 'System', 'Administrator', 'admin@swift.com', '+63-XXX-XXX-XXXX', '2025-10-07 17:12:39', '2025-10-07 17:12:39'),
(2, 2, 'John Jesus Godwin', 'Quismorio', 'jquismorio01282@student.dmmmsu.edu.ph', '09156659104', '2025-10-07 17:31:36', '2025-10-07 17:31:50');

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
  ADD KEY `fk_devices_user` (`user_id`),
  ADD KEY `fk_devices_farm` (`farm_id`),
  ADD KEY `idx_device_code` (`device_code`),
  ADD KEY `idx_ip_address` (`ip_address`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_last_seen` (`last_seen`),
  ADD KEY `idx_component_last_checked` (`component_last_checked`);

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=468;

--
-- AUTO_INCREMENT for table `devices`
--
ALTER TABLE `devices`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `farms`
--
ALTER TABLE `farms`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `system_settings`
--
ALTER TABLE `system_settings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `user_profiles`
--
ALTER TABLE `user_profiles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

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
  ADD CONSTRAINT `fk_devices_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

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

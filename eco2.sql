-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 15, 2026 at 05:48 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `eco`
--

-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

CREATE TABLE `admin` (
  `id` int(11) NOT NULL,
  `email` varchar(100) NOT NULL,
  `admin_id` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admin`
--

INSERT INTO `admin` (`id`, `email`, `admin_id`) VALUES
(1, 'karthikvenkat062@gmail.com', '192372092');

-- --------------------------------------------------------

--
-- Table structure for table `complaints`
--

CREATE TABLE `complaints` (
  `id` int(11) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `phone` varchar(15) DEFAULT NULL,
  `type` varchar(100) DEFAULT NULL,
  `message` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `complaints`
--

INSERT INTO `complaints` (`id`, `name`, `phone`, `type`, `message`, `created_at`) VALUES
(1, 'moksha', '9912250188', 'Late Service', 'nothing', '2026-05-12 04:32:03'),
(2, 'srikanth', '8008444328', 'Bad Behaviour', 'improve your communication', '2026-06-15 03:20:13');

-- --------------------------------------------------------

--
-- Table structure for table `feedback`
--

CREATE TABLE `feedback` (
  `id` int(11) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `rating` int(11) DEFAULT NULL,
  `drawback_option` varchar(255) DEFAULT NULL,
  `drawback_text` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `feedback`
--

INSERT INTO `feedback` (`id`, `name`, `rating`, `drawback_option`, `drawback_text`, `created_at`) VALUES
(1, 'moksha', 5, 'No', '', '2026-05-12 04:31:43'),
(2, 'praveen', 4, 'No', '', '2026-06-15 03:19:38');

-- --------------------------------------------------------

--
-- Table structure for table `requests`
--

CREATE TABLE `requests` (
  `id` int(11) NOT NULL,
  `tracking_id` varchar(100) DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `phone` varchar(15) DEFAULT NULL,
  `waste_type` varchar(100) DEFAULT NULL,
  `pickup_date` date DEFAULT NULL,
  `status` varchar(50) DEFAULT 'Pending',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `requests`
--

INSERT INTO `requests` (`id`, `tracking_id`, `name`, `address`, `phone`, `waste_type`, `pickup_date`, `status`, `created_at`) VALUES
(13, '9390241031', 'srikanth', 'khammam', '9390241031', 'Dry Waste', '2026-05-16', 'Assigned', '2026-05-12 09:17:39'),
(14, '9390241031', 'karthik', 'ongole', '9390241031', 'Dry Waste', '2026-05-16', 'Assigned', '2026-05-12 09:23:23'),
(15, '9390241031', 'karthik', 'ongole', '9390241031', 'Dry Waste', '2026-05-16', 'Completed', '2026-05-12 15:06:32'),
(16, '7680892454', 'teja', 'ongole', '7680892454', 'Dry Waste', '2026-05-16', 'Completed', '2026-05-12 15:07:59'),
(17, '9347758767', 'moksha', 'ongole', '9347758767', 'Dry Waste', '2026-05-16', 'Completed', '2026-05-12 15:16:50'),
(18, '9949763396', 'akshay', 'vijayawada', '9949763396', 'Dry Waste', '2026-05-13', 'Completed', '2026-05-12 16:46:23'),
(19, '9949763396', 'akshay', 'vijayawada', '9949763396', 'Dry Waste', '2026-05-13', 'Completed', '2026-05-12 16:58:31'),
(20, '9949763396', 'akshay', 'vijayawada', '9949763396', 'Dry Waste', '2026-05-16', 'Pending', '2026-05-12 16:59:43'),
(21, '9390241031', 'srikanth', 'chinnaganjam', '9390241031', 'Mixed Waste', '2026-05-13', 'Pending', '2026-05-13 02:38:44'),
(22, '8885692725', 'praveen', 'Hyderabad', '8885692725', 'Mixed Waste', '2026-06-17', 'Pending', '2026-06-15 03:22:29'),
(23, '8247859223', 'dharma', 'AMEEN NAGAR', '8247859223', 'Mixed Waste', '2026-06-16', 'Assigned', '2026-06-15 03:24:30');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `password`, `created_at`) VALUES
(1, 'dharma', 'dharma1234@gmail.com', '$2y$10$Js/pu1BvCdnjbldDaZCT7uJGqHVz.TmlksZ2m9Ta5tKhaWjB0YRPO', '2026-05-12 04:21:54'),
(2, 'praveen', 'praveen1234@gmail.com', '$2y$10$VDtqZN2AMS8wQUzGD5SfwuplxNXUpX1uSxI9yfUwZkymyam3JpZve', '2026-06-15 03:18:20');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `complaints`
--
ALTER TABLE `complaints`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `feedback`
--
ALTER TABLE `feedback`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `requests`
--
ALTER TABLE `requests`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admin`
--
ALTER TABLE `admin`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `complaints`
--
ALTER TABLE `complaints`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `feedback`
--
ALTER TABLE `feedback`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `requests`
--
ALTER TABLE `requests`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

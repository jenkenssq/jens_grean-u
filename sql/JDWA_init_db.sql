-- 创建数据库
CREATE DATABASE IF NOT EXISTS jens_green DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

-- 使用数据库
USE jens_green;

-- 用户表
CREATE TABLE IF NOT EXISTS `jens_user` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `username` varchar(50) NOT NULL COMMENT '用户名',
  `password` varchar(100) NOT NULL COMMENT '密码',
  `nickname` varchar(50) DEFAULT NULL COMMENT '昵称',
  `avatar` varchar(255) DEFAULT NULL COMMENT '头像URL',
  `email` varchar(100) DEFAULT NULL COMMENT '邮箱',
  `phone` varchar(20) DEFAULT NULL COMMENT '手机号',
  `gender` tinyint(1) DEFAULT 0 COMMENT '性别：0-未知，1-男，2-女',
  `birthday` date DEFAULT NULL COMMENT '生日',
  `total_carbon` decimal(10,2) DEFAULT 0.00 COMMENT '累计碳减排量(kg)',
  `carbon_points` int(11) DEFAULT 0 COMMENT '当前碳积分',
  `total_points` int(11) DEFAULT 0 COMMENT '累计获得碳积分',
  `status` tinyint(1) DEFAULT 1 COMMENT '状态：0-禁用，1-启用',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_username` (`username`),
  UNIQUE KEY `uk_email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- 运动记录表
CREATE TABLE IF NOT EXISTS `jens_activity_record` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '记录ID',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `activity_type` varchar(20) NOT NULL COMMENT '活动类型：walking-步行，running-跑步，cycling-骑行',
  `start_time` datetime NOT NULL COMMENT '开始时间',
  `end_time` datetime DEFAULT NULL COMMENT '结束时间',
  `duration` int(11) DEFAULT 0 COMMENT '持续时间(秒)',
  `distance` decimal(10,2) DEFAULT 0.00 COMMENT '距离(米)',
  `steps` int(11) DEFAULT 0 COMMENT '步数',
  `calories` decimal(10,2) DEFAULT 0.00 COMMENT '消耗卡路里(kcal)',
  `carbon_reduced` decimal(10,4) DEFAULT 0.0000 COMMENT '碳减排量(kg)',
  `points_earned` int(11) DEFAULT 0 COMMENT '获得积分',
  `status` tinyint(1) DEFAULT 1 COMMENT '状态：0-无效，1-有效',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_start_time` (`start_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='运动记录表';

-- 运动轨迹点表
CREATE TABLE IF NOT EXISTS `jens_track_point` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '轨迹点ID',
  `record_id` bigint(20) NOT NULL COMMENT '运动记录ID',
  `latitude` decimal(10,6) NOT NULL COMMENT '纬度',
  `longitude` decimal(10,6) NOT NULL COMMENT '经度',
  `altitude` decimal(10,2) DEFAULT 0.00 COMMENT '海拔(米)',
  `heart_rate` int(11) DEFAULT NULL COMMENT '心率(次/分)',
  `speed` decimal(5,2) DEFAULT 0.00 COMMENT '速度(米/秒)',
  `timestamp` datetime NOT NULL COMMENT '时间戳',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_record_id` (`record_id`),
  KEY `idx_timestamp` (`timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='运动轨迹点表';

-- 碳减排系数表
CREATE TABLE IF NOT EXISTS `jens_carbon_factor` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `activity_type` varchar(20) NOT NULL COMMENT '活动类型',
  `factor_name` varchar(50) NOT NULL COMMENT '系数名称',
  `factor_value` decimal(10,6) NOT NULL COMMENT '系数值',
  `unit` varchar(20) NOT NULL COMMENT '单位',
  `description` varchar(255) DEFAULT NULL COMMENT '描述',
  `status` tinyint(1) DEFAULT 1 COMMENT '状态：0-禁用，1-启用',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_activity_factor` (`activity_type`, `factor_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='碳减排系数表';

-- 奖品表
CREATE TABLE IF NOT EXISTS `jens_prize` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '奖品ID',
  `name` varchar(100) NOT NULL COMMENT '奖品名称',
  `description` text DEFAULT NULL COMMENT '奖品描述',
  `image_url` varchar(255) DEFAULT NULL COMMENT '图片URL',
  `points_required` int(11) NOT NULL COMMENT '所需积分',
  `stock` int(11) DEFAULT 0 COMMENT '库存',
  `prize_type` tinyint(1) NOT NULL COMMENT '奖品类型：1-虚拟奖品，2-实物奖品',
  `status` tinyint(1) DEFAULT 1 COMMENT '状态：0-下架，1-上架',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='奖品表';

-- 积分明细表
CREATE TABLE IF NOT EXISTS `jens_points_record` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '记录ID',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `points` int(11) NOT NULL COMMENT '积分数量（正为收入，负为支出）',
  `type` tinyint(1) NOT NULL COMMENT '类型：1-运动获得，2-奖品兑换，3-系统奖励，4-其他',
  `related_id` bigint(20) DEFAULT NULL COMMENT '关联ID（运动记录ID或奖品兑换ID）',
  `description` varchar(255) DEFAULT NULL COMMENT '描述',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='积分明细表';

-- 奖品兑换记录表
CREATE TABLE IF NOT EXISTS `jens_prize_exchange` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '兑换ID',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `prize_id` bigint(20) NOT NULL COMMENT '奖品ID',
  `points_cost` int(11) NOT NULL COMMENT '消耗积分',
  `exchange_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '兑换时间',
  `status` tinyint(1) DEFAULT 0 COMMENT '状态：0-待处理，1-已发放，2-已取消',
  `recipient_name` varchar(50) DEFAULT NULL COMMENT '收件人姓名',
  `recipient_phone` varchar(20) DEFAULT NULL COMMENT '收件人电话',
  `shipping_address` varchar(255) DEFAULT NULL COMMENT '收货地址',
  `tracking_number` varchar(50) DEFAULT NULL COMMENT '物流单号',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_exchange_time` (`exchange_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='奖品兑换记录表';

-- 模拟传感器配置表
CREATE TABLE IF NOT EXISTS `jens_sensor_config` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '配置ID',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `activity_type` varchar(20) NOT NULL COMMENT '活动类型',
  `heart_rate_min` int(11) DEFAULT 60 COMMENT '最低心率',
  `heart_rate_max` int(11) DEFAULT 180 COMMENT '最高心率',
  `speed_min` decimal(5,2) DEFAULT 0.50 COMMENT '最低速度(米/秒)',
  `speed_max` decimal(5,2) DEFAULT 5.00 COMMENT '最高速度(米/秒)',
  `step_frequency` decimal(5,2) DEFAULT 1.00 COMMENT '步频(步/秒)',
  `enabled` tinyint(1) DEFAULT 1 COMMENT '是否启用：0-禁用，1-启用',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_activity` (`user_id`, `activity_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='模拟传感器配置表';

-- 用户成就表
CREATE TABLE IF NOT EXISTS `jens_user_achievement` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '记录ID',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `achievement_id` bigint(20) NOT NULL COMMENT '成就ID',
  `achieve_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '获得时间',
  `status` tinyint(1) DEFAULT 1 COMMENT '状态：0-无效，1-有效',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_achievement` (`user_id`, `achievement_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户成就表';

-- 成就表
CREATE TABLE IF NOT EXISTS `jens_achievement` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '成就ID',
  `name` varchar(50) NOT NULL COMMENT '成就名称',
  `description` varchar(255) DEFAULT NULL COMMENT '成就描述',
  `icon_url` varchar(255) DEFAULT NULL COMMENT '图标URL',
  `type` varchar(20) NOT NULL COMMENT '类型：步数、距离、碳减排等',
  `condition_value` int(11) NOT NULL COMMENT '达成条件值',
  `reward_points` int(11) DEFAULT 0 COMMENT '奖励积分',
  `status` tinyint(1) DEFAULT 1 COMMENT '状态：0-禁用，1-启用',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='成就表';

-- 初始化数据

-- 添加碳减排系数
INSERT INTO `jens_carbon_factor` (`activity_type`, `factor_name`, `factor_value`, `unit`, `description`) VALUES
('walking', '步行碳减排系数', 0.000215, 'kg/m', '每米步行减少的二氧化碳排放量'),
('running', '跑步碳减排系数', 0.000275, 'kg/m', '每米跑步减少的二氧化碳排放量'),
('cycling', '骑行碳减排系数', 0.000196, 'kg/m', '每米骑行减少的二氧化碳排放量');

-- 添加成就
INSERT INTO `jens_achievement` (`name`, `description`, `type`, `condition_value`, `reward_points`) VALUES
('初级环保者', '累计减少1公斤碳排放', 'carbon', 1, 50),
('中级环保者', '累计减少5公斤碳排放', 'carbon', 5, 100),
('高级环保者', '累计减少10公斤碳排放', 'carbon', 10, 200),
('步行达人初级', '累计步行10000步', 'step', 10000, 50),
('步行达人中级', '累计步行50000步', 'step', 50000, 100),
('步行达人高级', '累计步行100000步', 'step', 100000, 200),
('马拉松初体验', '累计跑步10公里', 'run_distance', 10000, 50),
('半程马拉松', '累计跑步21公里', 'run_distance', 21000, 100),
('马拉松完成者', '累计跑步42公里', 'run_distance', 42000, 200);

-- 添加虚拟奖品
INSERT INTO `jens_prize` (`name`, `description`, `image_url`, `points_required`, `stock`, `prize_type`, `status`) VALUES
('碳中和证书', '获得个人专属碳中和电子证书', '/image/Prize/certificate.png', 500, 9999, 1, 1),
('视频平台月卡', '获得某视频平台VIP会员月卡', '/image/Prize/video_vip.png', 1000, 100, 1, 1),
('音乐平台季卡', '获得某音乐平台VIP会员季卡', '/image/Prize/music_vip.png', 2000, 50, 1, 1);

-- 添加实物奖品
INSERT INTO `jens_prize` (`name`, `description`, `image_url`, `points_required`, `stock`, `prize_type`, `status`) VALUES
('定制环保袋', '可降解材质制作的定制环保购物袋', '/image/Prize/eco_bag.png', 800, 200, 2, 1),
('太阳能充电宝', '环保便携式太阳能充电宝', '/image/Prize/solar_charger.png', 3000, 50, 2, 1),
('智能水杯', '记录饮水量的智能水杯', '/image/Prize/smart_cup.png', 2500, 30, 2, 1); 
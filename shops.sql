/*
 Navicat Premium Data Transfer

 Source Server         : localhost_MARIA_DB
 Source Server Type    : MariaDB
 Source Server Version : 100508
 Source Host           : localhost:3306
 Source Schema         : fivem

 Target Server Type    : MariaDB
 Target Server Version : 100508
 File Encoding         : 65001

 Date: 08/12/2020 02:07:26
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for shops
-- ----------------------------
DROP TABLE IF EXISTS `shops`;
CREATE TABLE `shops`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `shop_id` varchar(255) CHARACTER SET armscii8 COLLATE armscii8_general_ci NOT NULL,
  `item` varchar(255) CHARACTER SET armscii8 COLLATE armscii8_general_ci NOT NULL,
  `label` varchar(255) CHARACTER SET armscii8 COLLATE armscii8_general_ci NOT NULL,
  `price` int(11) NULL DEFAULT NULL,
  `description` varchar(255) CHARACTER SET armscii8 COLLATE armscii8_general_ci NOT NULL,
  `stock` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 248 CHARACTER SET = armscii8 COLLATE = armscii8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of shops
-- ----------------------------
INSERT INTO `shops` VALUES (1, '1', 'bread', 'Bread', 10, 'Increase Thirst, Hunger', 129);
INSERT INTO `shops` VALUES (2, '1', 'water', 'Water', 10, 'Increase Thirst, Hunger', 121);
INSERT INTO `shops` VALUES (3, '1', 'activia', 'Activia', 10, 'Increase Thirst, Hunger', 150);
INSERT INTO `shops` VALUES (4, '1', 'wine', 'Wine', 10, 'Increase Thirst, Hunger, Alcohol', 150);
INSERT INTO `shops` VALUES (6, '1', 'vine', 'Vine', 10, 'Increase Thirst, Hunger, Alcohol', 150);
INSERT INTO `shops` VALUES (7, '1', 'tequila', 'Tequila', 10, 'Increase Thirst, Hunger, Alcohol', 159);

SET FOREIGN_KEY_CHECKS = 1;

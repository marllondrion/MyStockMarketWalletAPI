-- MySQL Script generated by MySQL Workbench
-- Tue May 11 22:34:17 2021
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mystockwalletdb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mystockwalletdb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mystockwalletdb` DEFAULT CHARACTER SET utf8 ;
USE `mystockwalletdb` ;

-- -----------------------------------------------------
-- Table `mystockwalletdb`.`user`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mystockwalletdb`.`user` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `full_name` VARCHAR(255) NOT NULL,
  `passcode_rsa` TEXT NOT NULL,
  `login` VARCHAR(100) NOT NULL,
  `email` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `login` (`login` ASC) VISIBLE,
  UNIQUE INDEX `email` (`email` ASC) VISIBLE);


-- -----------------------------------------------------
-- Table `mystockwalletdb`.`wallet`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mystockwalletdb`.`wallet` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NOT NULL,
  `code_country` CHAR(2) NOT NULL,
  `correcy` VARCHAR(10) NOT NULL,
  `user_id` INT NOT NULL,
  PRIMARY KEY (`id`, `user_id`),
  INDEX `fk_wallet_user1_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `fk_wallet_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `mystockwalletdb`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `mystockwalletdb`.`stockbroker`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mystockwalletdb`.`stockbroker` (
  `name` VARCHAR(50) NOT NULL,
  `description` VARCHAR(100) NULL DEFAULT NULL,
  `user_id` INT NOT NULL,
  PRIMARY KEY (`user_id`),
  INDEX `fk_stockbroker_user_idx` (`user_id` ASC) INVISIBLE,
  CONSTRAINT `fk_stockbroker_user`
    FOREIGN KEY (`user_id`)
    REFERENCES `mystockwalletdb`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `mystockwalletdb`.`orders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mystockwalletdb`.`orders` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `stockbroker_id` INT NOT NULL,
  `status` ENUM('sell', 'buy') NOT NULL,
  `request_date` DATETIME NOT NULL,
  `execulte_date` DATETIME NULL DEFAULT NULL,
  `description` VARCHAR(255) NULL DEFAULT NULL,
  `stockbroker_user_id` INT NOT NULL,
  `wallet_id` INT NOT NULL,
  `wallet_user_id` INT NOT NULL,
  PRIMARY KEY (`id`, `stockbroker_user_id`, `wallet_id`, `wallet_user_id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
  INDEX `fk_orders_stockbroker1_idx` (`stockbroker_user_id` ASC) VISIBLE,
  INDEX `fk_orders_wallet1_idx` (`wallet_id` ASC, `wallet_user_id` ASC) VISIBLE,
  CONSTRAINT `fk_orders_stockbroker1`
    FOREIGN KEY (`stockbroker_user_id`)
    REFERENCES `mystockwalletdb`.`stockbroker` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_orders_wallet1`
    FOREIGN KEY (`wallet_id` , `wallet_user_id`)
    REFERENCES `mystockwalletdb`.`wallet` (`id` , `user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `mystockwalletdb`.`segment`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mystockwalletdb`.`segment` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NOT NULL,
  `description` VARCHAR(255) NULL DEFAULT NULL,
  UNIQUE INDEX `name_UNIQUE` (`name` ASC) VISIBLE,
  PRIMARY KEY (`id`));


-- -----------------------------------------------------
-- Table `mystockwalletdb`.`stock`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mystockwalletdb`.`stock` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NOT NULL,
  `code` VARCHAR(20) NOT NULL,
  `code_company` VARCHAR(100) NOT NULL,
  `segment_id` INT NOT NULL,
  PRIMARY KEY (`id`, `segment_id`),
  INDEX `fk_stock_segment1_idx` (`segment_id` ASC) VISIBLE,
  CONSTRAINT `fk_stock_segment1`
    FOREIGN KEY (`segment_id`)
    REFERENCES `mystockwalletdb`.`segment` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `mystockwalletdb`.`order_items`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mystockwalletdb`.`order_items` (
  `price` DECIMAL NOT NULL,
  `quantity` INT NOT NULL DEFAULT 1,
  `orders_id` INT NOT NULL,
  `stock_id` INT NOT NULL,
  `stock_segment_id` INT NOT NULL,
  INDEX `fk_order_items_orders1_idx` (`orders_id` ASC) VISIBLE,
  INDEX `fk_order_items_stock1_idx` (`stock_id` ASC, `stock_segment_id` ASC) VISIBLE,
  CONSTRAINT `fk_order_items_orders1`
    FOREIGN KEY (`orders_id`)
    REFERENCES `mystockwalletdb`.`orders` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_order_items_stock1`
    FOREIGN KEY (`stock_id`)
    REFERENCES `mystockwalletdb`.`stock` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

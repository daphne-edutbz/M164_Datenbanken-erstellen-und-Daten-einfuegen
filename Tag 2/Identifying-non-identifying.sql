-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `mydb` ;

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `Person`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Person` ;

CREATE TABLE IF NOT EXISTS `Person` (
  `idPerson` INT NOT NULL,
  `name` VARCHAR(50) NULL,
  PRIMARY KEY (`idPerson`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Kleidungsstück`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Kleidungsstück` ;

CREATE TABLE IF NOT EXISTS `Kleidungsstück` (
  `Kleidungsstück_id` INT NOT NULL,
  `typ` VARCHAR(50) NULL,
  `Person_idPerson` INT NOT NULL,
  PRIMARY KEY (`Kleidungsstück_id`),
  INDEX `fk_Kleidungsstück_Person_idx` (`Person_idPerson` ASC) VISIBLE,
  CONSTRAINT `fk_Kleidungsstück_Person`
    FOREIGN KEY (`Person_idPerson`)
    REFERENCES `Person` (`idPerson`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Ausweis`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Ausweis` ;

CREATE TABLE IF NOT EXISTS `Ausweis` (
  `Person_idPerson` INT NOT NULL,
  `Ausweis_id` INT NOT NULL,
  PRIMARY KEY (`Person_idPerson`, `Ausweis_id`),
  INDEX `fk_Ausweis_Person1_idx` (`Person_idPerson` ASC) VISIBLE,
  CONSTRAINT `fk_Ausweis_Person1`
    FOREIGN KEY (`Person_idPerson`)
    REFERENCES `Person` (`idPerson`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;




SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

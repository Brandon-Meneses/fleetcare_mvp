DROP DATABASE IF EXISTS fleetcare;
CREATE DATABASE fleetcare CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE fleetcare;

-- 1) Catalogs first (to avoid FK issues)
CREATE TABLE roles (
  id_rol INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(50) UNIQUE NOT NULL,
  descripcion VARCHAR(100)
) ENGINE=InnoDB;

CREATE TABLE tipos_mantenimiento (
  id_tipo_mant INT AUTO_INCREMENT PRIMARY KEY,
  descripcion VARCHAR(50) UNIQUE NOT NULL
) ENGINE=InnoDB;

CREATE TABLE tipos_alerta (
  id_tipo_alerta INT AUTO_INCREMENT PRIMARY KEY,
  descripcion VARCHAR(50) UNIQUE NOT NULL
) ENGINE=InnoDB;

-- 2) Core entities
CREATE TABLE usuarios (
  id_usuario BIGINT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
  activo BOOLEAN DEFAULT TRUE,
  id_rol INT,
  CONSTRAINT fk_usuarios_rol
    FOREIGN KEY (id_rol) REFERENCES roles(id_rol)
    ON UPDATE CASCADE
    ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE buses (
  id_bus BIGINT AUTO_INCREMENT PRIMARY KEY,
  placa VARCHAR(20) UNIQUE NOT NULL,
  kilometraje_actual DECIMAL(10,2) DEFAULT 0,
  fecha_ultimo_mant DATE DEFAULT NULL,
  estado ENUM('OK','PROXIMO','VENCIDO','FUERA_SERVICIO') DEFAULT 'OK',
  notas TEXT,
  id_usuario BIGINT,
  CONSTRAINT fk_buses_usuario
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
    ON UPDATE CASCADE
    ON DELETE SET NULL
) ENGINE=InnoDB;

-- 3) Transactional
CREATE TABLE mantenimientos (
  id_mantenimiento BIGINT AUTO_INCREMENT PRIMARY KEY,
  id_tipo_mant INT NOT NULL,
  fecha_inicio DATE NOT NULL,
  fecha_fin DATE DEFAULT NULL,
  notas TEXT,
  id_bus BIGINT NOT NULL,
  id_usuario BIGINT,
  CONSTRAINT fk_mant_tipo
    FOREIGN KEY (id_tipo_mant) REFERENCES tipos_mantenimiento(id_tipo_mant)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  CONSTRAINT fk_mant_bus
    FOREIGN KEY (id_bus) REFERENCES buses(id_bus)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT fk_mant_usuario
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
    ON UPDATE CASCADE
    ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE predicciones (
  id_prediccion BIGINT AUTO_INCREMENT PRIMARY KEY,
  km_estimado_dia DECIMAL(10,2),
  fecha_estimacion DATE NOT NULL,
  fecha_umbral DATE,
  estado_prediccion ENUM('PENDIENTE','CALCULADO') DEFAULT 'PENDIENTE',
  id_bus BIGINT NOT NULL,
  CONSTRAINT fk_pred_bus
    FOREIGN KEY (id_bus) REFERENCES buses(id_bus)
    ON UPDATE CASCADE
    ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE alertas (
  id_alerta BIGINT AUTO_INCREMENT PRIMARY KEY,
  id_tipo_alerta INT NOT NULL,
  fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
  atendida BOOLEAN DEFAULT FALSE,
  id_bus BIGINT NOT NULL,
  CONSTRAINT fk_alerta_tipo
    FOREIGN KEY (id_tipo_alerta) REFERENCES tipos_alerta(id_tipo_alerta)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  CONSTRAINT fk_alerta_bus
    FOREIGN KEY (id_bus) REFERENCES buses(id_bus)
    ON UPDATE CASCADE
    ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE informes (
  id_informe BIGINT AUTO_INCREMENT PRIMARY KEY,
  fecha_generacion DATETIME DEFAULT CURRENT_TIMESTAMP,
  resumen_kpis TEXT,
  recomendaciones TEXT,
  origen ENUM('IA','LOCAL') DEFAULT 'LOCAL',
  ruta_pdf VARCHAR(255),
  id_bus BIGINT,
  id_usuario BIGINT,
  CONSTRAINT fk_informe_bus
    FOREIGN KEY (id_bus) REFERENCES buses(id_bus)
    ON UPDATE CASCADE
    ON DELETE SET NULL,
  CONSTRAINT fk_informe_usuario
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
    ON UPDATE CASCADE
    ON DELETE SET NULL
) ENGINE=InnoDB;

SET FOREIGN_KEY_CHECKS = 1;

-- Seeds

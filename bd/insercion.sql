INSERT INTO roles (nombre, descripcion) VALUES
('ADMIN', 'Administrador del sistema'),
('MANTENIMIENTO', 'Encargado de revisiones y órdenes'),
('INFORMES', 'Responsable de reportes y análisis');

INSERT INTO tipos_mantenimiento (descripcion) VALUES
('PREVENTIVO'),
('CORRECTIVO');

INSERT INTO tipos_alerta (descripcion) VALUES
('MANTENIMIENTO'),
('REEMPLAZO'),
('OTRO');
-- Inserción de usuarios
INSERT INTO usuarios (nombre, email, password_hash, id_rol)
VALUES
('Brandon Meneses', 'brandon@fleetcare.com', 'hash123', 1),
('Luis Araujo', 'laraujo@fleetcare.com', 'hash456', 2),
('Gresly Ruiz', 'gruiz@fleetcare.com', 'hash789', 3);

-- Inserción de buses
INSERT INTO buses (placa, kilometraje_actual, fecha_ultimo_mant, estado, id_usuario)
VALUES
('ABC-123', 50000, '2025-08-01', 'OK', 1),
('XYZ-987', 95000, '2025-07-15', 'PROXIMO', 2);

-- Inserción de mantenimientos
INSERT INTO mantenimientos (id_tipo_mant, fecha_inicio, fecha_fin, notas, id_bus, id_usuario)
VALUES
(1, '2025-09-01', '2025-09-03', 'Cambio de aceite y filtros', 1, 1),
(2, '2025-09-10', NULL, 'Revisión del sistema eléctrico', 2, 2);

-- Inserción de predicciones
INSERT INTO predicciones (km_estimado_dia, fecha_estimacion, fecha_umbral, estado_prediccion, id_bus)
VALUES
(120.5, '2025-09-25', '2025-10-10', 'CALCULADO', 1);

-- Inserción de alertas
INSERT INTO alertas (id_tipo_alerta, fecha_creacion, atendida, id_bus)
VALUES
(1, NOW(), FALSE, 2);

-- Inserción de informes
INSERT INTO informes (fecha_generacion, resumen_kpis, recomendaciones, origen, ruta_pdf, id_bus, id_usuario)
VALUES
(NOW(), 'Promedio de kilometraje: 120km/día', 'Programar mantenimiento en 10 días', 'IA', '/docs/inf_001.pdf', 1, 1);
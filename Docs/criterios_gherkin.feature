# ==============================================================================
# HU-01: Búsqueda de disponibilidad de habitaciones
# ==============================================================================
Feature: Búsqueda de disponibilidad de habitaciones
  Scenario: Búsqueda exitosa con fechas válidas y habitaciones disponibles
    Given que el huésped se encuentra en el portal de reservas
    And existen habitaciones disponibles para el rango del "2026-12-01" al "2026-12-05"
    When selecciona fecha de entrada "2026-12-01", fecha de salida "2026-12-05" y "2" adultos
    And presiona el botón "Buscar disponibilidad"
    Then el sistema muestra el listado de habitaciones disponibles con su tarifa por noche y total

  Scenario: Validación de rango de fechas inválido
    Given que el huésped se encuentra en el portal de reservas
    When ingresa una fecha de salida anterior o igual a la fecha de entrada
    Then el sistema bloquea la búsqueda y muestra el mensaje "La fecha de salida debe ser posterior a la entrada"

# ==============================================================================
# HU-02: Registro de reserva en línea
# ==============================================================================
Feature: Registro de reserva en línea
  Scenario: Creación exitosa de reserva con datos completos
    Given que el huésped seleccionó una habitación "Doble Superior" disponible
    When completa sus datos obligatorios (Nombre, DNI/Pasaporte, Correo, Teléfono)
    And confirma la reserva aceptando los términos y condiciones
    Then el sistema genera un código único de reserva en estado "Confirmada"
    And bloquea la disponibilidad de dicha habitación para las fechas seleccionadas

# ==============================================================================
# HU-04: Cancelación de reserva
# ==============================================================================
Feature: Cancelación de reserva por el huésped
  Scenario: Cancelación permitida con más de 24 horas de anticipación
    Given que el huésped tiene una reserva "Confirmada" cuya fecha de Check-in es en 48 horas
    When ingresa su código de reserva y selecciona "Cancelar reserva"
    Then el sistema cambia el estado de la reserva a "Cancelada"
    And libera inmediatamente la habitación en el inventario disponible

  Scenario: Intento de cancelación fuera de plazo (< 24 horas)
    Given que el huésped tiene una reserva "Confirmada" cuya fecha de Check-in es en 10 horas
    When intenta seleccionar la opción "Cancelar reserva"
    Then el sistema deshabilita la cancelación en línea e indica "Contacte a recepción para gestionar cambios de último minuto"

# ==============================================================================
# HU-06: Registro de Check-in en recepción
# ==============================================================================
Feature: Registro de Check-in
  Scenario: Check-in exitoso de huésped con reserva previa
    Given que el recepcionista ha localizado la reserva "RES-1045" en estado "Confirmada"
    And la habitación asignada "302" se encuentra en estado "Disponible"
    When valida el documento de identidad del huésped y presiona "Registrar Check-in"
    Then el sistema actualiza el estado de la reserva a "En curso"
    And cambia el estado de la habitación "302" a "Ocupada" registrando la hora exacta de ingreso

# ==============================================================================
# HU-08: Proceso de Check-out y liberación de habitación
# ==============================================================================
Feature: Proceso de Check-out
  Scenario: Cierre de estadía y cálculo de saldo total
    Given que la habitación "302" está en estado "Ocupada" con 2 noches alojadas y S/ 45.00 en consumos extra
    When el recepcionista inicia el proceso de "Check-out" y registra el pago del saldo pendiente
    Then el sistema cierra la cuenta de la estadía con saldo "0.00"
    And cambia automáticamente el estado de la habitación "302" a "Limpieza"

# ==============================================================================
# HU-10: Actualización de estado de limpieza
# ==============================================================================
Feature: Actualización de estado de habitación por personal de limpieza
  Scenario: Cambio de estado de Limpieza a Disponible
    Given que el personal de limpieza ha iniciado sesión en la vista móvil
    And la habitación "302" figura en estado "Limpieza"
    When selecciona la habitación "302" y marca la acción "Limpieza completada"
    Then el sistema cambia el estado de la habitación "302" a "Disponible"
    And actualiza en tiempo real el panel del recepcionista
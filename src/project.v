/*
 * Copyright (c) 2024 Carlos
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_pulsebox (
    input  wire [7:0] ui_in,    // Entradas dedicadas
    output wire [7:0] uo_out,   // Salidas dedicadas
    input  wire [7:0] uio_in,   // E/S: Ruta de entrada
    output wire [7:0] uio_out,  // E/S: Ruta de salida
    output wire [7:0] uio_oe,   // E/S: Habilitar ruta (0=entrada, 1=salida)
    input  wire       ena,      // Siempre 1 cuando el diseño está encendido
    input  wire       clk,      // Reloj
    input  wire       rst_n     // Reset activo en bajo (0 = reiniciar)
);

    // --- 1. Definición de Entradas (Botones) ---
    wire b0 = ui_in[0]; // Botón jugador 1
    wire b1 = ui_in[1]; // Botón jugador 2
    wire b2 = ui_in[2]; // Botón jugador 3
    wire b3 = ui_in[3]; // Botón jugador 4
    wire btn_verdadero = ui_in[4]; // Botón respuesta correcta
    wire btn_falso     = ui_in[5]; // Botón respuesta incorrecta

    // --- 2. Registros para mantener encendidos los LEDs ---
    reg [3:0] led_jugador;
    reg led_correcto;
    reg led_incorrecto;

    // --- 3. Lógica de Compuertas ---
    // Compuerta OR: detecta si algún jugador ya ganó el turno
    wire alguien_presiono = led_jugador[0] | led_jugador[1] | led_jugador[2] | led_jugador[3];
    
    // Compuerta OR: detecta si ya se calificó la respuesta
    wire ya_evaluado = led_correcto | led_incorrecto;

    // Compuertas AND y NOT: prioridad para evitar empates simultáneos y bloquear si ya presionaron
    wire activar_j0 = (~alguien_presiono) & b0;
    wire activar_j1 = (~alguien_presiono) & (~b0) & b1;
    wire activar_j2 = (~alguien_presiono) & (~b0) & (~b1) & b2;
    wire activar_j3 = (~alguien_presiono) & (~b0) & (~b1) & (~b2) & b3;

    // Compuertas AND y NOT: solo permite calificar si alguien presionó y no se ha evaluado
    wire activar_correcto   = alguien_presiono & (~ya_evaluado) & btn_verdadero & (~btn_falso);
    wire activar_incorrecto = alguien_presiono & (~ya_evaluado) & btn_falso & (~btn_verdadero);

    // --- 4. Enclavamiento (Memoria de estado con Reset) ---
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset: apaga todos los LEDs
            led_jugador    <= 4'b0000;
            led_correcto   <= 1'b0;
            led_incorrecto <= 1'b0;
        end else begin
            // Mantiene el estado anterior (OR) o enciende el nuevo (activar_*)
            led_jugador[0] <= led_jugador[0] | activar_j0;
            led_jugador[1] <= led_jugador[1] | activar_j1;
            led_jugador[2] <= led_jugador[2] | activar_j2;
            led_jugador[3] <= led_jugador[3] | activar_j3;

            led_correcto   <= led_correcto   | activar_correcto;
            led_incorrecto <= led_incorrecto | activar_incorrecto;
        end
    end

    // --- 5. Asignación de Salidas ---
    assign uo_out[3:0] = led_jugador;
    assign uo_out[4]   = led_correcto;
    assign uo_out[5]   = led_incorrecto;
    assign uo_out[7:6] = 2'b00; // Pines sin usar en 0

    // Pines bidireccionales sin usar en 0
    assign uio_out = 8'b00000000;
    assign uio_oe  = 8'b00000000;

    // Evitar advertencias por señales no utilizadas
    wire _unused = &{ena, uio_in, ui_in[7:6], 1'b0};

endmodule

`timescale 1ns / 1ps

// ============================================================================
// Modul: q8_8_add
// Amac: Q8.8 formatindaki iki isaretli sayiyi toplamak.
// Not: Kesir kisimlari (Q noktalari) ayni hizada oldugu icin (8 bit),
//      herhangi bir bit kaydirma yapilmadan dogrudan 2'ye tumleyen toplamasi yapilir.
// ============================================================================
module q8_8_add (
    input  signed [15:0] a,       // 1. Isaretli girdi (Q8.8 formati)
    input  signed [15:0] b,       // 2. Isaretli girdi (Q8.8 formati)
    output signed [15:0] result   // Toplam cikisi (Q8.8 formati)
);

    // Iki Q8.8 sayinin toplami yine Q8.8 formatindadir.
    // Tasmayi engellemek icin normalde 1 bit genisletme yapilabilir,
    // ancak veri yolu genisligini 16-bit sabit tutmak adina 16-bit cıkıs verilir.
    assign result = a + b;

endmodule
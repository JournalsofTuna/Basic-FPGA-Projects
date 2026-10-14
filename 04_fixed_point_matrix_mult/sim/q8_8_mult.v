`timescale 1ns / 1ps

// ============================================================================
// Modul: q8_8_mult
// Format: Q8.8 Isaretli Sabit Noktali Sayi (Signed Fixed-Point)
// Bit Yapisi:
//   - Bit [15]     : Isaret biti (Sign bit: 0 pozitif, 1 negatif)
//   - Bit [14:8]   : 7 bit tamsayi kismi (Integer: -128 ile +127 arasi)
//   - Bit [7:0]    : 8 bit kesir kismi (Fraction: Adim cozunurlugu = 1 / 256 = 0.00390625)
// ============================================================================
module q8_8_mult (
    input  signed [15:0] a,        // 1. Carpan girdisi (Q8.8)
    input  signed [15:0] b,        // 2. Carpan girdisi (Q8.8)
    output signed [15:0] result,   // Q8.8 formatina normalize edilmis carpim sonucu
    output               overflow  // Tasma bayragi (1: Sonuc 16-bit Q8.8 araligina sigmadi)
);

    // ------------------------------------------------------------------------
    // ARA CARPIM TELI TANIMLAMASI:
    // Iki adet 16-bit isaretli sayi carpildiginda donanimsal olarak 32-bit genislik olusur.
    // Format degisimi: (Q8.8) * (Q8.8) = Q16.16
    // Yani olusan 32-bit sayinin:
    //   - En ust biti [31]   : Isaret biti
    //   - Orta bitler [30:16]: 15 bit tamsayi kismi
    //   - Alt bitler [15:0]  : 16 bit kesir kismi
    // ------------------------------------------------------------------------
    wire signed [31:0] temp;

    // 16x16 Isaretli Carpma Islemi:
    // Vivado sentezleyicisi bu satiri hedef FPGA'deki adanmis DSP48 dilimine haritalar.
    assign temp = a * b;

    // ------------------------------------------------------------------------
    // NORMALIZASYON (Q16.16 -> Q8.8 DONUSUMU):
    // Hedef formata donmek icin kesir kismindaki fazla 8 biti atmamiz gerekir (saga 8 bit kaydirma).
    //   - temp[7:0]   : En onemsiz 8 kesir biti atilir (Trunkasyon / Kirpma yapilir).
    //   - temp[15:8]  : Yeni Q8.8 sayimizin 8-bitlik kesir kismi olur.
    //   - temp[22:16] : Yeni Q8.8 sayimizin 7-bitlik tamsayi kismi olur.
    //   - temp[23]    : Yeni Q8.8 sayimizin isaret biti olur.
    // Dolayisiyla [23:8] araligi tam olarak 16-bitlik Q8.8 sayisini verir.
    // ------------------------------------------------------------------------
    assign result = temp[23:8];

    // ------------------------------------------------------------------------
    // TASMA (OVERFLOW) KONTROLU:
    // Kirptigimiz ust bitler ([31:23] arasi, toplam 9 bit), sonucun isaret bitinin ([23])
    // basarili bir isaret uzantisi (sign extension) olup olmadigini gosterir.
    // Eger bu 9 bitin TAMAMI '0' (pozitif sayi icin) ya da TAMAMI '1' (negatif sayi icin) degilse;
    // carpim sonucu 16-bit Q8.8 araligini asmis, yani tasma olusmus demektir.
    // ------------------------------------------------------------------------
    assign overflow = (temp[31:23] != 9'b000000000) && (temp[31:23] != 9'b111111111);

endmodule
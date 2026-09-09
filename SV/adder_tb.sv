module adder_tb ();
    bit a, b, ci, s, co;
    single_bit_full_adder adder0 (
        .A(a),
        .B(b),
        .Cin(ci),
        .Co(co),
        .S(s));

  // Test vector definition
  typedef struct {
    bit ci, a, b;
    bit co, s;
  } pattern_t;

  pattern_t patterns[] = '{
    '{0,0,0,0,0},
    '{0,0,1,0,1},
    '{0,1,0,0,1},
    '{0,1,1,1,0},
    '{1,0,0,0,1},
    '{1,0,1,1,0},
    '{1,1,0,1,0},
    '{1,1,1,1,1}
  };

  initial begin
    foreach (patterns[i]) begin
      // Apply stimulus
      ci = patterns[i].ci;
      a  = patterns[i].a;
      b  = patterns[i].b;

      #1ns;

      // Check outputs
      assert (s == patterns[i].s)
        else $error("bad sum value: expected=%0b actual=%0b",
                    patterns[i].s, s);

      assert (co == patterns[i].co)
        else $error("bad carry out value: expected=%0b actual=%0b",
                    patterns[i].co, co);
    end

    $display("end of test");
    $finish;
  end

endmodule

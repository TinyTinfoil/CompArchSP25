//System verilog code for generating the data waveform
module generate_waveform;
  real x = 0;
  real pi = 3.14159265358979323846;
  string text = "0";
  int fd;
  initial begin
    fd = $fopen("sine.txt", "w");
    for (x = 0; x <= 127; x = x + 1) begin
      // format specifiers not fully implemented in iverilog
      $sformat(text, "%x", $rtoi($sin(x * pi / (2 * 127)) * 511));
      text = text.substr(5, 7);  //trim to 3 chars
      $fdisplay(fd, "%s", text);
    end
    $fclose(fd);
    $finish;
  end

endmodule

-- Two-Node White Rabbit Example Top Level
-- Simplified for synthesis testing

library ieee;
use ieee.std_logic_1164.all;

entity two_node_wr_top is
  port (
    -- Clock inputs
    clk_125m_p : in  std_logic;
    clk_125m_n : in  std_logic;
    
    -- Reset
    rst_n      : in  std_logic;
    
    -- LEDs
    led        : out std_logic_vector(7 downto 0);
    
    -- UART
    uart_txd   : out std_logic;
    uart_rxd   : in  std_logic;
    
    -- SFP interface (simplified)
    sfp_txp    : out std_logic;
    sfp_txn    : out std_logic;
    sfp_rxp    : in  std_logic;
    sfp_rxn    : in  std_logic
  );
end two_node_wr_top;

architecture behavioral of two_node_wr_top is
  signal clk_125m : std_logic;
  signal counter  : integer range 0 to 125000000 := 0;
begin

  -- Simple clock buffer (in real design, use proper IBUFDS)
  clk_125m <= clk_125m_p;
  
  -- Simple counter for LED blinking
  process(clk_125m)
  begin
    if rising_edge(clk_125m) then
      if rst_n = '0' then
        counter <= 0;
        led <= (others => '0');
      else
        if counter = 125000000 then
          counter <= 0;
          led <= not led;
        else
          counter <= counter + 1;
        end if;
      end if;
    end if;
  end process;
  
  -- Simple UART (always transmit '1')
  uart_txd <= '1';
  
  -- Simple SFP (just pass signals)
  sfp_txp <= '1';
  sfp_txn <= '0';
  
end behavioral;

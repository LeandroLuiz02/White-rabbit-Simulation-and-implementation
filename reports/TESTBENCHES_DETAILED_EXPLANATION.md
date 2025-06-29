# 🧪 Explicação Detalhada dos Testbenches White Rabbit

## 📊 VISÃO GERAL DOS 10 TESTBENCHES

O projeto contém **10 testbenches SystemVerilog** organizados em diferentes níveis de complexidade e funcionalidade específica. Cada um serve um propósito educacional e técnico específico.

---

## 📚 TESTBENCHES POR CATEGORIA

### 🟢 **NÍVEL BÁSICO (Iniciante)**

#### **1. `wr_standalone_basic_tb.sv`**
- **Propósito**: Testbench mais simples, sem dependências externas
- **Funcionalidade**: 
  - Simula um módulo `spec_top` básico
  - Gera clocks diferenciais (125 MHz)
  - Simula sinais SFP+ e UART
  - Contador simples para demonstrar atividade
- **Ideal para**: Verificar sintaxe, aprender estrutura básica
- **Dependências**: Nenhuma (totalmente independente)
- **Tempo de simulação**: ~100ns (muito rápido)

#### **2. `wr_minimal_two_node_tb.sv`**
- **Propósito**: Versão simplificada de dois nós White Rabbit
- **Funcionalidade**:
  - Dois nós WR conectados (master e slave)
  - Monitor UART para cada nó
  - Conexão SFP+ entre os nós
  - Mostra processo de boot e inicialização
- **Ideal para**: Entender comunicação entre nós
- **Dependências**: Módulos WR básicos
- **Tempo de simulação**: ~10µs

### 🟡 **NÍVEL INTERMEDIÁRIO (Componentes Específicos)**

#### **3. `wr_endpoint_tb.sv`**
- **Propósito**: Testa funcionalidade de endpoint White Rabbit
- **Funcionalidade**:
  - Interface de transmissão/recepção de dados
  - Codificação 8b/10b simplificada
  - Sinais de controle (tx_k, rx_k)
  - Detecção de erros básica
- **Ideal para**: Compreender interface física WR
- **Foco**: Camada física do protocolo

#### **4. `wr_timing_tb.sv`**
- **Propósito**: Sistema de timing e timestamping
- **Funcionalidade**:
  - Contadores TAI (Temps Atomique International)
  - Geração e detecção de PPS (Pulse Per Second)
  - Sincronização de clocks
  - Validação de timing
- **Ideal para**: Entender precisão temporal
- **Foco**: Aspectos de timing crítico

#### **5. `wr_softpll_ng_tb.sv`**
- **Propósito**: Software PLL (Phase-Locked Loop) Next Generation
- **Funcionalidade**:
  - Controle de DACs para ajuste de frequência
  - DMTD (Dual Mixer Time Difference)
  - Loop de controle de fase
  - Sincronização de clock
- **Ideal para**: Compreender sincronização de frequência
- **Foco**: Algoritmos de sincronização

#### **6. `wr_pps_gen_tb.sv`**
- **Propósito**: Gerador de pulsos PPS (Pulse Per Second)
- **Funcionalidade**:
  - Geração precisa de pulsos a cada segundo
  - Baseado em contador TAI
  - Sincronização temporal
  - Saída de referência temporal
- **Ideal para**: Entender geração de referência temporal
- **Foco**: Saídas de timing de precisão

#### **7. `wr_nic_tb.sv`**
- **Propósito**: Network Interface Card White Rabbit
- **Funcionalidade**:
  - Interface Wishbone para CPU
  - Registros de configuração
  - Acesso a memória e controle
  - Interface de rede simplificada
- **Ideal para**: Compreender interface de software
- **Foco**: Interface CPU-hardware

#### **8. `wr_streamers_tb.sv`**
- **Propósito**: Streamers para transferência de dados determinística
- **Funcionalidade**:
  - TX Streamer (transmissão)
  - RX Streamer (recepção)
  - Timestamping de dados
  - Transferência determinística
- **Ideal para**: Aplicações de dados em tempo real
- **Foco**: Transferência de dados com timing

#### **9. `wr_switch_tb.sv`**
- **Propósito**: Switch White Rabbit multi-porta
- **Funcionalidade**:
  - 8 portas de rede
  - Switching de pacotes
  - Propagação de timing
  - Interfaces WRF (White Rabbit Fabric)
- **Ideal para**: Compreender redes WR complexas
- **Foco**: Infraestrutura de rede

### 🔴 **NÍVEL AVANÇADO (Sistema Completo)**

#### **10. `wr_master_slave_sync_tb.sv`**
- **Propósito**: Sistema completo master-slave com sincronização
- **Funcionalidade**:
  - Nó master (Grandmaster Clock)
  - Nó slave sincronizando com master
  - Protocolo PTP completo
  - Medição de precisão
  - Monitor UART avançado
- **Ideal para**: Validar implementação completa
- **Foco**: Sistema WR funcional completo
- **Tempo de simulação**: ~1ms (mais longo)

---

## 🎯 RECOMENDAÇÕES DE USO

### **Para Aprendizado (Sequência Recomendada)**
1. **`wr_standalone_basic_tb.sv`** - Primeiro contato
2. **`wr_timing_tb.sv`** - Conceitos de timing
3. **`wr_endpoint_tb.sv`** - Interface física
4. **`wr_minimal_two_node_tb.sv`** - Comunicação entre nós
5. **`wr_master_slave_sync_tb.sv`** - Sistema completo

### **Para Desenvolvimento Específico**
- **Hardware/FPGA**: `wr_endpoint_tb.sv`, `wr_timing_tb.sv`
- **Software/Firmware**: `wr_nic_tb.sv`, `wr_streamers_tb.sv`
- **Rede/Protocolo**: `wr_switch_tb.sv`, `wr_master_slave_sync_tb.sv`
- **Timing/Sincronização**: `wr_softpll_ng_tb.sv`, `wr_pps_gen_tb.sv`

### **Para Validação**
- **Funcionalidade básica**: `wr_standalone_basic_tb.sv`
- **Comunicação**: `wr_minimal_two_node_tb.sv`
- **Sistema completo**: `wr_master_slave_sync_tb.sv`

---

## 🔧 SCRIPTS DE SIMULAÇÃO CORRESPONDENTES

### **Vivado (9 scripts .tcl)**
```
run_vivado_simple.tcl      → wr_standalone_basic_tb.sv
run_vivado_sim.tcl         → Testbenches específicos (2-9)
run_vivado_full.tcl        → wr_master_slave_sync_tb.sv
run_all_vivado_sims.tcl    → Todos os testbenches
```

### **ModelSim (6 scripts .do)**
```
run_modelsim_sim.do        → Testbenches específicos
run_all_modelsim_sims.do   → Todos os testbenches
run_simple.do              → wr_standalone_basic_tb.sv
```

---

## 📈 COMPLEXIDADE E TEMPO DE SIMULAÇÃO

| Testbench | Complexidade | Tempo Sim. | Dependências |
|-----------|--------------|------------|--------------|
| `wr_standalone_basic_tb.sv` | ⭐ | ~100ns | Nenhuma |
| `wr_minimal_two_node_tb.sv` | ⭐⭐ | ~10µs | Mínimas |
| `wr_endpoint_tb.sv` | ⭐⭐ | ~1µs | WR cores |
| `wr_timing_tb.sv` | ⭐⭐ | ~1µs | WR cores |
| `wr_pps_gen_tb.sv` | ⭐⭐ | ~8µs | WR cores |
| `wr_softpll_ng_tb.sv` | ⭐⭐⭐ | ~10µs | WR cores |
| `wr_nic_tb.sv` | ⭐⭐⭐ | ~1µs | WR cores |
| `wr_streamers_tb.sv` | ⭐⭐⭐ | ~5µs | WR cores |
| `wr_switch_tb.sv` | ⭐⭐⭐⭐ | ~10µs | WR cores |
| `wr_master_slave_sync_tb.sv` | ⭐⭐⭐⭐⭐ | ~1ms | WR cores |

---

## 💡 VALOR EDUCACIONAL DE CADA TESTBENCH

### **Conceitos Fundamentais**
- **Timing de precisão**: `wr_timing_tb.sv`, `wr_pps_gen_tb.sv`
- **Sincronização**: `wr_softpll_ng_tb.sv`, `wr_master_slave_sync_tb.sv`
- **Comunicação**: `wr_endpoint_tb.sv`, `wr_minimal_two_node_tb.sv`

### **Aspectos Práticos**
- **Interface software**: `wr_nic_tb.sv`
- **Transferência de dados**: `wr_streamers_tb.sv`
- **Infraestrutura de rede**: `wr_switch_tb.sv`

### **Validação de Sistema**
- **Teste básico**: `wr_standalone_basic_tb.sv`
- **Sistema completo**: `wr_master_slave_sync_tb.sv`

---

## 🚀 PRÓXIMOS PASSOS SUGERIDOS

### **Para Começar Agora**
```bash
# Teste o mais simples primeiro
vivado -source scripts/run_vivado_simple.tcl
```

### **Para Explorar Componentes**
```bash
# Execute testbenches específicos
vivado -source scripts/run_vivado_sim.tcl
```

### **Para Sistema Completo**
```bash
# Sistema master-slave completo
vivado -source scripts/run_vivado_full.tcl
```

Cada testbench foi projetado para ensinar aspectos específicos do White Rabbit, desde conceitos básicos até implementação completa de rede de timing de precisão.

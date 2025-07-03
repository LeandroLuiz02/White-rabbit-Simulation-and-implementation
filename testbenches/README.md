# 🧪 WHITE RABBIT TESTBENCHES

Esta pasta contém os testbenches SystemVerilog organizados e otimizados para o projeto White Rabbit Two-Node Example.

## 📋 TESTBENCHES DISPONÍVEIS

### 🎯 **TESTBENCHES PRINCIPAIS** (Cenários de Sistema)

#### 1. **`wr_standalone_basic_tb.sv`** 
- **Descrição**: Testbench básico standalone sem dependências WR-cores
- **Uso**: Verificação de sintaxe e estrutura básica
- **Nível**: Iniciante 
- **Módulo principal**: `wr_standalone_basic_tb`

#### 2. **`wr_minimal_two_node_tb.sv`**
- **Descrição**: Configuração mínima de dois nós White Rabbit 
- **Uso**: Exemplo mais simples de sincronização entre dois nós
- **Nível**: Intermediário
- **Módulo principal**: `wr_minimal_two_node_tb`

#### 3. **`wr_master_slave_sync_tb.sv`**
- **Descrição**: Demonstração completa Master-Slave com sincronização
- **Uso**: Cenário realista de sincronização White Rabbit
- **Nível**: Avançado
- **Módulo principal**: `wr_master_slave_sync_tb`

### 🔧 **TESTBENCHES DE COMPONENTES** (Testes Unitários)

#### 4. **`wr_endpoint_tb.sv`**
- **Componente**: White Rabbit Endpoint
- **Funcionalidade**: Interface de rede WR e codificação 8b/10b

#### 5. **`wr_nic_tb.sv`**
- **Componente**: Network Interface Controller  
- **Funcionalidade**: Interface Wishbone e controle de rede

#### 6. **`wr_pps_gen_tb.sv`**
- **Componente**: Pulse Per Second Generator
- **Funcionalidade**: Geração de pulsos de sincronização

#### 7. **`wr_softpll_ng_tb.sv`** 
- **Componente**: Software PLL Next Generation
- **Funcionalidade**: Sincronização de clock e DMTD

#### 8. **`wr_streamers_tb.sv`**
- **Componente**: White Rabbit Streamers
- **Funcionalidade**: Transmissão de dados com timestamp

#### 9. **`wr_switch_tb.sv`**
- **Componente**: White Rabbit Switch
- **Funcionalidade**: Switching de frames entre portas

#### 10. **`wr_timing_tb.sv`**
- **Componente**: White Rabbit Timing
- **Funcionalidade**: Contadores de tempo TAI/UTC

## 🎓 GUIA DE USO POR NÍVEL

### 📚 **Para Iniciantes**:
1. `wr_standalone_basic_tb.sv` - Comece aqui para entender a estrutura
2. `wr_endpoint_tb.sv` - Componente básico de rede
3. `wr_timing_tb.sv` - Conceitos de temporização

### 🔬 **Para Desenvolvimento**:
1. `wr_minimal_two_node_tb.sv` - Configuração simples de dois nós
2. `wr_nic_tb.sv` + `wr_pps_gen_tb.sv` - Componentes de rede e sincronização
3. `wr_master_slave_sync_tb.sv` - Cenário completo

### ⚙️ **Para Especialistas**:
1. `wr_softpll_ng_tb.sv` - PLL avançado e DMTD
2. `wr_streamers_tb.sv` - Transmissão com timestamp
3. `wr_switch_tb.sv` - Switching avançado

## 🚀 COMO EXECUTAR

### Vivado:
```bash
# Basic simulation
vivado -source ../scripts/run_vivado_simple.tcl

# Complete simulation  
vivado -source ../scripts/run_vivado_full.tcl

# All testbenches
vivado -source ../scripts/run_all_vivado_sims.tcl
```

### Testbench Específico:
```bash
# Exemplo para wr_minimal_two_node_tb
vivado -mode batch -source run_specific_tb.tcl -tclargs wr_minimal_two_node_tb
```

## 📊 ESTATÍSTICAS DOS TESTBENCHES

| Testbench | Tipo | Complexidade | Dependências |
|-----------|------|--------------|--------------|
| `wr_standalone_basic_tb` | Sistema | Baixa | Nenhuma |
| `wr_minimal_two_node_tb` | Sistema | Média | Mínimas |
| `wr_master_slave_sync_tb` | Sistema | Alta | WR-cores |
| `wr_endpoint_tb` | Unitário | Baixa | Básicas |
| `wr_nic_tb` | Unitário | Média | Wishbone |
| `wr_pps_gen_tb` | Unitário | Baixa | Timing |
| `wr_softpll_ng_tb` | Unitário | Alta | PLL/DMTD |
| `wr_streamers_tb` | Unitário | Média | Ethernet |
| `wr_switch_tb` | Unitário | Alta | Switching |
| `wr_timing_tb` | Unitário | Baixa | Contadores |


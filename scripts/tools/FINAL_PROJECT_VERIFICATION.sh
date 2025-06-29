#!/bin/bash
# ================================================================
# FINAL PROJECT VERIFICATION SCRIPT
# Comprehensive verification of all project components after reorganization
# ================================================================

echo "=========================================="
echo "FINAL PROJECT VERIFICATION"
echo "=========================================="
echo "Date: $(date)"
echo "Project: White Rabbit Two-Node Example"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Counters
TOTAL_CHECKS=0
PASSED_CHECKS=0
FAILED_CHECKS=0
WARNING_CHECKS=0

# Function to log results
log_check() {
    local status=$1
    local message=$2
    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
    
    case $status in
        "PASS")
            echo -e "${GREEN}✓ PASS${NC}: $message"
            PASSED_CHECKS=$((PASSED_CHECKS + 1))
            ;;
        "FAIL")
            echo -e "${RED}✗ FAIL${NC}: $message"
            FAILED_CHECKS=$((FAILED_CHECKS + 1))
            ;;
        "WARN")
            echo -e "${YELLOW}⚠ WARN${NC}: $message"
            WARNING_CHECKS=$((WARNING_CHECKS + 1))
            ;;
    esac
}

echo "=========================================="
echo "1. CHECKING PROJECT STRUCTURE"
echo "=========================================="

# Check main directories
main_dirs=("scripts" "testbenches" "docs" "constraints")
for dir in "${main_dirs[@]}"; do
    if [ -d "$dir" ]; then
        log_check "PASS" "Directory '$dir' exists"
    else
        log_check "FAIL" "Directory '$dir' missing"
    fi
done

# Check subdirectories
sub_dirs=("scripts/build" "scripts/setup" "scripts/tools" "scripts/analysis")
for dir in "${sub_dirs[@]}"; do
    if [ -d "$dir" ]; then
        log_check "PASS" "Subdirectory '$dir' exists"
    else
        log_check "FAIL" "Subdirectory '$dir' missing"
    fi
done

echo ""
echo "=========================================="
echo "2. CHECKING MAIN EXECUTABLE SCRIPTS"
echo "=========================================="

# Check main executable scripts in root
main_scripts=("build.sh" "setup.sh" "test.sh" "cleanup.sh" "FINALIZE_IMPLEMENTATION.sh")
for script in "${main_scripts[@]}"; do
    if [ -f "$script" ] && [ -x "$script" ]; then
        log_check "PASS" "Main script '$script' exists and is executable"
    elif [ -f "$script" ]; then
        log_check "WARN" "Main script '$script' exists but not executable"
    else
        log_check "FAIL" "Main script '$script' missing"
    fi
done

echo ""
echo "=========================================="
echo "3. CHECKING ORGANIZED SCRIPTS"
echo "=========================================="

# Check build scripts
build_scripts=("BUILD_REAL_WR.sh" "CREATE_MYD_J7A100T_SYNTHESIS.sh" "CREATE_VIVADO_SYNTHESIS.sh" "BUILD_HARDWARE_FIRST.sh")
for script in "${build_scripts[@]}"; do
    if [ -f "scripts/build/$script" ]; then
        log_check "PASS" "Build script 'scripts/build/$script' exists"
    else
        log_check "FAIL" "Build script 'scripts/build/$script' missing"
    fi
done

# Check setup scripts
setup_scripts=("MYD_J7A100T_SETUP.sh" "IMPLEMENTATION_ROADMAP.sh")
for script in "${setup_scripts[@]}"; do
    if [ -f "scripts/setup/$script" ]; then
        log_check "PASS" "Setup script 'scripts/setup/$script' exists"
    else
        log_check "FAIL" "Setup script 'scripts/setup/$script' missing"
    fi
done

# Check tool scripts
tool_scripts=("CLEANUP_PROJECT.sh" "test_project.sh" "quick_cleanup.sh")
for script in "${tool_scripts[@]}"; do
    if [ -f "scripts/tools/$script" ]; then
        log_check "PASS" "Tool script 'scripts/tools/$script' exists"
    else
        log_check "FAIL" "Tool script 'scripts/tools/$script' missing"
    fi
done

# Check analysis scripts
analysis_scripts=("ERROR_ANALYSIS.sh")
for script in "${analysis_scripts[@]}"; do
    if [ -f "scripts/analysis/$script" ]; then
        log_check "PASS" "Analysis script 'scripts/analysis/$script' exists"
    else
        log_check "FAIL" "Analysis script 'scripts/analysis/$script' missing"
    fi
done

echo ""
echo "=========================================="
echo "4. CHECKING SIMULATION FILES"
echo "=========================================="

# Check Vivado scripts
vivado_scripts=("run_vivado_sim.tcl" "run_all_vivado_sims.tcl")
for script in "${vivado_scripts[@]}"; do
    if [ -f "scripts/$script" ]; then
        log_check "PASS" "Vivado script 'scripts/$script' exists"
    else
        log_check "FAIL" "Vivado script 'scripts/$script' missing"
    fi
done

# Check ModelSim scripts
modelsim_scripts=("run_modelsim_sim.do" "run_all_modelsim_sims.do")
for script in "${modelsim_scripts[@]}"; do
    if [ -f "scripts/$script" ]; then
        log_check "PASS" "ModelSim script 'scripts/$script' exists"
    else
        log_check "FAIL" "ModelSim script 'scripts/$script' missing"
    fi
done

# Check testbenches
testbenches=("wr_endpoint_tb.sv" "wr_nic_tb.sv" "wr_pps_gen_tb.sv" "wr_softpll_ng_tb.sv" "wr_streamers_tb.sv" "wr_switch_tb.sv" "wr_timing_tb.sv" "wr_two_node_tb.sv")
for tb in "${testbenches[@]}"; do
    if [ -f "testbenches/$tb" ]; then
        log_check "PASS" "Testbench 'testbenches/$tb' exists"
    else
        log_check "FAIL" "Testbench 'testbenches/$tb' missing"
    fi
done

echo ""
echo "=========================================="
echo "5. CHECKING DOCUMENTATION"
echo "=========================================="

# Check main documentation files
main_docs=("README.md" "PROJECT_EXECUTIVE_SUMMARY.md" "PROJECT_MANIFEST.md")
for doc in "${main_docs[@]}"; do
    if [ -f "$doc" ]; then
        log_check "PASS" "Main document '$doc' exists"
    else
        log_check "FAIL" "Main document '$doc' missing"
    fi
done

# Check docs directory
docs_files=("COMPLETE_ROADMAP.md" "IMPLEMENTATION_GUIDE.md" "TECHNICAL_GUIDE.md" "VIVADO_SETUP.md" "SCRIPT_ORGANIZATION_LOGIC.md" "FINAL_VERIFICATION_REPORT.md")
for doc in "${docs_files[@]}"; do
    if [ -f "docs/$doc" ]; then
        log_check "PASS" "Documentation 'docs/$doc' exists"
    else
        log_check "FAIL" "Documentation 'docs/$doc' missing"
    fi
done

# Check scripts README
if [ -f "scripts/README.md" ]; then
    log_check "PASS" "Scripts documentation 'scripts/README.md' exists"
else
    log_check "FAIL" "Scripts documentation 'scripts/README.md' missing"
fi

echo ""
echo "=========================================="
echo "6. CHECKING FILE REFERENCES AND LINKS"
echo "=========================================="

# Function to check script references in files
check_references() {
    local file=$1
    local description=$2
    
    if [ ! -f "$file" ]; then
        log_check "FAIL" "$description - File not found"
        return
    fi
    
    # Check for old script references that should have been updated
    old_refs=$(grep -n "\.\/[A-Z_]*\.sh" "$file" 2>/dev/null | grep -v "scripts/" | head -5)
    if [ -n "$old_refs" ]; then
        log_check "WARN" "$description - Contains potential old script references"
        echo "    Found: $(echo "$old_refs" | tr '\n' '; ')"
    else
        log_check "PASS" "$description - No old script references found"
    fi
    
    # Check for broken documentation links
    broken_links=$(grep -n "\[.*\](.*/[^)]*)" "$file" 2>/dev/null | grep -v "http" | head -3)
    if [ -n "$broken_links" ]; then
        # Verify if referenced files exist
        while IFS= read -r link_line; do
            link_path=$(echo "$link_line" | sed -n 's/.*](\([^)]*\)).*/\1/p')
            if [ -n "$link_path" ] && [ ! -f "$link_path" ]; then
                log_check "WARN" "$description - Potential broken link: $link_path"
            fi
        done <<< "$broken_links"
    fi
}

# Check main files for references
check_references "README.md" "Main README"
check_references "docs/COMPLETE_ROADMAP.md" "Complete Roadmap"
check_references "docs/IMPLEMENTATION_GUIDE.md" "Implementation Guide"
check_references "scripts/README.md" "Scripts README"

echo ""
echo "=========================================="
echo "7. TESTING SCRIPT FUNCTIONALITY"
echo "=========================================="

# Test main wrapper scripts (dry run where possible)
echo "Testing main scripts..."

# Test build.sh
if [ -f "build.sh" ]; then
    if bash -n build.sh 2>/dev/null; then
        log_check "PASS" "build.sh - Syntax check passed"
    else
        log_check "FAIL" "build.sh - Syntax errors found"
    fi
else
    log_check "FAIL" "build.sh - File not found"
fi

# Test setup.sh
if [ -f "setup.sh" ]; then
    if bash -n setup.sh 2>/dev/null; then
        log_check "PASS" "setup.sh - Syntax check passed"
    else
        log_check "FAIL" "setup.sh - Syntax errors found"
    fi
else
    log_check "FAIL" "setup.sh - File not found"
fi

# Test cleanup.sh
if [ -f "cleanup.sh" ]; then
    if bash -n cleanup.sh 2>/dev/null; then
        log_check "PASS" "cleanup.sh - Syntax check passed"
    else
        log_check "FAIL" "cleanup.sh - Syntax errors found"
    fi
else
    log_check "FAIL" "cleanup.sh - File not found"
fi

echo ""
echo "=========================================="
echo "8. CHECKING EXTERNAL DEPENDENCIES"
echo "=========================================="

# Check for wr-cores
if [ -d "../wr-cores" ]; then
    log_check "PASS" "wr-cores repository found"
else
    log_check "WARN" "wr-cores repository not found in expected location"
fi

# Check for wrpc-sw
if [ -d "../wrpc-sw" ]; then
    log_check "PASS" "wrpc-sw repository found"
else
    log_check "WARN" "wrpc-sw repository not found in expected location"
fi

# Check for hdlmake
if command -v hdlmake &> /dev/null; then
    log_check "PASS" "hdlmake tool available"
else
    log_check "WARN" "hdlmake tool not found in PATH"
fi

echo ""
echo "=========================================="
echo "9. FINAL SUMMARY"
echo "=========================================="

echo "Total Checks: $TOTAL_CHECKS"
echo -e "${GREEN}Passed: $PASSED_CHECKS${NC}"
echo -e "${YELLOW}Warnings: $WARNING_CHECKS${NC}"
echo -e "${RED}Failed: $FAILED_CHECKS${NC}"
echo ""

if [ $FAILED_CHECKS -eq 0 ]; then
    echo -e "${GREEN}✓ PROJECT VERIFICATION COMPLETE - NO CRITICAL ISSUES FOUND${NC}"
    exit_code=0
elif [ $FAILED_CHECKS -le 2 ]; then
    echo -e "${YELLOW}⚠ PROJECT VERIFICATION COMPLETE - MINOR ISSUES FOUND${NC}"
    exit_code=1
else
    echo -e "${RED}✗ PROJECT VERIFICATION COMPLETE - CRITICAL ISSUES FOUND${NC}"
    exit_code=2
fi

echo ""
echo "=========================================="
echo "Verification completed at: $(date)"
echo "See above for detailed results."
echo "=========================================="

exit $exit_code

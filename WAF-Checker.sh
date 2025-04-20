#!/bin/bash

# Colors
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
CYAN=$(tput setaf 6)
YELLOW=$(tput setaf 3)
WHITE=$(tput setaf 7)
RESET=$(tput sgr0)
BOLD=$(tput bold)

# Banner
show_banner() {
    echo ""
    echo "${CYAN}${BOLD}╔════════════════════════════════════════════╗"
    echo "║        WAF Detector by MHSec 🇧🇩           ║"
    echo "╠════════════════════════════════════════════╣"
    echo "║ ${WHITE}Scan web targets for WAF protection easily${CYAN} ║"
    echo "╚════════════════════════════════════════════╝${RESET}"
    echo ""
}

# Single domain/IP check
check_single_domain() {
    read -p "${YELLOW}Enter the domain or IP to scan: ${RESET}" target
    echo -e "${CYAN}[*] Scanning ${target}...${RESET}"
    wafw00f "$target"
}

# Multiple domain/IP check from file
check_multiple_domains() {
    read -p "${YELLOW}Enter the file path with targets: ${RESET}" filepath
    if [[ ! -f "$filepath" ]]; then
        echo "${RED}[!] File not found! Please check the path.${RESET}"
        exit 1
    fi

    echo -e "${CYAN}[*] Starting bulk scan...${RESET}"
    while IFS= read -r target || [[ -n "$target" ]]; do
        echo -e "${GREEN}→ Scanning: $target ${RESET}"
        wafw00f "$target"
        echo "${WHITE}---------------------------------------------${RESET}"
    done < "$filepath"
}

# Main Menu
main_menu() {
    show_banner
    echo "${BOLD}${WHITE}[1]${RESET} ${GREEN}Scan a single domain or IP${RESET}"
    echo "${BOLD}${WHITE}[2]${RESET} ${GREEN}Scan multiple targets from file${RESET}"
    echo "${BOLD}${WHITE}[0]${RESET} ${RED}Exit${RESET}"
    echo ""
    read -p "${YELLOW}Select an option (0-2): ${RESET}" choice

    case "$choice" in
        1) check_single_domain ;;
        2) check_multiple_domains ;;
        0) echo "${RED}Exiting...${RESET}"; exit 0 ;;
        *) echo "${RED}[!] Invalid option. Try again.${RESET}"; sleep 1; main_menu ;;
    esac
}

main_menu

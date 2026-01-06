#!/bin/bash

# Colores para la interfaz
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Variables
PLAYIT_VERSION="v0.15.26"
PLAYIT_URL="https://github.com/playit-cloud/playit-agent/releases/download/${PLAYIT_VERSION}/playit-linux-amd64"
PLAYIT_FILE="playit-linux-amd64"

# Función para mostrar el banner
show_banner() {
    clear
    echo -e "${PURPLE}"
    echo "====================================================="
    echo "██████╗░██╗░░░░░░█████╗░██╗░░░██╗██╗████████╗"
    echo "██╔══██╗██║░░░░░██╔══██╗╚██╗░██╔╝██║╚══██╔══╝"
    echo "██████╔╝██║░░░░░███████║░╚████╔╝░██║░░░██║░░░"
    echo "██╔═══╝░██║░░░░░██╔══██║░░╚██╔╝░░██║░░░██║░░░"
    echo "██║░░░░░███████╗██║░░██║░░░██║░░░██║░░░██║░░░"
    echo "╚═╝░░░░░╚══════╝╚═╝░░╚═╝░░░╚═╝░░░╚═╝░░░╚═╝░░░"
    echo "====================================================="
    echo -e "${NC}"
}

# Función para mostrar mensajes
show_info() {
    echo -e "${CYAN}[ℹ]${NC} $1"
}

show_success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

show_warning() {
    echo -e "${YELLOW}[⚠]${NC} $1"
}

show_error() {
    echo -e "${RED}[✗]${NC} $1"
}

# Función para verificar dependencias
check_dependencies() {
    show_info "Verificando dependencias..."
    
    # Verificar wget
    if ! command -v wget &> /dev/null; then
        show_warning "wget no está instalado. Instalando..."
        apt-get update && apt-get install -y wget
        if [ $? -ne 0 ]; then
            show_error "No se pudo instalar wget"
            exit 1
        fi
        show_success "wget instalado correctamente"
    else
        show_success "wget ya está instalado"
    fi
    
    # Verificar si ya existe playit
    if [ -f "$PLAYIT_FILE" ]; then
        show_warning "El archivo $PLAYIT_FILE ya existe"
        read -p "¿Deseas sobrescribirlo? (s/n): " overwrite
        if [[ $overwrite == "s" || $overwrite == "S" ]]; then
            rm -f $PLAYIT_FILE
            show_success "Archivo anterior eliminado"
        else
            show_info "Usando archivo existente"
        fi
    fi
}

# Función principal para instalar Playit
install_playit() {
    show_banner
    
    echo -e "${WHITE}════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}         INSTALADOR DE PLAYIT.GG AGENT${NC}"
    echo -e "${WHITE}════════════════════════════════════════════════════${NC}"
    echo ""
    
    # Mostrar información de versión
    echo -e "${YELLOW}Versión:${NC} $PLAYIT_VERSION"
    echo -e "${YELLOW}URL:${NC} $PLAYIT_URL"
    echo ""
    
    # Verificar dependencias
    check_dependencies
    
    # Paso 1: Descargar Playit
    show_info "Paso 1/3: Descargando Playit Agent..."
    wget $PLAYIT_URL -O $PLAYIT_FILE
    
    if [ $? -eq 0 ]; then
        show_success "Playit Agent descargado correctamente"
    else
        show_error "Error al descargar Playit Agent"
        exit 1
    fi
    
    # Paso 2: Dar permisos de ejecución
    show_info "Paso 2/3: Configurando permisos..."
    chmod +x $PLAYIT_FILE
    
    if [ $? -eq 0 ]; then
        show_success "Permisos configurados correctamente"
    else
        show_error "Error al configurar permisos"
        exit 1
    fi
    
    # Paso 3: Ejecutar Playit
    show_info "Paso 3/3: Ejecutando Playit Agent..."
    echo ""
    echo -e "${GREEN}════════════════════════════════════════════════════${NC}"
    echo -e "${WHITE}¡PLAYIT AGENT INSTALADO CORRECTAMENTE! 🚀${NC}"
    echo -e "${GREEN}════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "${YELLOW}El agente de Playit.gg se está ejecutando...${NC}"
    echo -e "${CYAN}Archivo:${NC} $PWD/$PLAYIT_FILE"
    echo ""
    echo -e "${WHITE}Presiona Ctrl+C para detener la ejecución${NC}"
    echo ""
    
    # Ejecutar Playit
    ./$PLAYIT_FILE
}

# Función del menú principal
main_menu() {
    while true; do
        show_banner
        
        echo -e "${WHITE}╔════════════════════════════════════════════╗${NC}"
        echo -e "${WHITE}║       MENÚ PLAYIT.GG INSTALLER             ║${NC}"
        echo -e "${WHITE}╠════════════════════════════════════════════╣${NC}"
        echo -e "${WHITE}║                                            ║${NC}"
        echo -e "${WHITE}║  ${CYAN}1)${NC} ${GREEN}Instalar/Ejecutar Playit Agent${NC}      ${WHITE}║${NC}"
        echo -e "${WHITE}║  ${CYAN}2)${NC} ${YELLOW}Descargar solo (sin ejecutar)${NC}      ${WHITE}║${NC}"
        echo -e "${WHITE}║  ${CYAN}3)${NC} ${BLUE}Verificar instalación${NC}              ${WHITE}║${NC}"
        echo -e "${WHITE}║  ${CYAN}4)${NC} ${RED}Salir${NC}                               ${WHITE}║${NC}"
        echo -e "${WHITE}║                                            ║${NC}"
        echo -e "${WHITE}╚════════════════════════════════════════════╝${NC}"
        echo ""
        
        read -p "$(echo -e ${CYAN}"Selecciona una opción [1-4]: "${NC})" option
        
        case $option in
            1)
                install_playit
                ;;
            2)
                show_banner
                echo -e "${CYAN}════════════════════════════════════════════════════${NC}"
                echo -e "${WHITE}          DESCARGAR PLAYIT AGENT${NC}"
                echo -e "${CYAN}════════════════════════════════════════════════════${NC}"
                
                check_dependencies
                
                show_info "Descargando Playit Agent..."
                wget $PLAYIT_URL -O $PLAYIT_FILE
                
                if [ $? -eq 0 ]; then
                    chmod +x $PLAYIT_FILE
                    show_success "Playit Agent descargado correctamente en: $PWD/$PLAYIT_FILE"
                    echo ""
                    echo -e "${YELLOW}Para ejecutarlo manualmente:${NC}"
                    echo -e "${CYAN}./$PLAYIT_FILE${NC}"
                else
                    show_error "Error al descargar"
                fi
                
                echo ""
                read -p "$(echo -e ${CYAN}"Presiona Enter para continuar..."${NC})"
                ;;
            3)
                show_banner
                echo -e "${CYAN}════════════════════════════════════════════════════${NC}"
                echo -e "${WHITE}          VERIFICAR INSTALACIÓN${NC}"
                echo -e "${CYAN}════════════════════════════════════════════════════${NC}"
                
                if [ -f "$PLAYIT_FILE" ]; then
                    show_success "Playit Agent está instalado"
                    echo -e "${YELLOW}Ubicación:${NC} $PWD/$PLAYIT_FILE"
                    
                    # Verificar permisos
                    if [ -x "$PLAYIT_FILE" ]; then
                        show_success "Tiene permisos de ejecución"
                    else
                        show_warning "No tiene permisos de ejecución"
                    fi
                    
                    # Mostrar información del archivo
                    echo ""
                    echo -e "${YELLOW}Información del archivo:${NC}"
                    ls -lh $PLAYIT_FILE
                else
                    show_error "Playit Agent no está instalado"
                fi
                
                echo ""
                read -p "$(echo -e ${CYAN}"Presiona Enter para continuar..."${NC})"
                ;;
            4)
                echo ""
                echo -e "${GREEN}¡Hasta luego! 👋${NC}"
                echo ""
                exit 0
                ;;
            *)
                echo -e "${RED}Opción inválida. Intenta de nuevo.${NC}"
                sleep 2
                ;;
        esac
    done
}

# Verificar si se ejecuta como root (opcional, Playit no siempre necesita root)
check_root() {
    if [[ $EUID -eq 0 ]]; then
        show_warning "Este script se está ejecutando como root"
        echo -e "${YELLOW}Playit.gg generalmente no requiere privilegios root${NC}"
        read -p "¿Deseas continuar? (s/n): " continue_as_root
        if [[ $continue_as_root != "s" && $continue_as_root != "S" ]]; then
            echo -e "${GREEN}Saliendo...${NC}"
            exit 0
        fi
    fi
}

# Iniciar el script
check_root
main_menu

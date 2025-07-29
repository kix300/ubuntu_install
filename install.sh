#!/bin/bash

# Vérifier que le script est exécuté en tant que root
if [ "$(id -u)" -ne 0 ]; then
    echo "Ce script doit être exécuté en tant que root. Utilisez sudo."
    exit 1
fi

# Mise à jour des paquets existants
echo "Mise à jour des paquets..."
apt update && apt upgrade -y

# Installation des dépendances et outils de développement
echo "Installation des outils de développement..."
apt install -y git make gcc g++ libreadline-dev

# Installation de Visual Studio Code
echo "Installation de Visual Studio Code..."
if ! command -v code &> /dev/null; then
    apt install -y wget gpg
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
    sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
    apt update
    apt install -y code
    rm packages.microsoft.gpg
else
    echo "VSCode est déjà installé"
fi

# Installation de Fish shell
echo "Installation de Fish shell..."
apt install -y fish

# Définir Fish comme shell par défaut pour l'utilisateur actuel
echo "Configuration de Fish comme shell par défaut..."
if [ "$SHELL" != "$(which fish)" ]; then
    chsh -s $(which fish) $(whoami)
else
    echo "Fish est déjà le shell par défaut"
fi

# Installation de Starship
echo "Installation de Starship..."
if ! command -v starship &> /dev/null; then
    sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- --yes
else
    echo "Starship est déjà installé"
fi

# Configuration de Starship pour Fish
echo "Configuration de Starship pour Fish..."
FISH_CONFIG_DIR=~/.config/fish
mkdir -p $FISH_CONFIG_DIR

if ! grep -q "starship init fish" $FISH_CONFIG_DIR/config.fish 2>/dev/null; then
    echo "starship init fish | source" >> $FISH_CONFIG_DIR/config.fish
else
    echo "Starship est déjà configuré pour Fish"
fi

# Installation terminée
echo "Installation terminée avec succès!"
echo "Pour appliquer les changements, vous devrez peut-être vous déconnecter et vous reconnecter."
echo "Fish shell avec Starship se lancera automatiquement lors de votre prochaine connexion."

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
apt install -y git build-essential gcc g++ libreadline-dev clang valgrind vim
snap install code --classic

apt update
apt install ca-certificates curl
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
apt update

sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

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
echo "Verifie que Starship est bien dans fish et que chsh ai bien ete fait"

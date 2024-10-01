#!/bin/bash

log() {
  echo "[$(date)] $1"
}

# Проверяем, запущен ли уже ssh-agent
if ! [[ -v SSH_AUTH_SOCK ]]; then
  log "Запуск ssh-agent..."
  eval "$(ssh-agent -s)"
fi

# Добавляем ключ, только если он еще не добавлен
if ssh-add -l ~/.config/oxidized/id_rsa 2>/dev/null; then
  log "Ключ уже добавлен в ssh-agent."
else
  log "Добавление ключа в ssh-agent..."
  ssh-add ~/.config/oxidized/id_rsa
fi

# Добавляем хост-ключ GitHub, только если он еще не добавлен
if grep -q github.com ~/.ssh/known_hosts; then
  log "Хост-ключ GitHub уже добавлен."
else
  log "Добавление хост-ключа GitHub..."
  ssh-keyscan github.com >> ~/.ssh/known_hosts 2>/dev/null
fi

# Выполняем git push
log "Выполнение git push..."
cd /home/oxidized/.config/oxidized/oxidized_project/.git/
git push origin main

# Проверяем код выхода git push
if [[ $? -eq 0 ]]; then
  log "git push выполнен успешно."
else
  log "Ошибка при выполнении git push."
fi

## Настройка резервного копирования конфигурации сетевого оборудования с помощью Oxidized и автоматической отправкой изменений в GitHub.

### Шаг 1: Клонирование репозитория Oxidized и сборка Docker-образа.

```bash
git clone https://github.com/ytti/oxidized.git
docker build -t oxidized/oxidized:latest oxidized/
```

### Шаг 2: Создание директории конфигурации и копирование примеров.

```bash
mkdir oxidized_config
cp oxidized/examples/podman-compose/oxidized-config/{config,router.db} oxidized_config/
```

### Шаг 3: Настройка конфигурации Oxidized.

1. Откройте файл `oxidized_config/config` и отредактируйте следующие параметры:
    * `username`: Укажите имя пользователя для доступа к сетевым устройствам.
    * `password`: Укажите пароль для доступа к сетевым устройствам.
    * В секции `git`  укажите параметры для подключения к вашему Git-репозиторию на GitHub:
        * `repo`: Путь к локальному Git-репозиторию (например, `/home/oxidized/.config/oxidized/oxidized_project/.git`).
        * `user`: Имя пользователя на GitHub.
        * `email`: Email-адрес, который будет использоваться для Git-коммитов.

2. Откройте файл `oxidized_config/router.db` и добавьте информацию о ваших сетевых устройствах:
    * **IP-адрес**: IP-адрес устройства.
    * **Модель**: Модель устройства (например, `routeros`  для Mikrotik).

**Пример:**

```
192.168.1.1:routeros:admin:password
```

### Шаг 4: Клонирование Git-репозитория и настройка SSH-ключа.

1. Клонируйте ваш Git-репозиторий в директорию `oxidized_config`:

   ```bash
   git clone git@github.com:<ваш_логин_на_GitHub>/<имя_репозитория>.git oxidized_config/oxidized_project
   ```

2. Скопируйте ваш приватный SSH-ключ в директорию `oxidized_config`:

   ```bash
   cp ~/.ssh/id_rsa oxidized_config/id_rsa
   ```

3. Измените владельца и права доступа к SSH-ключу:

   ```bash
   chown 30000:30000 oxidized_config/id_rsa
   chmod 600 oxidized_config/id_rsa
   ```

### Шаг 5: Запуск контейнера Oxidized.

```bash
docker run -v oxidized_config:/home/oxidized/.config/oxidized/ -p 8888:8888/tcp -t oxidized/oxidized:latest
```

### Дополнительная информация:

* После запуска Oxidized вы можете получить доступ к его web-интерфейсу по адресу `http://<IP-адрес_сервера>:8888`.
* Oxidized будет автоматически получать конфигурации сетевых устройств, указанных в файле `router.db`, и сохранять изменения в Git-репозитории.
* Для настройки дополнительных параметров Oxidized (например, интервал опроса устройств) обратитесь к документации Oxidized: [https://github.com/ytti/oxidized](https://github.com/ytti/oxidized).

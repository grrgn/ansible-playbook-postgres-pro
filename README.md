# Установка и настройка PostgreSQL с помощью Ansible

## Описание

Консольное приложение, реализованное на Ansible, автоматически устанавливает PostgreSQL на наименее загруженный из двух указанных серверов (один на Debian, второй на AlmaLinux), настраивает доступ извне, создает пользователя с ограничением по IP, так же выполняет запрос с другого хоста.

## Возможности

- Подключение к удалённым серверам по SSH
- Оценка загрузки CPU на каждом сервере
- Выбор наименее загруженного хоста
- Установка PostgreSQL
- Настройка PostgreSQL для внешних соединений
- Создание пользователя `student` с разрешением подключения только с IP второго сервера
- Проверка доступности БД SQL-запросом `SELECT 1`

## Требования

- Ansible 2.15+
- Python 3.8+
- Приватный SSH-ключ с доступом к серверам под пользователем `ansible`

## Установка и запуск

1. Клонируйте репозиторий:

```bash
git clone https://github.com/grrgn/ansible-playbook-postgres-pro
cd ansible-playbook-postgres-pro
```
2. Установите роль

```bash
ansible-galaxy install -r requirements.yml
```
3. Запустите playbook с нужными ip-адресами через запятую. Так же можно переопределить переменные c ключом -e.
Переменные, которые можно переопределить:
```
pg_db_user: 
pg_db_user_password: 
pg_source_addr: 
pg_listen_addresses: 
pg_database: 
pg_version:
```
Запуск playbook.yml
```bash
ansible-playbook playbook.yml -i host1,host2
```
## Структура проекта
- roles/postgresql/ - роль для установки и настройки PostgreSQL
- playbook.yml - основной playbook для выбора хоста для установки и выполнения запроса
- requirements.yml - зависимости playbook'а

## Принятые решения и возникшие трудности

1. Выбор инструмента
Для установки postgresql был выбран ansible как наиболее подходящее production-ready решение для автоматизации установки и конфигурирования инфраструктуры.

2. Архитектура решения
Написана роль postgresql, отвечающая за установку, настройку подключения и пользователей. Для выбора наименее загруженного хоста и выполнения запроса запускается playbook

3. Конфигурация PostgreSQL
Первоначально рассматривался вариант шаблонов Jinja2 для настройки postgresql.conf и pg_hba.conf, но был выбран модульный подход через community.postgresql.*, как более подходящий и надёжный с точки зрения безопасности и поддержки.

4. Тестирование
Использован molecule с драйвером Docker. Созданы Dockerfile для образов Debian 12 и AlmaLinux 9 с поддержкой systemd.

5. Ограничения
Данный playbook будет работать только с двумя хостами, для того чтобы он мог работать с любым количеством хостов, нужно явно указать хосты в inventory файле и немного доработать переменные playbook.

## Примеры
# Запускаем два хоста: Debian 12 и AlmaLinux 9

- Запускаем нагрузку на одном из хостов для проверки playbook (AlmaLinux)
```bash
dd if=/dev/zero of=/dev/null bs=1M &
```
![Загрузка](https://i.imgur.com/jy2blQ6.png)

- Запускаем playbook
```bash
ansible-playbook playbook.yml -i 192.168.1.201, 192.168.1.202
```
![Запуск](https://i.imgur.com/pxCBaqh.png)

- Проверяем наличие PostgreSQL на хосте
```bash
sudo systemctl status postgresql-17.service
```
![Статус](https://i.imgur.com/VrR3sok.png)

- Делаем то же самое на другом хосте (Debian)
```bash
dd if=/dev/zero of=/dev/null bs=1M &
```
![Загрузка](https://i.imgur.com/nIqegM1.png)

- Запускаем playbook
```bash
ansible-playbook playbook.yml -i 192.168.1.201, 192.168.1.202
```
![Запуск](https://i.imgur.com/OVoysqX.png)

- Проверяем наличие PostgreSQL на хосте
```bash
sudo systemctl status postgresql@17-main.service
```
![Статус](https://i.imgur.com/W1dNeTf.png)

- Выполнение запроса к БД с другого хоста
![Запрос](https://i.imgur.com/lBr0EJ2.png)
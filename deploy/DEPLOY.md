# Serverga o'rnatish (Ubuntu/Debian)

Bot `main.py` orqali doimiy ishlaydi: har kuni `REPORT_HOUR:REPORT_MINUTE`
(`.env`, hozir 08:00, Asia/Tashkent) da hisobotlarni tayyorlab, `.env` dagi
barcha `TELEGRAM_CHAT_ID` larga yuboradi. Bundan tashqari botga `/run_now`
yozilsa — darrov yuboradi.

Quyida `USER` = server foydalanuvchingiz, `DIR` = loyiha yo'li
(masalan `/home/USER/report_bot`).

## 1. Tizim paketlari
```bash
sudo apt update
sudo apt install -y python3 python3-venv python3-pip git
```

## 2. Loyihani serverga ko'chirish
Lokal mashinadan (rsync bilan; keraksiz narsalarni tashlab):
```bash
rsync -av --exclude .venv --exclude output --exclude .playwright --exclude __pycache__ \
      ./report_bot/  USER@SERVER_IP:/home/USER/report_bot/
```
yoki git ishlatsangiz — serverda `git clone ...`.

## 3. Virtual muhit va kutubxonalar
```bash
cd /home/USER/report_bot
python3 -m venv .venv
.venv/bin/pip install --upgrade pip
.venv/bin/pip install -r requirements.txt
```

## 4. Playwright brauzeri (PDF uchun)
Brauzer loyiha ichiga (`.playwright`) o'rnatiladi — systemd xizmati topishi uchun:
```bash
cd /home/USER/report_bot
export PLAYWRIGHT_BROWSERS_PATH=$PWD/.playwright
.venv/bin/playwright install --with-deps chromium
```
> `--with-deps` kerakli tizim kutubxonalarini ham o'rnatadi (sudo so'raydi).

## 5. `.env` ni sozlash
```bash
cd /home/USER/report_bot
cp .env.example .env
nano .env
```
To'ldiring:
```
DB_HOST=<DB_HOST>
DB_PORT=5432
DB_NAME=<DB_NAME>
DB_USER=<DB_USER>
DB_PASSWORD=<parol>

TELEGRAM_BOT_TOKEN=<token>
TELEGRAM_CHAT_ID=111111111,222222222      # vergul bilan bir nechta

REPORT_HOUR=8
REPORT_MINUTE=0
TIMEZONE=Asia/Tashkent
```

## 6. Ulanishni tekshirish (ixtiyoriy)
```bash
cd /home/USER/report_bot
.venv/bin/python -c "import db, config; print(db.run_query_rows(config.QUERIES_DIR/'daily_summary.sql')[0][:4])"
```
Ustun nomlari chiqsa — baza ulanishi joyida.

## 7. systemd xizmati
```bash
# service faylni nusxalab, USER/DIR ni almashtiramiz
sudo cp deploy/report-bot.service /etc/systemd/system/report-bot.service
sudo sed -i "s|__USER__|USER|g; s|__DIR__|/home/USER/report_bot|g" /etc/systemd/system/report-bot.service

sudo systemctl daemon-reload
sudo systemctl enable --now report-bot.service
```

## 8. Tekshirish va boshqarish
```bash
systemctl status report-bot.service        # holati
journalctl -u report-bot.service -f        # jonli loglar
sudo systemctl restart report-bot.service  # qayta ishga tushirish
sudo systemctl stop report-bot.service     # to'xtatish
```

Ishlayotganini bilish uchun Telegramda botga **/run_now** yuboring — hisobotlar
darrov kelishi kerak. Har kuni 08:00 da avtomatik yuboriladi.

## Yangilanish (kodni o'zgartirgach)
```bash
# lokaldan rsync bilan qayta yuklang (2-qadam), so'ng:
sudo systemctl restart report-bot.service
```

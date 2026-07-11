# Docker bilan serverga o'rnatish (Ubuntu/Debian)

Bu usul systemd/venv/Playwright-deps bilan ovora bo'lmaslik uchun eng oson yo'l.
Barcha bog'liqliklar (Python, chromium, tizim kutubxonalari) image ichida.

## 1. Docker o'rnatish (server'da, bir marta)
```bash
curl -fsSL https://get.docker.com | sudo sh
sudo usermod -aG docker $USER    # keyin qayta login qiling
```

## 2. Loyihani serverga ko'chirish
```bash
rsync -av --exclude .venv --exclude output --exclude .playwright --exclude __pycache__ \
      ./report_bot/  USER@SERVER_IP:/home/USER/report_bot/
```

## 3. `.env` ni to'ldirish
```bash
cd /home/USER/report_bot
cp .env.example .env
nano .env
```
```
DB_HOST=<DB_HOST>
DB_PORT=5432
DB_NAME=<DB_NAME>
DB_USER=<DB_USER>
DB_PASSWORD=<parol>
TELEGRAM_BOT_TOKEN=<token>
TELEGRAM_CHAT_ID=111111111,222222222
REPORT_HOUR=8
REPORT_MINUTE=0
TIMEZONE=Asia/Tashkent
```
> Baza `<DB_HOST>` — konteyner uni host tarmog'i orqali bemalol ko'radi
> (qo'shimcha tarmoq sozlash shart emas).

## 4. Ishga tushirish
```bash
cd /home/USER/report_bot
docker compose up -d --build
```
Tamom — bot doimiy ishlaydi, server qayta yuklansa ham avtomatik ko'tariladi
(`restart: always`).

## 5. Boshqarish
```bash
docker compose logs -f          # jonli loglar
docker compose restart          # qayta ishga tushirish
docker compose down             # to'xtatish
docker compose up -d --build    # kod yangilangach qayta qurish
```

Tekshirish: Telegramda botga **/run_now** yozing — hisobotlar darrov keladi.
Har kuni 08:00 (Asia/Tashkent) da avtomatik yuboriladi.

## Eslatma
- Image `mcr.microsoft.com/playwright/python:v1.61.0-jammy` ga asoslangan —
  bu pip'dagi `playwright` versiyasiga mos. Agar `requirements.txt` da versiya
  o'zgarsa, `Dockerfile` dagi tag'ni ham moslang.
- LibreOffice (Excel pivot 0 muammosi) keyin kerak bo'lsa, `Dockerfile` ga
  `RUN apt-get update && apt-get install -y libreoffice-calc` qo'shiladi.

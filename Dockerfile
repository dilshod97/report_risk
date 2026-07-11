# Rasmiy Playwright image - chromium va uning barcha tizim kutubxonalari tayyor.
# Tag pip'dagi playwright versiyasiga mos (hozir 1.61.0).
FROM mcr.microsoft.com/playwright/python:v1.61.0-jammy

WORKDIR /app

# Kutubxonalar
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# O'rnatilgan playwright versiyasiga mos chromium brauzerini olib qo'yamiz
RUN playwright install chromium

# Loyiha kodi
COPY . .

# Bot doimiy ishlaydi (scheduler + /run_now)
CMD ["python", "main.py"]

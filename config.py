import os
from pathlib import Path

from dotenv import load_dotenv

BASE_DIR = Path(__file__).resolve().parent
load_dotenv(BASE_DIR / ".env")

DB_HOST = os.getenv("DB_HOST", "localhost")
DB_PORT = int(os.getenv("DB_PORT", "5432"))
DB_NAME = os.getenv("DB_NAME", "")
DB_USER = os.getenv("DB_USER", "")
DB_PASSWORD = os.getenv("DB_PASSWORD", "")

TELEGRAM_BOT_TOKEN = os.getenv("TELEGRAM_BOT_TOKEN", "")
# Bir nechta qabul qiluvchi - .env da vergul bilan ajratiladi, masalan:
# TELEGRAM_CHAT_ID=111111111,222222222,-1001234567890
TELEGRAM_CHAT_IDS = [
    cid.strip() for cid in os.getenv("TELEGRAM_CHAT_ID", "").split(",") if cid.strip()
]

REPORT_HOUR = int(os.getenv("REPORT_HOUR", "8"))
REPORT_MINUTE = int(os.getenv("REPORT_MINUTE", "0"))
TIMEZONE = os.getenv("TIMEZONE", "Asia/Tashkent")

QUERIES_DIR = BASE_DIR / "queries"
TEMPLATES_DIR = BASE_DIR / "templates"
OUTPUT_DIR = BASE_DIR / "output"

# PDF dagi 9 ta karta guruhlash konfiguratsiyasi (yorliqlar, справочник
# mapping va tartib) 'йўналиш гурухлари кесимида' sheetidan avtomatik
# o'qiladi (reports/pdf_daily_summary.py). Shu sababli guruhlar bu yerda
# qo'lda ko'rsatilmaydi.

# Har bir guruh (kartaga) biriktirilgan mas'ul xodim. Bazadan emas, qo'lda
# to'ldiriladi. Kalitlar 'йўналиш гурухлари кесимида' B10:B18 yorliqlariga
# aynan mos kelishi kerak. Bo'sh qoldirilganlar kartada ko'rinmaydi.
EMPLOYEE_BY_GROUP = {
    "Иш ҳақи ҳисобланиши ва тўланиши": "Х.саттаров",
    "\"Шаффоф қурилиш\" миллий ахборот тизими": "м.қосимов",
    "Банк маълумотлари таҳлили": "а.каримов",
    "Давлат бюджет маблағларини самарадорлиги": "у.тангриев",
    "Давлат харидлари": "А.Норов",
    "Субсидияларни ажратилиши": "Х.саттаров",
    "Солиқ бўйича": "у.тангриев",
    "Комплаенс-назорат": "а.каримов",
    "Сунъий интеллект орқали амалга оширилган таҳлиллар": "А.норов",
}

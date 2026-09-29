from pathlib import Path

import psycopg2
import psycopg2.extras

import config


def _connect():
    return psycopg2.connect(
        host=config.DB_HOST,
        port=config.DB_PORT,
        dbname=config.DB_NAME,
        user=config.DB_USER,
        password=config.DB_PASSWORD,
    )


def _load_sql(sql_path: Path, replacements: dict[str, str] | None = None) -> str:
    """SQL matnini o'qiydi; replacements berilsa, har bir kalitni almashtiradi.

    Kalit matnda topilmasa xato ko'taradi - filtr jimgina tushib qolmasligi uchun.
    """
    sql = Path(sql_path).read_text(encoding="utf-8")
    for old, new in (replacements or {}).items():
        if old not in sql:
            raise ValueError(f"{sql_path}: almashtiriladigan matn topilmadi: {old!r}")
        sql = sql.replace(old, new)
    return sql


def run_query(sql_path: Path, replacements: dict[str, str] | None = None) -> list[dict]:
    sql = _load_sql(sql_path, replacements)
    conn = _connect()
    try:
        with conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor) as cur:
            cur.execute(sql)
            rows = cur.fetchall()
            return [dict(row) for row in rows]
    finally:
        conn.close()


def run_query_rows(sql_path: Path, replacements: dict[str, str] | None = None) -> tuple[list[str], list[tuple]]:
    """Natijani ustunlar tartibini saqlagan holda qaytaradi (list -> tuple).

    Ba'zi query'larda ustun aliaslari takrorlanadi (masalan *_boshqa_holatlar
    ham son, ham summa uchun) - dict bunday ustunlarni yo'qotadi, shuning uchun
    pozitsion (tartibli) o'qish kerak bo'lganda shu funksiyadan foydalaniladi.
    """
    sql = _load_sql(sql_path, replacements)
    conn = _connect()
    try:
        with conn.cursor() as cur:
            cur.execute(sql)
            columns = [desc[0] for desc in cur.description]
            rows = cur.fetchall()
            return columns, rows
    finally:
        conn.close()

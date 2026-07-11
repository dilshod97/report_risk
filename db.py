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


def run_query(sql_path: Path) -> list[dict]:
    sql = Path(sql_path).read_text(encoding="utf-8")
    conn = _connect()
    try:
        with conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor) as cur:
            cur.execute(sql)
            rows = cur.fetchall()
            return [dict(row) for row in rows]
    finally:
        conn.close()


def run_query_rows(sql_path: Path) -> tuple[list[str], list[tuple]]:
    """Natijani ustunlar tartibini saqlagan holda qaytaradi (list -> tuple).

    Ba'zi query'larda ustun aliaslari takrorlanadi (masalan *_boshqa_holatlar
    ham son, ham summa uchun) - dict bunday ustunlarni yo'qotadi, shuning uchun
    pozitsion (tartibli) o'qish kerak bo'lganda shu funksiyadan foydalaniladi.
    """
    sql = Path(sql_path).read_text(encoding="utf-8")
    conn = _connect()
    try:
        with conn.cursor() as cur:
            cur.execute(sql)
            columns = [desc[0] for desc in cur.description]
            rows = cur.fetchall()
            return columns, rows
    finally:
        conn.close()

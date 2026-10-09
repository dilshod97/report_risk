from __future__ import annotations

import datetime as dt
from copy import copy
from decimal import Decimal
from pathlib import Path

from openpyxl import load_workbook
from openpyxl.workbook.properties import CalcProperties

import config
from db import run_query_rows

TEMPLATE_PATH = config.TEMPLATES_DIR / "risk_groups_template.xlsx"
DATA_SHEET = "рўйхат"

# рўйхат sheet tuzilishi:
#   1-3 qatorlar   - yordamchi/bo'sh (B3 - hisobot sanasi)
#   4-7 qatorlar   - ko'p bosqichli chiroyli sarlavha
#   8-qator        - "Жами" (=SUM(X9:X9999) formulalari, shablonda tayyor)
#   9-qator        - SQL ustun nomlari
#   10-qatordan    - ma'lumot
# Query 98 ustun qaytaradi: 1-4 kalitlar, 5-94 asosiy ko'rsatkichlar,
# 95-98 muddat kesimi (muddati mavjud/o'tgan son-summa).
# Sheetda C ustuni ("Соҳа") qo'lda yuritiladi (formulalar unga tayanmaydi),
# shuning uchun query ustunlari sheetga siljigan holda yotqiziladi:
#   1-2  -> A-B,  3-94 -> D..CQ,  95-98 -> CZ..DC.
HEADER_ROW = 9
FIRST_DATA_ROW = 10
QUERY_COLUMN_COUNT = 98
LAST_COLUMN = 108  # DD (Комплаенс)


def _sheet_col(query_col: int) -> int:
    if query_col <= 2:
        return query_col
    if query_col <= 94:
        return query_col + 1
    return query_col + 9


# Hisobot shakllangan sana ko'rsatiladigan katakchalar. Formula qayta
# hisoblanmaydigan ko'ruvchilarda eskirmasligi uchun sanani har bir katakka
# bevosita (statik qiymat) yozamiz.
DATE_CELLS = {
    DATA_SHEET: "B3",
    "Йўналишлар кесимида ": "BF3",
    "Вазирликлар кесимида (22)": "BF3",
    "йўналиш гурухлари кесимида": "CH4",
}

# Davr matni yoziladigan kataklar.
PERIOD_CELLS = [("Вазирликлар кесимида_new", "D4"), ("Вазирлик коррупцион", "D4")]

# Har bir ma'lumot qatoriga qo'yiladigan yordamchi ustun formulalari.
# {r} - qator raqami bilan almashtiriladi. CR/CS - "Тасдиғини топган",
# CT..CY - pivotlar tayanadigan VLOOKUP yordamchilari.
HELPER_FORMULAS = {
    96: "=+BP{r}+BR{r}+BZ{r}+CB{r}+CJ{r}+CL{r}",                # CR
    97: "=+BQ{r}+BS{r}+CA{r}+CC{r}+CK{r}+CM{r}",                # CS
    98: "=VLOOKUP(D{r},'Йўналишлар кесимида '!B:C,1,0)",        # CT
    99: "=VLOOKUP(B{r},'Вазирликлар кесимида (22)'!B:CF,1,0)",  # CU
    100: "=VLOOKUP(E{r},справочник!D:E,2,0)",                    # CV
    101: "=VLOOKUP(CV{r},'йўналиш гурухлари кесимида'!B:B,1,0)", # CW
    102: '=IFERROR(CU{r},"Бошқалар")',                           # CX
    103: "=VLOOKUP(D{r},справочник!A:B,2,0)",                    # CY
    # DD - Комплаенс belgisi: risk nomi 'Комплаенс реестр'da korrupsion (1)
    # deb belgilangan bo'lsa 1. 'Вазирлик коррупцион' varag'i shu ustunga tayanadi.
    108: "=IF(COUNTIFS('Комплаенс реестр'!$C:$C,D{r},'Комплаенс реестр'!$D:$D,1)>0,1,\"\")",
}


def _cell_value(value):
    if isinstance(value, Decimal):
        return float(value)
    return value


def fill_workbook(columns: list[str], rows: list[tuple], period_start: str = "01.01.2024"):
    wb = load_workbook(TEMPLATE_PATH)
    ws = wb[DATA_SHEET]

    # Eski ma'lumot qatorlari uchun uslub namunasini (birinchi data qatoridan)
    # saqlab qolamiz, keyin yangi qatorlarga qo'llash uchun.
    style_by_col = {}
    for col in range(1, LAST_COLUMN + 1):
        src = ws.cell(row=FIRST_DATA_ROW, column=col)
        style_by_col[col] = {
            "font": copy(src.font),
            "border": copy(src.border),
            "fill": copy(src.fill),
            "alignment": copy(src.alignment),
            "number_format": src.number_format,
        }

    # Eski ma'lumot qatorlarini (10-qatordan oxirigacha) tozalash.
    if ws.max_row >= FIRST_DATA_ROW:
        ws.delete_rows(FIRST_DATA_ROW, ws.max_row - FIRST_DATA_ROW + 1)

    # Yangi ma'lumotni yozish.
    for i, row in enumerate(rows):
        r = FIRST_DATA_ROW + i
        for qcol in range(1, QUERY_COLUMN_COUNT + 1):
            col = _sheet_col(qcol)
            value = _cell_value(row[qcol - 1]) if qcol - 1 < len(row) else None
            cell = ws.cell(row=r, column=col, value=value)
            _apply_style(cell, style_by_col.get(col))
        _apply_style(ws.cell(row=r, column=3), style_by_col.get(3))  # C bo'sh
        for col, formula in HELPER_FORMULAS.items():
            cell = ws.cell(row=r, column=col, value=formula.format(r=r))
            _apply_style(cell, style_by_col.get(col))

    # Hisobot shakllangan sanani barcha ko'rinadigan katakchalarga statik
    # qiymat sifatida yozamiz (formula emas - har qanday ko'ruvchida ko'rinsin).
    today = dt.datetime.combine(dt.date.today(), dt.time())
    for sheet_name, coord in DATE_CELLS.items():
        cell = wb[sheet_name][coord]
        fmt = cell.number_format
        cell.value = today
        cell.number_format = fmt
    for sheet_name, coord in PERIOD_CELLS:
        if sheet_name in wb.sheetnames:
            wb[sheet_name][coord] = f"{period_start}-{today:%d.%m.%Y} й"

    # Excel/LibreOffice faylni ochganda barcha formulalar (Жами, pivotlar,
    # yordamchi ustunlar) qayta hisoblanishi uchun.
    wb.calculation = CalcProperties(calcId=0, fullCalcOnLoad=True)
    return wb


def _apply_style(cell, style):
    if not style:
        return
    cell.font = copy(style["font"])
    cell.border = copy(style["border"])
    cell.fill = copy(style["fill"])
    cell.alignment = copy(style["alignment"])
    cell.number_format = style["number_format"]


def build(date_from: str | None = None) -> Path:
    """date_from berilsa (YYYY-MM-DD) hisobot shu sanadan boshlab yig'iladi
    (standart - 2024-01-01, ya'ni butun davr)."""
    replacements = {"'2024-01-01'": f"'{date_from}'"} if date_from else None
    columns, rows = run_query_rows(config.QUERIES_DIR / "daily_summary.sql", replacements)
    period_start = "01.01.2024" if not date_from else dt.date.fromisoformat(date_from).strftime("%d.%m.%Y")
    wb = fill_workbook(columns, rows, period_start=period_start)

    config.OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    suffix = "" if not date_from else f"_{dt.date.fromisoformat(date_from).year}_yil"
    out_path = config.OUTPUT_DIR / f"risk_guruhlari{suffix}_{dt.date.today().isoformat()}.xlsx"
    wb.save(out_path)
    return out_path


if __name__ == "__main__":
    print(build())

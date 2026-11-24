"""CareGrid LOCAL DEMO shared assistant, not a production AI or health service.

SQLite here persists fictional FAQ rules and redacted chat turns across browser
profiles on the same computer. It does NOT authenticate users or verify roles.
Use only on 127.0.0.1 with made-up examples.
"""
from __future__ import annotations

import json
import re
import sqlite3
import threading
from datetime import datetime, timezone
from pathlib import Path

ROLES = ("ngo", "admin", "lab", "pharmacy")
DEFAULT_CRITERIA = {
    "minimumMatches": 1,
    "maxQuestionLength": 500,
    "fallback": "This CareGrid demo has no verified answer. Please ask the appropriate team. No live beneficiary, patient or financial records are accessible.",
    "prohibited": "password,otp,pin,secret key",
    "retainHistory": True,
}
ALL_ROLES = list(ROLES)
DEFAULT_FAQS = [
    dict(id="faq-1", question="How do I register a beneficiary?",
         answer="In the NGO workspace, open Walk-in Registration and check original documents and consent. This is a demonstration; real registration needs secure server verification.",
         keywords="beneficiary,register,registration,walk in,cnic", roles=["ngo","admin"], enabled=True, category="Registration"),
    dict(id="faq-2", question="How does the Digital ID work?",
         answer="The Digital ID is a visual DEMO. Secure issuance, QR validation and counter verification are not active. Use signed credentials and a verification service for real use.",
         keywords="digital id,id card,verify,qr,identity,card", roles=ALL_ROLES, enabled=True, category="Digital ID"),
    dict(id="faq-3", question="How can a laboratory handle a request?",
         answer="In the Lab preview, open Lab Requests to inspect fictional appointments. Real prescription approval, OCR and reports require a backend and clinical safeguards.",
         keywords="lab,test,appointment,diagnostic,cbc,request,report", roles=["lab","ngo","admin"], enabled=True, category="Laboratory"),
    dict(id="faq-4", question="How is medicine support processed?",
         answer="The Pharmacy preview shows fictional prescriptions. Real dispensing requires professional checks, approved eligibility, inventory and secure transaction records.",
         keywords="pharmacy,medicine,prescription,dispense,medication,drug", roles=["pharmacy","ngo","admin"], enabled=True, category="Pharmacy"),
    dict(id="faq-5", question="How do I handle complaints?",
         answer="Beneficiaries can create sample complaint references. Actual staff workflows require authenticated requests and controlled access to a central service.",
         keywords="complaint,feedback,issue,support,help", roles=ALL_ROLES, enabled=True, category="Support"),
    dict(id="faq-6", question="Who manages assistant questions and criteria?",
         answer="The Admin Assistant Control page can manage local server demo FAQs, role visibility and matching criteria after entering the local demo admin key.",
         keywords="admin,assistant,criteria,rule,faq,questions,settings,history", roles=ALL_ROLES, enabled=True, category="Assistant"),
    dict(id="faq-7", question="Are the values live?",
         answer="No. Cards, balances, subsidies and lab records are fictional prototype data. There is no connected clinical, subsidy or financial system.",
         keywords="live,balance,remaining,eligibility,account,amount,subsidy", roles=ALL_ROLES, enabled=True, category="Demo data"),
]


class InvalidRequest(ValueError):
    """A request is malformed or over the configured demo safety limits."""


def _text(value, limit):
    if not isinstance(value, str):
        raise InvalidRequest("Expected a text field")
    return value.strip()[:limit]


def clean_faq(item):
    if not isinstance(item, dict):
        raise InvalidRequest("FAQ must be an object")
    roles = item.get("roles")
    if not isinstance(roles, list) or not roles or any(r not in ROLES for r in roles):
        raise InvalidRequest("Each FAQ needs one or more valid roles")
    cleaned = {
        "id": _text(item.get("id", ""), 90),
        "question": _text(item.get("question", ""), 180),
        "answer": _text(item.get("answer", ""), 1500),
        "keywords": _text(item.get("keywords", ""), 500),
        "category": _text(item.get("category", "General"), 65) or "General",
        "roles": list(dict.fromkeys(roles)),
        "enabled": bool(item.get("enabled", True)),
    }
    if not all(cleaned[k] for k in ("id", "question", "answer", "keywords")):
        raise InvalidRequest("FAQ ID, question, answer and keywords are required")
    return cleaned


def clean_criteria(value):
    if not isinstance(value, dict):
        raise InvalidRequest("Criteria must be an object")
    values = {**DEFAULT_CRITERIA, **value}
    try:
        minimum = int(values["minimumMatches"])
        maximum = int(values["maxQuestionLength"])
    except (ValueError, TypeError):
        raise InvalidRequest("Criteria numeric fields must be integers") from None
    if not 1 <= minimum <= 5 or not 100 <= maximum <= 1000:
        raise InvalidRequest("Criteria outside the allowed limits")
    return {
        "minimumMatches": minimum,
        "maxQuestionLength": maximum,
        "fallback": _text(values["fallback"], 900) or DEFAULT_CRITERIA["fallback"],
        "prohibited": _text(values["prohibited"], 400),
        "retainHistory": bool(values["retainHistory"]),
    }


def redact(value):
    """Best-effort demo redaction; NOT comprehensive PII de-identification."""
    text = str(value)
    text = re.sub(r"\b\d{5}-?\d{7}-?\d\b", "[redacted CNIC]", text)
    text = re.sub(r"[\w.+-]+@[\w.-]+\.[A-Za-z]{2,}", "[redacted email]", text)
    text = re.sub(r"\b(?:\+92|0)3\d{2}[- ]?\d{7}\b", "[redacted phone]", text)
    text = re.sub(r"\b\d{11,}\b", "[redacted number]", text)
    return text


def norm(value):
    return re.sub(r"\s+", " ", re.sub(r"[^a-z0-9\s]", " ", value.lower())).strip()


class DemoAssistantStore:
    def __init__(self, db_path: str | Path):
        self.db_path = Path(db_path).expanduser()
        self.db_path.parent.mkdir(parents=True, exist_ok=True)
        self._lock = threading.RLock()
        self._initialize()

    def _connect(self):
        db = sqlite3.connect(str(self.db_path), timeout=10)
        db.row_factory = sqlite3.Row
        return db

    def _initialize(self):
        with self._lock, self._connect() as db:
            db.execute("CREATE TABLE IF NOT EXISTS settings (name TEXT PRIMARY KEY, json_value TEXT NOT NULL)")
            db.execute("CREATE TABLE IF NOT EXISTS faqs (id TEXT PRIMARY KEY, json_value TEXT NOT NULL)")
            db.execute("""CREATE TABLE IF NOT EXISTS turns (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              session_id TEXT NOT NULL,
              role TEXT NOT NULL,
              date TEXT NOT NULL,
              question TEXT NOT NULL,
              answer TEXT NOT NULL,
              source TEXT NOT NULL
            )""")
            if db.execute("SELECT COUNT(*) FROM faqs").fetchone()[0] == 0:
                db.executemany("INSERT INTO faqs(id,json_value) VALUES (?,?)",
                               [(f["id"], json.dumps(f)) for f in DEFAULT_FAQS])
            db.execute("INSERT OR IGNORE INTO settings(name,json_value) VALUES (?,?)",
                       ("criteria", json.dumps(DEFAULT_CRITERIA)))
            db.commit()
        try:
            self.db_path.chmod(0o600)
        except OSError:
            pass

    def get_faqs(self, role=None):
        if role is not None and role not in ROLES:
            raise InvalidRequest("Unknown portal role")
        with self._lock, self._connect() as db:
            faqs = [json.loads(row["json_value"]) for row in db.execute("SELECT json_value FROM faqs ORDER BY rowid")]
        if role:
            return [faq for faq in faqs if faq["enabled"] and role in faq["roles"]]
        return faqs

    def replace_faqs(self, records):
        if not isinstance(records, list) or len(records) > 200:
            raise InvalidRequest("Expected up to 200 FAQs")
        sanitized = [clean_faq(v) for v in records]
        ids = [x["id"] for x in sanitized]
        if len(ids) != len(set(ids)):
            raise InvalidRequest("FAQ IDs must be unique")
        with self._lock, self._connect() as db:
            # No empty-list seed on subsequent reads; deliberate administrator removal persists.
            db.execute("DELETE FROM faqs")
            db.executemany("INSERT INTO faqs(id,json_value) VALUES (?,?)",
                           [(f["id"], json.dumps(f)) for f in sanitized])
            db.commit()
        return sanitized

    def get_criteria(self):
        with self._lock, self._connect() as db:
            row = db.execute("SELECT json_value FROM settings WHERE name='criteria'").fetchone()
            return clean_criteria(json.loads(row["json_value"]))

    def replace_criteria(self, data):
        criteria = clean_criteria(data)
        with self._lock, self._connect() as db:
            db.execute("INSERT OR REPLACE INTO settings(name,json_value) VALUES('criteria',?)",
                       (json.dumps(criteria),))
            db.commit()
        return criteria

    def get_history(self):
        with self._lock, self._connect() as db:
            rows = db.execute("SELECT * FROM turns ORDER BY id DESC LIMIT 500").fetchall()
        return [
            {"id": str(row["id"]), "sessionId": row["session_id"],
             "role": row["role"], "date": row["date"],
             "question": row["question"], "answer": row["answer"], "source": row["source"]}
            for row in reversed(rows)
        ]

    def clear_history(self):
        with self._lock, self._connect() as db:
            db.execute("DELETE FROM turns")
            db.commit()

    def reply(self, role, question, session_id=""):
        if role not in ROLES:
            raise InvalidRequest("Choose NGO, Admin, Lab or Pharmacy")
        if not isinstance(question, str):
            raise InvalidRequest("Question must be text")
        criteria = self.get_criteria()
        if len(question) > criteria["maxQuestionLength"]:
            raise InvalidRequest("Question exceeds the configured limit")
        clean = redact(question.strip())
        if not clean:
            raise InvalidRequest("Question cannot be blank")
        q = norm(clean)
        prohibited = [norm(x) for x in criteria["prohibited"].split(",") if norm(x)]
        if any(word in q for word in prohibited):
            result = {"text": "Do not share passwords, one-time codes or confidential information in this demo.",
                      "source": "Demo safety rule"}
        else:
            best, score = None, 0
            for faq in self.get_faqs(role):
                words = [norm(x) for x in faq["keywords"].split(",") if norm(x)]
                hits = sum(1 for k in words if k in q or any(
                    len(w) > 3 and w in q.split(" ") for w in k.split(" ")))
                if q == norm(faq["question"]):
                    hits += 4
                if hits > score:
                    best, score = faq, hits
            result = ({"text": best["answer"], "source": "Admin-configured demo FAQ · " + best["category"]}
                      if best and score >= criteria["minimumMatches"]
                      else {"text": criteria["fallback"], "source": "Demo fallback · No verified answer"})
        # No unredacted input is ever written to the database.
        if criteria["retainHistory"]:
            session = _text(session_id, 100) if isinstance(session_id, str) else ""
            with self._lock, self._connect() as db:
                db.execute("""INSERT INTO turns(session_id,role,date,question,answer,source)
                              VALUES(?,?,?,?,?,?)""",
                           (session, role, datetime.now(timezone.utc).isoformat(),
                            clean[:1000], redact(result["text"])[:1500], result["source"]))
                db.execute("DELETE FROM turns WHERE id NOT IN (SELECT id FROM turns ORDER BY id DESC LIMIT 500)")
                db.commit()
        return result

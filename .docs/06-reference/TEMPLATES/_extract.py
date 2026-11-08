#!/usr/bin/env python3
"""Ekstraksi fakta dari kode Flutter dan backend Laravel.

Modul ini sengaja hanya membaca file dan mengembalikan struktur data. Semua
hasil ekstraksi dipakai generator PRD/SKILL agar dokumen memuat path, kelas,
endpoint, aturan validasi, model, dan state yang benar-benar ada di repo.
"""
from __future__ import annotations

import json
import re
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]  # mobile_app
REPO_ROOT = ROOT.parent
BACKEND = REPO_ROOT / "Mobile-And-Backend"
LIB = ROOT / "lib"

_TABLES = json.loads((HERE / "_tables.json").read_text(encoding="utf-8"))
_ENDPOINTS = json.loads((HERE / "_endpoint_meta.json").read_text(encoding="utf-8"))

_CONTROLLER_INDEX: dict[str, list[Path]] | None = None
_PROVIDER_INDEX: dict[str, str] | None = None
_MODEL_CACHE: dict[str, dict] = {}
_BACKEND_CACHE: dict[tuple[str, str], dict] = {}


# ---------------------------------------------------------------------------
# Util
# ---------------------------------------------------------------------------

def read(path: Path) -> str:
    return path.read_text(encoding="utf-8", errors="ignore")


def rel(path: Path) -> str:
    resolved = path.resolve()
    try:
        return resolved.relative_to(ROOT).as_posix()
    except ValueError:
        try:
            return "../" + resolved.relative_to(REPO_ROOT).as_posix()
        except ValueError:
            return resolved.as_posix()


def delimiter_body(text: str, open_index: int, open_ch: str, close_ch: str) -> str:
    """Ambil isi blok berdelimiter, abaikan string/komentar."""
    depth = 0
    quote: str | None = None
    escaped = False
    line_comment = False
    block_comment = False
    i = open_index
    start = None
    while i < len(text):
        ch = text[i]
        nxt = text[i + 1] if i + 1 < len(text) else ""
        if line_comment:
            if ch == "\n":
                line_comment = False
            i += 1
            continue
        if block_comment:
            if ch == "*" and nxt == "/":
                block_comment = False
                i += 2
                continue
            i += 1
            continue
        if quote:
            if escaped:
                escaped = False
            elif ch == "\\":
                escaped = True
            elif ch == quote:
                quote = None
            i += 1
            continue
        if ch == "/" and nxt == "/":
            line_comment = True
            i += 2
            continue
        if ch == "/" and nxt == "*":
            block_comment = True
            i += 2
            continue
        if ch in "'\"`":
            quote = ch
            i += 1
            continue
        if ch == open_ch:
            depth += 1
            if start is None:
                start = i + 1
        elif ch == close_ch:
            depth -= 1
            if depth == 0 and start is not None:
                return text[start:i]
        i += 1
    return text[open_index + 1:]


def brace_body(text: str, open_index: int) -> str:
    return delimiter_body(text, open_index, "{", "}")


def method_body(text: str, method: str) -> str:
    match = re.search(rf"\bfunction\s+{re.escape(method)}\s*\(", text)
    if not match:
        return ""
    open_index = text.find("{", match.end())
    if open_index < 0:
        return ""
    return brace_body(text, open_index)


def class_body(text: str, class_name: str) -> str:
    match = re.search(rf"\bclass\s+{re.escape(class_name)}\b[^{{]*\{{", text)
    if not match:
        return ""
    return brace_body(text, match.end() - 1)


# ---------------------------------------------------------------------------
# Index backend
# ---------------------------------------------------------------------------

def controller_index() -> dict[str, list[Path]]:
    global _CONTROLLER_INDEX
    if _CONTROLLER_INDEX is not None:
        return _CONTROLLER_INDEX
    index: dict[str, list[Path]] = {}
    roots = [
        BACKEND / "app" / "Http" / "Controllers" / "Api" / "User",
        BACKEND / "app" / "Http" / "Controllers" / "Api" / "Admin",
        BACKEND / "app" / "Http" / "Controllers",
    ]
    seen: set[Path] = set()
    for root in roots:
        if not root.exists():
            continue
        for path in root.rglob("*.php"):
            if path in seen:
                continue
            seen.add(path)
            text = read(path)
            match = re.search(r"\bclass\s+(\w+)", text)
            if match:
                index.setdefault(match.group(1), []).append(path)
    _CONTROLLER_INDEX = index
    return index


def pick_controller(class_name: str) -> Path | None:
    candidates = controller_index().get(class_name, [])
    if not candidates:
        return None
    normalized = [str(p).replace("\\", "/") for p in candidates]
    user = [p for p, n in zip(candidates, normalized) if "/Api/User/" in n]
    return (user or candidates)[0]


def form_request_fields(type_name: str) -> list[tuple[str, str]]:
    """Baca rules() dari FormRequest bila method memakai FormRequest."""
    if not type_name or not type_name.endswith("Request"):
        return []
    for root in [BACKEND / "app" / "Http" / "Requests", BACKEND / "app"]:
        if not root.exists():
            continue
        for path in root.rglob(f"{type_name}.php"):
            body = method_body(read(path), "rules")
            if body:
                return parse_rules(body)
    return []


def parse_rules(body: str) -> list[tuple[str, str]]:
    fields: list[tuple[str, str]] = []
    seen: set[str] = set()
    pattern = re.compile(
        r"['\"]([a-zA-Z0-9_.*]+)['\"]\s*=>\s*['\"]([^'\"]*)['\"]"
    )
    for match in pattern.finditer(body):
        name, rule = match.group(1), match.group(2)
        if name in seen:
            continue
        if not re.search(
            r"\b(required|nullable|string|integer|numeric|boolean|array|image|file|email|date|"
            r"in:|max:|min:|size:|digits:|mimes:|exists:|unique:|after|before|confirmed|"
            r"sometimes|present)\b",
            rule,
        ):
            continue
        seen.add(name)
        fields.append((name, rule))
    return fields


def response_keys(body: str) -> list[str]:
    keys: list[str] = []
    for match in re.finditer(r"response\(\)->json\(\s*\[", body):
        open_index = body.find("[", match.start())
        block = delimiter_body(body, open_index, "[", "]") if open_index >= 0 else ""
        if not block:
            continue
        depth = 0
        for line in block.splitlines():
            stripped = line.strip()
            if depth == 0:
                key = re.match(r"['\"]([a-zA-Z0-9_]+)['\"]\s*=>", stripped)
                if key and key.group(1) not in keys:
                    keys.append(key.group(1))
            depth += line.count("[") - line.count("]")
    return keys


def method_params(text: str, method: str) -> list[tuple[str, str]]:
    match = re.search(rf"\bfunction\s+{re.escape(method)}\s*\(([^)]*)\)", text)
    if not match:
        return []
    params = []
    for raw in match.group(1).split(","):
        raw = raw.strip()
        if not raw:
            continue
        bits = raw.split()
        if len(bits) >= 2:
            params.append((bits[-2].lstrip("?\\"), bits[-1].lstrip("$")))
    return params


def extract_backend(controller: str, method: str) -> dict:
    key = (controller, method)
    if key in _BACKEND_CACHE:
        return _BACKEND_CACHE[key]

    result = {
        "source": "",
        "fields": [],
        "response_keys": [],
        "messages": [],
        "params": [],
        "found": False,
    }
    path = pick_controller(controller)
    if path and method and method != "-":
        text = read(path)
        body = method_body(text, method)
        if body:
            result["found"] = True
            result["source"] = rel(path)
            result["fields"] = parse_rules(body)
            result["response_keys"] = response_keys(body)
            result["params"] = method_params(text, method)
            messages = []
            for match in re.finditer(r"__\(\s*['\"]([^'\"]{3,160})['\"]", body):
                msg = match.group(1).strip()
                low = msg.lower()
                if len(msg) < 12 or low in {"tidak dikenal", "admin", "tamu", "user", "guest"}:
                    continue
                if not any(
                    key in low
                    for key in (
                        "tidak", "gagal", "salah", "wajib", "habis", "kadaluarsa",
                        "kedaluwarsa", "ditolak", "valid", "berhasil", "belum",
                        "harap", "silakan", "sudah", "batal", "terbatas",
                    )
                ):
                    continue
                if msg not in messages:
                    messages.append(msg)
            result["messages"] = messages[:4]
            for type_name, _param in method_params(text, method):
                if type_name.endswith("Request") and type_name != "Request":
                    result["fields"].extend(form_request_fields(type_name))
    _BACKEND_CACHE[key] = result
    return result


# ---------------------------------------------------------------------------
# Index provider dan model
# ---------------------------------------------------------------------------

def provider_index() -> dict[str, str]:
    global _PROVIDER_INDEX
    if _PROVIDER_INDEX is not None:
        return _PROVIDER_INDEX
    index: dict[str, str] = {}
    if not LIB.exists():
        _PROVIDER_INDEX = index
        return index
    pattern = re.compile(r"\b(?:final|const)\s+(\w+Provider)\s*=")
    for path in LIB.rglob("*.dart"):
        text = read(path)
        for match in pattern.finditer(text):
            index.setdefault(match.group(1), rel(path))
    _PROVIDER_INDEX = index
    return index


def find_provider_file(name: str) -> str:
    return provider_index().get(name, "")


def model_fields(path: Path) -> dict:
    key = rel(path)
    if key in _MODEL_CACHE:
        return _MODEL_CACHE[key]
    text = read(path)
    class_match = re.search(r"\bclass\s+(\w+)", text)
    class_name = class_match.group(1) if class_match else path.stem
    fields: list[tuple[str, str]] = []
    body = class_body(text, class_name) or text
    pattern = re.compile(
        r"^\s{2}(?:final|late\s+final)\s+([A-Za-z_][\w<>,? ]*?)\s+(\w+)\s*;",
        re.M,
    )
    for match in pattern.finditer(body):
        name = match.group(2)
        if name.startswith("_") or name in {n for n, _ in fields}:
            continue
        fields.append((name, match.group(1).strip()))
    info = {"class": class_name, "file": key, "fields": fields[:18]}
    _MODEL_CACHE[key] = info
    return info


# ---------------------------------------------------------------------------
# Ekstraksi layar Flutter
# ---------------------------------------------------------------------------

_ENDPOINT_NAMES = set(_ENDPOINTS)


def _unique(values):
    out = []
    for value in values:
        if value and value not in out:
            out.append(value)
    return out


def _normalize_route(route: str) -> str:
    """Ubah string navigasi Dart menjadi pola route yang dapat dibaca."""
    route = route.strip()
    if "${" in route:
        head, rest = route.split("${", 1)
        match = re.search(r"\[['\"]([^'\"]+)['\"]\]|\.([A-Za-z_]\w*)", rest)
        param = (match.group(1) or match.group(2)) if match else "id"
        if not head.endswith("/") and "=" not in head:
            head += "/"
        return head + ":" + param
    if re.search(r"\$[A-Za-z_]\w*", route):
        return re.sub(r"\$[A-Za-z_]\w*", ":id", route)
    return route.rstrip("[(")


def _infer_type(line: str) -> str:
    """Tebak tipe field dari inisialisasinya bila anotasi tidak eksplisit."""
    if "=" not in line:
        return "inferred"
    rhs = line.split("=", 1)[1].strip().rstrip(";").strip()
    if not rhs:
        return "inferred"
    generated = re.search(r"\.generate\s*\(.*?=>\s*([A-Za-z_]\w*)\s*\(", rhs)
    if generated:
        return f"List<{generated.group(1)}>"
    call = re.search(r"^(?:const\s+)?([A-Za-z_][\w<>,? ]*?)\s*\(", rhs)
    if call and call.group(1) not in {"const"}:
        return call.group(1).strip()
    if rhs.startswith("["):
        has_null = re.search(r"\bnull\b", rhs) is not None
        if re.search(r"['\"]", rhs):
            return "List<String?>" if has_null else "List<String>"
        if "{" in rhs:
            return "List<Map<String, dynamic>>"
        return "List<dynamic>"
    if rhs in {"true", "false"}:
        return "bool"
    if re.fullmatch(r"-?\d+", rhs):
        return "int"
    if re.fullmatch(r"-?\d+\.\d+", rhs):
        return "double"
    if re.fullmatch(r"['\"].*['\"]", rhs, re.S):
        return "String"
    return "inferred"


def extract_screen(path: Path) -> dict:
    text = read(path)
    lines = len(text.splitlines())

    class_matches = re.findall(r"\bclass\s+(\w+)\s+extends\s+([A-Za-z0-9_<>?, ]+)", text)
    screen_classes = [
        (name, base.strip())
        for name, base in class_matches
        if name.endswith("Screen")
    ]
    if not screen_classes:
        screen_classes = [(path.stem, "")]
    cls, base = screen_classes[0]

    state_class = ""
    state_base = ""
    for name, state_base_name in class_matches:
        if name.endswith("State") and ("ConsumerState" in state_base_name or "State<" in state_base_name):
            state_class, state_base = name, state_base_name.strip()
            break

    imports = re.findall(r"^\s*import\s+['\"]([^'\"]+)['\"]", text, re.M)

    core_widgets = []
    feature_widgets = []
    models = []
    repositories = []
    services = []
    for imp in imports:
        if "/Core/Widgets/" in imp:
            match = re.search(r"/Core/Widgets/([^/]+)/", imp)
            if match:
                core_widgets.append(match.group(1))
        elif "/Presentation/Widgets/" in imp:
            match = re.search(r"/Presentation/Widgets/([^/]+)/", imp)
            if match:
                feature_widgets.append(match.group(1))
        elif "/Data/Models/" in imp or "/Models/" in imp:
            models.append(imp)
        elif "/Data/Repositories/" in imp:
            repositories.append(imp)
        elif "/Data/Services/" in imp or "/Core/Services/" in imp:
            services.append(imp)

    # Resolve import paths relatif terhadap file layar.
    model_infos = []
    for imp in _unique(models):
        if not imp.startswith("."):
            continue
        resolved = (path.parent / imp).resolve()
        if resolved.exists():
            model_infos.append(model_fields(resolved))

    providers = _unique(re.findall(r"ref\.(?:read|watch|listen)\(([A-Za-z_][A-Za-z0-9_]*)", text))
    endpoints = []
    for name in re.findall(r"ApiEndpoints\.([A-Za-z0-9_]+)", text):
        if name in _ENDPOINT_NAMES:
            endpoints.append(name)
    endpoints = _unique(endpoints)

    nav_routes = []
    for match in re.finditer(
        r"(?:context\.(?:go|push|replace|pushNamed)|Navigator\.(?:pushNamed|pushReplacementNamed))"
        r"\(\s*['\"]([^'\"]+)['\"]",
        text,
    ):
        nav_routes.append(_normalize_route(match.group(1)))
    for match in re.finditer(
        r"(?:context\.(?:go|push|replace)|Navigator\.(?:pushNamed|pushReplacementNamed))"
        r"\(\s*['\"]([^'\"]*?\$\{[^}]+\}[^'\"]*)['\"]",
        text,
    ):
        nav_routes.append(_normalize_route(match.group(1)))
    nav_routes = _unique(nav_routes)

    controllers = len(re.findall(r"\bTextEditingController\s*\(", text))
    form_fields = len(re.findall(r"\b(?:TextFormField|TextField)\s*\(", text))
    dropdowns = len(re.findall(r"\b(?:DropdownButtonFormField|DropdownButton)\s*[<(]", text))
    switches = len(re.findall(r"\b(?:SwitchListTile|Switch)\s*\(", text))
    validators = len(re.findall(r"\bvalidator\s*:", text))
    obscure = len(re.findall(r"obscureText\s*:\s*true", text))
    max_lengths = _unique(re.findall(r"maxLength\s*:\s*(\d+)", text))
    keyboard_types = _unique(re.findall(r"keyboardType\s*:\s*TextInputType\.(\w+)", text))
    input_formatters = _unique(re.findall(r"([A-Za-z0-9_]+InputFormatter)", text))

    flags = {
        "camera": bool(re.search(r"\bCameraController\b", text)),
        "image_picker": bool(re.search(r"\bImagePicker\b", text)),
        "webview": bool(re.search(r"\bWebViewController\b", text)),
        "timer": bool(re.search(r"\bTimer\b|\bTimer\.periodic\b", text)),
        "scroll_controller": bool(re.search(r"\bScrollController\b", text)),
        "refresh_indicator": bool(re.search(r"\bRefreshIndicator\b", text)),
        "cached_image": bool(re.search(r"\bCachedNetworkImage\b", text)),
        "shimmer": bool(re.search(r"\bAppShimmer\b", text)),
        "guest_prompt": bool(re.search(r"\bGuestAuthPrompt\b", text)) or bool(re.search(r"\bGuestMode\b", text)),
        "empty_state": bool(re.search(r"\bAppEmptyState\b", text)),
        "error_state": bool(re.search(r"\bAppErrorState\b", text)),
        "snackbar": bool(re.search(r"\bSnackBar\b|AppSnackbar", text)),
        "dialog": bool(re.search(r"\bshowDialog\b", text)),
        "bottom_sheet": bool(re.search(r"\bshowModalBottomSheet\b", text)),
        "upload": bool(re.search(r"\b(?:FormData|MultipartFile|XFile)\b", text)),
        "websocket": bool(re.search(r"\bWebSocket\b|\bweb_socket\b|\bsocket\.on\b", text)),
        "pagination": bool(re.search(r"\b(?:hasMore|currentPage|nextPage|loadMore)\b", text)),
        "l10n": "AppLocalizations" in text,
        "observer": "WidgetsBindingObserver" in text,
        "ticker": "TickerProviderStateMixin" in text,
        "keep_alive": "AutomaticKeepAliveClientMixin" in text,
        "riverpod": "flutter_riverpod" in text,
        "go_router": "go_router" in text,
        "dio": "DioClient" in text or "Dio(" in text,
        "direct_dio": "DioClient.instance" in text,
        "secure_storage": "FlutterSecureStorage" in text,
        "shared_prefs": "SharedPreferences" in text,
    }

    if state_class:
        body = class_body(text, state_class)
    else:
        body = class_body(text, cls) or text
    state_fields = []
    field_pattern = re.compile(
        r"^\s{2}(?:(?:final|late|var)\s+)*([A-Za-z_][\w<>,?. ]*?)\s+(_\w+)\s*(?:=|;)",
        re.M,
    )
    for match in field_pattern.finditer(body):
        type_name = match.group(1).strip()
        name = match.group(2)
        if name in {n for n, _ in state_fields}:
            continue
        line_end = body.find("\n", match.start())
        line = body[match.start(): line_end if line_end >= 0 else len(body)]
        if " get " in line or "static const" in line:
            continue
        if type_name in {"final", "late", "var", "late final", "const"}:
            type_name = _infer_type(line)
        state_fields.append((name, type_name))

    methods = _unique(
        re.findall(
            r"\b(?:Future<[^>]+>|void|bool|int|double|String|Widget)\s+(_[a-zA-Z0-9_]+)\s*\(",
            body,
        )
    )

    if not state_fields:
        # Layar stateless/wrapper: tetap ambil field kelas layar.
        for match in field_pattern.finditer(class_body(text, cls)):
            line_end = text.find("\n", match.start())
            line = text[match.start(): line_end if line_end >= 0 else len(text)]
            if " get " in line or "static const" in line:
                continue
            state_fields.append((match.group(2), match.group(1).strip()))

    if "ConsumerStatefulWidget" in base:
        state_mode = "Riverpod + state lokal (`setState`)"
    elif "ConsumerWidget" in base:
        state_mode = "Riverpod (`ConsumerWidget`)"
    elif "StatefulWidget" in base:
        state_mode = "State lokal (`setState`)"
    elif "StatelessWidget" in base:
        state_mode = "Stateless"
    else:
        state_mode = base or "Tidak terdeteksi"

    if flags["websocket"]:
        realtime = "real-time (WebSocket/sinyal)"
    elif flags["timer"] and flags["camera"]:
        realtime = "kamera real-time"
    elif flags["timer"]:
        realtime = "polling periodik"
    elif flags["camera"]:
        realtime = "kamera on-demand"
    else:
        realtime = "request-response"

    return {
        "lines": lines,
        "class": cls,
        "base": base,
        "state_class": state_class,
        "state_base": state_base,
        "imports": imports,
        "core_widgets": _unique(core_widgets),
        "feature_widgets": _unique(feature_widgets),
        "models": model_infos,
        "repositories": _unique(repositories),
        "services": _unique(services),
        "providers": providers,
        "endpoints": endpoints,
        "nav_routes": nav_routes,
        "controllers": controllers,
        "form_fields": form_fields,
        "dropdowns": dropdowns,
        "switches": switches,
        "validators": validators,
        "obscure": obscure,
        "max_lengths": max_lengths,
        "keyboard_types": keyboard_types,
        "input_formatters": input_formatters,
        "flags": flags,
        "state_fields": state_fields[:20],
        "methods": methods[:20],
        "state_mode": state_mode,
        "realtime": realtime,
        "source": rel(path),
    }


def screen_type(slug: str, ex: dict) -> str:
    slug = slug.lower()
    flags = ex["flags"]
    if "scanner" in slug or flags["camera"]:
        return "scanner"
    if "webview" in slug or flags["webview"]:
        return "webview"
    if any(word in slug for word in ("payment", "qris", "virtual-account")):
        return "payment"
    if any(word in slug for word in ("checkout", "order")):
        return "order"
    if "chat" in slug or flags["websocket"]:
        return "chat"
    if any(word in slug for word in ("app-lock", "pin-unlock", "password-unlock", "biometric-unlock", "two-factor", "otp", "forgot-password", "reset-password", "security-question")):
        return "auth"
    if ex["controllers"] or ex["form_fields"] or ex["validators"]:
        return "form"
    if any(word in slug for word in ("grid", "list", "history", "notification", "favorite", "voucher", "reviews")):
        return "list"
    if "detail" in slug:
        return "detail"
    return "content"


def endpoint_names() -> set[str]:
    return _ENDPOINT_NAMES


def table_columns(table: str, limit: int = 10) -> str:
    cols = _TABLES.get(table, [])
    names = [f"`{c['name']}`" for c in cols[:limit]]
    suffix = " …" if len(cols) > limit else ""
    return ", ".join(names) + suffix

import json
import re
import os

def load_translations(path):
    with open(path, 'r', encoding='utf-8') as f:
        return json.load(f)

def escape_for_dart_single(text):
    return text.replace('\\', '\\\\').replace("'", "\\'").replace('\n', '\\n').replace('\r', '')

def escape_for_dart_double(text):
    return text.replace('\\', '\\\\').replace('"', '\\"').replace('$', '\\$').replace('\n', '\\n').replace('\r', '')

def resolve_nested_tr_in_expr(expr, trans_map):
    """Resolve all 'key'.tr() patterns inside an expression string.
    Returns the expression with all .tr() calls resolved to their translated values.
    Only matches simple .tr() calls, not namedArgs ones."""
    # Find all 'key'.tr() patterns, sorted by key length descending
    keys = sorted(trans_map.keys(), key=len, reverse=True)
    for key in keys:
        value = trans_map[key]
        escaped = escape_for_dart_single(value)
        # Replace 'key'.tr() with 'value'
        expr = expr.replace("'" + key + "'.tr()", "'" + escaped + "'")
    return expr

def replace_all_simple_tr(content, trans_map):
    """Replace ALL 'KEY'.tr() patterns with translated text.
    This is done FIRST before namedArgs replacement to handle nested .tr() calls."""
    # Sort keys by length descending to avoid partial matches
    sorted_keys = sorted(trans_map.keys(), key=len, reverse=True)
    
    for key in sorted_keys:
        value = trans_map[key]
        escaped = escape_for_dart_single(value)
        # Replace 'key'.tr() with 'translated'
        content = content.replace("'" + key + "'.tr()", "'" + escaped + "'")
    
    return content

def replace_named_args_single_line(content, trans_map):
    """Replace single-line .tr(namedArgs: {...}) calls."""
    # First resolve any nested .tr() calls in the param expressions
    # Then replace the entire namedArgs call
    
    pattern = r"'([^']+)'\.tr\(namedArgs:\s*\{([^}]*)\}\s*\)"
    
    def replacer(m):
        key = m.group(1)
        params_block = m.group(2)
        
        if key not in trans_map:
            return m.group(0)
        
        translated = trans_map[key]
        
        # Extract param name -> expression mappings
        param_pattern = r"'([^']+)'\s*:\s*((?:'[^']*'|[^,}])+)"
        params = re.findall(param_pattern, params_block)
        
        result = translated
        for param_name, param_expr in params:
            param_expr = param_expr.strip()
            # Resolve any nested .tr() calls inside the expression
            param_expr = resolve_nested_tr_in_expr(param_expr, trans_map)
            
            if (param_expr.startswith("'") and param_expr.endswith("'")):
                inner = param_expr[1:-1]
                result = result.replace('{' + param_name + '}', inner)
            elif (param_expr.startswith('"') and param_expr.endswith('"')):
                inner = param_expr[1:-1]
                result = result.replace('{' + param_name + '}', inner)
            else:
                result = result.replace('{' + param_name + '}', '${' + param_expr + '}')
        
        return "'" + escape_for_dart_single(result) + "'"
    
    return re.sub(pattern, replacer, content)

def replace_named_args_multiline(content, trans_map):
    """Replace multi-line .tr(namedArgs: { ... }) calls."""
    pattern = r"'([^']+)'\.tr\(namedArgs:\s*\{"
    
    result = []
    i = 0
    while i < len(content):
        m = re.search(pattern, content[i:])
        if not m:
            result.append(content[i:])
            break
        
        result.append(content[i:i + m.start()])
        key = m.group(1)
        
        if key not in trans_map:
            result.append(content[i + m.start():i + m.end()])
            i = i + m.end()
            continue
        
        translated = trans_map[key]
        
        # Find the matching }
        start = i + m.end()
        brace_depth = 1
        j = start
        in_single_quote = False
        in_double_quote = False
        
        while j < len(content) and brace_depth > 0:
            ch = content[j]
            if ch == "'" and not in_double_quote:
                in_single_quote = not in_single_quote
            elif ch == '"' and not in_single_quote:
                in_double_quote = not in_double_quote
            elif not in_single_quote and not in_double_quote:
                if ch == '{':
                    brace_depth += 1
                elif ch == '}':
                    brace_depth -= 1
            j += 1
        
        params_block = content[start:j - 1]
        
        # Find the closing ) after }
        k = j
        while k < len(content) and content[k] == ' ':
            k += 1
        if k < len(content) and content[k] == ')':
            k += 1
        else:
            result.append(content[i + m.start():i + m.end()])
            i = i + m.end()
            continue
        
        # Extract params
        param_pattern = r"'([^']+)'\s*:\s*((?:'[^']*'|[^,}])+(?:,[^,}]*)?)"
        params = re.findall(param_pattern, params_block)
        
        result_text = translated
        for param_name, param_expr in params:
            param_expr = param_expr.strip()
            param_expr = resolve_nested_tr_in_expr(param_expr, trans_map)
            
            if (param_expr.startswith("'") and param_expr.endswith("'")):
                inner = param_expr[1:-1]
                result_text = result_text.replace('{' + param_name + '}', inner)
            elif (param_expr.startswith('"') and param_expr.endswith('"')):
                inner = param_expr[1:-1]
                result_text = result_text.replace('{' + param_name + '}', inner)
            else:
                result_text = result_text.replace('{' + param_name + '}', '${' + param_expr + '}')
        
        result.append("'" + escape_for_dart_single(result_text) + "'")
        i = k
    
    return ''.join(result)

def replace_variable_tr(content):
    """Replace variable.tr() where variable is a Dart identifier with just variable.
    Handles: variable.tr(), (expr).tr(), list[i].tr(), etc."""
    # Pattern: word.tr()
    content = re.sub(r'([a-zA-Z_][a-zA-Z0-9_]*)\.tr\(\)', r'\1', content)
    # Pattern: (something).tr()
    content = re.sub(r'(\.[a-zA-Z_][a-zA-Z0-9_]*\b)\.tr\(\)', r'\1', content)
    return content

def replace_unknown_keys(content, trans_map):
    """For remaining .tr() calls with keys NOT in the translation map,
    replace them by just removing .tr() and keeping the literal key."""
    # Find all remaining 'key'.tr() patterns where key is not in trans_map
    pattern = r"'([^']+)'\.tr\(\)"
    
    def replacer(m):
        key = m.group(1)
        if key not in trans_map:
            return "'" + escape_for_dart_single(key) + "'"
        return m.group(0)
    
    return re.sub(pattern, replacer, content)

def remove_imports(content):
    content = re.sub(
        r"import 'package:easy_localization/easy_localization.dart';\s*",
        '',
        content
    )
    return content

def process_file(filepath, trans_map):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    original = content
    
    # Step 1: Replace ALL simple .tr() patterns first (handles nested ones in namedArgs)
    content = replace_all_simple_tr(content, trans_map)
    
    # Step 2: Replace multi-line named args patterns
    content = replace_named_args_multiline(content, trans_map)
    
    # Step 3: Replace single-line named args patterns
    content = replace_named_args_single_line(content, trans_map)
    
    # Step 4: Handle remaining unknown keys (not in translation map)
    content = replace_unknown_keys(content, trans_map)
    
    # Step 5: Replace variable.tr() patterns
    content = replace_variable_tr(content)
    
    # Step 6: Remove imports
    content = remove_imports(content)
    
    if content != original:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)
        return True
    return False

def main():
    base_dir = r'D:\Weeding-Organizer-CBIR\mobile_app'
    trans_path = os.path.join(base_dir, 'assets', 'translations', 'id.json')
    lib_dir = os.path.join(base_dir, 'lib')
    
    trans_map = load_translations(trans_path)
    print(f"Loaded {len(trans_map)} translation keys")
    
    all_files = []
    for root, dirs, files in os.walk(lib_dir):
        for f in files:
            if f.endswith('.dart') and f != 'main.dart':
                all_files.append(os.path.join(root, f))
    
    print(f"Found {len(all_files)} .dart files to process")
    
    modified_files = []
    total_replacements = 0
    
    for filepath in all_files:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
        before_count = content.count('.tr(')
        
        if before_count == 0:
            if "easy_localization" in content:
                content = remove_imports(content)
                with open(filepath, 'w', encoding='utf-8') as f:
                    f.write(content)
                modified_files.append(os.path.relpath(filepath, lib_dir))
                print(f"  Removed import from: {os.path.relpath(filepath, lib_dir)}")
            continue
        
        modified = process_file(filepath, trans_map)
        if modified:
            with open(filepath, 'r', encoding='utf-8') as f:
                new_content = f.read()
            after_count = new_content.count('.tr(')
            replacements = before_count - after_count
            total_replacements += replacements
            relpath = os.path.relpath(filepath, lib_dir)
            modified_files.append(relpath)
            print(f"  {replacements:3d} replacements in {relpath}")
    
    # Final check for remaining .tr() calls
    print(f"\n{'='*60}")
    print(f"Final check for remaining .tr() calls:")
    remaining = 0
    for root, dirs, files in os.walk(lib_dir):
        for f in files:
            if f.endswith('.dart') and f != 'main.dart':
                fp = os.path.join(root, f)
                with open(fp, 'r', encoding='utf-8') as fh:
                    c = fh.read()
                count = c.count('.tr(')
                if count > 0:
                    print(f"  {count} remaining in {os.path.relpath(fp, lib_dir)}")
                    remaining += count
    print(f"TOTAL remaining .tr() calls: {remaining}")
    print(f"{'='*60}")
    print(f"Total files modified: {len(modified_files)}")
    print(f"Total .tr() replacements: {total_replacements}")

if __name__ == '__main__':
    main()

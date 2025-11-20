import re
from collections import defaultdict

def convert_lines_to_array(text: str) -> str:
    groups = defaultdict(list)
    vars_converted = []  # 收集 "$key = value" 转换结果

    for raw in text.splitlines():
        line = raw.strip()

        # 跳过注释与空行
        if not line or line.startswith("#"):
            continue

        # ① 优先匹配 $var = value
        m_var = re.match(r'\$(\w+)\s*=\s*(.+)', line)
        if m_var:
            key = m_var.group(1)
            value = m_var.group(2).strip()
            vars_converted.append(f"\"{key}\" = \"{value}\"")
            continue

        # ② 匹配普通 key = value
        m = re.match(r'(\w+)\s*=\s*(.+)', line)
        if not m:
            continue  # 忽略不标准的行

        key, value = m.group(1), m.group(2).strip()
        groups[key].append(value)

    out = []

    # 输出数组转换的部分
    for key, values in groups.items():
        out.append(f"{key} = [")
        for v in values:
            out.append(f'    "{v}"')
        out.append("];")
        out.append("")

    # 输出变量转换部分
    if vars_converted:
        out.append("\n".join(vars_converted) + ";")

    return "\n".join(out).rstrip()


data = """
bind = $mainMod, Q, exec, $terminal
bind = $mainMod, C, killactive,
bind = $mainMod, M, exit,

$terminal = kitty
$fileManager = dolphin
$menu = wofi --show drun
"""

print(convert_lines_to_array(data))

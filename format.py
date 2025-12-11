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
animations {
    enabled = true
    # Animation curves
    
    bezier = linear, 0, 0, 1, 1
    bezier = md3_standard, 0.2, 0, 0, 1
    bezier = md3_decel, 0.05, 0.7, 0.1, 1
    bezier = md3_accel, 0.3, 0, 0.8, 0.15
    bezier = overshot, 0.05, 0.9, 0.1, 1.1
    bezier = crazyshot, 0.1, 1.5, 0.76, 0.92 
    bezier = hyprnostretch, 0.05, 0.9, 0.1, 1.0
    bezier = menu_decel, 0.1, 1, 0, 1
    bezier = menu_accel, 0.38, 0.04, 1, 0.07
    bezier = easeInOutCirc, 0.85, 0, 0.15, 1
    bezier = easeOutCirc, 0, 0.55, 0.45, 1
    bezier = easeOutExpo, 0.16, 1, 0.3, 1
    bezier = softAcDecel, 0.26, 0.26, 0.15, 1
    bezier = md2, 0.4, 0, 0.2, 1 # use with .2s duration
    # Animation configs
    animation = windows, 1, 3, md3_decel, popin 60%
    animation = windowsIn, 1, 3, md3_decel, popin 60%
    animation = windowsOut, 1, 3, md3_accel, popin 60%
    animation = border, 1, 10, default
    animation = fade, 1, 3, md3_decel
    # animation = layers, 1, 2, md3_decel, slide
    animation = layersIn, 1, 3, menu_decel, slide
    animation = layersOut, 1, 1.6, menu_accel
    animation = fadeLayersIn, 1, 2, menu_decel
    animation = fadeLayersOut, 1, 4.5, menu_accel
    animation = workspaces, 1, 7, menu_decel, slide
    # animation = workspaces, 1, 2.5, softAcDecel, slide
    # animation = workspaces, 1, 7, menu_decel, slidefade 15%
    # animation = specialWorkspace, 1, 3, md3_decel, slidefadevert 15%
    animation = specialWorkspace, 1, 3, md3_decel, slidevert
}
"""

print(convert_lines_to_array(data))

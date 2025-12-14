import re

original_text = """
[[mgr.prepend_keymap]]
on = [ "m" ]
run = "plugin bookmarks save"
desc = "Save current position as a bookmark"

[[mgr.prepend_keymap]]
on = [ "'" ]
run = "plugin bookmarks jump"
desc = "Jump to a bookmark"

[[mgr.prepend_keymap]]
on = [ "b", "d" ]
run = "plugin bookmarks delete"
desc = "Delete a bookmark"

[[mgr.prepend_keymap]]
on = [ "b", "D" ]
run = "plugin bookmarks delete_all"
desc = "Delete all bookmarks"
"""

def convert_to_nix_string(text):
    # -------------------------------------------------
    # 规则 A: 处理 Keymap
    # 兼容 [[manager...]] 和 [[mgr...]]
    # -------------------------------------------------
    pattern_keymap = (
        r'\[\[(?:manager|mgr)\.prepend_keymap\]\]\s+' # 核心修改：允许 manager 或 mgr
        r'on\s*=\s*(.*?)\s+'                          # 捕获 on 的值 (Group 1)，非贪婪匹配直到换行
        r'run\s*=\s*"(.*?)"\s+'                       # 捕获 run (Group 2)
        r'desc\s*=\s*"(.*?)"'                         # 捕获 desc (Group 3)
    )

    def replace_keymap(match):
        raw_on = match.group(1).strip() # 获取 on 的原始内容，例如 '[ "m" ]' 或 '"H"'
        cmd = match.group(2)
        desc = match.group(3)

        # 处理按键格式，转换为 Nix 列表
        if raw_on.startswith('['):
            # 如果原本就是列表 (例如 [ "b", "d" ] 或 [ "m" ])
            # 只需去掉逗号即可符合 Nix 语法: [ "b" "d" ]
            nix_keys = raw_on.replace(',', '')
        else:
            # 如果原本是单个字符串且没括号 (例如 "H")
            # 加上方括号
            nix_keys = f'[ {raw_on} ]'

        return f'{{ on = {nix_keys}; run = "{cmd}"; desc = "{desc}"; }}'

    # -------------------------------------------------
    # 规则 B: 处理 Previewers (保持不变)
    # -------------------------------------------------
    pattern_previewer = (
        r'\[\[plugin\.prepend_previewers\]\]\s+'
        r'mime\s*=\s*"(.*?)"\s+'
        r'run\s*=\s*"(.*?)"'
    )

    def replace_previewer(match):
        mime = match.group(1)
        run = match.group(2)
        return f'{{ mime = "{mime}"; run = "{run}"; }}'

    # -------------------------------------------------
    # 执行替换
    # -------------------------------------------------
    text = re.sub(pattern_keymap, replace_keymap, text)
    text = re.sub(pattern_previewer, replace_previewer, text)
    
    return text

if __name__ == "__main__":
    nix_formatted_text = convert_to_nix_string(original_text)
    
    print("-" * 20 + " 转换结果 " + "-" * 20)
    print(nix_formatted_text)
    print("-" * 50)

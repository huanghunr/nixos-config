import re

# 1. 这里放入你需要转换的原始字符串（包含了 keymap 和 previewer 两种情况）
original_text = """
[[mgr.prepend_keymap]]
on   = [ "c", "m" ]
run  = "plugin chmod"
desc = "Chmod on selected files"

[[plugin.prepend_previewers]]
mime = "application/{*zip,tar,bzip2,7z*,rar,xz,zstd,java-archive}"
run  = "ouch"
"""

def convert_to_nix_string(text):
    # -------------------------------------------------
    # 规则 A: 处理 Keymap ([[mgr.prepend_keymap]])
    # -------------------------------------------------
    pattern_keymap = (
        r'\[\[mgr\.prepend_keymap\]\]\s+'
        r'on\s*=\s*\[\s*(.*?)\s*\]\s+'
        r'run\s*=\s*"(.*?)"\s+'
        r'desc\s*=\s*"(.*?)"'
    )

    def replace_keymap(match):
        keys = match.group(1).replace(',', '') 
        cmd = match.group(2)
        desc = match.group(3)
        return f'{{ on = [ {keys} ]; run = "{cmd}"; desc = "{desc}"; }}'

    # -------------------------------------------------
    # 规则 B: 处理 Previewers ([[plugin.prepend_previewers]])
    # -------------------------------------------------
    pattern_previewer = (
        r'\[\[plugin\.prepend_previewers\]\]\s+' # 匹配头部
        r'mime\s*=\s*"(.*?)"\s+'                 # 捕获组1: mime 类型
        r'run\s*=\s*"(.*?)"'                     # 捕获组2: 运行命令
    )

    def replace_previewer(match):
        mime = match.group(1)
        run = match.group(2)
        # 格式化为 Nix 语法: { mime = "..."; run = "..."; }
        return f'{{ mime = "{mime}"; run = "{run}"; }}'

    # -------------------------------------------------
    # 执行替换
    # -------------------------------------------------
    
    # 第一步：替换所有的 keymap
    text = re.sub(pattern_keymap, replace_keymap, text)
    
    # 第二步：在结果的基础上，替换所有的 previewer
    text = re.sub(pattern_previewer, replace_previewer, text)
    
    return text

if __name__ == "__main__":
    nix_formatted_text = convert_to_nix_string(original_text)
    
    print("-" * 20 + " 转换结果 " + "-" * 20)
    print(nix_formatted_text)
    print("-" * 50)
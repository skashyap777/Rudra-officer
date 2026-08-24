import os
import glob
import re

def wrap_body_with_safe_area(file_path):
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # If already contains SafeArea(child: , we might skip it to avoid double wrap
    # But wait, SafeArea could be used for something else. 
    # Let's search for "body: " inside the file.
    
    # Find all occurrences of "body:"
    # We will iterate and replace them.
    
    pattern = re.compile(r'body:\s*')
    matches = list(pattern.finditer(content))
    
    if not matches:
        return False
        
    new_content = ""
    last_idx = 0
    changed = False
    
    for match in matches:
        start_idx = match.end()
        # Find the end of the expression
        idx = start_idx
        brackets = {'(': 0, '{': 0, '[': 0}
        
        while idx < len(content):
            c = content[idx]
            if c == '(': brackets['('] += 1
            elif c == ')': 
                if brackets['('] > 0:
                    brackets['('] -= 1
                else:
                    # Unbalanced closing parenthesis means we reached the end of Scaffold
                    break
            elif c == '{': brackets['{'] += 1
            elif c == '}': brackets['{'] -= 1
            elif c == '[': brackets['['] += 1
            elif c == ']': brackets['['] -= 1
            elif c == ',':
                if sum(brackets.values()) == 0:
                    # We reached the end of the body argument
                    break
            idx += 1
            
        expr = content[start_idx:idx].strip()
        
        # Don't wrap if it's already a SafeArea
        if expr.startswith('SafeArea('):
            new_content += content[last_idx:idx]
            last_idx = idx
            continue
            
        new_content += content[last_idx:match.start()]
        new_content += f'body: SafeArea(child: {expr})'
        last_idx = idx
        changed = True

    new_content += content[last_idx:]
    
    if changed:
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(new_content)
        print(f"Wrapped body in {file_path}")
        return True
    return False

def main():
    base_dir = r"d:\COGNItech\Rudra officer\rudra_officer\lib"
    files = glob.glob(os.path.join(base_dir, '**', '*.dart'), recursive=True)
    count = 0
    for file in files:
        if wrap_body_with_safe_area(file):
            count += 1
    print(f"Total files updated: {count}")

if __name__ == '__main__':
    main()

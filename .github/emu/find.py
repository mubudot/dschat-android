import sys, re
xml = open(sys.argv[1], encoding='utf-8').read()
pat = re.compile(sys.argv[2])
for node in re.findall(r'<node [^>]*>', xml):
    attrs = dict(re.findall(r'(\w[\w-]*)="([^"]*)"', node))
    if pat.search(attrs.get('class', '')) or pat.search(attrs.get('content-desc', '')) or pat.search(attrs.get('text', '')):
        x1, y1, x2, y2 = map(int, re.findall(r'\d+', attrs['bounds']))
        print((x1 + x2) // 2, (y1 + y2) // 2)
        sys.exit(0)
print('100 300')  # fallback

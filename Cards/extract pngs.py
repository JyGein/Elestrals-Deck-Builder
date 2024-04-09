from pathlib import Path
import re

elestral_name_regex = "[A-Z][A-Z]\d{1,2}(?:-\d{2,3})?([\w ]+?)(?:Promo|Stellar|Holo|Celebration|FullArt)*\.png"
p = Path(".")
root_items = [x for x in p.iterdir()]
image_paths = list(p.glob('**/*.png'))
image_names = [x.name for x in image_paths]
#print([x[7:] for x in image_names if x.startswith('Card')])

output = ''
for i in image_names:
    m = re.search(elestral_name_regex, i)
    if m != None:
        output += f'{m.groups()[0]}, '
print(output)
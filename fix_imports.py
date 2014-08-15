import os
import sys
import fnmatch
import codecs

if len(sys.argv) < 3:
   print os.path.basename(__file__), 'target_path', 'framework_names...'
   sys.exit(1)

FRAMEWORK_PATH = os.path.join(os.path.dirname(__file__), 'Frameworks')
target_path = sys.argv[1]

print 'Patching #import in *.h/*.m from', target_path

header_map = {}
for framework in sys.argv[2:]:
   for root, dirnames, filenames in os.walk(os.path.join(FRAMEWORK_PATH, framework+'.framework', 'Headers')):
      header_map[framework] = filenames

for framework in header_map.keys():
   print framework+'.framework'
   for header in header_map[framework]:
       print '-', header

for root, dirnames, filenames in os.walk(os.path.join(os.path.dirname(__file__), target_path)):
   for fname in [fname for fname in filenames if fname.endswith('.h') or fname.endswith('.m')]:
      filepath = os.path.join(root, fname)
      with codecs.open(filepath, 'r', 'utf-8') as input:
         content = input.read()
         for framework, headers in header_map.iteritems():
            for header in headers: 
               content = content.replace('"'+header+'"', '<'+framework+'/'+header+'>')
         with codecs.open(filepath, 'w', 'utf-8') as output:
            output.write(content)
            print 'patched', filepath

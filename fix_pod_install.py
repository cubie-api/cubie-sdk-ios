from xml.dom.minidom import parse, parseString
import os

path = os.path.join(os.path.dirname(__file__), 'sdk.xcodeproj', 'project.pbxproj')
dom = parse(path)
ref= [e.previousSibling.previousSibling.childNodes[0].data \
	for e in dom.getElementsByTagName('dict')[3:] \
		if e.toxml().find('libPods.a') != -1][0]
refref= [e.previousSibling.previousSibling.childNodes[0].data \
	for e in dom.getElementsByTagName('dict')[3:] \
		if e.toxml().find(ref) != -1 and e.toxml().find('PBXBuildFile') != -1][0]

result = '\n'.join([line.rstrip() for line in open(path).readlines() if line.find('<string>'+refref) == -1])
open(path, 'w').write(result)

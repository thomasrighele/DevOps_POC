## Python Script to parse Informatica Connection XML and update attributes
## XMLTree https://docs.python.org/2/library/xml.etree.elementtree.html 

import sys
import xml.etree.ElementTree as ET

## Variables to be passed in
ENV=sys.argv[1]
XMLDir=sys.argv[2]
ProjectName=sys.argv[3]
ArtDir=sys.argv[4]

## Attribute XML File
attribupdatefile= XMLDir + '/_' + ProjectName + '/attrib_updatefile.xml'

## Functions below to update the namespace
## http://effbot.org/zone/element-namespaces.htm
def set_prefixes(elem, prefix_map):

    # check if this is a tree wrapper
    if not ET.iselement(elem):
        elem = elem.getroot()

    # build uri map and add to root element
    uri_map = {}
    for prefix, uri in prefix_map.items():
        uri_map[uri] = prefix
        elem.set("xmlns:" + prefix, uri)

    # fixup all elements in the tree
    memo = {}
    for elem in elem.iter():
        fixup_element_prefixes(elem, uri_map, memo)

def fixup_element_prefixes(elem, uri_map, memo):
    def fixup(name):
        try:
            return memo[name]
        except KeyError:
            if name[0] != "{":
                return
            uri, tag = name[1:].split("}")
            if uri in uri_map:
                new_name = uri_map[uri] + ":" + tag
                memo[name] = new_name
                return new_name
    # fix element name
    name = fixup(elem.tag)
    if name:
        elem.tag = name
    # fix attribute names
    for key, value in elem.items():
        name = fixup(key)
        if name:
            elem.set(name, value)
            del elem.attrib[key]

## Parsing the attribute update file
attribupdatefile_parsed = ET.parse(attribupdatefile)
for configuration in attribupdatefile_parsed.iter('configuration'):
    environment = configuration.find('environment').text
    if environment == ENV:
        for connection in configuration.iter('connection'):
            connname = connection.find('name').text

            ## Parse Informatica's extracted XML File for the connection   
            tree = ET.parse(ArtDir + '/Explore/' + ProjectName + '/Connections/'+ connname +'.AI_CONNECTION.xml')
            root = tree.getroot()


            ## Register the main namespace
            ET.register_namespace('aetgt', "http://schemas.active-endpoints.com/appmodules/repository/2010/10/avrepository.xsd")

            ## Declare namespace
            ns = {'types1': 'http://schemas.active-endpoints.com/appmodules/repository/2010/10/avrepository.xsd',
                'ns0': 'http://schemas.informatica.com/socrates/data-services/2014/04/avosConnections.xsd'}

            
            for Item in root.findall('types1:Item', ns):
                ## Update the Namespace for the items in the Item tag
                set_prefixes(Item, dict(types1="http://schemas.active-endpoints.com/appmodules/repository/2010/10/avrepository.xsd"))

                ############################# TEST #############################
                print(Item.find('types1:Entry'))
                ############################# TEST #############################   


                ## Update the value within the attributes tag
                for Entry in Item.find('types1:Entry'):
                    ## Iterate on attributes in attribute file
                    for attributes in connection.iter('attributes'):
                        varname = attributes.find('varname').text
                        varvalue = attributes.find('varvalue').text
                        attributes = Entry.find('ns0:attributes', ns)
                        attribute = attributes.find('ns0:attribute[@name="'+varname+'"]', ns)
                        attribute.set('value',varvalue)
                ## Update the namespace to match the original
                for Entry in Item.iter('types1:Entry'):
                    for connection in Entry.iter('{http://schemas.informatica.com/socrates/data-services/2014/04/avosConnections.xsd}connection'):
                        set_prefixes(connection, dict(c="http://schemas.informatica.com/socrates/data-services/2014/04/avosConnections.xsd"))
                    for businessConnector in Entry.iter('{http://schemas.informatica.com/appmodules/screenflow/2014/04/avosConnectors.xsd}businessConnector'):
                        set_prefixes(businessConnector, dict(c="http://schemas.informatica.com/appmodules/screenflow/2014/04/avosConnectors.xsd"))

            ## Output the file
            ##tree.write(ArtDir + '/Explore/' + ProjectName + '/Connections/'+ connname +'.AI_CONNECTION.xml')
            ET.dump(tree)

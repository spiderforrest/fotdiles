#!/usr/bin/python

#Get the Arch Latest News with xml.etree

from xml.etree import ElementTree
from urllib import request
import re

#Make a user agent string for urllib to use
agent = ('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:86.0) '
         'Gecko/20100101 Firefox/86.0')

user_agent = {'User-Agent': agent}

class MakeList():
    def __init__(self, url):

        #Get the xml to parse
        req = request.Request(url, data=None, headers=user_agent)
        html = request.urlopen(req)
        tree = ElementTree.parse(html)
        root = tree.getroot()

        #Get tag data
        tagA = root.findall('./channel/item/title')
        tagB = root.findall('./channel/item/link')
        tagC = root.findall('./channel/item/description')
        tagD = []
        tagR = '<[^>]*>'

        #Append lines with separator
        for a,b,c in zip(tagA,tagB,tagC):
            tagD.extend([re.sub(tagR,'',a.text), re.sub(tagR,'',b.text), 
                         re.sub(tagR,'',c.text), '_' * 70])


        #Print
        for line in tagD:
            print(line, '\n')

if __name__ == "__main__":

    #Urls, log names
    A = 'https://archlinux.org/feeds/news/'
    #B = ('file:///local/file/archfeed.xml', '.bin/test.log')

    MakeList(A)

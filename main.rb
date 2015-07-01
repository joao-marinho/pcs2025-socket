require 'server'
require 'client'
require 'transfer'

s = File.open('README.md', 'r')
d = File.open("produced.txt", 'w')

t = Transfer.new(s, d)
t.run()
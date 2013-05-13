def products_adder(factor):
    print "products_adder..."
    val = 0
    while True:
        print val
        val += (yield) * factor

print "hello"
a = products_adder(3)
a.next()   # a.send(None) would also work
a.send(1)
a.send(5)
a.send(8)
a.send(10)

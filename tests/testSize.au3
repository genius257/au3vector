#include "../au3pm/au3unit/Unit/assert.au3"
#include "../Vector.au3"

$vector = Vector()

assertEquals(0, $vector.size)

$vector.push_back('a')

assertEquals(1, $vector.size)

$vector.push_back('b')

assertEquals(2, $vector.size)

$vector.push_back('c')

assertEquals(3, $vector.size)

$vector.empty()

assertEquals(0, $vector.size)
